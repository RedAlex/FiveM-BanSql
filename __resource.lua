resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

version '1.1'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/function.lua',
	'server/main.lua'
}

client_scripts {
  'client.lua'
}

dependencies {
	'essentialmode',
	'async'
}