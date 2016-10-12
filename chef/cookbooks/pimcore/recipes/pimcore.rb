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



bash "install_libreoffice" do
  code "apt-get install libreoffice --no-install-recommends -y"
end

package "libav-tools"

bash "alias_for_ffmpeg" do
  code "echo \"alias ffmpeg='avconv'\" >> /etc/bash.bashrc && alias ffpmpeg='avconv'"
end

directory '/vagrant/www/pimcore' do
    action :create
    owner 'vagrant'
    group 'vagrant'
end


bash "install_composer" do
    code "php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\"
          php -r \"if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;\"
          php composer-setup.php
          php -r \"unlink('composer-setup.php');\"
          "
    cwd  "/vagrant/www"
    not_if { ::File.exists?('/vagrant/www/composer.phar') }
    user "vagrant"
end

node[:hosts].each do |project_id, host|
  # database
  bash "create_database_for_dashboard_plugin" do
    code "mysql -u root -e 'CREATE DATABASE IF NOT EXISTS #{project_id} CHARACTER SET utf8 COLLATE utf8_general_ci;'"
  end


# Directory for the installation
  directory host[:root_directory] do
    owner 'vagrant'
    group 'vagrant'
    action :create
  end

# Nginx
  template "/etc/nginx/sites-available/#{project_id}" do
    source "default_pimcore_nginx_conf.erb"
    variables(
        :domain => host[:server_name],
        :root_directory => host[:root_directory],
        :host => node["php"]["fpm"]["host"],
        :port => node["php"]["fpm"]["port"],
        :max_execution_time => node['max_execution_time'],
    )
  end

# install pimcore
  composer_path = "#{host[:root_directory]}/composer.json"
  bash "#{project_id}_pimcore_installation" do
    cwd "/vagrant/www"
    code <<-EOH
        php composer.phar create-project pimcore/pimcore #{host[:root_directory]}
    EOH
    not_if { ::File.exists?(composer_path) }
  end

  link "/etc/nginx/sites-enabled/#{project_id}" do
    to "/etc/nginx/sites-available/#{project_id}"
  end

end


bash "restart_services" do
  code "service nginx reload && service php5-fpm reload"
end