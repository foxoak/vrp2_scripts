resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'HEAD BAG SCRIPT FOR VRP2 by FOXOAK'

author 'Converted by: FoxOak - Original:BicuS - FAMERP.PL'

version '1.0.1'

client_scripts {
   '@vrp/lib/utils.lua',
	'client.lua'
}

server_scripts {
	'@vrp/lib/utils.lua',
    'vrp.lua'
}

ui_page('index.html') --HEAD BAG IMAGE

files {
    'index.html'
}