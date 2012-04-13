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
# including templates but not snapshots
#
conn.servers.all :include_templates => true, 
                 :name_matches => "Ubuntu",
                 :include_snapshots => false

#
# First server available
#
# Templates aren't included by default
# in listing
server = conn.servers.all.first

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
conn.storage_repositories.all

#
# XenServer Pools
#
conn.pools

# Default Storage repository in a Pool
conn.pools.all.first.default_sr
# or
# conn.pools.all.first.default_storage_repository

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
## Saving will start it
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
# Force shutdown
vm.stop 'hard'
# vm.hard_shutdown is equivalent

#
# Clean shutdown
vm.stop 'clean'
# also vm.clean_shutdown

# Destroy the foobar2  VM
vm.destroy

