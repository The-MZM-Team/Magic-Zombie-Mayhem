local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Submodules.Packages.Component)
local Janitor = require(ReplicatedStorage.Submodules.Packages.Janitor)

local Zombie = Component.new({
	Tag = "Zombie",
})

function Zombie:Construct()
	self._janitor = Janitor.new() :: table
	self._zombie = self.Instance :: Instance
	self._damage = 10 :: number
	self._health = 100 :: number
	self._distance = 50 :: number
	self._walkspeed = 16 :: number
	self._attackDebounce = true :: boolean
	self._currentTarget = nil :: Instance?
	self._idleAnimation = nil :: Animation
	self._attackAnimation = nil :: Animation?
end

function Zombie:Start() end

function Zombie:Stop() end

return Zombie
