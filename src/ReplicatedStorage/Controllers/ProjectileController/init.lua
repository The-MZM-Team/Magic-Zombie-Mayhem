local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local ProjectileCastController = require(ReplicatedStorage.Modules.ProjectileCast.ProjectileCastController)

local player: Player = game.Players.LocalPlayer
local mouse: Mouse = player:GetMouse()

local ProjectileController = Knit.CreateController({
	Name = "ProjectileController",
	Client = {},
})

local function projectileRequested(gameProcessed)
	if gameProcessed or not player.Character then
		return
	end

	ProjectileCastController.castSingle({
		StartCFrame = player.Character.HumanoidRootPart.CFrame,
		Drop = 25,
	})
end

function ProjectileController:KnitInit()
	ProjectileCastController.Init()

	mouse.Button1Down:Connect(projectileRequested)
end

return ProjectileController
