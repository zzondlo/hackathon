#
# Cookbook Name:: dynect
# Recipe:: ec2
#
# Copyright:: 2010, Opscode, Inc <legal@opscode.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'dynect'

new_hostname = "#{node["name"]}"
Chef::Log.info("Recipe Added #{@new_hostname} to dynect")
new_fqdn = "#{new_hostname}.#{node["dynect"]["domain"]}"
Chef::Log.info("Recipe Added #{@new_fqdn} to dynect")

dynect_rr new_hostname do
  record_type "CNAMERecord"
  fqdn new_fqdn
  rdata({ "cname" => "#{node[:ec2][:public_hostname]}." })
  customer node["dynect"]["customer"]
  username node["dynect"]["usiername"]
  password node["dynect"]["password"]
  zone     node["dynect"]["zone"]
  ttl      30
  action :update
end

ruby_block "edit resolv conf" do
  block do
    rc = Chef::Util::FileEdit.new("/etc/resolv.conf")
    rc.search_file_replace_line(/^search/, "search #{node["dynect"]["domain"]} compute-1.internal")
    rc.search_file_replace_line(/^domain/, "domain #{node["dynect"]["domain"]}")
    rc.write_file
  end
end

#ruby_block "edit etc hosts" do
#  block do
#  rc = Chef::Util::FileEdit.new("/etc/hosts")
#    rc.search_file_replace_line(/^127\.0\.0\.1 localhost$/, "127.0.0.1 #{new_fqdn} #{new_hostname} localhost")
#    rc.write_file
#  end
#end

execute "hostname --file /etc/hostname" do
  action :nothing
end

file "/etc/hostname" do
  content "#{new_hostname}"
  notifies :run, resources(:execute => "hostname --file /etc/hostname"), :immediately
end

node.automatic_attrs["hostname"] = new_hostname
node.automatic_attrs["fqdn"] = new_fqdn