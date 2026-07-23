TankTruckReverse = TankTruckReverse or {}
TankTruckReverse.Trigger = {}

-- Règle métier (pure, testable) : on bipe uniquement si l'addon est activé, que
-- le joueur recule, qu'il est en combat, et qu'il est tank.
function TankTruckReverse.Trigger.ShouldBeep(enabled, backpedaling, inCombat, isTank)
    if enabled and backpedaling and inCombat and isTank then
        return true
    end
    return false
end
