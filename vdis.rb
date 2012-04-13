require 'fog'
require 'pp'

conn = Fog::Compute.new({
  :provider => 'XenServer',
  :xenserver_url => 'xenserver-test',
  :xenserver_username => 'root',
  :xenserver_password => 'changeme',
})


# Find a storage repository (SR)
sr = conn.storage_repositories.find { |sr| sr.name == 'Local storage' }

# Create a ~17GB VDI in storage repository 'Local Storage'
vdi = conn.vdis.create :name => 'foovdi', 
                       :storage_repository => sr,
                       :description => 'my foovdi',
                       :virtual_size => '18589934592' # ~17GB in bytes


# List all VDIs
conn.vdis.each { |vdi| puts vdi.name }

# Destroy the VDI
vdi.destroy
