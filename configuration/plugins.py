# Add your plugins and plugin settings here.
# Of course uncomment this file out.

# To learn how to build images with your required plugins
# See https://github.com/netbox-community/netbox-docker/wiki/Using-Netbox-Plugins

PLUGINS = [
  'netbox_inventory',
  'netbox_lifecycle',
  'netbox_branching', # MUST BE THE LAST PLUGIN
]

PLUGINS_CONFIG = {
  "netbox_inventory": {},
  "netbox_lifecycle": {},
}
