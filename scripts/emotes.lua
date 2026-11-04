local password = "meowmeowmeow"
local speed = 50
local unlocked = false
local me = owner -- your own player

function makeTool()
	local tool = Instance.new("Tool")
	tool.Name = "Fly"
	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(1, 1, 1)
	handle.Parent = tool

	local equipped = false
	local holding = false

	tool.Equipped:connect(function(mouse)
		local char = tool.Parent
		local torso = char:FindFirstChild("Torso")
		local humanoid = char:FindFirstChild("Humanoid")
		if not torso or not humanoid then return end

		equipped = true
		humanoid.PlatformStand = true

		local bv = Instance.new("BodyVelocity")
		bv.maxForce = Vector3.new(math.huge, math.huge, math.huge)
		bv.velocity = Vector3.new(0, 0, 0)
		bv.Parent = torso

		local bg = Instance.new("BodyGyro")
		bg.maxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bg.cframe = torso.CFrame
		bg.Parent = torso

		mouse.Button1Down:connect(function() holding = true end)
		mouse.Button1Up:connect(function() holding = false end)

		while equipped and torso.Parent do
			local target = mouse.Hit.p
			if (target - torso.Position).magnitude > 1 then
				bg.cframe = CFrame.new(torso.Position, target)
				if holding then
					bv.velocity = (target - torso.Position).unit * speed
				else
					bv.velocity = Vector3.new(0, 0, 0)
				end
			end
			wait()
		end

		bv:Remove()
		bg:Remove()
		humanoid.PlatformStand = false
	end)

	tool.Unequipped:connect(function()
		equipped = false
		holding = false
	end)

	return tool
end

function give()
	local backpack = me:FindFirstChild("Backpack")
	if backpack and not backpack:FindFirstChild("Fly") then
		makeTool().Parent = backpack
	end
end

me.Chatted:connect(function(msg)
	if string.lower(msg) == password then
		unlocked = true
		give()
	end
end)

me.CharacterAdded:connect(function()
	wait(1)
	if unlocked then
		give()
	end
end)
