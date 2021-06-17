Vagrant.configure(2) do |config|
  key_file='~/.ssh/id_rsa_testingk8s'
  if ! File.file?(File.expand_path(key_file))
    raise key_file + " not found"
  end

  common = <<-SHELL
  apt update && apt upgrade -y
  ## Add repo
  ## Add docker install
  ## Add adduser + groups

  sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
  sudo systemctl restart sshd
  SHELL

  config.vm.box = "ubuntu/focal64"
  config.vm.box_url = "ubuntu/focal64"
  NODES = [
   { :hostname => "yaka", :ip => "192.168.8.120", :cpu => 1, :mem => 16392, :type => "fokon" }
  ]

  etcHosts= ""
  NODES.each do |node|
    if node[:type] != "haproxy"
      etcHosts += "echo '" + node[:ip] + "    " + node[:hostname] +"' >> /etc/hosts" +"\n"
    else
      etcHosts += "echo '" + node[:ip] + "    " + node[:hostname] +" autoelb.kub' >> /etc/hosts" +"\n"
    end
  end

  NODES.each do |node|
    config.vm.define node[:hostname] do |cfg|
  	   cfg.vm.hostname = node[:hostname]
      cfg.vm.network "public_network", use_dhcp_assigned_default_route: true
    	cfg.vm.provider "virtualbox" do |v|
    		v.customize ["modifyvm", :id, "--cpus", node[:cpu]]
    		v.customize ["modifyvm", :id, "--memory", node[:mem]]
    		v.customize ["modifyvm", :id, "--name", node[:hostname]]
    	end

      ### Adding ssh key
      cfg.ssh.insert_key = false
      cfg.ssh.private_key_path = ['~/.vagrant.d/insecure_private_key', key_file]
      cfg.vm.provision "file", source: key_file + '.pub', destination: "~/.ssh/authorized_keys"

      ### Adding /etc/hosts generated file
      cfg.vm.provision :shell, :inline => etcHosts

      ### Specific installation

    end
  end
end 
