local Debris = game:GetService("Debris")

local DataTypes = require(script.Parent.Parent.Parent.Data.DataTypes)
local createBulletHole = require(script.Parent.createBulletHole)

local BULLET_HOLE_LIFETIME = 60

local function weldProjectileHole(
	projectile: DataTypes.Projectile,
	raycastResult: RaycastResult,
	bulletParent: Instance
)
	local color = raycastResult.Instance.Color or projectile._color

	local projectilePart: Part = createBulletHole(projectile._decal):Clone()

	if not projectilePart then
		return
	end

	projectilePart.Parent = bulletParent

	projectilePart.CFrame = CFrame.new(raycastResult.Position, raycastResult.Position + raycastResult.Normal)

	local particle: ParticleEmitter = projectile._particles
	particle.Parent = projectilePart
	particle.Color = ColorSequence.new(color)
	particle:Emit(projectile._emitDebris)

	local Weld = Instance.new("Weld")
	Weld.Part0 = raycastResult.Instance
	Weld.Part1 = projectilePart
	Weld.C0 = raycastResult.Instance.CFrame:Inverse()
	Weld.C1 = projectilePart.CFrame:Inverse()
	Weld.Parent = projectilePart

	Debris:AddItem(projectilePart, BULLET_HOLE_LIFETIME)
end

return weldProjectileHole
