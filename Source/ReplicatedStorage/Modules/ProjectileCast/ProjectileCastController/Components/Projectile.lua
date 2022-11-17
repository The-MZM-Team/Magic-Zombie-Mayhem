local DataTypes = require(script.Parent.Parent.Parent.Data.DataTypes)
local DefaultValues = require(script.Parent.Parent.Parent.Data.DefaultValues)

local Projectile = {}
Projectile.__index = Projectile

Projectile.projectileArray = {}

function Projectile.new(plr: Player, projectileTable: DataTypes.ProjectileTable, projectileParent: Instance)
	local self = setmetatable({}, Projectile)

	self._origin = CFrame.new(
		projectileTable.StartCFrame.Position
			+ Vector3.new(0, (projectileTable.YOffset or 0), 0)
			+ projectileTable.StartCFrame.LookVector * (projectileTable.ZOffset or 0),
		if not projectileTable.EndCFrame
			then projectileTable.StartCFrame.Position + projectileTable.StartCFrame.LookVector * 5
			else projectileTable.EndCFrame.Position
	) * CFrame.Angles(0, math.rad(projectileTable.XOffset or 0), 0)

	self._velocity = projectileTable.Velocity or DefaultValues.DEFAULT_VELOCITY
	self._drop = projectileTable.Drop or DefaultValues.DEFAULT_DROP
	self._laps = 0
	self._oldPosition = self._origin
	self._position = self._origin
	self._despawn = tick() + (projectileTable.Despawn or DefaultValues.DEFAULT_DESPAWN)
	self._character = plr.Character
	self._damage = projectileTable.Damage or DefaultValues.DEFAULT_DAMAGE
	self._particles = projectileTable.Particles or DefaultValues.DEFAULT_PARTICLES
	self._emitDebris = projectileTable.EmitDebris or DefaultValues.DEFAULT_EMIT_DEBRIS
	self._color = projectileTable.Color or DefaultValues.DEFAULT_COLOR
	self._projectileParent = projectileParent or DefaultValues.DEFAULT_PROJECTILE_PARENT
	self._projectile = projectileTable.Bullet ~= nil and projectileTable.Bullet or DefaultValues.DEFAULT_PROJECTILE
	self._decal = projectileTable.Decal or DefaultValues.DEFAULT_DECAL_ID
	self._ignoreList = { self._character, self._projectileParent } :: DataTypes.IgnoreList

	self:Init()

	return self
end

function Projectile:Init()
	self._projectile = self._projectile:Clone()
	self._projectile.Parent = self._projectileParent

	table.insert(Projectile.projectileArray, self)
end

function Projectile:Destroy()
	self._projectile:Destroy()
end

return Projectile
