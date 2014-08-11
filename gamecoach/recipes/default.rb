include_recipe "gc-base"
include_recipe "gc-python"
include_recipe "gc-nginx"
include_recipe "gc-supervisor"
include_recipe "gc-postgresql::server"
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
  path "#{node['gamecoach']['home_dir']}/.pgpass"
  owner node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
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

directory "#{node['gamecoach']['filestystem']['mediaroot']}" do
  owner node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
  action :create
  recursive true
end

directory "#{node['gamecoach']['project_folder']}" do
  owner node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
  action :create
end

git "#{node['gamecoach']['project_folder']}" do
  repository "#{node['gamecoach']['repository']}"
  reference "#{node['gamecoach']['branch']}"
  action "sync"
  user node["gamecoach"]["user"]
end

template "#{node['gamecoach']['project_folder']}/#{node['gamecoach']['application_name']}/.env" do
  source ".env.erb"
  user node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
  mode 00771
end

#python_pip 'setuptools' do
#  action :upgrade
#  version node['python']['setuptools_version']
#end

python_virtualenv "#{node['gamecoach']['project_folder']}/venv" do
  interpreter "python2.7"
  owner node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
  options "--no-site-packages"
  action :create
end

python_pip "Pillow" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "2.4.0"
  user node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
end

python_pip "django" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "1.6.5"
  user node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
end

python_pip "gunicorn" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "19.0.0"
  user node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
end

python_pip "django-nose" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "1.2"
  user node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
end

python_pip "django-dotenv" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "1.2"
  user node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
end

python_pip "django-getenv" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "1.3.1"
  user node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
end

python_pip "django-postman" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "3.1.0"
  user node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
end

python_pip "django-facebook" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "6.0.0"
  user node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
end

ENV['PATH'] = ENV['PATH'] + ":" + node['gamecoach']['postgresql']['path_to_pg_config']
python_pip "psycopg2" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "2.5.3"
  user node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
end

python_pip "south" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "1.0"
  user node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
end

python_pip "mock" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "1.0.1"
  user node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
end

python_pip "factory_boy" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "2.3.1"
  user node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
end

python_pip "fake-factory" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "0.4.0"
  user node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
end

python_pip "Faker" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "0.0.4"
  user node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
end

python_pip "selenium" do
  virtualenv "#{node['gamecoach']['project_folder']}/venv"
  version "2.42.1"
  user node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
end

execute "#{node['gamecoach']['project_folder']}/venv/bin/python #{node['gamecoach']['project_folder']}/manage.py syncdb --noinput > #{node['gamecoach']['project_folder']}/syncdb.log" do
end

execute "#{node['gamecoach']['project_folder']}/venv/bin/python #{node['gamecoach']['project_folder']}/manage.py migrate django_facebook > #{node['gamecoach']['project_folder']}/migrate.log" do
end

execute "#{node['gamecoach']['project_folder']}/venv/bin/python #{node['gamecoach']['project_folder']}/manage.py migrate profiles > #{node['gamecoach']['project_folder']}/migrate.log" do
end

template "#{node['gamecoach']['project_folder']}/venv/bin/gunicorn_start" do
  source "gunicorn_start.erb"
  user node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
  mode 00771
end

template "#{node['nginx']['dir']}/sites-enabled/gamecoach.conf" do
  source "gamecoach_nginx_conf.erb"
  notifies :restart, "service[nginx]", :immediately
end

directory "#{node['gamecoach']['project_folder']}/logs" do
  owner node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
  action :create
end

template "/etc/supervisor.d/gamecoach.conf" do
  source "gamecoach_supervisor_conf.erb"
  user node["gamecoach"]["user"]
  group node["gamecoach"]["group"]
  mode 00644
end

service 'supervisord' do
  action :restart
end

supervisor_service "gamecoach" do
  command "#{node['gamecoach']['project_folder']}/venv/bin/gunicorn_start"
  user node["gamecoach"]["group"]
  stdout_logfile "#{node['gamecoach']['project_folder']}/logs/gunicorn_supervisor.log"
  redirect_stderr true
end