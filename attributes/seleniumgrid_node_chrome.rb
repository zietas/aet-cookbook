#
# Cookbook Name:: aet
# Attributes:: seleniumgrid
#
# AET Cookbook
#
# Copyright (C) 2016 Cognifide Limited
#

default['aet']['seleniumgrid']['user'] = 'seleniumgrid'
default['aet']['seleniumgrid']['group'] = 'seleniumgrid'

default['aet']['seleniumgrid']['node_chrome']['root_dir'] = '/opt/aet/seleniumgrid/node-chrome'

default['aet']['seleniumgrid']['node_chrome']['log_dir'] = '/var/log/seleniumgrid'

default['aet']['seleniumgrid']['source'] = 'https://selenium-release.storage.googleapis.com/3.14/selenium-server-standalone-3.14.0.jar'

default['aet']['seleniumgrid']['node_chrome']['src_cookbook']['init_script'] = 'aet'

default['aet']['chromedriver']['source'] = 'https://chromedriver.storage.googleapis.com/72.0.3626.69/chromedriver_linux64.zip'
