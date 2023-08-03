fx_version 'cerulean'
game 'gta5'

description 'capy'
version '1.0.0'
lua54 'yes'

ui_page "nui/index.html"
shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',
	'@es_extended/locale.lua',
	'config.lua',

}
files {
	"nui/**/*",
}
server_script {
	'server.lua',
	'@oxmysql/lib/MySQL.lua',
}
client_script {
	'client.lua',

}
