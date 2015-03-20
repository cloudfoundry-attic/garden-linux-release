Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  # synced directories for go development environment
  config.vm.synced_folder ENV['GOPATH'], "/vagrant_go"
  config.vm.synced_folder "./scripts/vagrant-go", "/vagrant_setup"

  # warden (debugging)
  config.vm.network "forwarded_port", guest: 7777, host: 7777
  if ports = ENV["GARDEN_EXTRA_PORTS"]
    ports.split(",").each do |port|
      config.vm.network "forwarded_port", guest: port, host: port
    end
  end

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 6

    # dns resolution appears to be very slow in some environments; this fixes it
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  # provides aufs
  config.vm.provision "shell", inline: "apt-get update && apt-get -y install linux-image-extra-$(uname -r)"

  # go development environment
  config.vm.provision :shell, path: "./scripts/vagrant-go/configure-box.sh"

  manifest_file = ENV["GARDEN_MANIFEST"] || "manifests/vagrant-bosh.yml"
  config.vm.provision "bosh" do |c|
    c.manifest = File.read(manifest_file)
  end
end
