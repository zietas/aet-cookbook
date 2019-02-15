#
# Cookbook Name:: aet
# Recipe:: chrome
#
# AET Cookbook
#

# Create script to always run firefox with parameters
template '/etc/yum.repos.d/google-chrome.repo' do
  source 'etc/yum.repos.d/google-chrome.repo.erb'
  owner 'root'
  group 'root'
  cookbook node['aet']['chrome']['src_cookbook']['bin']
  mode '0644'
end

yum_package 'google-chrome-stable' do
  version node['aet']['chrome']['version']
  action :install
  flush_cache [ :before ]
end
