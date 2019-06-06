# Under Construction

# rpi-cluster-k3s
This is a guide on how to build a six node Raspberry Pi cluster running K3s: Lightweigt Kubernetes

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
6x Heatsink, 3 piece set  
1x Tower case: for six Pi's  
4x Cooling fans (12V, 4cm by 4cm)  
1x DC-DC Step-up Boost Converter XL6009 4A: To supply the 12V from a 5V USB source  
1x USB to type M cable: (Only usefull if you have a switch with a 5V input like the D-Link GO-SW-8E or GO-SW-8G)  
6x RGB Leds: https://shop.pimoroni.com/products/blinkt  
1x Power button: Reset button, to power on and off the Pi's  
1x Power butten: On/Off, for the cooling fans (faster than setting up the circuit to switch a transistor from one of the Pi's, but on the todo list!)  

## Setup Pi's 
Go to https://www.raspberrypi.org/downloads/ and use whatever OS image you like. I used "Raspbian Stretch with desktop". However, I recommend using the Rasbian Strech Lite image, if you can find your way around the OS just fine from the cli and if you have a smaller sized SD card. The setup was quite easy, so will be using the Lite image in the future aswell. 
