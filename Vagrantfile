# -*- mode: ruby -*-
# vi: set ft=ruby :

def install_plugin(plugin)
  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

install_plugin('vagrant-vbguest')
install_plugin('vagrant-hostmanager')
install_plugin('sahara')
install_plugin('vagrant-vbox-snapshot')
install_plugin('vagrant-docker-compose')

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  #config.vm.box = "base"
  config.vm.box = "generic/rocky9"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 80, host: 40080
  config.vm.network "forwarded_port", guest: 443, host: 40443
  config.vm.network "forwarded_port", guest: 6379, host: 46379
  config.vm.network "forwarded_port", guest: 3306, host: 43306, host_ip: "127.0.0.1", auto_correct: true
  config.vm.network "forwarded_port", guest: 2376, host: 42376, host_ip: "127.0.0.1", auto_correct: true

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "private_network", ip: "192.168.56.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.synced_folder "./", "/vagrant"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.
  config.vm.provider :virtualbox do |vb|
    vb.name = "testdocker"
    vb.gui = false
    vb.memory = "4096"
    vb.cpus = 4
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    #ボリューム変更方法
    # $ vagrant ssh
    # $ sudo pvdisplay  ... LVMの Phigical Volume 確認
    # $ sudo lvdisplay  ... LVMの Logical Volume 確認
    # $ sudo vgdisplay  ... LVMの Volume Group 確認
    # $ sudo lvextend -L100GB /dev/centos_centos7/root  ... LVMの Logical Volume サイズ拡張
    # $ sudo xfs_growfs /dev/mapper/centos_centos7-root  ... ファイルシステム（xfs）サイズ拡張
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  config.vm.provision :setup, privileged: true, type: "shell",
    run: "once" do |s|
      s.inline = <<-SHELL
        echo setup
        #hostname -b testdocker.localdomain
        hostnamectl set-hostname testdocker.localdomain
        dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        dnf -y update
        dnf -y install docker-ce --allowerasing
        usermod -aG docker vagrant
        #sed -i -e 's/-H fd:\/\/ --containerd/-H fd:\/\/ --tlsverify --tlscacert=\/vagrant\/docker\/ca\/ca.pem --tlscert=\/vagrant\/docker\/ca\/server-cert.pem --tlskey=\/vagrant\/docker\/ca\/server-key.pem -H tcp:\/\/0.0.0.0:2376 --containerd/' /usr/lib/systemd/system/docker.service
        sed -i -e 's,-H fd:// --containerd,-H fd:// --tlsverify --tlscacert=/vagrant/docker/ca/ca.pem --tlscert=/vagrant/docker/ca/server-cert.pem --tlskey=/vagrant/docker/ca/server-key.pem -H tcp://0.0.0.0:2376 --containerd,' /usr/lib/systemd/system/docker.service
        #cp /vagrant/docker/fw/docker.xml /usr/lib/firewalld/services/.
        firewall-cmd --add-port=2376/tcp --permanent
        #firewall-cmd --add-port=2375/tcp --permanent
        firewall-cmd --reload
        systemctl daemon-reload
        systemctl stop docker
        systemctl start docker
        systemctl enable docker
      SHELL
    end
  config.vm.provision :wait, privileged: true, type: "shell",
    run: "always" do |s|
      s.inline = <<-SHELL
        echo wait for start docker
        for ((i=0; i < 10; i++)); do if [ -f /vagrant/docker/ca/server-cert.pem -a -f /vagrant/docker/ca/server-key.pem -a -f /vagrant/docker/docker-compose.yml ]; then break; fi; sleep 1; done
        sleep 1
        #cat /vagrant/docker/ca/server-cert.pem
        #cat /vagrant/docker/ca/server-key.pem
        #cat /vagrant/docker/docker-compose.yml
        systemctl start docker
        systemctl status docker
      SHELL
    end
  config.vm.provision :docker
  config.vm.provision :docker_compose, yml: "/vagrant/docker/docker-compose.yml", run: "always"
end