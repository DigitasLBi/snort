snort_path = "#{Chef::Config[:file_cache_path]}/snort.rpm"

remote_file snort_path do
	source node["snort_rpm_url"]
	action :create_if_missing
	notifies :install, "yum_package[#{snort_path}]", :immediately
end

yum_package snort_path do
	action :nothing
end