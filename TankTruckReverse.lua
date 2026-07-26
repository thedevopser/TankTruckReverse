TankTruckReverse = TankTruckReverse or {}

local Trigger = TankTruckReverse.Trigger
local Sounds  = TankTruckReverse.Sounds

local backpedaling = false -- vrai entre MoveBackwardStart et MoveBackwardStop
local debug = false
local ticker

local function isEnabled() return TankTruckReverseDB and TankTruckReverseDB.enabled end

local function isTank()
    local spec = GetSpecialization()
    return spec and GetSpecializationRole(spec) == "TANK"
end

local function shouldBeep()
    return Trigger.ShouldBeep(isEnabled(), backpedaling, InCombatLockdown(), isTank())
end

-- Son courant (résolu depuis le choix stocké, repli sur le défaut).
local function currentSound()
    return Sounds.Resolve(TankTruckReverseDB and TankTruckReverseDB.sound)
end

local function playBeep()
    PlaySoundFile(currentSound().file, "Master")
end

-- ---------------------------------------------------------------------------
-- Boucle de bip : n'existe que pendant que la touche recul est tenue.
-- Le ticker tourne dès qu'on recule, mais ne joue le son que si toutes les
-- conditions sont réunies (combat + tank + activé) — ainsi, si le combat
-- démarre alors qu'on recule déjà, le bip suit sans re-presser la touche.
-- ---------------------------------------------------------------------------
local function stopLoop()
    if ticker then ticker:Cancel(); ticker = nil end
end

local function tick()
    if not backpedaling then stopLoop(); return end
    if shouldBeep() then playBeep() end
end

local function startLoop()
    if ticker then return end
    -- La période suit le son choisi (une voix dure plus longtemps qu'un bip).
    ticker = C_Timer.NewTicker(currentSound().period, tick)
    tick() -- premier bip immédiat si les conditions sont réunies
end

-- ---------------------------------------------------------------------------
-- Détection du recul : on observe les fonctions de mouvement appelées par la
-- liaison « reculer » (MOVEBACKWARD). hooksecurefunc observe sans toucher au
-- code sécurisé, donc ça fonctionne EN COMBAT et EN INSTANCE, contrairement à
-- la lecture du clavier ou de la position (bloquées / restreintes en 12.0).
-- ---------------------------------------------------------------------------
hooksecurefunc("MoveBackwardStart", function()
    backpedaling = true
    if debug then print("|cff00ff00TTR|r recul: start") end
    startLoop()
end)

hooksecurefunc("MoveBackwardStop", function()
    backpedaling = false
    if debug then print("|cff00ff00TTR|r recul: stop") end
    stopLoop()
end)

-- ---------------------------------------------------------------------------
-- Init des SavedVariables
-- ---------------------------------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, name)
    if name == "TankTruckReverse" then
        TankTruckReverseDB = TankTruckReverseDB or {}
        if TankTruckReverseDB.enabled == nil then TankTruckReverseDB.enabled = true end
        if TankTruckReverseDB.sound == nil then TankTruckReverseDB.sound = Sounds.DEFAULT end
        TankTruckReverse.SetupOptions() -- construit le panneau une fois la DB prête
    end
end)

-- ---------------------------------------------------------------------------
-- Slash : /ttr (toggle) | /ttr config | /ttr test | /ttr debug
-- ---------------------------------------------------------------------------
SLASH_TANKTRUCKREVERSE1 = "/ttr"
SlashCmdList["TANKTRUCKREVERSE"] = function(msg)
    local cmd = strtrim(msg):lower()
    if cmd == "config" then
        TankTruckReverse.OpenOptions()
    elseif cmd == "test" then
        playBeep()
        print("|cff00ff00TTR|r bip de test")
    elseif cmd == "debug" then
        debug = not debug
        print("|cff00ff00TTR|r debug " .. (debug and "on" or "off"))
    else
        TankTruckReverseDB.enabled = not TankTruckReverseDB.enabled
        print("|cff00ff00TTR|r " .. (TankTruckReverseDB.enabled and "activé" or "désactivé"))
    end
end
