print("script name: " .. script.Name)
local ok, env = pcall(getfenv, 1)
if ok and env then
	for k, v in pairs(env) do
		print("global: " .. tostring(k) .. " = " .. tostring(v))
	end
end
for _, c in pairs(script:GetChildren()) do
	print("child: " .. c.Name .. " (" .. c.ClassName .. ")")
end
local ok2, attrs = pcall(function() return script:GetAttributes() end)
if ok2 and attrs then
	for k, v in pairs(attrs) do
		print("attribute: " .. tostring(k) .. " = " .. tostring(v))
	end
end
