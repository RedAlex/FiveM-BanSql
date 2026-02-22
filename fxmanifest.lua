fx_version 'adamant'

game 'gta5'

version '1.3.0'

ui_page 'html/index.html'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'locale.lua',
	'locales/*.lua',
	'config.lua',
	'server/database.lua',
	'server/framework.lua',
	'server/function.lua',
	'server/ui.lua',
	'server/anticheat_bridge.lua',
	'server/main.lua',
	'server/command.lua',
	'server/update.lua'
}

client_scripts {
  'client.lua'
}

files {
	'html/index.html',
	'html/style.css',
	'html/script.js'
}

-- At least one of these frameworks must be installed
optional_dependencies {
    'es_extended',
    'qb-core',
    'qbox_core',
}

-- Database provider is required (oxmysql can satisfy this via provide 'mysql-async')
dependency 'mysql-async'

