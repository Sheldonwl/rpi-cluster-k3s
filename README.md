# rpi-cluster-k3s
This is a guide on how to build a six node Raspberry Pi cluster running K3s: Lightweight Kubernetes

![Alt text](/docs/images/rpi-cluster-small.jpg?raw=true "Raspberry Pi cluster")

## Shopping list
The following shopping list will have the bare essentials you will need to get a "High Available" cluster working, and the specific products I used for my first hardware cluster setup. However, you might choose a different case or cooling solution for example. Currently HA is not working on K3s, but it will eventually, and then we'll be ready! However having a high available control plane might not be necessary. 

### Essentials:
6x Raspberry Pi 3 model B+  
6x Micro SD card (Class 10, 8GB+)  
6x USB A to USB Micro B cable  
1x Anker Powerport 6  
1x Switch: 8 ports  
7x RJ45 Ethernet cables  
6x Heatsinks  
1x Case  
1x Router (Optional: If you don't want to setup DHCP yourself)  

### My setup:
6x Raspberry Pi 3 model B+  
6x Micro SD cards (Class 10, 16 GB)  
1x Anker Powerport 10  
1x Switch: 8 ports (D-Link GO-SW-8E, should have gotten the GO-SW-8G)  
7x RJ45 Ethernet cables  
6x Heatsink, 3-piece set  
1x Tower case: for six Pi's  
4x Cooling fans (12V, 4cm by 4cm)  
1x DC-DC Step-up Boost Converter XL6009 4A: To supply the 12V from a 5V USB source  
1x USB to type M cable: (Only useful if you have a switch with a 5V input like the D-Link GO-SW-8E or GO-SW-8G)  
6x RGB Leds: https://shop.pimoroni.com/products/blinkt  
1x Power button: Reset button, to power on and off the Pi's  
1x Power button: On/Off, for the cooling fans (faster than setting up the circuit to switch a transistor from one of the Pi's, but on the to-do list!)  

## Setup Pi's 
### Download image
Go to https://www.raspberrypi.org/downloads/ and use whatever OS image you like. I used "Raspbian Stretch with desktop". However, I recommend using the Rasbian Strech Lite image, if you can find your way around the OS just fine from the cli and if you have a smaller sized SD card. The setup was quite easy, so I will be using the Lite image in the future as well. 

### Installation guide
I won't be reinventing the wheel, so just follow: https://www.raspberrypi.org/documentation/installation/installing-images/README.md to install the OS image. 

### Configure 
After flashing the image and placing the SD card in your Pi, connect a monitor to the HDMI port and connect the micro-USB cable to power up the Pi.  
If you installed the desktop version you can follow: [Desktop setup](https://github.com/Sheldonwl/rpi-cluster-k3s/blob/master/docs/setup/desktop/README.md)  
If you're doing it from the CLI you can follow: https://www.raspberrypi.org/documentation/configuration/raspi-config.md and change the user password and enable SSH. 

### Setup DHCP server
I chose to make one of the Pi's a DHCP server, so I don't have to depend on an external router. My setup uses the Wi-Fi of the Pi running the DHCP server as access to the internet. You can choose to do it the same way or just use and external router to act as DHCP server. If you choose this route, you might want to assign static IP's to the Pi's, in the router’s configs.

![Alt text](/docs/images/rpi-network.jpg?raw=true "Raspberry Pi Network setup")  

#### Install and configure DHCP

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

#### Setup network settings and static IP
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

#### Setup internet access for all Pi's
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

### Usefull tools
Networking tools
~~~
sudo apt install net-tools -y
~~~

## Possible issues


