dofile("tests/mock_wow_api.lua")
dofile("Core/Trigger.lua")

local S = TankTruckReverse.Trigger.ShouldBeep

describe("Trigger.ShouldBeep", function()
    it("bipe quand tout est réuni (activé + recul + combat + tank)", function()
        assert.is_true(S(true, true, true, true))
    end)

    it("ne bipe pas si l'addon est désactivé", function()
        assert.is_false(S(false, true, true, true))
    end)

    it("ne bipe pas si le joueur ne recule pas", function()
        assert.is_false(S(true, false, true, true))
    end)

    it("ne bipe pas hors combat", function()
        assert.is_false(S(true, true, false, true))
    end)

    it("ne bipe pas si le joueur n'est pas tank", function()
        assert.is_false(S(true, true, true, false))
    end)

    it("renvoie un vrai booléen même avec des entrées nil", function()
        assert.is_false(S(nil, nil, nil, nil))
    end)
end)
