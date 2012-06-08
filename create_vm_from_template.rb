#!/usr/bin/env ruby
#
# Create a VM from an existing XenServer template
#
require 'fog'

XS_HOST = 'xenserver-test'
XS_PASSWORD = 'changeme'
XS_USER = 'root'

vm_name = 'test'

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

# Create the VM but do not start/provision it
vm = conn.servers.new :name          => "#{vm_name}",
                      :template_name => 'Ubuntu Lucid Lynx 10.04 (64-bit) (experimental)',
                      :networks      => [net]

vm.save :auto_start => false
puts "VM UUID: #{vm.uuid}"

# Misc attributes for PV VMs
vm.set_attribute 'PV_bootloader', 'eliloader'
vm.set_attribute 'other_config', {
  'mac_seed'           => '9299540c-660d-acbf-9001-f1ee2254dfea',
  'linux_template'     => 'true',
  'install-methods'    => 'http,ftp',
  'install-repository' => 'http://archive.ubuntu.com/ubuntu', 
  'install-arch'       => 'i386',
  'debian-release'     => 'lucid', 
  'disks'              => "<provision><disk device='0' size='8589934592' sr='#{sr.uuid}' bootable='true' type='system'/></provision>",
  'install-distro'     => 'debianlike'
}

# Provision and start it
vm.provision
puts "\nStarting server..."
vm.start
puts 'Done!'
