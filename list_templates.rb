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
# List built-in server (VMs) templates
# excluding custom templates
servers = conn.servers.builtin_templates
#
# All the "custom" templates, i.e. created by us.
custom_templates = servers.custom_templates

#
# Templates are Servers too, they have all the attributes
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


