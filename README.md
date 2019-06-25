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

## Setup hardware
If you'd like to know how I created the hardware go to: [Setup hardware](https://github.com/Sheldonwl/rpi-cluster-k3s/blob/master/docs/setup-hardware.md)   

## Setup Pi's 
### Download image
Go to https://www.raspberrypi.org/downloads/ and use whatever OS image you like. I used "Raspbian Stretch with desktop". However, I recommend using the Rasbian Strech Lite image, if you can find your way around the OS just fine from the cli and if you have a smaller sized SD card. The setup was quite easy, so I will be using the Lite image in the future as well. 

### Install OS
I won't be reinventing the wheel, so just follow: https://www.raspberrypi.org/documentation/installation/installing-images/README.md to install the OS image. 

### Configure Pi's
After flashing the image and placing the SD card in your Pi, connect a monitor to the HDMI port and connect the micro-USB cable to power up the Pi.  
If you installed the desktop version you can follow: [Desktop setup](https://github.com/Sheldonwl/rpi-cluster-k3s/blob/master/docs/setup/desktop/README.md)  
If you're doing it from the CLI you can follow: https://www.raspberrypi.org/documentation/configuration/raspi-config.md and change the user password and enable SSH. 

### Setup DHCP Server and Networking on master-1
Go to: [Setup DHCP and Networking](https://github.com/Sheldonwl/rpi-cluster-k3s/blob/master/docs/setup-dhcp.md)  

### Setup K3s server
Go to: [Setup K3s server](https://github.com/Sheldonwl/rpi-cluster-k3s/blob/master/docs/setup-k3s-server.md)  

### Setup K3s agent
Go to: [Setup K3s agent](https://github.com/Sheldonwl/rpi-cluster-k3s/blob/master/docs/setup-k3s-agent.md)  