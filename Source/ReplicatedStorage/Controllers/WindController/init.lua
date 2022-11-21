local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WindShake = require(ReplicatedStorage.Submodules.Libraries.WindShake)
local WindLines = require(ReplicatedStorage.Submodules.Libraries.WindShake.WindLines)
local Knit = require(ReplicatedStorage.Submodules.Packages.Knit)

local WIND_DIRECTION = Vector3.new(1, 0, 0.3)
local WIND_SPEED = 25
local WIND_POWER = 0.55

local WindShakeController = Knit.CreateController({
	Name = "WindShakeController",
	Client = {},
})

function WindShakeController:KnitInit()
	WindShake:SetDefaultSettings({
		WindSpeed = WIND_SPEED,
		WindDirection = WIND_DIRECTION,
		WindPower = WIND_POWER,
	})

	WindShake:Init() -- Anything with the WindShake tag will now shake

	WindLines:Init({ -- Create Wind Lines
		Direction = WIND_DIRECTION,
		Speed = WIND_SPEED,
		Lifetime = 1.5,
		SpawnRate = 5,
	})
end

return WindShakeController
