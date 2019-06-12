resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

version '1.0.7a'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server.lua'
}

dependencies {
	'essentialmode',
	'async'
}