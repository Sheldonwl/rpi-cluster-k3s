# Under Construction

# rpi-cluster-k3s
This is a guide on how to build a six node Raspberry Pi cluster running K3s: Lightweight Kubernetes

## Shopping list
The following shopping list will have the bare essentials you will need to get a "Highly Available" cluster working, and the specific products I used for my first hardware cluster setup. However, you might choose a different case or cooling solution for example. Currently HA is not working on K3s, but it will eventually, and then we'll be ready!

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
Go to https://www.raspberrypi.org/downloads/ and use whatever OS image you like. I used "Raspbian Stretch with desktop". However, I recommend using the Rasbian Strech Lite image, if you can find your way around the OS just fine from the cli and if you have a smaller sized SD card. The setup was quite easy, so will be using the Lite image in the future as well. 

### Installation guide
I won't be recreating the wheel, so just follow: https://www.raspberrypi.org/documentation/installation/installing-images/README.md to install the images. 

### Configure 
After flashing the image and placing the SD card in your Pi, connect a monitor to the HDMI port and connect the micro-USB cable.  
If you installed the desktop version, go to your start menu and open your raspberry configurations.  
If you're doing it from the CLI you can follow: https://www.raspberrypi.org/documentation/configuration/raspi-config.md
Now you can enable SSH, change the hostname, change the default password etc.

### Setup DHCP server
I choose to make one of the Pi's a DHCP server, so I don't have to depend on an external router. My setup uses the Wi-Fi of the Pi running the DHCP server as access to the internet. You can choose to do it the same way or just use and external router to act as DHCP server. If you choose this route, you might want to assign static IP's to the Pi's, in the router’s configs.

![Alt text](/docs/images/rpi-network-setup.jpg?raw=true "Raspberry Pi Network setup")  