#
# Cookbook Name:: postgresql-src
# Recipe:: vagrant


sudo "vagrant" do
  user      "vagrant"
  nopasswd  true

  # only_if { node[:postgresql_src][:vagrant] }
end
