include_recipe 'yum-epel'
yum_package 'libdnet'

daq_path = "#{Chef::Config[:file_cache_path]}/daq.rpm"

remote_file daq_path do
	source node["snort_daq_rpm_url"]
	action :create_if_missing
	notifies :install, "yum_package[#{daq_path}]", :immediately
end

yum_package daq_path do
	action :nothing
end

snort_path = "#{Chef::Config[:file_cache_path]}/snort.rpm"

remote_file snort_path do
	source node["snort_rpm_url"]
	action :create_if_missing
	notifies :install, "yum_package[#{snort_path}]", :immediately
end

yum_package snort_path do
	action :nothing
end

community_compressed_file = "#{Chef::Config[:file_cache_path]}/community.tar.gz"
community_path = "/etc/snort/rules/"

remote_file community_compressed_file do 
	source "http://www.snort.org/rules/community"
	action :create_if_missing
end

execute "tar zxvf #{community_compressed_file} -C #{community_path}" do
  action :run
end

template '/etc/snort/snort.conf' do
  source 'snort.conf.erb'
end

template '/etc/init.d/snortd' do
  source 'init.d.snortd.erb'
end

service "snortd" do
	supports :status => true, :restart => true, :reload => true
	action [:start, :enable]
end