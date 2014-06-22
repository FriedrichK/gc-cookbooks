include_recipe "database::postgresql"

ENV['PGUSER'] = node['gamecoach']['postgresql']['user']
file "/etc/profile.d/postgres_variables.sh" do
  content <<-EOF
export PGUSER=#{node['gamecoach']['postgresql']['user']}
  EOF
  owner "root"
  group "root"
  mode 00644
end

cookbook_file ".pgpass" do
  path "/home/vagrant/.pgpass"
  owner "vagrant"
  group "vagrant"
  mode 00600
  action :create
end

postgresql_database "#{node['gamecoach']['postgresql']['database']}" do
  connection(
    :host => node['gamecoach']['postgresql']['host'],
    :port => node['gamecoach']['postgresql']['port'],
    :username => node['gamecoach']['postgresql']['user']
  )
  action :create
end

directory "#{node['gamecoach']['project_folder']}" do
  owner "vagrant"
  group "root"
  action :create
end

git "#{node['gamecoach']['project_folder']}" do
  repository "#{node['gamecoach']['repository']}"
  reference "#{node['gamecoach']['branch']}"
  action "sync"
  user "vagrant"
end

template "#{node['gamecoach']['project_folder']}/#{node['gamecoach']['application_name']}/.env" do
  source ".env.erb"
  user "vagrant"
  group "root"
  mode 00771
end

python_virtualenv "#{node['gamecoach']['project_folder']}/venv" do
  interpreter "python2.7"
  owner "vagrant"
  group "root"
  options "--no-site-packages"
  action :create
end

python_pip "django" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "1.6.5"
  user "vagrant"
  group "root"
end

python_pip "gunicorn" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "19.0.0"
  user "vagrant"
  group "root"
end

python_pip "django-dotenv" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "1.2"
  user "vagrant"
  group "root"
end

python_pip "django-getenv" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "1.3.1"
  user "vagrant"
  group "root"
end

python_pip "factory_boy" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "2.3.1"
  user "vagrant"
  group "root"
end

python_pip "fake-factory" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "0.4.0"
  user "vagrant"
  group "root"
end

ENV['PATH'] = ENV['PATH'] + ":" + node['gamecoach']['postgresql']['path_to_pg_config']
python_pip "psycopg2" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "2.5.3"
  user "vagrant"
  group "root"
end

execute "#{node['gamecoach']['project_folder']}/venv/bin/python #{node['gamecoach']['project_folder']}/manage.py syncdb --noinput > #{node['gamecoach']['project_folder']}/syncdb.log" do
end

template "#{node['gamecoach']['project_folder']}/venv/bin/gunicorn_start" do
  source "gunicorn_start.erb"
  user "vagrant"
  group "root"
  mode 00771
end

template "#{node['nginx']['dir']}/conf.d/gamecoach.conf" do
  source "gamecoach_nginx_conf.erb"
  notifies :restart, "service[nginx]", :immediately
end

directory "#{node['gamecoach']['project_folder']}/logs" do
  owner "vagrant"
  group "root"
  action :create
end

service 'supervisord' do
  action :restart
end

supervisor_service "gamecoach" do
  command "#{node['gamecoach']['project_folder']}/venv/bin/gunicorn_start"
  user "root"
  stdout_logfile "#{node['gamecoach']['project_folder']}/logs/gunicorn_supervisor.log"
  redirect_stderr true
end