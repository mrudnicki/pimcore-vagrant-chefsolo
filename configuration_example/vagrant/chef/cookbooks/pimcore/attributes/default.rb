default['max_execution_time'] = 600
default["php"]["max_execution_time"] = 600
default["php"]["fpm"]['port'] = 9000
default["php"]["fpm"]['host'] = '127.0.0.1'

default[:hosts][:pimcore1] = {
    :server_name => "pimcore-vagrant.local *.pimcore-vagrant.local",
    :root_directory => "/vagrant/www/pimcore1"

}

# default[:hosts][:pimcore2] = {
#     :server_name => "pimcore-vagrant2.local",
#     :root_directory => "/vagrant/www/pimcore2"
# }