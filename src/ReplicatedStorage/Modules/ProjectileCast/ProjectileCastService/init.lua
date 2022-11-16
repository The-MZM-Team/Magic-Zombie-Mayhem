local TargetSettings = require(script.Parent.TargetSettings)
local DataType = require(script.Parent.Data.DataTypes)

local OnMouseClick = script.Parent.Assets.Remotes.OnMouseClick
local OnBulletRender = script.Parent.Assets.Remotes.OnBulletRender
local ProjectileHitRequested = script.Parent.Assets.Remotes.ProjectileHitRequested

local ProjectileCastService = {}

ProjectileCastService.activePlayerLatency = {} :: { [Player]: number }

function ProjectileCastService.setRemotes()
	OnMouseClick.OnServerEvent:Connect(function(player: Player, projectileTable: DataType.ProjectileTable)
		if not player.Character then
			return warn("[Projectile Cast] - Character does not exist on server!")
		end

		OnBulletRender:FireAllClients(player, projectileTable, os.time())
	end)

	ProjectileHitRequested.OnServerEvent:Connect(
		function(player: Player, hit: BasePart, damage: number, bulletCharacter: Model)
			local humanoid: Instance? = if hit and hit.Parent ~= nil then hit.Parent:FindFirstChild("Humanoid") else nil

			if humanoid and TargetSettings.getTaggedTargets(hit) and player.Character == bulletCharacter then
				humanoid:TakeDamage(damage)
			end
		end
	)
end

return ProjectileCastService
