local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local ProjectileCastService = require(ReplicatedStorage.Modules.ProjectileCast.ProjectileCastService)
local TargetSettings = require(ReplicatedStorage.Modules.ProjectileCast.TargetSettings)

local ProjectileService = Knit.CreateService({
	Name = "ProjectileService",
})

function ProjectileService:KnitInit()
	ProjectileCastService.setRemotes()
	TargetSettings.setTaggedTargets({ "Zombie" })
end

return ProjectileService
