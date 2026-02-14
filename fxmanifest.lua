fx_version 'adamant'

game 'gta5'

version '1.2.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/framework.lua',
	'server/function.lua',
	'server/main.lua',
	'server/command.lua'
}

client_scripts {
  'client.lua'
}
