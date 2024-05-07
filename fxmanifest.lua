fx_version 'cerulean'
game 'gta5'

author 'Stan'
description 'Commands to display text above your head'
version '1.0'

shared_script '@ox_lib/init.lua'

client_script 'client.lua'

server_scripts {
    'server.lua',
    'config.lua'
}

use_experimental_fxv2_oal 'yes'
lua54 'yes'
