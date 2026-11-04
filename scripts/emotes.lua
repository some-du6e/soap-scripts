-- Gives the Fly tool to anyone whose name starts with "karim"
-- Tool must be in Lighting and named "Fly"

local tool = game.Lighting:FindFirstChild("Fly")

function isKarim(player)
	return string.lower(string.sub(player.Name, 1, 5)) == "karim"
end

function give(player)
	if not tool then return end
	if not isKarim(player) then return end
	local backpack = player:FindFirstChild("Backpack")
	if backpack and not backpack:FindFirstChild("Fly") then
		tool:Clone().Parent = backpack
	end
end

function setup(player)
	player.CharacterAdded:connect(function()
		wait(1) -- let the backpack reset first
		give(player)
	end)
	if player.Character then
		give(player)
	end
end

game.Players.PlayerAdded:connect(setup)

for _, player in pairs(game.Players:GetChildren()) do
	setup(player)
end
