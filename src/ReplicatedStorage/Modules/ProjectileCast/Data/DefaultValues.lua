--!strict
local DataTypes = require(script.Parent.DataTypes)

local assets = script.Parent.Parent.Assets

local DefaultValues: DataTypes.DefaultValues = {
	DEFAULT_VELOCITY = 125,
	DEFAULT_DROP = 5,
	DEFAULT_DESPAWN = 3,
	DEFAULT_DAMAGE = 5,
	DEFAULT_EMIT_DEBRIS = 5,
	DEFAULT_COLOR = Color3.fromRGB(255, 55, 55),
	DEFAULT_PROJECTILE_PARENT = workspace.Camera,
	DEFAULT_DECAL_ID = 4784881970,
	DEFAULT_PROJECTILE = assets.FX:WaitForChild("DefaultBullet"),
	DEFAULT_PARTICLES = assets.FX:WaitForChild("ImpactParticle"),
	DEFAULT_TILT = 5,
}

return DefaultValues
