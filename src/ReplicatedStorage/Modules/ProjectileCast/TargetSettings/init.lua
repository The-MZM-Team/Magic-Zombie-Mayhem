local CollectionService = game:GetService("CollectionService")

local TARGETS_FOLDER_NAME = "Targets"

local Settings = {}

local function CreateFolder()
	if script.Parent:FindFirstChild("Targets") == nil then
		local FolderTargets = Instance.new("Folder")
		FolderTargets.Parent = script
		FolderTargets.Name = TARGETS_FOLDER_NAME
	end
end

local function SetTags(targetsArray: { string })
	for _, tagName: string in pairs(targetsArray) do
		local newTarget = Instance.new("StringValue")
		newTarget.Parent = script[TARGETS_FOLDER_NAME]
		newTarget.Name = tagName
		newTarget.Value = tagName
	end
end

function Settings.setTaggedTargets(targetsArray: { string })
	CreateFolder()
	SetTags(targetsArray)
end

function Settings.getTaggedTargets(hit: BasePart): boolean?
	for _, tagValue: StringValue in pairs(script[TARGETS_FOLDER_NAME]:GetChildren()) do
		if CollectionService:HasTag(hit, tagValue.Value) or CollectionService:HasTag(hit.Parent, tagValue.Value) then
			return true
		end
	end
end

return Settings
