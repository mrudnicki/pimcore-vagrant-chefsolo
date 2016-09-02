package 'mysql-server'
package 'php5-mysql'

template "/etc/mysql/my.cnf" do
  source "my.cnf.erb"
  notifies :reload, "service[mysql]", :immediately
end

service "mysql" do
  supports :restart => true, :start => true, :stop => true, :reload => true
  action [ :enable, :start]
end

