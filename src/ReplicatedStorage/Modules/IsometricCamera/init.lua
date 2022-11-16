--!strict
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local packages: Folder = ReplicatedStorage:FindFirstChild("Packages")

local Janitor = require(packages:FindFirstChild("Janitor"))

local mouse: Mouse = Players.LocalPlayer:GetMouse()
local camera: Camera = workspace.CurrentCamera

local TWEEN_DURATION: number = 0.6
local ZOOM_DURATION: number = 0.1

local DEFAULT_MIN_ZOOM: number = 20
local DEFAULT_MAX_ZOOM: number = 50
local DEFAULT_ZOOM_MULTIPLIER: number = 100 / DEFAULT_MAX_ZOOM

local DEFAULT_X_DEPTH: number = DEFAULT_MAX_ZOOM
local DEFAULT_Y_DEPTH: number = DEFAULT_MAX_ZOOM
local DEFAULT_Z_DEPTH: number = DEFAULT_MAX_ZOOM
local DEFAULT_HEIGHT: number = 0
local DEFAULT_FOV: number = 30

local BIND_RENDER_NAME: string = "IsometricCamera"

local IsometricCamera = {}
IsometricCamera.__index = IsometricCamera

export type IsometricCamera = {}

function IsometricCamera.new()
	local self = setmetatable({}, IsometricCamera)

	self._janitor = Janitor.new()

	self._cameraKeybinds = { "Q", "E" } :: { string? }

	self._swapPrespectiveDebounce = true :: boolean
	self._zoomEnabled = true :: boolean
	self._originPart = nil :: Part?

	self._inputNumber = 0 :: number

	self._maxYZoom = DEFAULT_MAX_ZOOM :: number
	self._minYZoom = DEFAULT_MIN_ZOOM :: number

	self._maxZoom = DEFAULT_MAX_ZOOM :: number
	self._minZoom = DEFAULT_MIN_ZOOM :: number

	self._zoomMultiplier = DEFAULT_ZOOM_MULTIPLIER :: number

	self._xDepth = Instance.new("NumberValue") :: NumberValue
	self._yDepth = Instance.new("NumberValue") :: NumberValue
	self._zDepth = Instance.new("NumberValue") :: NumberValue
	self._height = Instance.new("NumberValue") :: NumberValue

	-->>: Update camera function
	self._updateCamera = function()
		if self._originPart then
			if self._swapPrespectiveDebounce then
				local zoomValue: number =
					math.clamp(math.floor(math.abs(self._xDepth.Value * self._zoomMultiplier) + 0.5), 55, 100)
				zoomValue = math.floor(((200 / zoomValue) * 27.54) + 0.5)
			end

			local originPosition: Vector3 = self._originPart.Position + Vector3.new(0, self._height.Value, 0)

			local cameraPosition: Vector3? = if originPosition
				then originPosition + Vector3.new(self._xDepth.Value, self._yDepth.Value, self._zDepth.Value)
				else warn("Camera point does not exist!")

			if cameraPosition then
				camera.CFrame = CFrame.lookAt(cameraPosition, originPosition)
			end
		end
	end

	-->>: Checks if Depth is negative or positive
	self._getDepthSign = function(): (number, number)
		local xDepthCheck: number = if self._xDepth and self._xDepth.Value < 0 then -1 else 1
		local zDepthCheck: number = if self._zDepth and self._zDepth.Value < 0 then -1 else 1

		return xDepthCheck, zDepthCheck
	end

	-->>: Checks what Depths are the Min and Max values
	self._getMinMaxValues = function(xDepthCheck: number, zDepthCheck: number): number & number & number & number
		local xMinZoom: number, xMaxZoom: number, zMinZoom: number, zMaxZoom: number

		xMinZoom = math.min(self._minZoom * xDepthCheck, self._maxZoom * xDepthCheck)
		xMaxZoom = math.max(self._minZoom * xDepthCheck, self._maxZoom * xDepthCheck)

		zMinZoom = math.min(self._minZoom * zDepthCheck, self._maxZoom * zDepthCheck)
		zMaxZoom = math.max(self._minZoom * zDepthCheck, self._maxZoom * zDepthCheck)

		return xMinZoom, xMaxZoom, zMinZoom, zMaxZoom
	end

	-->>: Swaps camera prespective
	self._swapPrespective = function(remainder: number)
		if self._swapPrespectiveDebounce and self._zDepth and self._xDepth then
			self._swapPrespectiveDebounce = false
			if self._inputNumber % 2 == remainder then
				self._inputNumber += 1
				local zDepthValue: number = self._zDepth.Value * -1
				local depthTween: Tween = TweenService:Create(
					self._zDepth,
					TweenInfo.new(TWEEN_DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ Value = zDepthValue }
				)
				depthTween:Play()
			else
				self._inputNumber -= 1
				local xDepthValue: number = self._xDepth.Value * -1
				local depthTween: Tween = TweenService:Create(
					self._xDepth,
					TweenInfo.new(TWEEN_DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ Value = xDepthValue }
				)
				depthTween:Play()
			end
			task.wait(TWEEN_DURATION)
			self._swapPrespectiveDebounce = true
		end
	end

	-->>: Sets zoom for camera (Zooms in or out)
	self._setZoomForCamera = function(multiplier: number, conditionCheck: boolean)
		if self._zoomEnabled then
			local xDepthCheck: number, zDepthCheck: number = self._getDepthSign()

			local xMinZoom: number, xMaxZoom: number, zMinZoom: number, zMaxZoom: number =
				self._getMinMaxValues(xDepthCheck, zDepthCheck)

			if conditionCheck and self._swapPrespectiveDebounce and self._xDepth and self._yDepth and self._zDepth then
				TweenService:Create(
					self._xDepth,
					TweenInfo.new(ZOOM_DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ Value = math.clamp(self._xDepth.Value + ((4 * xDepthCheck) * multiplier), xMinZoom, xMaxZoom) }
				):Play()
				TweenService:Create(
					self._yDepth,
					TweenInfo.new(ZOOM_DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ Value = math.clamp(self._yDepth.Value + (4 * multiplier), self._minYZoom, self._maxYZoom) }
				):Play()
				TweenService:Create(
					self._zDepth,
					TweenInfo.new(ZOOM_DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ Value = math.clamp(self._zDepth.Value + ((4 * zDepthCheck) * multiplier), zMinZoom, zMaxZoom) }
				):Play()
			end
		end
	end

	self:Init()

	return self
end

function IsometricCamera:getDepthValues(): (number, number, number)
	return self._xDepth.Value, self._yDepth.Value, self._zDepth.Value
end

function IsometricCamera:setCameraKeybinds(keyTable: { string | nil }?)
	if keyTable then
		self._cameraKeybinds = keyTable

		return
	end

	self._cameraKeybinds = {}

	return warn("Function did not receive a table in the correct format. Example: SetCameraKeybinds({'Q','E'})")
end

function IsometricCamera:setIsometricDepthAndHeight(depthTable: { [string]: number }?)
	if depthTable and depthTable["xzDepths"] and depthTable["yDepth"] and depthTable["height"] then
		self._xDepth.Value = depthTable["xzDepths"] or DEFAULT_X_DEPTH
		self._yDepth.Value = depthTable["yDepth"] or DEFAULT_Y_DEPTH
		self._zDepth.Value = depthTable["xzDepths"] or DEFAULT_Z_DEPTH
		self._height.Value = depthTable["height"] or DEFAULT_HEIGHT

		self._maxZoom = depthTable["xzDepths"]
		self._maxYZoom = depthTable["yDepth"]

		self._zoomMultiplier = 100 / self._maxZoom

		return
	end

	return warn(
		"Function did not receive dictionary in correct format. Example: SetIsometricDepthValues({X = value, Y = value, Z = value})"
	)
end

function IsometricCamera:setXZMinZoom(minZoom: number)
	self._minZoom = if minZoom then minZoom else warn("minZoom did not return a number type.")
end

function IsometricCamera:setYMinZoom(minZoom: number)
	self._minYZoom = if minZoom then minZoom else warn("minYZoom did not return a number type.")
end

function IsometricCamera:setZoomEnabled(bool: boolean)
	self._zoomEnabled = bool
end

function IsometricCamera:setOriginPart(part: Part)
	if part and (part:IsA("Part") or part:IsA("UnionOperation") or part:IsA("MeshPart")) then
		self._originPart = part

		return
	end

	return warn("Origin Point must be a Part, UnionOperation, or MeshPart!")
end

function IsometricCamera:Init()
	-->>: Set NumberValues for X,Y,Z Depths
	self._xDepth.Parent = script
	self._yDepth.Parent = script
	self._zDepth.Parent = script
	self._height.Parent = script

	self._xDepth.Name = "XDepth"
	self._yDepth.Name = "YDepth"
	self._zDepth.Name = "ZDepth"
	self._height.Name = "Height"

	self._xDepth.Value = DEFAULT_X_DEPTH
	self._yDepth.Value = DEFAULT_Y_DEPTH
	self._zDepth.Value = DEFAULT_Z_DEPTH
	self._height.Value = DEFAULT_HEIGHT

	-->>: Set mouse event connections
	self._janitor:Add(mouse.WheelForward:Connect(function()
		self._setZoomForCamera(-1, math.abs(self._xDepth.Value) > self._minZoom)
	end))

	self._janitor:Add(mouse.WheelBackward:Connect(function()
		self._setZoomForCamera(1, math.abs(self._xDepth.Value) < self._maxZoom)
	end))

	self._janitor:Add(UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
		-->>: Makes sure input is processed and that player is on Keyboard
		if gameProcessed or input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		if self._cameraKeybinds and self._cameraKeybinds[1] and self._cameraKeybinds[2] then
			if input.KeyCode == Enum.KeyCode[self._cameraKeybinds[1]] then
				self._swapPrespective(1)
			elseif input.KeyCode == Enum.KeyCode[self._cameraKeybinds[2]] then
				self._swapPrespective(0)
			end
		end
	end))

	-->>: Set CameraType and FieldOfView
	camera.CameraType = Enum.CameraType.Scriptable
	camera.FieldOfView = DEFAULT_FOV

	RunService:BindToRenderStep(BIND_RENDER_NAME, Enum.RenderPriority.Camera.Value, self._updateCamera)
end

function IsometricCamera:Destroy()
	RunService:UnbindFromRenderStep(BIND_RENDER_NAME)

	self._janitor:Destroy()

	for i: number, _ in pairs(self) do
		self[i] = nil
	end
end

return IsometricCamera
