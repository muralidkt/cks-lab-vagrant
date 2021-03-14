
# CKA / CKS Lab Environment
This is a lab environment for the CKA / CKS Certification course. Please follow the instructions to setup the lab.
## Cluster Details
  | Node Name   | IP Address           |
  | ------      | ------------- |
  | master-01   | 192.168.10.11 |
  | worker-01   | 192.168.10.13 |
  | worker-02   | 192.168.10.14 | 
## Prerequesites
- Vagrant : Vagrant is a tool from HashiCorp for building and distributing development environments. You can read more about the tool in the below link. Please download vagrant from [here](https://www.vagrantup.com/downloads) and follow the [instructions](https://learn.hashicorp.com/tutorials/vagrant/getting-started-install) for installing vagrant in your machine.
    - Website: https://www.vagrantup.com/
    - Source: https://github.com/hashicorp/vagrant
    - HashiCorp Discuss: https://discuss.hashicorp.com/c/vagrant/24


- VritualBox : VirtualBox is a general-purpose virtualization tool. You can download virtualbox from [here](https://www.virtualbox.org/wiki/Downloads) and install in your machine.

## Instruction run the lab
Once you install both Vagrant and VirtualBox.

Clone this repository
````
git clone 
````

Move repository folder
````
cd  
````
Run tbe vagrant command
````
vagrant up
````
Check the cluster status
````
vagrant status
````
SSH to the master node
````
ssh student@192.168.10.11 -i id_rsa
````
List the nodes in the kubernestes cluster
````
kubectl get nodes
````
List the pods in the kube-system namespace
````
kubectl get pods -n kube-system
````
Run your first pod
````
kubectl run nginx --image=nginx
````
Suspend the cluster
````
vagrant halt
````
Resume the cluster
````
vagrant resume
````

