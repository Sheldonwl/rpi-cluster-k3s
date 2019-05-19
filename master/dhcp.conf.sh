# dhcpd.conf

default-lease-time 600;
max-lease-time 7200;
ddns-update-style none;

authoritative;

#host master-1 {
#  hardware ethernet MAC;
#  fixed-address 192.168.3.1;
#}

host master-2 {
  hardware ethernet MAC;
  fixed-address 192.168.3.2;
}

host master-3 {
  hardware ethernet MAC;
  fixed-address 192.168.3.3;
}

host worker-1 {
  hardware ethernet MAC;
  fixed-address 192.168.3.4;
}

host worker-2 {
  hardware ethernet MAC;
  fixed-address 192.168.3.5;
}

host worker-3 {
  hardware ethernet MAC;
  fixed-address 192.168.3.6;
}

subnet 192.168.3.0 netmask 255.255.255.0 {
  range 192.168.3.2 192.168.3.20;
  option broadcast-address 192.168.3.255;
  option routers 192.168.3.1;
  max-lease-time 7200;
  option domain-name "rpi-local";
  option domain-name-servers 8.8.8.8, 4.4.4.4;
}

#default-lease-time = Integer which sets the default lease time in seconds.
#max-lease-time = Integer which sets the maximum lease time, in seconds
#ping = check boolean If true, the server pings an address before assigning a lease on that address to a client.
#option domain-name–servers = The IP address or addresses of DNS servers the clients may use.
#option domain-name = The name of the domain that will grant fr the clients to use.
#authorative = The server is authoritative, this DHCP server should send DHCPNAK messages to misconfigured clients
#log-facility local7 = Send logs to syslog facility local7
#subnet 192.168.1.0 netmask 255.255.255.0 { anything enclosed here } the subnet declaration for 192.168.1.10 network
#range 192.168.1.50 192.168.1.115 = defines the IP address range that the server will lease IPs.
#option routers = defines the IP address of your gateway or the network exit point.
#option netbios-name-servers = The IP addresses of NetBIOS Name Service (NBNS) servers or Windows Internet Name Service (WINS) servers which are used by SMB/CIFS protocols to share files on Windows.
#option netbios-node-type = A code for how NetBIOS clients should attempt name resolution. Values are 1 to use broadcasts, 2 to use a WINS server, 4 to try broadcasts first followed by a WINS server and 8 to try a WINS server first followed by a broadcast.
#You should replace the presented values with the parameters specific for your own network.

#tail -f /var/log/syslog

#Set static ip for the pi
# sudo vi /etc/dhcpcd.conf

# #DHCP default config
# sudo vi /etc/dhcp/dhcpd.conf

# # Set DHCP interface
# sudo vi /etc/init.d/isc-dhcp-server

# Systemd service
# /run/systemd/generator.late/isc-dhcp-server.service
# sudo vi /etc/default/isc-dhcp-server
