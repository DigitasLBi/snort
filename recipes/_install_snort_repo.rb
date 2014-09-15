yum_repository node["snort_repo"]["name"] do
  description node["snort_repo"]["name"]
  baseurl node["snort_repo"]["baseurl"]
  gpgkey node["snort_repo"]["gpgkey"]
  action :create
end

yum_package 'snort.x86_64'