Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  # warden (debugging)
  config.vm.network "forwarded_port", guest: 7777, host: 7777

  if ports = ENV["GARDEN_EXTRA_PORTS"]
    ports.split(",").each do |port|
      config.vm.network "forwarded_port", guest: port, host: port
    end
  end

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 4

    # dns resolution appears to be very slow in some environments; this fixes it
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  # dev
  config.vm.synced_folder ENV['GOHOME']+"/src", "/vagrant_go_src"
  config.vm.synced_folder ENV['GOHOME']+"/pkg", "/vagrant_go_pkg"
  config.vm.synced_folder "./vagrant_setup", "/vagrant_setup"
  config.vm.synced_folder "~/.ssh", "/vagrant_ssh"

  # provides aufs
  config.vm.provision "shell", inline: "apt-get update && apt-get -y install linux-image-extra-$(uname -r)"

  manifest_file = ENV["GARDEN_MANIFEST"] || "manifests/vagrant-bosh.yml"
  config.vm.provision "bosh" do |c|
    c.manifest = File.read(manifest_file)
  end

  config.vm.provision :shell, path: "configure_box.sh"

end
