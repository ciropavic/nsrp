fx_version "cerulean"

games { "gta5" }

name "qb-WooshPD"
description "A QB-Core script designed to allow police job, on duty players to interact with locals/NPC's."

lua54 'yes'

escrow_ignore {
    'core/shared/sh_config.lua',
}

client_scripts {
    "core/client/*.lua",
}

server_scripts {
    "core/server/*.lua",
}

shared_scripts {
    "core/shared/*.lua",
}
dependency '/assetpacks'