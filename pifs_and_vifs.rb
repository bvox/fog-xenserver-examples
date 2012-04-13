require 'fog'
require 'pp'

conn = Fog::Compute.new({
  :provider => 'XenServer',
  :xenserver_url => 'xenserver-test',
  :xenserver_username => 'root',
  :xenserver_password => 'changeme',
})

# List of Host physical network interfaces
# http://docs.vmd.citrix.com/XenServer/5.6.0/1.0/en_gb/api/?c=PIF
conn.pifs.each do |pif|
  puts pif.device
  puts pif.mac
  puts pif.ip
  puts pif.gateway
  puts pif.vlan
  # The Host the PIF belongs to
  # Fog::Compute::XenServer::Host
  puts pif.host.name
  # The network the VIF belongs to
  # Fog::Compute::XenServer::Network
  puts pif.network.name
end

# List of Host virtual interfaces
# http://docs.vmd.citrix.com/XenServer/5.6.0/1.0/en_gb/api/?c=VIF
conn.vifs.each do |vif|
  puts vif.mac
  # The Server (VM) the VIF belongs to
  # Fog::Compute::XenServer::Server
  puts vif.server.name
  # The network the VIF belongs to
  # Fog::Compute::XenServer::Network
  puts vif.network.name
end
