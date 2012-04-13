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
  $stderr.puts "Usage: #{$0} vm-name disk.vhd"
  exit 1
end

source = ARGV[1]
if source.nil? or not File.exist?(source)
  $stderr.puts "Invalid source disk #{source}"
  $stderr.puts "Usage: #{$0} vm-name disk.vhd"
  exit 1
end
if source !~ /\.vhd$/
  $stderr.puts "Invalid source disk #{source}. I need a VHD file."
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

# Create the VM but do not start/provision it
vm = conn.servers.new :name => "#{vm_name}",
                      :template_name => 'Ubuntu Maverick Meerkat 10.10 (64-bit) (experimental)',
                      :networks => [net]

vm.save :auto_start => false
puts "VM UUID: #{vm.uuid}"

# Add the required VBD to the VM 
conn.vbds.create :server => vm, :vdi => vdi

# Misc attributes for HVM domains
vm.set_attribute 'PV_bootloader', 'eliloader'
vm.set_attribute 'other_config', {}
vm.set_attribute 'HVM_boot_policy', 'BIOS order'

# Provision and start it
vm.provision

# Upload and replace the VDI with our template
dest = "/var/run/sr-mount/#{sr.uuid}/#{vdi.uuid}.vhd"
puts "XS_HOST: #{XS_HOST}"
Net::SSH.start(XS_HOST, XS_USER, :password => XS_PASSWORD) do |ssh|
  puts "Uploading file #{File.basename(source)}..." 
  puts "Destination: #{dest}"
  ssh.scp.upload!(source, dest) do |ch, name, sent, total|
    print "\rProgress: #{(sent.to_f * 100 / total.to_f).to_i}% completed"
  end
end
puts "\nStarting server..."
vm.start
puts 'Done!'
