# Pimcore Vagrant project

## Requirements

* Vagrant: [Go to the download page](https://www.vagrantup.com/downloads.html)
* Virtualbox: [Here you can download it](https://www.virtualbox.org/wiki/Downloads)

**Windows users:** 
To optimize performance, Windows users should install the vagrant plugin. 
Just use the command: ```vagrant plugin install vagrant-winnfsd``` in cmd

## Optional configuration

You can change some of the machine settings (e.g. domain) in chef/cookbooks/pimcore/attributes/default.rb

## Installation

* In a terminal go to VagrantFile directory
* type: ```vagrant up``` (you can also just open this project in PHPstorm and use vagrant up command)

If you're using this vagrant box a first time it can take around 15 minutes. 

## It's ready

Ok the environment is ready to use

 * Mysql, Nginx, php-fpm installed and configured
 * every package required by Pimcore installed
 * Pimcore project is in /vagrant/www/pimcore path on virtual machine
 * Project's folder is shared live between your machine and virtual one
 * Host root configured to domain which you chose (default: pimcore-vagrant.local)
 
Type ```vagrant ssh```

If you're Mac or Linux user now you're connected via ssh to VM
Windows user has to use returned value in Putty or an other ssh client

The password for vagrant user is: **vagrant**. You're able to use sudo.

Check your ip using ```sudo ifconfig``` (eth1 inet addr) and add row to your hosts file.
For example:
```
192.168.33.4	 pimcore-vagrant.local
```

MySQL credentials:

database: pimcore
user: root
pass: 

## Update

Use ```vagrant provision``` command to update your VM
