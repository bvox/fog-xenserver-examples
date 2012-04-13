require 'fog'
require 'pp'

conn = Fog::Compute.new({
  :provider => 'XenServer',
  :xenserver_url => 'xenserver-test',
  :xenserver_username => 'root',
  :xenserver_password => 'changeme',
  :xenserver_defaults => { 
    :template => "squeeze-test" 
  }
})

#
# A Fog::Compute::XenServer::Server 
# is a XenServer VM 
#
# a Fog::Compute::XenServer::Host
# is a Hypervisor
#


# List all servers (VMs)
#
conn.servers.all 

# List servers matching Ubuntu
conn.servers.all :name_matches => "Ubuntu"

#
# First server available
#
# Templates aren't included by default
# in listing
server = conn.servers.first

#
# List custom templates
custom = conn.servers.custom_templates
#
# List built-in templates
built_in = conn.servers.builtin_templates

#
# Get server VIFs
#
server.networks
# or server.vifs

#
# List the hypervisors
#
conn.hosts

#
# Listing Storage Repositories (Xen SRs)
conn.storage_repositories

#
# XenServer Pools
#
conn.pools

# Default Storage repository in a Pool
conn.pools.first.default_sr
# or
# conn.pools.first.default_storage_repository

#
# Create server from template
# conn.default_template
#
# :template_name overrides default template in 
# xenserver_defaults
#
# The server is automatically started
#
# vm = conn.servers.create :name => 'foobar' + "#{i}"

vm = conn.servers.create :name => 'foobar2',
                         :template_name => 'squeeze-test'

#
# If you don't want to automatically start the server
#vm = conn.servers.new    :name => 'foobar',
#                         :template_name => 'test_template'
## Saving will start it unless :auto_start => false
#vm.save(:auto_start => false)

#
# List all XenServer VBDs
conn.vbds.all

#
# Get a VM VBDs
vm.vbds

#
# Get VDIs for every VM VBD
vm.vbds.each do |vbd|
  vbd.vdi
end

#
# List all XenServer VDIs
conn.vdis.all

#
# Force server shutdown
vm.stop 'hard'
# vm.hard_shutdown is equivalent

#
# Clean shutdown
vm.stop 'clean'
# also vm.clean_shutdown

#
# Destroy the foobar2 VM
# Shutdown hard it first if running
vm.destroy

