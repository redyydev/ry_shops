fx_version 'adamant'
game 'gta5'

author 'Redyy'
version '1.0.0'

lua54 'yes'

ui_page {'html/index.html'}

client_script {
    'client/main.lua',
    'client/functions.lua',
    'client/events.lua',
}

server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

shared_scripts {'config.lua'}

files {'html/index.html','html/js/*.js','html/css/*.css', 'html/assets/*.png', 'html/assets/*.jpg'}
