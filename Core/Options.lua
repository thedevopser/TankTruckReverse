TankTruckReverse = TankTruckReverse or {}

-- ---------------------------------------------------------------------------
-- Panneau d'options natif (API Settings, Échap → Options → AddOns).
-- Construit APRÈS l'init des SavedVariables : SetupOptions() est appelé depuis
-- le handler ADDON_LOADED du fichier principal, une fois TankTruckReverseDB
-- garanti non-nil (RegisterAddOnSetting lie directement la table + la clé).
-- ---------------------------------------------------------------------------
local category

local function playPreview(key)
    local preset = TankTruckReverse.Sounds.Resolve(key)
    PlaySoundFile(preset.file, "Master")
end

function TankTruckReverse.SetupOptions()
    if category then return end -- idempotent
    local Sounds = TankTruckReverse.Sounds

    category = Settings.RegisterVerticalLayoutCategory("TankTruckReverse")

    -- Case à cocher « Activé » liée à TankTruckReverseDB.enabled.
    do
        local setting = Settings.RegisterAddOnSetting(
            category, "TankTruckReverse_Enabled", "enabled",
            TankTruckReverseDB, "boolean", "Activé", true)
        Settings.CreateCheckbox(category, setting,
            "Joue un son quand un tank recule en combat.")
    end

    -- Menu déroulant « Son » lié à TankTruckReverseDB.sound + aperçu au changement.
    do
        local setting = Settings.RegisterAddOnSetting(
            category, "TankTruckReverse_Sound", "sound",
            TankTruckReverseDB, "string", "Son", Sounds.DEFAULT)

        local function getOptions()
            local container = Settings.CreateControlTextContainer()
            for _, p in ipairs(Sounds.PRESETS) do
                container:Add(p.key, p.label)
            end
            return container:GetData()
        end

        Settings.CreateDropdown(category, setting, getOptions,
            "Son joué au recul. La sélection est jouée en aperçu.")

        setting:SetValueChangedCallback(function(_, value)
            playPreview(value)
        end)
    end

    Settings.RegisterAddOnCategory(category)
end

function TankTruckReverse.OpenOptions()
    if not category then TankTruckReverse.SetupOptions() end
    -- OpenToCategory appelle OpenSettingsPanel(), fonction protégée bloquée en
    -- combat par le jeu : on prévient plutôt que de déclencher le blocage.
    if InCombatLockdown() then
        print("|cff00ff00TTR|r la configuration n'est accessible qu'en dehors du combat.")
        return
    end
    Settings.OpenToCategory(category:GetID())
end
