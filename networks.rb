require 'fog'
require 'pp'

conn = Fog::Compute.new({
  :provider => 'XenServer',
  :xenserver_url => 'xenserver-test',
  :xenserver_username => 'root',
  :xenserver_password => 'changeme',
})

# Get the default network
default = conn.default_network

# Get VIFs associated to this network
default.vifs

# Get PIFs associated to this network
default.pifs

# Iterate over all the available networks
conn.networks.each do |n|
end

# Find servers in default network
set = conn.servers.find_all do |s| 
  associated = false
  s.networks.each do |n|
    if n.name == default.name
      associated = true
      break
    end
  end
  associated
end
set.each { |s| puts "server #{s.name} is in default network '#{default.name}'" }

