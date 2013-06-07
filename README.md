# postgresql-src

Installs/Configures postgresql from src on Ubuntu

Currently assumes Vagrant, you probably don't want this in production at the moment.


## Requirements

## Usage

## Attributes

```
# http://ftp.postgresql.org/pub/source/v9.3beta1/postgresql-9.3beta1.tar.gz

node.set[:postgresql_src][:version]     = "9.3beta1"

node.set[:postgresql_src][:remote_tar]  = "http://ftp.postgresql.org/pub/source/v#{node[:postgresql_src][:version]}/postgresql-#{node.set[:postgresql_src][:version]}.tar.gz"

node.set[:postgresql_src][:packages]    = %w{build-essential libreadline6-dev zlib1g-dev}

node.set[:postgresql_src][:data_dir]    = "/usr/local/pgsql/data"

node.set[:postgresql_src][:bin_dir]     = "/usr/local/pgsql/bin"

node.set[:postgresql_src][:connections] = {"10.0.0.0/16" => "trust"}

node.set[:postgresql_src][:replication] = {}

node.set[:postgresql_src][:conf]        = {listen_addresses: "*"}


node.set[:postgresql_src][:vagrant]     = true

```

## Recipes

### Default
Installs Postgresql from Source.
Default version is 9.3


### Vagrant
Adds vagrant user to sudo. Possibly a better way of doing this.

# Author

Author:: Toby Hede (<tobyhede@info-architects.net>)
