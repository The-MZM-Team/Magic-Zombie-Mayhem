local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local IsometricCamera = require(ReplicatedStorage.Modules.IsometricCamera)

local CameraController = Knit.CreateController({
	Name = "CameraController",
	Client = {},
})

function CameraController:KnitInit()
	repeat
		task.wait()
	until Players.LocalPlayer.Character

	self._isometricCamera = IsometricCamera.new()
end

function CameraController:KnitStart()
	self._isometricCamera:setOriginPart(Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"))
	self._isometricCamera:setCameraKeybinds({ "Q", "E" })
end

return CameraController
