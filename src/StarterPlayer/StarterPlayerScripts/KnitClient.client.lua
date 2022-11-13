local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Component = require(game:GetService("ReplicatedStorage").Packages.Component)

local Controllers = ReplicatedStorage:WaitForChild("Controllers")
local Components = ReplicatedStorage:WaitForChild("Components")

local clockOffset: number = os.clock()

Knit.AddControllers(Controllers)

Knit.Start()
	:andThen(function()
		Component.Auto(Components)
		print(string.format("[Client-Knit]: Framework Initiated [%sms]", os.clock() - clockOffset))
	end)
	:catch(warn)
