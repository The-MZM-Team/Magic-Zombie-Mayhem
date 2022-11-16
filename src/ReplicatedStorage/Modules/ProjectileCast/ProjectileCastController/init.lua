local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local DataTypes = require(script.Parent.Data.DataTypes)
local Projectile = require(script.Components.Projectile)
local weldProjectileHole = require(script.Functions.weldProjectileHole)

local OnMouseClick = script.Parent.Assets:WaitForChild("Remotes"):WaitForChild("OnMouseClick")
local OnBulletRender = script.Parent.Assets:WaitForChild("Remotes"):WaitForChild("OnBulletRender")
local ProjectileHitRequested = script.Parent.Assets:WaitForChild("Remotes"):WaitForChild("ProjectileHitRequested")

local mouse: Mouse = Players.LocalPlayer:GetMouse()

local ProjectileCastController = {}

ProjectileCastController.destroy = {} :: { Instance }
ProjectileCastController.remove = {} :: { number }
ProjectileCastController.bulletParent = workspace.Camera :: Instance

local function updateBullets(step: number)
	for _, projectile in pairs(ProjectileCastController.destroy) do
		projectile:Destroy()
	end

	ProjectileCastController.remove = {}
	ProjectileCastController.destroy = {}

	for iteration: number, projectile: DataTypes.Projectile in pairs(Projectile.projectileArray) do
		-->>: How many times the bullet has been rendered
		projectile._laps = projectile._laps + 1
		-->>: Sets next position as current position then move it forward by velocity amount multiplied by the delta time
		-->>: We then use vector 3 to lowered the bullet based on the drop property. We use laps so it iteratively moves down more over time.
		projectile._position = projectile._position * CFrame.new(0, 0, -projectile._velocity * step)
			+ Vector3.new(0, -projectile._drop * (step ^ 2) * projectile._laps, 0)
		-->>: Gets the old position to look at the new position so we can CFrame it to the right orientation
		local bul = projectile._projectile
		local distance = (projectile._oldPosition.Position - projectile._position.Position).Magnitude
		-->>: Moves it forward half the distance so its in the middle of where the ray will be so its in the right place
		-->>: Want the bullet to be in the middle of the ray since thats where the ray will be checking if it hit anything
		bul.CFrame = CFrame.new(projectile._oldPosition.Position, projectile._position.Position)
			* CFrame.new(0, 0, -distance * 0.5)
		-->>: Creates a ray pointing in direction of the old position to the new position with the distance already defined
		local rayOrigin = projectile._oldPosition.Position
		local rayDirection = (projectile._position.Position - projectile._oldPosition.Position).Unit * distance

		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = { projectile._ignoreList }
		raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
		raycastParams.IgnoreWater = true

		local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

		if raycastResult and not raycastResult.Instance:FindFirstAncestor(projectile._character) then
			ProjectileHitRequested:FireServer(raycastResult.Instance, projectile._damage, projectile._character)

			weldProjectileHole(projectile, raycastResult, ProjectileCastController.bulletParent)
			table.insert(ProjectileCastController.destroy, projectile._projectile)
			-->>: Tag bullet for removal
			table.insert(ProjectileCastController.remove, iteration)
		else
			projectile._oldPosition = projectile._position

			if tick() > projectile._despawn then
				-->>: Tag bullet for destruction
				table.insert(ProjectileCastController.destroy, projectile)
				-->>: Remove bullet for destruction
				table.insert(ProjectileCastController.remove, iteration)
			end
		end
	end

	-->>: Remove tagged bullets to prevent memory leaks
	for i, iteration in pairs(ProjectileCastController.remove) do
		table.remove(Projectile.getProjectileArray(), iteration - i + 1)
	end
end

function ProjectileCastController.castSingle(projectileTable: DataTypes.ProjectileTable)
	OnMouseClick:FireServer(projectileTable)
	Projectile.new(game.Players.LocalPlayer, projectileTable, ProjectileCastController.bulletParent)
end

function ProjectileCastController.castMultiple(projectileTable: DataTypes.ProjectileTable)
	-->>: We do this to spread the bullets apart by 2 studs
	for projectileIteration = -4, 4, 2 do
		task.spawn(function()
			projectileTable.XOffset = projectileIteration
			OnMouseClick:FireServer(projectileTable)
		end)
	end

	Projectile.new(game.Players.LocalPlayer, projectileTable, ProjectileCastController.bulletParent)
end

function ProjectileCastController.setTargetFilter(targetFilter: Instance)
	mouse.TargetFilter = targetFilter
end

function ProjectileCastController.setBulletParent(parent: Instance)
	ProjectileCastController.bulletParent = parent
end

function ProjectileCastController.Init()
	ProjectileCastController.setTargetFilter(workspace.Camera)

	OnBulletRender.OnClientEvent:Connect(function(player: Player, projectileTable: DataTypes.ProjectileTable)
		if player == Players.LocalPlayer then
			return
		end

		Projectile.new(player, projectileTable, ProjectileCastController.bulletParent)
	end)

	RunService.RenderStepped:Connect(function(deltaTime: number)
		updateBullets(deltaTime)
	end)
end

return ProjectileCastController
