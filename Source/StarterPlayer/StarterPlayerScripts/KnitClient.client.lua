local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Submodules.Packages.Knit)

local Controllers = ReplicatedStorage:WaitForChild("Controllers")
local CoreControllers = ReplicatedStorage.Submodules.Core.Source.Controllers
local ClientComponents = ReplicatedStorage.Submodules.Core.Source.Components

local clockOffset = os.clock()

Knit.AddControllers(CoreControllers)
Knit.AddControllers(Controllers)

for _, component in pairs(ClientComponents:GetChildren()) do
	require(component)
end

Knit.Start()
	:andThen(function()
		print(string.format("[Client-Knit]: Framework Initiated [%sms]", os.clock() - clockOffset))
	end)
	:catch(warn)
