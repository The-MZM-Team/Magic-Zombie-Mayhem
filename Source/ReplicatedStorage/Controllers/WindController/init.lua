local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WindShake = require(ReplicatedStorage.Submodules.Libraries.WindShake)
local WindLines = require(ReplicatedStorage.Submodules.Libraries.WindShake.WindLines)
local Knit = require(ReplicatedStorage.Submodules.Packages.Knit)

local WIND_DIRECTION: Vector3 = Vector3.new(1, 0, 0.3)
local WIND_SPEED: number = 15
local WIND_POWER: number = 1
local LINES_LIFETIME: number = 2
local LINES_SPAWN_RATE: number = 8

local WindShakeController = Knit.CreateController({
	Name = "WindShakeController",
	Client = {},
})

function WindShakeController:KnitInit()
	for _, trees: Model in pairs(workspace.IgnoreInstances.Map.Trees:GetDescendants()) do
		if trees:FindFirstChild("Leaves") then
			CollectionService:AddTag(trees:FindFirstChild("Leaves"), "WindShake")
		end
	end

	local linesDefaultSettings = {
		Direction = WIND_DIRECTION,
		Speed = WIND_SPEED,
		Lifetime = LINES_LIFETIME,
		SpawnRate = LINES_SPAWN_RATE,
	}

	WindShake:SetDefaultSettings({
		WindSpeed = WIND_SPEED,
		WindDirection = WIND_DIRECTION,
		WindPower = WIND_POWER,
	})

	WindShake:Init() -- Anything with the WindShake tag will now shake
	WindLines:Init(linesDefaultSettings)
end

return WindShakeController
