default["gamecoach"]["distribution"] = "release"
default["gamecoach"]["application_name"] = "gamecoach"

default["gamecoach"]["user"] = "root"
default["gamecoach"]["group"] = "root"

if node["gamecoach"]["user"] == "root"
	default["gamecoach"]["home_dir"] = "/root"
else
	default["gamecoach"]["home_dir"] = '/home/#{node["gc-base"]["user"]}'
end

default['gamecoach']['project_folder'] = "/opt/gamecoach"
default['gamecoach']['repository'] = "git@github.com:FriedrichK/gamecoach.git"
default['gamecoach']['branch'] = "master"

default["gamecoach"]["virtualenv"]["bin"] = "#{node['gamecoach']['project_folder']}/venv/bin"
default["gamecoach"]["virtualenv"]["activate_script"] = "#{node['gamecoach']['virtualenv']['bin']}/activate"

default["gamecoach"]["django"]["settings"] = "gamecoach.settings"
default["gamecoach"]["django"]["wsgi"] = "gamecoach.wsgi"

default["gamecoach"]["gunicorn"]["sock_file"] = "#{node['gamecoach']['project_folder']}/run/gunicorn.sock"
default["gamecoach"]["gunicorn"]["number_of_workers"] = "3"

default["gamecoach"]["nginx"]["port"] = "80"
default["gamecoach"]["nginx"]["server_name"] = "127.0.0.1"
default["gamecoach"]["nginx"]["static_directory"] = "#{node['gamecoach']['project_folder']}/static"
default["gamecoach"]["nginx"]["static_directory_facebook"] = "#{node['gamecoach']['project_folder']}/venv/lib/python2.7/site-packages/django_facebook/static/django_facebook"
default["gamecoach"]["nginx"]["mediaroot"] = '/var/gamecoach/'

default["gamecoach"]["postgresql"]["host"] = "127.0.0.1"
default["gamecoach"]["postgresql"]["port"] = "5432"
default["gamecoach"]["postgresql"]["user"] = "postgres"
default["gamecoach"]["postgresql"]["password"] = "temporary"
default["gamecoach"]["postgresql"]["database"] = "gamecoach"
default['gamecoach']['postgresql']['path_to_pg_config'] = '/usr/pgsql-9.3/bin/pg_config'

default['gamecoach']['facebook']['id'] = '240307459426941'
default['gamecoach']['facebook']['secret'] = 'b43a86dfa3d76dfac28a1d4527246099'

default["gamecoach"]["filestystem"]["mediaroot"] = '/var/gamecoach/upload'