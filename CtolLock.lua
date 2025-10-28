getgenv().Aimbot = {
Status = true,
Keybind = 'C',
Hitpart = 'HumanoidRootPart',
['Prediction'] = {
X = 0.145,
Y = 0.08,
},
}
if getgenv().AimbotRan then
return
else
getgenv().AimbotRan = true
end
-- make it reexecutable to update settings
local RunService = game:GetService('RunService')
local Workspace = game:GetService('Workspace')
local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local Player = nil -- Our target player
local GetClosestPlayer = function() -- // Optimized GetClosestPlayer i believe?
local ClosestDistance, ClosestPlayer = 100000, nil
for _, Player : Player in pairs(Players:GetPlayers()) do
if Player.Name ~= LocalPlayer.Name and Player.Character and Player.Character:FindFirstChild('HumanoidRootPart') then
local Root, Visible = Camera:WorldToScreenPoint(Player.Character.HumanoidRootPart.Position)
if not Visible then
continue
end
Root = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Root.X, Root.Y)).Magnitude
if Root < ClosestDistance then
ClosestPlayer = Player
ClosestDistance = Root
end
end
end
return ClosestPlayer
end
Mouse.KeyDown:Connect(function(key) -- Get our closest player (toggle)
if key == Aimbot.Keybind:lower() then
Player = not Player and GetClosestPlayer() or nil
end
end)
RunService.RenderStepped:Connect(function()
if not Player then
return
end
if not Aimbot.Status then
return
end
local Hitpart = Player.Character:FindFirstChild(Aimbot.Hitpart)
if not Hitpart then
return
end
Camera.CFrame = CFrame.new(Camera.CFrame.Position, Hitpart.Position + Hitpart.Velocity * Vector3.new(Aimbot.Prediction.X, Aimbot.Prediction.Y, Aimbot.Prediction.X))
end)
