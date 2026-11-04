-- LocalScript: put in StarterPlayer > StarterPlayerScripts
-- F = toggle fly | WASD = move (follows camera) | Space = up | LeftCtrl = down

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local SPEED = 60
local flying = false
local att, lv, ao

local function stopFly()
	flying = false
	if att then att:Destroy() end
	if lv then lv:Destroy() end
	if ao then ao:Destroy() end
	att, lv, ao = nil, nil, nil
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.PlatformStand = false end
end

local function startFly()
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not root or not hum then return end

	att = Instance.new("Attachment")
	att.Parent = root

	lv = Instance.new("LinearVelocity")
	lv.Attachment0 = att
	lv.RelativeTo = Enum.ActuatorRelativeTo.World
	lv.MaxForce = math.huge
	lv.VectorVelocity = Vector3.zero
	lv.Parent = root

	ao = Instance.new("AlignOrientation")
	ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
	ao.Attachment0 = att
	ao.RigidityEnabled = true
	ao.Parent = root

	hum.PlatformStand = true
	flying = true
end

UIS.InputBegan:Connect(function(input, typing)
	if typing then return end
	if input.KeyCode == Enum.KeyCode.F then
		if flying then stopFly() else startFly() end
	end
end)

RunService.RenderStepped:Connect(function()
	if not flying then return end
	local cf = camera.CFrame
	local dir = Vector3.zero

	if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
	if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end

	lv.VectorVelocity = dir.Magnitude > 0 and dir.Unit * SPEED or Vector3.zero
	ao.CFrame = cf.Rotation
end)

player.CharacterAdded:Connect(stopFly)
