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


#
# List all servers (VMs) templates
# excluding custom templates
servers = conn.servers.all(:include_templates => true,          # false by default
                           :include_custom_templates => false)   # false by default
builtin_templates = servers.delete_if { |s| !s.is_a_template }

#
# All the "custom" templates, i.e. created by us.
servers = conn.servers.all(:include_templates => false,        # false by default
                           :include_custom_templates => true) # false by default
custom_templates = servers.delete_if { |s| !s.is_a_template }
# Print the names
custom_templates.each do |t|
  puts t.name
  # We can destroy them too
  #
  # t.destroy
end

#
# Only 'real' servers, no templates, no snapshots
servers = conn.servers.all
servers.each do |s|
  #puts s.name
end

# 'real' + snaphots
servers = conn.servers.all(:include_snapshots => true)
servers.each do |s|
  #puts s.name
  #puts s.is_a_snapshot
end


