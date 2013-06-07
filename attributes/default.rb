# http://ftp.postgresql.org/pub/source/v9.3beta1/postgresql-9.3beta1.tar.gz

node.set[:postgresql_src][:version]     = "9.3beta1"

node.set[:postgresql_src][:remote_tar]  = "http://ftp.postgresql.org/pub/source/v#{node[:postgresql_src][:version]}/postgresql-#{node.set[:postgresql_src][:version]}.tar.gz"

node.set[:postgresql_src][:packages]    = %w{build-essential libreadline6-dev zlib1g-dev}

node.set[:postgresql_src][:data_dir]    = "/usr/local/pgsql/data"

node.set[:postgresql_src][:bin_dir]     = "/usr/local/pgsql/bin"

node.set[:postgresql_src][:connections] = {"10.0.0.0/16" => "trust"}

node.set[:postgresql_src][:replication] = {}

conf = {
  listen_addresses: "*"
}

node.set[:postgresql_src][:conf]        = conf


node.set[:postgresql_src][:vagrant]     = true
