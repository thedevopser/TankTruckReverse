TankTruckReverse = TankTruckReverse or {}
TankTruckReverse.Sounds = {}

local MEDIA = "Interface\\AddOns\\TankTruckReverse\\Media\\"

-- Registre des sons. L'ordre = ordre d'affichage dans le menu déroulant.
-- Ajouter un son = ajouter une ligne ici + déposer le .ogg dans Media/.
--   period = intervalle de ré-émission (s), à caler sur la durée du clip pour
--   qu'il ne se chevauche pas.
TankTruckReverse.Sounds.PRESETS = {
    { key = "beep",     label = "Bip camion (défaut)",         file = MEDIA .. "backup_beep.ogg",   period = 0.7 },
    { key = "canard",   label = "Coin coin (canard)",          file = MEDIA .. "duck_quack.ogg",    period = 1.4 },
    { key = "klaxon",   label = "Klaxon",                      file = MEDIA .. "horn.ogg",          period = 0.9 },
    { key = "retro",    label = "Bip 8-bit",                   file = MEDIA .. "retro_blip.ogg",    period = 0.6 },
    { key = "sonar",    label = "Sonar",                       file = MEDIA .. "sonar_ping.ogg",    period = 1.2 },
}

TankTruckReverse.Sounds.DEFAULT = "beep"

-- Renvoie le preset correspondant à `key`, avec repli sur DEFAULT si la clé est
-- nil ou inconnue. Ne renvoie jamais nil.
function TankTruckReverse.Sounds.Resolve(key)
    local presets = TankTruckReverse.Sounds.PRESETS
    local default
    for _, p in ipairs(presets) do
        if p.key == key then return p end
        if p.key == TankTruckReverse.Sounds.DEFAULT then default = p end
    end
    return default or presets[1]
end
