fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Springo'
title 'springo-gasmask'
description 'Gas mask item made custom for Optic Networks | springo_1
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@on_lib/init.lua',
    '@qbx_core/modules/playerdata.lua',
    'config.lua',
}

server_scripts {
    'server/*.lua',
    '@qbx_core/modules/playerdata.lua',
}

client_scripts {
    'client/*.lua',
    '@qbx_core/modules/playerdata.lua',
}