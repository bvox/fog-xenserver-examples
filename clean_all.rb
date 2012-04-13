require 'fog'
require 'pp'

conn = Fog::Compute.new({
  :provider => 'XenServer',
  :xenserver_url => 'xenserver-test',
  :xenserver_username => 'root',
  :xenserver_password => 'changeme',
})

#
# WARNING! ACHTUNG!
# WARNING! ACHTUNG!
# WARNING! ACHTUNG!
# This will WIPE OUT your XenServer
#

# Destroy custom templates
conn.servers.custom_templates.each { |s| s.destroy if s.name != 'squeeze-test' }

# Destroy servers
conn.servers.each { |s| s.destroy }
