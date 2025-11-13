-- ======= CONFIGURATION =======
local KeySlots = {
    {Key = "KEY1", Username = "XenLikeThat"}, -- replace KEY1 & Player1
    {Key = "KEY2", Username = "Au_qrx"}, -- replace KEY2 & Player2
    {Key = "KEY3", Username = "Valhalla3667"},
    {Key = "KEY4", Username = "Water_man409322"}, -- replace KEY3 & Player3
}

local GetKeyLink = "https://discord.gg/PeZDSt7NJG" -- Replace with your link
-- ==============================

-- ======= UI CREATION =======
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = PlayerGui

-- Background frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 250)
frame.Position = UDim2.new(0.5, -200, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Key Verification"
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Key Entry Box
local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.8, 0, 0, 50)
keyBox.Position = UDim2.new(0.1, 0, 0, 60)
keyBox.PlaceholderText = "Enter Key"
keyBox.TextScaled = true
keyBox.ClearTextOnFocus = true
keyBox.TextColor3 = Color3.fromRGB(0, 0, 0)
keyBox.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
keyBox.Parent = frame

-- Verify Key Button
local verifyButton = Instance.new("TextButton")
verifyButton.Size = UDim2.new(0.35, 0, 0, 50)
verifyButton.Position = UDim2.new(0.1, 0, 0, 120)
verifyButton.Text = "Verify Key"
verifyButton.TextScaled = true
verifyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
verifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyButton.Font = Enum.Font.GothamBold
verifyButton.Parent = frame

-- Get Key Button
local getKeyButton = Instance.new("TextButton")
getKeyButton.Size = UDim2.new(0.35, 0, 0, 50)
getKeyButton.Position = UDim2.new(0.55, 0, 0, 120)
getKeyButton.Text = "Get Key"
getKeyButton.TextScaled = true
getKeyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.Parent = frame

-- Notification Label
local notifyLabel = Instance.new("TextLabel")
notifyLabel.Size = UDim2.new(1, 0, 0, 30)
notifyLabel.Position = UDim2.new(0, 0, 0, 190)
notifyLabel.Text = ""
notifyLabel.TextScaled = true
notifyLabel.BackgroundTransparency = 1
notifyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
notifyLabel.Font = Enum.Font.GothamBold
notifyLabel.Parent = frame

-- ======= FUNCTIONALITY =======
local function notify(msg, color)
    notifyLabel.Text = msg
    notifyLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    delay(3, function() notifyLabel.Text = "" end)
end

local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
        notify("Copied link to clipboard!", Color3.fromRGB(0, 255, 0))
    else
        notify("Cannot copy! Unsupported environment.", Color3.fromRGB(255, 0, 0))
    end
end

getKeyButton.MouseButton1Click:Connect(function()
    copyToClipboard(GetKeyLink)
end)

local KeyVerified = false

verifyButton.MouseButton1Click:Connect(function()
    local enteredKey = keyBox.Text
    local username = LocalPlayer.Name
    local valid = false

    for _, slot in ipairs(KeySlots) do
        if slot.Key == enteredKey and slot.Username == username then
            valid = true
            break
        end
    end

    if valid then
        KeyVerified = true
        notify("Key verified!", Color3.fromRGB(0, 255, 0))
        screenGui:Destroy()
        runAimbot() -- Run aimbot after verification
    else
        notify("Invalid key or not for your account!", Color3.fromRGB(255, 0, 0))
    end
end)

-- ======= AIMBOT SCRIPT =======
function runAimbot()
    getgenv().Aimbot = {
        Status = true,
        Keybind = 'C',
        Hitpart = 'HumanoidRootPart',
        ['Prediction'] = {
            X = 0.1,
            Y = 0.08,
        },
    }

    if getgenv().AimbotRan then
        return
    else
        getgenv().AimbotRan = true
    end

    local RunService = game:GetService('RunService')
    local Workspace = game:GetService('Workspace')
    local Players = game:GetService('Players')
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()
    local Player = nil

    local GetClosestPlayer = function()
        local ClosestDistance, ClosestPlayer = 100000, nil
        for _, P in pairs(Players:GetPlayers()) do
            if P.Name ~= LocalPlayer.Name and P.Character and P.Character:FindFirstChild('HumanoidRootPart') then
                local Root, Visible = Camera:WorldToScreenPoint(P.Character.HumanoidRootPart.Position)
                if not Visible then continue end
                Root = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Root.X, Root.Y)).Magnitude
                if Root < ClosestDistance then
                    ClosestPlayer = P
                    ClosestDistance = Root
                end
            end
        end
        return ClosestPlayer
    end

    Mouse.KeyDown:Connect(function(key)
        if key == Aimbot.Keybind:lower() then
            Player = not Player and GetClosestPlayer() or nil
        end
    end)

    RunService.RenderStepped:Connect(function()
        if not Player or not Aimbot.Status then return end
        local Hitpart = Player.Character:FindFirstChild(Aimbot.Hitpart)
        if not Hitpart then return end
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Hitpart.Position + Hitpart.Velocity * Vector3.new(Aimbot.Prediction.X, Aimbot.Prediction.Y, Aimbot.Prediction.X))
    end)
end
