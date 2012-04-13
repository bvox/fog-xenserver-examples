require 'fog'
require 'pp'

conn = Fog::Compute.new({
  :provider => 'XenServer',
  :xenserver_url => 'xenserver-test',
  :xenserver_username => 'root',
  :xenserver_password => 'changeme',
})


sr = conn.storage_repositories.find { |sr| sr.name == 'Local storage' }
vdi = conn.vdis.create :name => 'foovdi', :storage_repository => sr
pp vdi
conn.vdis.each { |vdi| puts vdi.name }
