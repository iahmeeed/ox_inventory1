fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'
name 'ox_inventory'
author 'Overextended & Karma Developments'
version '2.43.5'
repository 'https://github.com/overextended/ox_inventory'
description 'Prodigy RP 2.0 Inspired UI Inventory from ox_inventory'

dependencies {
    '/server:6116',
    '/onesync',
    'oxmysql', -- Make sure to start this before inventory!
    'ox_lib', -- Make sure to start this before inventory!
}

shared_script {'@ox_lib/init.lua', 'config.lua'}

ox_libs {
    'locale',
    'table',
    'math',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'init.lua',
    'sv_karmafunctions.lua',
}

client_script {'init.lua', '@qbx_core/modules/playerdata.lua', 'cl_karmafunctions.lua'}

ui_page 'web/build/index.html'

files {
    'client.lua',
    'server.lua',
    'locales/*.json',
    'web/build/index.html',
    'web/build/assets/*.js',
    'web/build/assets/*.css',
    'web/images/**',
    'web/images/*.png',
    'web/images/*.webp',
    'modules/**/shared.lua',
    'modules/**/client.lua',
    'modules/bridge/**/client.lua',
    'data/*.lua',
}

escrow_ignore {
    'config.lua',
    'cl_karmafunctions.lua',
    'sv_karmafunctions.lua',
    'client.lua',
    'server.lua',
    'init.lua',
    'framework.lua',
    'locales/*.json',
    'modules/**/**',
    'data/*.lua',
    'setup/*.lua',
}
