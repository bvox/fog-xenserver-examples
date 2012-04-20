#!/usr/bin/env ruby
#
# Create a template from an existing VDI in 'Local Storage' SR
#
require 'fog'
require 'pp'
require 'net/scp'

XS_HOST = 'xenserver-test'
XS_PASSWORD = 'changeme'
XS_USER = 'root'

conn = Fog::Compute.new({
  :provider => 'XenServer',
  :xenserver_url => XS_HOST,
  :xenserver_username => XS_USER,
  :xenserver_password => XS_PASSWORD,
})

# The template name
vm_name = 'my_vdi_template'

net = conn.networks.find { |n| n.name == "Integration-VLAN" }

# We will create the VDI in this SR
sr = conn.storage_repositories.find { |sr| sr.name == 'Local storage' }
sr.scan

vdi = conn.vdis.find { |vdi| vdi.uuid == 'aead0be4-d535-4b5b-bf5e-b73afc3b5590' }

# Create the VM (from scratch no template) but do not start/provision it
vm = conn.servers.new :name => "#{vm_name}",
                      :affinity => conn.hosts.first,
                      :pv_bootloader => 'pygrub'

vm.save :auto_start => false

# Add the network 'Integration-VLAN' to the VM
conn.vifs.create :server => vm, :network => net

# Add the required VBD to the VM 
conn.vbds.create :server => vm, :vdi => vdi

# Misc attributes for PV VMs
vm.set_attribute 'PV_bootloader', 'pygrub'
vm.set_attribute 'other_config', {}

# Provision and start it
#vm.provision
#vm.start
