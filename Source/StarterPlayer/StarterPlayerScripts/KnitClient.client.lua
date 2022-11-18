local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Submodules.Packages.Knit)
local Component = require(ReplicatedStorage.Submodules.Packages.Component)

local Controllers = ReplicatedStorage:WaitForChild("Controllers")
local CoreControllers = ReplicatedStorage.Submodules.Core.Source.Controllers
local Components = ReplicatedStorage:WaitForChild("Components")

local clockOffset = os.clock()

Knit.AddControllers(CoreControllers)
Knit.AddControllers(Controllers)

Knit.Start()
	:andThen(function()
		Component.Auto(Components)
		print(string.format("[Client-Knit]: Framework Initiated [%sms]", os.clock() - clockOffset))
	end)
	:catch(warn)
