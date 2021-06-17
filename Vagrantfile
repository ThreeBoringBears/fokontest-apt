require 'socket'
require 'ipaddr'

subnet = IPAddr.new('192.168.16.0/20')
addr_infos = Socket.getifaddrs

inet_name=''
addr_infos.each do |addr_info|
  if addr_info.addr && addr_info.addr.ipv4?
    tmpnet = IPAddr.new(addr_info.addr.ip_address)
    if subnet.include?(tmpnet)
      inet_name = addr_info.name
      break
    end
  end
end

Vagrant.configure(2) do |config|
  key_file='~/.ssh/id_rsa_testingk8s'
  if ! File.file?(File.expand_path(key_file))
    raise key_file + " not found"
  end

  common = <<-SHELL

  SHELL

  config.vm.box = "ubuntu/focal64"
  config.vm.box_url = "ubuntu/focal64"
  NODES = [
   { :hostname => "yaka", :ip => "192.168.8.120", :cpu => 1, :mem => 16392, :type => "fokon" }
  ]

#  etcHosts= ""
#  NODES.each do |node|
#    if node[:type] != "haproxy"
#      etcHosts += "echo '" + node[:ip] + "    " + node[:hostname] +"' >> /etc/hosts" +"\n"
#    else
#      etcHosts += "echo '" + node[:ip] + "    " + node[:hostname] +" autoelb.kub' >> /etc/hosts" +"\n"
#    end
#  end

  NODES.each do |node|
    config.vm.define node[:hostname] do |cfg|
  	   cfg.vm.hostname = node[:hostname]
      cfg.vm.network "public_network", bridge: inet_name, use_dhcp_assigned_default_route: true
    	cfg.vm.provider "virtualbox" do |v|
    		v.customize ["modifyvm", :id, "--cpus", node[:cpu]]
    		v.customize ["modifyvm", :id, "--memory", node[:mem]]
    		v.customize ["modifyvm", :id, "--name", node[:hostname]]
    	end

      ### Adding ssh key
      cfg.ssh.insert_key = false
      cfg.ssh.private_key_path = ['~/.vagrant.d/insecure_private_key', key_file]
      cfg.vm.provision "file", source: key_file + '.pub', destination: "~/.ssh/authorized_keys"

      if node[:type] == "fokon"
        cfg.vm.provision :shell, :path => "install/yaka_installer.sh"
      end
      ### Specific installation
      cfg.vm.provision "file", source: "./packages_dir", destination: "/var/www/html/"

    end
  end
end
