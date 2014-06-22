template "/etc/rc.d/init.d/supervisord" do
  source "supervisor.erb"
  owner "root"
  group "root"
  mode 00755
end

execute "chkconfig --level 345 supervisord on" do
  user "root"
end

include_recipe 'supervisor'