local name = "karimm"
local speed = 60    -- max flying speed
local climb = 40    -- how fast space lifts you
local smooth = 0.15 -- lower = floatier, higher = snappier

local flying = true
local lastJump = false
local lastTap = 0
local vel = Vector3.new()
local facing = Vector3.new(0, 0, -1)

while true do
	local char = workspace:FindFirstChild(name)
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))

	if humanoid and root and humanoid.Health > 0 then
		-- double tap space to toggle flying
		local jump = humanoid.Jump
		if jump and not lastJump then
			if tick() - lastTap < 0.35 then
				flying = not flying
				lastTap = 0
			else
				lastTap = tick()
			end
		end
		lastJump = jump

		local bv = root:FindFirstChild("FlyVelocity")
		local bg = root:FindFirstChild("FlyGyro")

		if flying then
			if not bv then
				bv = Instance.new("BodyVelocity")
				bv.Name = "FlyVelocity"
				bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
				bv.Velocity = Vector3.new()
				bv.Parent = root
				vel = Vector3.new()
			end
			if not bg then
				bg = Instance.new("BodyGyro")
				bg.Name = "FlyGyro"
				bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
				bg.P = 10000
				bg.CFrame = root.CFrame
				bg.Parent = root
			end
			humanoid.PlatformStand = true

			local move = humanoid.MoveDirection
			local target = move * speed
			if jump then
				target = target + Vector3.new(0, climb, 0)
			end
			vel = vel:Lerp(target, smooth)
			bv.Velocity = vel

			if move.Magnitude > 0.1 then
				facing = move
			end
			local flat = Vector3.new(vel.X, 0, vel.Z).Magnitude
			local tilt = math.rad(-25) * math.min(flat / speed, 1)
			bg.CFrame = CFrame.new(Vector3.new(), facing) * CFrame.Angles(tilt, 0, 0)
		else
			if bv then bv:Destroy() end
			if bg then bg:Destroy() end
			humanoid.PlatformStand = false
		end
	end
	wait()
end
