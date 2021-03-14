
# CKS Lab Environment
This is a lab environment for the CKA / CKS Certification course. Please follow the instructions to setup the lab.
## Cluster Details
  | Node Name   | IP Address           |
  | ------      | ------------- |
  | master-01   | 192.168.10.11 |
  | worker-01   | 192.168.10.13 |
  | worker-02   | 192.168.10.14 | 
## Prerequisites
- Vagrant : Vagrant is a tool from HashiCorp for building and distributing development environments. You can read more about the tool in the below link. Please download vagrant from [here](https://www.vagrantup.com/downloads) and follow the [instructions](https://learn.hashicorp.com/tutorials/vagrant/getting-started-install) for installing vagrant in your machine.
    - Website: https://www.vagrantup.com/
    - Source: https://github.com/hashicorp/vagrant
    - HashiCorp Discuss: https://discuss.hashicorp.com/c/vagrant/24


- VritualBox : VirtualBox is a general-purpose virtualization tool. You can download virtualbox from [here](https://www.virtualbox.org/wiki/Downloads) and install in your machine.

## Instruction run the lab
Once you install both Vagrant and VirtualBox.

Clone this repository
````
murali@ckslab $ git clone https://github.com/muralidkt/cks-lab-vagrant.git

Cloning into 'cks-lab-vagrant'...
remote: Enumerating objects: 16, done.
remote: Counting objects: 100% (16/16), done.
remote: Compressing objects: 100% (13/13), done.
remote: Total 16 (delta 5), reused 4 (delta 2), pack-reused 0
Unpacking objects: 100% (16/16), 5.98 KiB | 471.00 KiB/s, done.
````

Move repository folder
````
murali@ckslab $ cd cks-lab-vagrant/
````
Run tbe vagrant command
````

murali@ckslab $ vagrant up

Bringing machine 'master1' up with 'virtualbox' provider...
Bringing machine 'worker1' up with 'virtualbox' provider...
==> master1: Importing base box 'ubuntu/bionic64'...
==> master1: Generating MAC address for NAT networking...
...
...
worker1: * Certificate signing request was sent to apiserver and a response was received.
    worker1: * The Kubelet was informed of the new secure connection details.
    worker1: 
    worker1: Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
````
Check the cluster status
````
murali@ckslab $ vagrant status
Current machine states:

master1                   running (virtualbox)
worker1                   running (virtualbox)
````
SSH to the master node
````
murali@ckslab $ ssh student@192.168.10.11 -i id_rsa
The authenticity of host '192.168.10.11 (192.168.10.11)' can't be established.
ECDSA key fingerprint is SHA256:JFKKm9BZz0YOUhyeyhBaFX3Ibbc6kuDW28K/5KGpSgs.
  System load:  0.28              Users logged in:        0
  Usage of /:   7.3% of 38.71GB   IP address for enp0s3:  10.0.2.15
  Memory usage: 38%               IP address for enp0s8:  192.168.10.11
  Swap usage:   0%                IP address for docker0: 172.17.0.1
  Processes:    152               IP address for weave:   10.32.0.1

````
List the nodes in the kubernestes cluster
````
student@master-01:~$ kubectl get node

NAME        STATUS   ROLES                  AGE    VERSION
master-01   Ready    control-plane,master   3m4s   v1.20.2
worker-01   Ready    <none>                 79s    v1.20.2
````
List the pods in the kube-system namespace
````
student@master-01:~$ kubectl get pod -n kube-system
NAME                                READY   STATUS    RESTARTS   AGE
coredns-74ff55c5b-dc8gd             1/1     Running   0          3m1s
coredns-74ff55c5b-gnvtj             1/1     Running   0          3m1s
etcd-master-01                      1/1     Running   0          3m15s
kube-apiserver-master-01            1/1     Running   0          3m15s
kube-controller-manager-master-01   1/1     Running   0          3m15s
kube-proxy-srrzg                    1/1     Running   0          94s
kube-proxy-wckhh                    1/1     Running   0          3m1s
kube-scheduler-master-01            1/1     Running   0          3m15s
weave-net-jwj2c                     2/2     Running   1          94s
weave-net-nbn2r                     2/2     Running   1          3m1s
````
Run your first pod
````
student@master-01:~$ kubectl run nginx --image=nginx
pod/nginx created

````
Check if the nginx pod status
````
student@master-01:~$ kubectl get pod nginx 
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          42s
````

Suspend the cluster
````
murali@ckslab $ vagrant suspend
==> master1: Saving VM state and suspending execution...
==> worker1: Saving VM state and suspending execution...
````
Resume the cluster
````
murali@ckslab $ vagrant resume

==> master1: Resuming suspended VM...
...
==> worker1: Resuming suspended VM...
...
==> worker1: flag to force provisioning. Provisioners marked to run always will still run.
````
