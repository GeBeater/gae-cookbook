package 'unzip'

cache_file_path = "#{Chef::Config['file_cache_path']}/#{node['google_app_engine']['sdk']['php']['file_name']}"
extract_path = "/opt/google_app_engine/php/#{node['google_app_engine']['sdk']['php']['sha256sum']}"

remote_file cache_file_path do
  source node['google_app_engine']['url'] + node['google_app_engine']['sdk']['php']['file_name']
  checksum node['google_app_engine']['sdk']['php']['sha256sum']
  owner 'root'
  group 'root'
  mode 00644
end

bash 'extract_module' do
  code <<-EOH
    mkdir -p #{extract_path}
    unzip #{cache_file_path} -d #{extract_path}
    rm -f /opt/google_appengine
    ln -s #{extract_path}/google_appengine /opt/google_appengine
    EOH
  not_if { ::File.exists?(extract_path) }
end