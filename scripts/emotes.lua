local name = "karimm"
local speed = 50  -- forward speed
local rise = 30   -- how fast space lifts you
local sink = -10  -- how fast you drift down when not holding space

while true do
	local char = workspace:FindFirstChild(name)
	local humanoid = char and char:FindFirstChild("Humanoid")
	local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
	if humanoid and root and humanoid.Health > 0 then
		local bv = root:FindFirstChild("FlyVelocity")
		if not bv then
			bv = Instance.new("BodyVelocity")
			bv.Name = "FlyVelocity"
			bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bv.Parent = root
		end
		local y = sink
		if humanoid.Jump then
			y = rise
		end
		bv.Velocity = humanoid.MoveDirection * speed + Vector3.new(0, y, 0)
	end
	wait()
end
