resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Faturas -  FOXOAK - VRP2'

author 'Created by: FoxOak'

version '1.0.0'

client_scripts {
    '@vrp/lib/utils.lua',
	'client.lua'
}

server_scripts {
	'@vrp/lib/utils.lua',
    'vrp.lua'
}