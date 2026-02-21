fx_version 'adamant'

game 'gta5'

version '1.2.1'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'locale.lua',
	'locales/*.lua',
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

-- At least one of these frameworks must be installed
optional_dependencies {
    'es_extended',
    'qb-core',
    'qbox_core',
}

-- Database provider is required (oxmysql can satisfy this via provide 'mysql-async')
dependency 'mysql-async'

