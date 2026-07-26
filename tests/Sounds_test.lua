dofile("tests/mock_wow_api.lua")
dofile("Core/Sounds.lua")

local Sounds = TankTruckReverse.Sounds

describe("Sounds.PRESETS", function()
    it("contient au moins le preset par défaut", function()
        assert.is_true(#Sounds.PRESETS >= 1)
    end)

    it("le DEFAULT correspond à une clé existante dans PRESETS", function()
        local found = false
        for _, p in ipairs(Sounds.PRESETS) do
            if p.key == Sounds.DEFAULT then found = true end
        end
        assert.is_true(found)
    end)

    it("chaque preset a key, label, file et un period numérique positif", function()
        for _, p in ipairs(Sounds.PRESETS) do
            assert.is_string(p.key)
            assert.is_string(p.label)
            assert.is_string(p.file)
            assert.is_true(type(p.period) == "number" and p.period > 0)
        end
    end)
end)

describe("Sounds.Resolve", function()
    it("renvoie le preset demandé quand la clé est connue", function()
        local p = Sounds.Resolve("canard")
        assert.are.equal("canard", p.key)
    end)

    it("renvoie le preset par défaut pour une clé inconnue", function()
        local p = Sounds.Resolve("nexistepas")
        assert.are.equal(Sounds.DEFAULT, p.key)
    end)

    it("renvoie le preset par défaut pour nil", function()
        local p = Sounds.Resolve(nil)
        assert.are.equal(Sounds.DEFAULT, p.key)
    end)

    it("renvoie toujours un preset complet (jamais nil)", function()
        local p = Sounds.Resolve("nexistepas")
        assert.is_not_nil(p)
        assert.is_string(p.file)
        assert.is_true(p.period > 0)
    end)
end)
