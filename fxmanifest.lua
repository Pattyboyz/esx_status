fx_version 'cerulean'
games { 'gta5' }

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	
	'config.lua',
	'server/classes/*.lua',
	'server/*.lua'
}

client_scripts {
	'config.lua',
	'client/*.lua'
}