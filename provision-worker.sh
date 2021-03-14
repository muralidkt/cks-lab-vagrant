#!/bin/sh
# set up hosts file in master
cat <<-EOF >>/etc/hosts
192.168.10.10 base
192.168.10.11 master-01
192.168.10.12 master-02
192.168.10.13 worker-01
192.168.10.14 worker-02

EOF

# allow root ssh logins
printf '\nPermitRootLogin yes\n' >> /etc/ssh/sshd_config
printf '\nStrictHostKeyChecking no\n' >>/etc/ssh/ssh_config
systemctl restart sshd

# Make a student sudo user with password welcome1
useradd student -m -p '$6$UhZjFYH1$9RiEbku8QFfIiKq0mf5spCHABaAK218nbH/c3ISzc63v5VRmM/2aUSRpsq3IAJ025.yXbOSJPCpr.VsgG.g3o.' -s /bin/bash
mkdir -p /home/student/.ssh
cp /vagrant/id_rsa /home/student/.ssh/
cp /vagrant/id_rsa.pub /home/student/.ssh/authorized_keys
chmod 0644 /home/student/.ssh/authorized_keys
touch /home/student/.ssh/known_hosts
chmod 0644 /home/student/.ssh/known_hosts
printf 'student ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/student
chmod 440 /etc/sudoers.d/student

# swap no allowed
swapoff -a

# allow ssh between nodes
cp /vagrant/id_rsa /root/.ssh
cp /vagrant/id_rsa.pub /root/.ssh/authorized_keys
chmod 0600 /root/.ssh/*

# Fix locale
locale-gen "en_US.UTF-8"
update-locale LC_ALL="en_US.UTF-8"


# Install and setup in worker 
apt-get install -y apt-transport-https ca-certificates curl 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get -y install docker.io
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "storage-driver": "overlay2"
}
EOF
mkdir -p /etc/systemd/system/docker.service.d
systemctl daemon-reload
systemctl restart docker
systemctl enable docker


# Install kubeadm, kubelet and kubectl
KUBE_VERSION=1.20.2
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet=${KUBE_VERSION}-00 kubeadm=${KUBE_VERSION}-00 kubectl=${KUBE_VERSION}-00
systemctl daemon-reload
systemctl enable kubelet && systemctl start kubelet
sleep 20
cp /vagrant/token.sh /root/token.sh
chmod 700 /root/token.sh
./token.sh