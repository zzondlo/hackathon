include_attribute "cf-deployment"

default[:ccdb][:user] = "root"
default[:ccdb][:password] = "changeme"
default[:ccdb][:database] = "cloud_controller"
default[:ccdb][:port] = "5432"
default[:ccdb][:data_dir] = File.join(node[:deployment][:home], "ccdb_data_dir")
