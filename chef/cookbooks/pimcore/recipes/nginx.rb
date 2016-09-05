package 'nginx'

template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  variables(
    :dev_user => 'vagrant'
  )
end

service "nginx" do
  supports :restart => true, :start => true, :stop => true, :reload => true
  action [ :enable, :start ]
end