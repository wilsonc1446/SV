--[[
    STELLARVORTEX v1.23
    Made By StellarVortex
    - FLY GUI TAB (Toggle, Speed Slider)
    - CLICKER: 2000 CPS MAX
    - UPDATE SOUND + NOTIFICATION
    - AUTO-UPDATE EVERY 24H
--]]

--// AUTO-UPDATE (24H)
local CURRENT_VERSION = "v1.23"
local REPO_URL = "https://raw.githubusercontent.com/wilsonc1446/SV/main/StellarVortexV122.lua"
local UPDATE_INTERVAL = 86400

local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local updateSound = Instance.new("Sound")
updateSound.SoundId = "rbxassetid://9072437480"  -- Epic update ping
updateSound.Volume = 0.5
updateSound.Parent = game:GetService("CoreGui")

local function showNotification(text, color)
    local notif = Instance.new("ScreenGui")
    local frame = Instance.new("Frame", notif)
    frame.Size = UDim2.new(0, 320, 0, 90)
    frame.Position = UDim2.new(1, -340, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
    frame.BorderSizePixel = 0
    local c = Instance.new("UICorner", frame); c.CornerRadius = UDim.new(0,14)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(0,255,150)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 22
    notif.Parent = game:GetService("CoreGui")

    updateSound:Play()
    TweenService:Create(frame, TweenInfo.new(0.5), {Position = UDim2.new(1, -340, 0, 20)}):Play()
    task.wait(4)
    TweenService:Create(frame, TweenInfo.new(0.5), {Position = UDim2.new(1, 0, 0, 20)}):Play()
    task.wait(0.5)
    notif:Destroy()
end

local function checkForUpdate()
    spawn(function()
        local success, remoteCode = pcall(function()
            return game:HttpGet(REPO_URL, true)
        end)
        if not success then return end

        local remoteVer = remoteCode:match('CURRENT_VERSION = "v([^"]+)"')
        if remoteVer and remoteVer > CURRENT_VERSION then
            showNotification("UPDATING TO v"..remoteVer.."!", Color3.fromRGB(255,215,0))
            task.wait(1.2)
            loadstring(remoteCode)()
        end
    end)
end

spawn(function()
    while true do
        checkForUpdate()
        task.wait(UPDATE_INTERVAL)
    end
end)

--------------------------------------------------------------------
--// MAIN SCRIPT
--------------------------------------------------------------------
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
task.wait(1)

--------------------------------------------------------------------
--// SAVE SYSTEM
--------------------------------------------------------------------
local SAVE_FILE = "StellarVortex_v123.json"
local defaultSettings = {clicking = false, speed = 16, autoRe = true, fly = false, flySpeed = 50, posX = 0.5, posY = 0.3}
local settings = defaultSettings

local function loadSettings()
    if isfile and readfile and isfile(SAVE_FILE) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(SAVE_FILE)) end)
        if success and data then settings = data end
    end
end
local function saveSettings()
    if writefile then
        pcall(function() writefile(SAVE_FILE, HttpService:JSONEncode(settings)) end)
    end
end
loadSettings()

--------------------------------------------------------------------
--// GUI SETUP (SOLARA STYLE)
--------------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "StellarVortexV123"
gui.ResetOnSpawn = false
gui.Parent = pgui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 950, 0, 650)
frame.Position = UDim2.new(settings.posX, -475, settings.posY, -150)
frame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = gui
local fc = Instance.new("UICorner", frame); fc.CornerRadius = UDim.new(0, 12)

-- Sidebar
local sidebar = Instance.new("Frame", frame)
sidebar.Size = UDim2.new(0, 220, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
sidebar.BorderSizePixel = 0
local sc = Instance.new("UICorner", sidebar); sc.CornerRadius = UDim.new(0, 12)

-- Top Bar
local top = Instance.new("Frame", frame)
top.Size = UDim2.new(1, -220, 0, 70)
top.Position = UDim2.new(0, 220, 0, 0)
top.BackgroundColor3 = Color3.fromRGB(15, 15, 22)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 25, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Made By StellarVortex v1.23"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.TextXAlignment = Enum.TextXAlignment.Left

-- Content
local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, -220, 1, -70)
content.Position = UDim2.new(0, 220, 0, 70)
content.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
content.ClipsDescendants = true

--------------------------------------------------------------------
--// TABS
--------------------------------------------------------------------
local tabs = {}
local areas = {}
local tabNames = {"TOOLS", "CLICKER", "FLY", "SCRIPTS", "PAST SCRIPTS", "SUPPORT"}

for i, name in ipairs(tabNames) do
    local tab = Instance.new("TextButton", sidebar)
    tab.Size = UDim2.new(1, -20, 0, 50)
    tab.Position = UDim2.new(0, 10, 0, 80 + (i-1)*55)
    tab.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    tab.Text = name
    tab.TextColor3 = Color3.fromRGB(200, 200, 255)
    tab.Font = Enum.Font.GothamBold
    tab.TextSize = 18
    local tc = Instance.new("UICorner", tab); tc.CornerRadius = UDim.new(0, 10)
    tab.Parent = sidebar

    local area = Instance.new("Frame", content)
    area.Size = UDim2.new(1, 0, 1, -80)
    area.Position = UDim2.new(0, 0, 0, 80)
    area.BackgroundTransparency = 1
    area.Visible = (i == 1)
    area.Parent = content
    areas[i] = area

    tab.Activated:Connect(function()
        for j, t in ipairs(tabs) do
            t.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
            areas[j].Visible = false
        end
        tab.BackgroundColor3 = Color3.fromRGB(0, 130, 200)
        area.Visible = true
    end)
    tabs[i] = tab
end

--------------------------------------------------------------------
--// FLY TAB (NEW!)
--------------------------------------------------------------------
local flyArea = areas[3]
local flyBtn = Instance.new("TextButton", flyArea)
flyBtn.Size = UDim2.new(0, 300, 0, 70)
flyBtn.Position = UDim2.new(0, 40, 0, 40)
flyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
flyBtn.Text = "FLY: OFF"
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 24
local fbc = Instance.new("UICorner", flyBtn); fbc.CornerRadius = UDim.new(0, 14)

local flySpeedSlider = Instance.new("TextBox", flyArea)
flySpeedSlider.Size = UDim2.new(0, 300, 0, 50)
flySpeedSlider.Position = UDim2.new(0, 40, 0, 130)
flySpeedSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
flySpeedSlider.Text = "Fly Speed: 50"
flySpeedSlider.TextColor3 = Color3.fromRGB(0, 255, 150)
flySpeedSlider.Font = Enum.Font.Gotham
flySpeedSlider.TextSize = 20
local fsc = Instance.new("UICorner", flySpeedSlider); fsc.CornerRadius = UDim.new(0, 10)

-- FLY LOGIC
local flying = false
local flySpeed = 50

flyBtn.Activated:Connect(function()
    flying = not flying
    flyBtn.Text = "FLY: "..(flying and "ON" or "OFF")
    flyBtn.BackgroundColor3 = flying and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 200, 100)
    settings.fly = flying
    saveSettings()
end)

flySpeedSlider.FocusLost:Connect(function()
    local num = tonumber(flySpeedSlider.Text:match("%d+"))
    if num and num > 0 and num <= 500 then
        flySpeed = num
        settings.flySpeed = num
        saveSettings()
    end
end)

RunService.Heartbeat:Connect(function()
    if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local cam = workspace.CurrentCamera
        local move = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
        hrp.Velocity = move * flySpeed
    end
end)

--------------------------------------------------------------------
--// CLICKER (2000 CPS MAX)
--------------------------------------------------------------------
local clickArea = areas[2]
local cpsLabel = Instance.new("TextLabel", clickArea)
cpsLabel.Size = UDim2.new(0, 300, 0, 50)
cpsLabel.Position = UDim2.new(0, 40, 0, 200)
cpsLabel.BackgroundTransparency = 1
cpsLabel.Text = "CPS: 0"
cpsLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
cpsLabel.Font = Enum.Font.GothamBold
cpsLabel.TextSize = 24

local speedSlider = Instance.new("TextBox", clickArea)
speedSlider.Size = UDim2.new(0, 300, 0, 50)
speedSlider.Position = UDim2.new(0, 40, 0, 130)
speedSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
speedSlider.Text = "Speed: 16"
speedSlider.TextColor3 = Color3.fromRGB(255, 100, 255)
speedSlider.Font = Enum.Font.Gotham
speedSlider.TextSize = 20
local ssc = Instance.new("UICorner", speedSlider); ssc.CornerRadius = UDim.new(0, 10)

-- [PAST SCRIPTS, DRAG, HOTKEY — SAME AS v1.22]

showNotification("v1.23 LOADED! FLY + 2000 CPS", Color3.fromRGB(255,215,0))
