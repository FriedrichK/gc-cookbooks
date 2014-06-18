default['postgresql']['version'] = "9.3"
default['postgresql']['enable_pgdg_yum'] = true
default['postgresql']['dir'] = "/var/lib/pgsql/9.3/data"
default['postgresql']['client']['packages'] = ["postgresql93", "postgresql93-devel"]
default['postgresql']['server']['packages'] = ["postgresql93-server"]
default['postgresql']['server']['service_name'] = "postgresql-9.3"
default['postgresql']['contrib']['packages'] = ["postgresql93-contrib"]

default['postgresql']['password']['postgres'] = 'temporary'