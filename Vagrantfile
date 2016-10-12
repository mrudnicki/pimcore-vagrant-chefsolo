Vagrant.configure("2") do |config|

  # In this case we're using bento/debian-8.4 virtual box
  config.vm.box = "bento/debian-8.4"

  # In this folder will be cloned pimcore instance. Wehen you're logged in to
  # the virtualbox by ssh synchronized path is available in /vagrant/www
  config.vm.synced_folder "./www", "/vagrant/www", type: "nfs"

  config.vm.network "private_network", type: "dhcp"

  config.vm.provider "virtualbox" do |vb|
    # don't disply virtualbox gui
    vb.gui = false

    # Virtual memory on the VM
    vb.memory = "1024"
  end

  #path with chef cookbooks
  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = "./chef/cookbooks"
    chef.roles_path = "./chef/roles"
    chef.add_role("pimcoredefault")
  end

end
