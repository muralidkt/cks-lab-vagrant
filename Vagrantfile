
MASTER_01_IP = "192.168.10.11"
WORKER_01_IP = "192.168.10.13"
WORKER_02_IP = "192.168.10.14"

POD_NETWORK_CIDR = "10.244.0.0/16"

unless File.exists?("id_rsa")
 system("ssh-keygen -t rsa -f id_rsa -N '' -q")
end

Vagrant.configure("2") do |config|
    config.vm.base_mac = nil
    config.vm.box = "ubuntu/bionic64"
    config.vm.box_check_update = false

# Provider-specific configuration -- VirtualBox
    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--groups", "/" + "CKS"]
    end

    config.vm.define "master1" do |master1|
        master1.vm.provider "virtualbox" do |vb|
            disk = 'master1.img'
            vb.memory = 2 * 1024
            vb.cpus = 2
            vb.name = "master-01"
        end

        master1.vm.hostname = "master-01"
        master1.vm.network "private_network", ip: MASTER_01_IP
        master1.vm.network "forwarded_port", guest: 8001, host: 9001
        master1.vm.provision :shell, path: "provision-master.sh"
    end

    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--groups", "/" + "CKS"]
    end
    config.vm.define "worker1" do |worker1|
        worker1.vm.provider "virtualbox" do |vb|
            disk = 'worker1.img'
            vb.memory = 2 * 1024
            vb.cpus = 2
            vb.name = "worker-01"
        end

        worker1.vm.hostname = "worker-01"
        worker1.vm.network "private_network", ip: WORKER_01_IP
        worker1.vm.provision :shell, path: "provision-worker.sh"
        worker1.vm.provision :shell, path: "token.sh"
    end

    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--groups", "/" + "CKS"]
    end
    config.vm.define "worker2" do |worker2|
        worker2.vm.provider "virtualbox" do |vb|
            disk = 'worker2.img'
            vb.memory = 2 * 1024
            vb.cpus = 2
            vb.name = "worker-02"
        end

        worker2.vm.hostname = "worker-02"
        worker2.vm.network "private_network", ip: WORKER_02_IP
        worker2.vm.provision :shell, path: "provision-worker.sh"
        worker2.vm.provision :shell, path: "token.sh"
    end

end
