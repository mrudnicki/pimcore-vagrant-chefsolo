bash "create_database" do
  code "mysql -u root -e 'CREATE DATABASE IF NOT EXISTS #{node["mysql_server"]["database_name"]} CHARACTER SET utf8 COLLATE utf8_general_ci;'"
end

# Recommended software

package "php5-imagick"
package "pngcrush"
package "wkhtmltopdf"
package "jpegoptim"
package "html2text"
package "poppler-utils"
package "php5-redis"
package "redis-server"
package "php5-memcache"

# Nginx
template "/etc/nginx/sites-available/#{node['dev_domain']}" do
  source "pimcore-v.local.erb"
  variables(
    :domain => node['dev_domain'],
    :path => node['mount_point'],
    :host => node["php"]["fpm"]["host"],
    :port => node["php"]["fpm"]["port"],
    :max_execution_time => node['max_execution_time'],

  )
end

link "/etc/nginx/sites-enabled/#{node['dev_domain']}" do
  to "/etc/nginx/sites-available/#{node['dev_domain']}"
end

bash "restart_services" do
  code "service nginx reload && service php5-fpm reload"
end

bash "install_libreoffice" do
  code "apt-get install libreoffice --no-install-recommends -y"
end

package "libav-tools"

bash "alias_for_ffmpeg" do
  code "echo \"alias ffmpeg='avconv'\" >> /etc/bash.bashrc && alias ffpmpeg='avconv'"
end


git "checkout_pimcore_installation" do
    checkout_branch "master"
    action  :export
    repository  "https://github.com/pimcore/pimcore.git"
    destination "/vagrant/www/pimcore"
    not_if { ::File.exists?('/vagrant/www/pimcore/index.php') }
end

bash "install_composer" do\
    code "php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\"
          php -r \"if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;\"
          php composer-setup.php
          php -r \"unlink('composer-setup.php');\"
          php composer.phar install;
          cp -R website_example website
          "
    cwd  "/vagrant/www/pimcore"
    not_if { ::File.exists?('/vagrant/www/pimcore/composer.phar') }
    user "vagrant"
end

directory '/vagrant/www/pimcore/website/var' do
    mode '0777'
    action :nothing
end

bash "update_composer" do
    code "php composer.phar update"
    cwd  "/vagrant/www/pimcore"
    user "vagrant"
end