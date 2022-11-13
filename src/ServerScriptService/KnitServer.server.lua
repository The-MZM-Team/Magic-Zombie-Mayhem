local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Component = require(game:GetService("ReplicatedStorage").Packages.Component)

local Services = ServerScriptService:WaitForChild("Services")
local Components = ServerScriptService:WaitForChild("Components")

local clockOffset: number = os.clock()

Knit.AddServices(Services)

Knit.Start()
	:andThen(function()
		Component.Auto(Components)
		print(string.format("[Server-Knit]: Framework Initiated [%sms]", os.clock() - clockOffset))
	end)
	:catch(warn)
