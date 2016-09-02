bash 'add-php56-repo-remove' do
    code "
      sudo rm -rf /etc/apt/sources.list.d/dotdeb.list
      sudo apt-get update
      sudo apt-get -y purge php5-common
      sudo rm -rf /etc/php56.xd
    "
    only_if { ::File.exists?("/etc/php56.xd") }
end

package 'imagemagick'
package 'php5-cli'
package 'php5-fpm'
package 'php5-curl'
package 'php5-gd'
package "make"
package "php5-dev"
package "php-pear"
package "libpcre3-dev"

# Update php.ini config to php-fpm
template "/etc/php5/fpm/php.ini" do
  source "php.ini.erb"
  mode '0644'
  variables(
    :max_execution_time => node["php"]["max_execution_time"]
  )
end

# Update php-fpm config
template "/etc/php5/fpm/pool.d/www.conf" do
  source "www.conf.erb"
  mode '0644'
  variables(
    :host => node["php"]["fpm"]["host"],
    :port => node["php"]["fpm"]["port"],
    :memory_limit => node['php_memory_limit'] || '256M',
    :dev_user => 'vagrant'
  )
end

package 'php5-mcrypt' do
  action :install
  notifies(:run, "execute[/usr/sbin/php5enmod mcrypt]", :immediately) if platform?('ubuntu') && node['platform_version'].to_f >= 12.04
end

execute '/usr/sbin/php5enmod mcrypt' do
  action :nothing
  only_if { platform?('ubuntu') && node['platform_version'].to_f >= 12.04 && ::File.exists?('/usr/sbin/php5enmod') }
end


# Install Xdebug
bash 'install_xdebug_php_extension' do
  code "
    pecl install xdebug
    OAUTH_EXTENSION_PATH=`find / -name \"xdebug.so\" 2>/dev/null`
    if [ -n \"$OAUTH_EXTENSION_PATH\" ]; then
      touch /etc/php5/mods-available/xdebug.ini
      echo -e '; configuration for php OAuth module\n; priority=10\nzend_extension=xdebug.so\nxdebug.remote_enable=1\nxdebug.remote_handler=dbgp\nxdebug.remote_port=9000\nxdebug.remote_log=\"/var/log/xdebug/xdebug.log\"\nxdebug.overload_var_dump=\"0\"\nxdebug.var_display_max_data=-1\nxdebug.idekey=PHPSTORM\nxdebug.remote_connect_back=1' > /etc/php5/mods-available/xdebug.ini
      /usr/sbin/php5enmod xdebug
      /etc/init.d/php5-fpm restart
    fi
  "
  not_if { ::File.exists?("/etc/php5/mods-available/xdebug.ini") }
end
