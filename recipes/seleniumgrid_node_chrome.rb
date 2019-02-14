#
# Cookbook Name:: aet
# Recipe:: seleniumgrid_node_chrome
#
# AET Cookbook
#
# Copyright (C) 2016 Cognifide Limited
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Create dedicated group
group node['aet']['seleniumgrid']['group'] do
  action :create
end

# Create dedicated user
user node['aet']['seleniumgrid']['user'] do
  group node['aet']['seleniumgrid']['group']
  system true
  action :create
end

# Create dedicated node directory
directory "#{node['aet']['seleniumgrid']['node_chrome']['root_dir']}" do
  owner node['aet']['seleniumgrid']['user']
  group node['aet']['seleniumgrid']['group']
  mode '0755'
  action :create
  recursive true
end

# Create log directory
directory "#{node['aet']['seleniumgrid']['node_chrome']['log_dir']}" do
  owner node['aet']['seleniumgrid']['user']
  group node['aet']['seleniumgrid']['group']
  mode '0755'
  action :create
  recursive true
end

# Get Selenium Grid file name from link
filename = get_filename(node['aet']['seleniumgrid']['source'])

# Download Selenium Grid jar to temporary folder
remote_file "/tmp/#{filename}" do
  owner node['aet']['seleniumgrid']['user']
  group node['aet']['seleniumgrid']['group']
  mode '0644'
  source node['aet']['seleniumgrid']['source']
end

# Copy Selenium Grid jar to chrome node folder
remote_file "#{node['aet']['seleniumgrid']['node_chrome']['root_dir']}/#{filename}" do
  source "file:///tmp/#{filename}"
  owner node['aet']['seleniumgrid']['user']
  group node['aet']['seleniumgrid']['group']
  mode 0755
end

# Get chromedriver\ Grid file name from link
filename = get_filename(node['aet']['chromedriver']['source'])

# Download chromedriver
remote_file "/tmp/#{filename}" do
  owner node['aet']['seleniumgrid']['user']
  group node['aet']['seleniumgrid']['group']
  mode '0644'
  source node['aet']['chromedriver']['source']
end

# Copy chromedriver to chrome node folder
remote_file "#{node['aet']['seleniumgrid']['node_chrome']['root_dir']}/#{filename}" do
  source "file:///tmp/#{filename}"
  owner node['aet']['seleniumgrid']['user']
  group node['aet']['seleniumgrid']['group']
  mode 0755
end

# Extract chromedriver file
execute 'extract chromedriver' do
  command "unzip #{filename}"
  cwd node['aet']['seleniumgrid']['node_chrome']['root_dir']
  user node['aet']['seleniumgrid']['user']
  group node['aet']['seleniumgrid']['group']

  not_if do
    File.exist?("#{node['aet']['seleniumgrid']['node_chrome']['root_dir']}/chromedriver")
  end
end

# Create Selenium Grid Chrome node init file
template '/etc/init.d/node-chrome' do
  source 'etc/init.d/node-chrome.erb'
  owner 'root'
  group 'root'
  cookbook node['aet']['seleniumgrid']['node_chrome']['src_cookbook']['init_script']
  mode '0755'
end

# Create systemd unit
template '/etc/systemd/system/node-chrome.service' do
  source 'etc/systemd/system/node-chrome.service.erb'
  owner 'root'
  group 'root'
  mode '0664'
  cookbook node['aet']['browsermob']['src_cookbook']['init_script']

  notifies :restart, 'service[node-chrome]', :delayed
end

# Enable and start Selenium Grid FF node
service 'node-chrome' do
  supports status: true, restart: true
  action [:start, :enable]
end
