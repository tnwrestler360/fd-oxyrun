fx_version 'cerulean'
game 'gta5'

author "forosty#1472"
description 'NoPixel Inspired Oxyrun'
version '1.0.0'


client_script {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/CircleZone.lua',
    'client/*.lua'
}

server_script 'server/*.lua'

shared_script {'config.lua',
               '@qb-core/shared/locale.lua',
               'locales/en.lua'
}

dependency 'qb-target'

lua54 'yes'

escrow_ignore { 
    'client/*.lua',
    'server/*.lua',
    'config.lua',
    'locales/*.lua',
}

dependency '/assetpacks'