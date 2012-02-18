#
# Cookbook Name:: vagrant_main
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node.override["java"]["install_flavor"] = "oracle"
#node.override['maven']['version'] = 3
# change the mysql root password before running 'vagrant up'
node.override['mysql']['server_root_password'] = 'change_me_Q2JED3yHrlVf'
node.override['mysql']['bind_address'] = '127.0.0.1'
node.override['mysql']['tunable']['max_allowed_packet'] = '20M'
node.override['mysql']['tunable']['max_connections'] = '100'

node.override['tomcat']['java_options'] = '-Xmx512m -XX:MaxPermSize=256m'

# rice parameters
node.override['rice']['datasource']['username'] = 'RICE'
node.override['rice']['datasource']['password'] = 'RICE'
node.override['rice']['datasource']['database'] = 'rice'
node.override['nat_hostname'] = 'cognus.ome.ksu.edu'

require_recipe "build-essential"
require_recipe "apt"
require_recipe "tar"
require_recipe "git"
require_recipe "apache2"
require_recipe "tomcat"
require_recipe "mysql"
require_recipe "mysql::server"
require_recipe "maven"

# link mysql java connector into tomcat
link "/var/lib/tomcat6/common/mysql-connector-java.jar" do
  to "/usr/share/java/mysql-connector-java.jar"
end

# misc packages
package "subversion" do
  action :install
end
package "libmysql-java" do
  action :install
end

# Maven 3

# RICE source, needs to be set up outside the VM in shared directory
directory "/opt/sources" do
  owner "vagrant"
  group "vagrant"
  mode "0755"
  action :create
end

# RICE standalone server
cookbook_file "/var/lib/tomcat6/webapps/kr-dev.war" do
  source "rice-standalone-2.0.0-rc4-SNAPSHOT.war"
  mode "0644"
  notifies :restart, resources(:service => "tomcat")
end

# rice config
directory "/usr/local/rice" do
  owner "vagrant"
  group "vagrant"
  mode "0755"
  action :create
  recursive true
end
template "/usr/local/rice/rice-config.xml" do
  source "rice-config.xml.erb"
  owner "vagrant"
  group "vagrant"
  mode 0644
  notifies :restart, resources(:service => "tomcat")
end

template "/usr/local/rice/log4j.properties" do
 source "log4j.properties.erb"
 owner "vagrant"
 group "vagrant"
 mode 0644
end
cookbook_file "/usr/local/rice/rice.keystore" do
  source "rice.keystore"
  owner "vagrant"
  group "vagrant"
  mode "0644"
  notifies :restart, resources(:service => "tomcat")
end

# initialize database
execute "impex master" do
  cwd "/opt/sources/rice/db/impex/master"
  # TODO run mvn validate first, and also check that install completed previously
  returns [0,1] # allow non-zero because it fails if already complete
  command "mvn install -Pdb,mysql  -Dimpex.dba.url=jdbc:mysql://localhost " \
    +"-Dimpex.dba.password=change_me_Q2JED3yHrlVf " \
    +"-Dimpex.username=RICE -Dimpex.password=RICE -Dimpex.database=rice"
  action :run
end

# subversion "RICE" do
#   repository "https://svn.kuali.org/repos/rice/trunk"
#   revision "HEAD"
#   user "vagrant"
#   group "vagrant"
#   destination "/opt/sources/rice"
#   action :sync
# end

# set up database
# check to see if it already exists?
# vagrant@lucid32-4:/opt/sources/rice/db/impex/master$ mvn clean install -Pdb,mysql  -Dimpex.dba.url=jdbc:mysql://localhost -Dimpex.dba.password=change_me_Q2JED3yHrlVf

# place the runtime in the correct location to deploy standalone RICE
