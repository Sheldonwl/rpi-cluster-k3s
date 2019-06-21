# Setup DHCP server
I chose to make one of the Pi's a DHCP server, so I don't have to depend on an external router. My setup uses the Wi-Fi of the Pi running the DHCP server as access to the internet. You can choose to do it the same way or just use and external router to act as DHCP server. If you choose this route, you might want to assign static IP's to the Pi's, in the router’s configs.

![Alt text](/docs/images/rpi-network.jpg?raw=true "Raspberry Pi Network setup")  

## Install and configure DHCP

**Install DHCP**  
~~~
apt-get update
apt-get install isc-dhcp-server -y
~~~
**Edit conf**  
Open */etc/dhcp/dhcp.conf* with your editor. Copy and paste the *rpi-cluster-k3s/docs/dhcp.conf* to a text editor and add the MAC addresses of your Raspberry Pi's. Replace the 'MAC' keyword with the MAC address of the Pi you want to assign a static IP to. Also change the hostnames, if you don't name them master-x and worker-x.   
The current DHCP config will assign the IP's *192.168.3.2* to *192.168.3.20* to any device connected to the switch, but *192.168.3.2* to *192.168.3.6* will always be assigned to the Pi's with the listed MAC address. 

**Add eth0 as interface value**  
Edit */etc/default/isc-dhcp-server*
~~~
INTERFACESv4=”eth0”;
~~~
**Start the dhcp server (if not already started) - not started on restart**  
~~~
sudo dhcpd -cf /etc/dhcp/dhcpd.conf 
~~~
**Start DHCP Server with systemd - automatically started on reboot**  
~~~
sudo systemctl start isc-dhcp-server
~~~
**You can find the DHCP logs here**
~~~
tail -f /var/lib/dhcp/dhcpd.leases
~~~

**Possible error**
~~~
-- Unit isc-dhcp-server.service has begun starting up.
mei 10 14:33:14 master-1 isc-dhcp-server[8350]: Launching IPv4 server only.
mei 10 14:33:14 master-1 isc-dhcp-server[8350]: Starting ISC DHCPv4 server: dhcpddhcpd service already running (pid file /var/run/dhcpd.pid currenty exists) ... failed!
mei 10 14:33:14 master-1 systemd[1]: isc-dhcp-server.service: Control process exited, code=exited status=1
mei 10 14:33:14 master-1 systemd[1]: Failed to start LSB: DHCP server.
-- Subject: Unit isc-dhcp-server.service has failed
~~~

**Solution**
~~~ 
sudo rm -f /var/run/dhcp.pid 
sudo systemctl start isc-dhcp-server
sudo Systemctl enable isc-dhcp-server
~~~

## Setup network settings, Wi-Fi and static IP
**Edit interface settings**  
Edit and add the following text to */etc/network/interface*. This will give the Pi with the DHCP server a static IP of *192.168.3.1*. You can change SSID and PASSWORD to your own Wi-Fi settings. 
~~~
# interfaces(5) file used by ifup(8) and ifdown(8)

# Please note that this file is written to be used with dhcpcd
# For static IP, consult /etc/dhcpcd.conf and 'man dhcpcd.conf'

# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d

#up iptables-restore < /etc/iptables.ipv4.nat

auto eth0
iface eth0 inet static
  address 192.168.3.1
  netmask 255.255.255.0

allow-hotplug wlan0
iface wlan0 inet dhcp
  wppa-ssid "SSID"
  wpa-psk "PASSWORD"
  wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
~~~

## Setup internet access for all Pi's
**Set ipv4_forward**
~~~
vi /etc/sysctl.conf
net.ipv4.ip_forward=1
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
~~~
**Configure iptables**
~~~
sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
sudo iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED
sudo iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
~~~
**Add settings**  
Add *post-up iptables-restore < /etc/iptables.ipv4.nat* to */etc/network/interfaces*  
~~~
sudo vi /etc/network/interfaces
auto eth0
iface eth0 inet static
  address 192.168.3.1
  netmask 255.255.255.0
  post-up iptables-restore < /etc/iptables.ipv4.nat
~~~
You can find the complete interface file at /rpi-cluster-k3s/docs/interface

## Usefull tools
Networking tools
~~~
sudo apt install net-tools -y
~~~



