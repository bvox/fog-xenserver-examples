require 'fog'
require 'pp'

conn = Fog::Compute.new({
  :provider => 'XenServer',
  :xenserver_url => 'xenserver-real',
  :xenserver_username => 'root',
  :xenserver_password => 'Klock09',
  :xenserver_defaults => { 
    :template => "squeeze-test" 
  }
})

# Create a VM using the default template
#vm = conn.servers.create :name => 'foobar'
#
#

#servers = conn.servers.find_all { |s| s.name =~ /foobar/ }
#servers.each { |s| puts "destroy #{s.name}";s.destroy }
#
#puts 'create server'
##
## Create a VM using a specific template
##
#vm = conn.servers.create :name => 'foobarUUID',
#                         :template_name => '5fbb06eb-8764-af47-94de-92088ad1cbec'
#
##vm.destroy

#conn.servers.custom_templates.each do |t|
#  pp t.name
#end

conn.servers.templates.each do |t|
  puts t.name
end

