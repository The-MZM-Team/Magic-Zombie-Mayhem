local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Submodules.Packages.Knit)
local Component = require(ReplicatedStorage.Submodules.Packages.Component)

local Services = ServerScriptService:WaitForChild("Services")
local CoreServices = ServerScriptService.Submodules.Core.Source.Services
local Components = ServerScriptService:WaitForChild("Components")

local clockOffset: number = os.clock()

Knit.AddServices(CoreServices)
Knit.AddServices(Services)

Knit.Start()
	:andThen(function()
		Component.Auto(Components)
		print(string.format("[Server-Knit]: Framework Initiated [%sms]", os.clock() - clockOffset))
	end)
	:catch(warn)
