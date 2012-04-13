#!/usr/bin/env ruby
require 'fog'
require 'pp'
require 'net/scp'

XS_HOST = 'xenserver-test'
XS_PASSWORD = 'changeme'
XS_USER = 'root'

vm_name = ARGV[0]
if vm_name.nil? 
  $stderr.puts "Invalid VM name"
  $stderr.puts "Usage: #{$0} vm-name"
  exit 1
end

puts "Creating VM #{vm_name} in #{XS_HOST}..."

conn = Fog::Compute.new({
  :provider => 'XenServer',
  :xenserver_url => XS_HOST,
  :xenserver_username => XS_USER,
  :xenserver_password => XS_PASSWORD,
})

# NIC 1 will be in Integration-VLAN
net = conn.networks.find { |n| n.name == "Integration-VLAN" }

# We will create the VDI in this SR
sr = conn.storage_repositories.find { |sr| sr.name == 'Local storage' }

# Create a ~8GB VDI in storage repository 'Local Storage'
vdi = conn.vdis.create :name => "#{vm_name}-disk1", 
                       :storage_repository => sr,
                       :description => "#{vm_name}-disk1",
                       :virtual_size => '8589934592' # ~8GB in bytes

host = conn.hosts.first

# Create the VM (from scratch no template) but do not start/provision it
vm = conn.servers.new :name => "#{vm_name}",
                      :affinity => host,
                      :pv_bootloader => 'pygrub'

vm.save
puts "VM UUID: #{vm.uuid}"

# Add a network to the VM
conn.vifs.create :server => vm, :network => conn.default_network

# Add the required VBD to the VM 
conn.vbds.create :server => vm, :vdi => vdi
vm.provision
puts 'Done!'
