# Setup K3s agent
Pay attention to the used IP addresses. If your using the same subnet and static IP's, just copy and paste. If not, change the IP's. 

## Enable container features
Edit */boot/cmdline.txt* and add *cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory*. 

## Manual install with binary (not recommended)
Change the release version, if you do it this way. You can find the release here: https://github.com/rancher/k3s/releases
~~~
wget https://github.com/rancher/k3s/releases/download/v0.5.0/k3s-armhf
mv k3s-armhf k3s
chmod +x k3s
sudo ./k3s server --bind-address 192.168.3.1 &
~~~

## Automatic script install (recommended)
~~~
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--bind-address 192.168.3.1" sh -s –
~~~

### Fast redeployment of a Pod when the node is unavailable
Source: https://medium.com/01001101/pod-rescheduling-after-a-node-failure-with-rke-and-kubernetes-ed11cf3dbeb4  
The following configurations will have the nodes send there status every 5 seconds and the controller checking for an unavailable node every 10 seconds.
~~~
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--bind-address 192.168.3.1 --kube-apiserver-arg default-not-ready-toleration-seconds=10 --kube-apiserver-arg default-unreachable-toleration-seconds=10 --kube-controller-arg node-monitor-period=10s --kube-controller-arg node-monitor-grace-period=10s --kubelet-arg node-status-update-frequency=5s" sh -
~~~

#### What are all those extra arguments?
**API Server**  
*--default-not-ready-toleration-seconds int     Default: 300*  
Indicates the tolerationSeconds of the toleration for notReady:NoExecute that is added by default to every pod that does not already have such a toleration.  
*--default-unreachable-toleration-seconds int     Default: 300*  

**Kubelet**  
*--node-status-update-frequency duration*  
Specifies how often kubelet posts node status to master. Note: be cautious when changing the constant, it must work with nodeMonitorGracePeriod in nodecontroller. (default 10s)  

**Controller Manager**  
*--node-monitor-grace-period duration     Default: 40s*  
Amount of time which we allow running Node to be unresponsive before marking it unhealthy. Must be N times more than kubelet's nodeStatusUpdateFrequency, where N means number of retries allowed for kubelet to post node status.  
*--node-monitor-period duration     Default: 5s*  
The period for syncing NodeStatus in NodeController.

## Get Server token
Copy the contents of */var/lib/rancher/k3s/server/node-token*. You will need this to set up the agent. 

## Tips 
1. You can use *journalctl -u [k3s or k3s-agent]* to check if somethings not working. 