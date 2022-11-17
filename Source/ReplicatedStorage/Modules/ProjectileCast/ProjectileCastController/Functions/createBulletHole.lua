local function createBulletHole(id: number): Part
	local projectileHole = Instance.new("Part")
	projectileHole.Size = Vector3.new(1, 1, 0.01)
	projectileHole.Anchored = false
	projectileHole.CanCollide = false
	projectileHole.Massless = true
	projectileHole.Transparency = 1
	projectileHole.Name = "BulletHole"

	local projectileholedecal = Instance.new("Decal")
	projectileholedecal.Parent = projectileHole
	projectileholedecal.Face = Enum.NormalId.Front
	projectileholedecal.Texture = "http://www.roblox.com/asset/?id=" .. tostring(id)

	return projectileHole
end

return createBulletHole
