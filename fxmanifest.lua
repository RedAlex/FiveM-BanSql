fx_version 'adamant'

game 'gta5'

version '1.2.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/database.lua',
	'server/framework.lua',
	'server/function.lua',
	'server/anticheat_bridge.lua',
	'server/main.lua',
	'server/command.lua',
	'server/update.lua'
}

client_scripts {
  'client.lua'
}
