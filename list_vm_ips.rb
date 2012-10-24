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

conn.servers.each do |vm|
  if vm.tools_installed?
    vm.guest_metrics.networks.each do |k,v|
      puts v
    end
  end
end
