Vagrant.configure("2") do |config|
  config.vm.define "vzurera-S" do |server|
    server.vm.box = "debian/bookworm64"
    server.vm.box_version = "12.20250126.1"
    server.ssh.forward_x11 = true
    server.vm.synced_folder ".", "/vagrant", disabled: true
    server.vm.hostname = "vzurera-S"
    server.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
      vb.cpus = 4
      vb.gui = false
      vb.customize ["modifyvm", :id, "--name", "vzurera-S"]
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "off"]
    end
    server.vm.provision "file", source: "srcs", destination: "/tmp/srcs"
    server.vm.provision "file", source: "Makefile", destination: "/tmp/Makefile"
    server.vm.provision "shell", path: "scripts/install.sh"
    server.vm.provision "shell", path: "scripts/start.sh", run: "always"
  end
  # config.trigger.after :up do |trigger|
  #   trigger.run = {
  #     inline: "ssh -Y -C -i .vagrant/machines/vzurera-S/virtualbox/private_key -p 2222 -o StrictHostKeyChecking=no vagrant@127.0.0.1 'firefox-esr https://vzurera.42.fr/inception & filezilla &'"
  #   }
  # end
end
