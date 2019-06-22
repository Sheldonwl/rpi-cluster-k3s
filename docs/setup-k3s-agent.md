# Setup K3s server
Pay attention to the used IP addresses. If your using the same subnet and static IP's, just copy and paste. If not, change the IP's. 

## Enable container features
Edit */boot/cmdline.txt* and add *cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory*.  

## Manual install with binary (not recommended)
Change the release version, if you do it this way. You can find the release here: https://github.com/rancher/k3s/releases  
After setting up the server, you copied the token. You will use this in the following commands.  

~~~
wget https://github.com/rancher/k3s/releases/download/v0.5.0/k3s-armhf
mv k3s-armhf k3s
chmod +x k3s
export NODE_TOKEN=[PASTE NODE TOKEN]
sudo ./k3s agent -s https://192.168.3.1:6443 -t ${NODE_TOKEN} &
~~~

## Automatic script install (recommended)
After setting up the server, you copied the token. You will use this in the following commands.  
~~~
export NODE_TOKEN=[PASTE NODE TOKEN]
curl -sfL https://get.k3s.io | K3S_TOKEN=${NODE_TOKEN} K3S_URL=https://192.168.3.1:6443" sh -
~~~

### Fast redeployment of a Pod when the node is unavailable
Source: https://medium.com/01001101/pod-rescheduling-after-a-node-failure-with-rke-and-kubernetes-ed11cf3dbeb4  
The following configurations will have the nodes send there status every 5 seconds and the controller checking for an unavailable node every 10 seconds.
~~~
export NODE_TOKEN=[PASTE NODE TOKEN]
curl -sfL https://get.k3s.io | K3S_TOKEN=${NODE_TOKEN} K3S_URL=https://192.168.3.1:6443 INSTALL_K3S_EXEC="--kubelet-arg node-status-update-frequency=5s" sh -
~~~
Now go back to the server and run *kubectl get nodes -o wide* to check if the agent has been added. Rembeber that starting the server the way we did, will create a one node cluster, so you need to have two nodes available now. 