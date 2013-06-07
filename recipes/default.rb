#
# Cookbook Name:: postgresql-src
# Recipe:: default



include_recipe "apt"

include_recipe "sudo::default"

include_recipe "postgresql-src::vagrant"



ruby_block "apt-get-update" do
  block do
    `apt-get update`
  end
  action :create
end

tarfile = "#{Chef::Config[:file_cache_path]}/postgresql-#{node[:postgresql_src][:version]}.tar.gz"
src_dir = "#{Chef::Config[:file_cache_path]}/postgresql-#{node[:postgresql_src][:version]}"

node[:postgresql_src][:packages].each do |package_name|
  package package_name do
    action :install
  end
end

remote_file tarfile do
  source node[:postgresql_src][:remote_tar]
  mode 00644
  not_if { File.exist?(tarfile) }
end

bash 'install postgres from source' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    rm -rf #{src_dir}
    tar zxvf #{tarfile}
    cd #{src_dir}
    ./configure
    make
    make install
  EOH

  not_if "ls -1 #{node[:postgresql_src][:bin_dir]}/postgres"
end

# user "postgres" do
#   action :create
# end

group "postgres" do
  action :create
end

# create postgres user if not already there
user "postgres" do
  comment "PostgreSQL User"
  group "postgres"
  home "/var/pgsql"
  action :create
end

# execute "sudo adduser postgres" do
#   command "sudo adduser postgres"
#   action :run
# end

sudo "postgres" do
  user      "postgres"
  nopasswd  true
end


directory node[:postgresql_src][:data_dir] do
  owner "postgres"
  group "postgres"
  mode 0700
  action :create
end

execute "initdb" do
  user "postgres"
  command "#{node[:postgresql_src][:bin_dir]}/initdb -D #{node[:postgresql_src][:data_dir]}"
  action :run
end


template "#{node[:postgresql_src][:data_dir]}/pg_hba.conf" do
  source "pg_hba.conf.erb"
  owner "postgres"
  group "postgres"
  mode "0600"
  # notifies :reload, "service[#{service_name}]"
  variables(connections: node[:postgresql_src][:connections],
            replication: node[:postgresql_src][:replication])
end


template "#{node[:postgresql_src][:data_dir]}/postgresql.conf" do
  source "postgresql.conf.erb"
  owner "postgres"
  group "postgres"
  mode "0600"
  variables(conf: node.set[:postgresql_src][:conf])
end

execute "postgres" do
  user "postgres"
  command "#{node[:postgresql_src][:bin_dir]}/postgres -D #{node[:postgresql_src][:data_dir]}"
  action :run
end



# template "#{data_dir}/postgresql.conf" do
#   source 'postgresql.conf.erb'
#   owner os_user
#   group os_group
#   mode '0600'
#   notifies :reload, "service[#{service_name}]"
#   variables config.to_hash.merge('listen_addresses' => node['postgres']['listen_addresses'])
# end

# include_recipe 'postgres::contrib'

# sudo mkdir /usr/local/pgsql/data
# sudo adduser postgres
# sudo chown postgres /usr/local/pgsql/data
# su - postgres
