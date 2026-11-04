local lines = {}
table.insert(lines, "script name: " .. script.Name)

local ok, env = pcall(getfenv, 1)
if ok and env then
	for k, v in pairs(env) do
		table.insert(lines, "global: " .. tostring(k) .. " = " .. tostring(v))
	end
end

local ok2, kids = pcall(function() return script:GetChildren() end)
if ok2 then
	for _, c in pairs(kids) do
		local val = ""
		pcall(function() val = " = " .. tostring(c.Value) end)
		table.insert(lines, "child: " .. c.Name .. " (" .. c.ClassName .. ")" .. val)
	end
end

local ok3, attrs = pcall(function() return script:GetAttributes() end)
if ok3 and attrs then
	for k, v in pairs(attrs) do
		table.insert(lines, "attribute: " .. tostring(k) .. " = " .. tostring(v))
	end
end

if #lines == 1 then
	table.insert(lines, "(nothing else found)")
end

local msg = Instance.new("Message")
msg.Text = table.concat(lines, "\n")
msg.Parent = workspace
wait(30)
msg:Remove()
