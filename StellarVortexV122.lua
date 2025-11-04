--[[
    STELLARVORTEX v1.22
    Made By StellarVortex
    - 24-HOUR AUTO-UPDATE
    - SOLARA CLONE + ALL FEATURES
    - AUTO-RELOAD ON NEW VERSION
--]]

--// AUTO-UPDATE SYSTEM (EVERY 24 HOURS)
local CURRENT_VERSION = "v1.22"
local REPO_URL = "https://raw.githubusercontent.com/wilsonc1446/SV/main/StellarVortexV122.lua"
local UPDATE_INTERVAL = 86400  -- 24 hours

local function showNotification(text, color)
    local notif = Instance.new("ScreenGui")
    local frame = Instance.new("Frame", notif)
    frame.Size = UDim2.new(0, 300, 0, 80)
    frame.Position = UDim2.new(1, -320, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
    frame.BorderSizePixel = 0
    local c = Instance.new("UICorner", frame); c.CornerRadius = UDim.new(0,12)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(0,255,150)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 20
    notif.Parent = game:GetService("CoreGui")

    TweenService:Create(frame, TweenInfo.new(0.5), {Position = UDim2.new(1, -320, 0, 20)}):Play()
    task.wait(3)
    TweenService:Create(frame, TweenInfo.new(0.5), {Position = UDim2.new(1, 0, 0, 20)}):Play()
    task.wait(0.5)
    notif:Destroy()
end

local function checkForUpdate()
    spawn(function()
        local success, remoteCode = pcall(function()
            return game:HttpGet(REPO_URL, true)
        end)

        if not success then
            warn("Update failed: No internet?")
            return
        end

        local remoteVer = remoteCode:match('CURRENT_VERSION = "v([^"]+)"')
        if remoteVer and remoteVer > CURRENT_VERSION then
            print("UPDATING TO "..remoteVer.."...")
            showNotification("Updating to "..remoteVer.."!", Color3.fromRGB(0,255,150))
            task.wait(1)
            loadstring(remoteCode)()
        else
            showNotification("Up to date! ("..CURRENT_VERSION..")", Color3.fromRGB(100,200,255))
        end
    end)
end

-- Run update check every 24 hours
spawn(function()
    while true do
        checkForUpdate()
        task.wait(UPDATE_INTERVAL)
    end
end)

--------------------------------------------------------------------
--// MAIN SCRIPT (GUI + FEATURES)
--------------------------------------------------------------------
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
task.wait(1)

--------------------------------------------------------------------
--// SAVE SYSTEM
--------------------------------------------------------------------
local SAVE_FILE = "StellarVortex_v122.json"
local defaultSettings = {clicking = false, speed = 16, autoRe = true, posX = 0.5, posY = 0.3}
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
--// SOLARA-STYLE GUI
--------------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "StellarVortexV122"
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
top.BorderSizePixel = 0

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 25, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Made By StellarVortex v1.22"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.TextXAlignment = Enum.TextXAlignment.Left

local xBtn = Instance.new("TextButton", top)
xBtn.Size = UDim2.new(0, 60, 0, 60)
xBtn.Position = UDim2.new(1, -70, 0, 5)
xBtn.BackgroundTransparency = 1
xBtn.Text = "X"
xBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
xBtn.Font = Enum.Font.GothamBold
xBtn.TextSize = 34

-- Content
local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, -220, 1, -70)
content.Position = UDim2.new(0, 220, 0, 70)
content.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
content.ClipsDescendants = true

-- Search
local searchBox = Instance.new("TextBox", content)
searchBox.Size = UDim2.new(1, -40, 0, 50)
searchBox.Position = UDim2.new(0, 20, 0, 15)
searchBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
searchBox.Text = "Search..."
searchBox.TextColor3 = Color3.fromRGB(200, 200, 255)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 20
searchBox.ClearTextOnFocus = true
local sbc = Instance.new("UICorner", searchBox); sbc.CornerRadius = UDim.new(0, 10)

--------------------------------------------------------------------
--// SIDEBAR TABS
--------------------------------------------------------------------
local tabs = {}
local areas = {}
local tabNames = {"TOOLS", "CLICKER", "SCRIPTS", "PAST SCRIPTS", "SUPPORT"}

for i, name in ipairs(tabNames) do
    local tab = Instance.new("TextButton", sidebar)
    tab.Size = UDim2.new(1, -20, 0, 55)
    tab.Position = UDim2.new(0, 10, 0, 80 + (i-1)*60)
    tab.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    tab.Text = ""
    tab.Parent = sidebar
    local tc = Instance.new("UICorner", tab); tc.CornerRadius = UDim.new(0, 10)

    local icon = Instance.new("ImageLabel", tab)
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 15, 0.5, -15)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://3926305904"
    icon.ImageColor3 = Color3.fromRGB(150, 150, 200)

    local label = Instance.new("TextLabel", tab)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 55, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 200, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left

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
            t:FindFirstChild("ImageLabel").ImageColor3 = Color3.fromRGB(150, 150, 200)
            areas[j].Visible = false
        end
        tab.BackgroundColor3 = Color3.fromRGB(0, 130, 200)
        icon.ImageColor3 = Color3.new(1,1,1)
        area.Visible = true
    end)

    tabs[i] = tab
end

--------------------------------------------------------------------
--// PAST SCRIPTS TAB
--------------------------------------------------------------------
local pastArea = areas[4]
local pastScroll = Instance.new("ScrollingFrame", pastArea)
pastScroll.Size = UDim2.new(1, -40, 1, 0)
pastScroll.Position = UDim2.new(0, 20, 0, 0)
pastScroll.BackgroundTransparency = 1
pastScroll.ScrollBarThickness = 8
pastScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
local pastLayout = Instance.new("UIListLayout", pastScroll); pastLayout.Padding = UDim.new(0, 12)

local pastScripts = {
    {name = "REMOTE SPY", code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/infyinfy/SimpleSpy/main/SimpleSpySource.lua"))()]]},
    {name = "FLY (F)", code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/GrokHub/Fly/main/fly.lua"))()]]},
    {name = "ESP", code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/GrokHub/ESP/main/esp.lua"))()]]},
    {name = "INFINITE YIELD", code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()]]},
}

for _, s in ipairs(pastScripts) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 70)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    btn.Text = s.name
    btn.TextColor3 = Color3.fromRGB(0, 200, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Parent = pastScroll
    local uc = Instance.new("UICorner", btn); uc.CornerRadius = UDim.new(0, 12)
    btn.Activated:Connect(function() loadstring(s.code)() end)
end
pastScroll.CanvasSize = UDim2.new(0,0,0,pastLayout.AbsoluteContentSize.Y + 50)

--------------------------------------------------------------------
--// DRAG + HOTKEY
--------------------------------------------------------------------
local dragging = false
local dragStart, startPos
top.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = i.Position; startPos = frame.Position
    end
end)
top.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
        settings.posX, settings.posY = frame.Position.X.Scale, frame.Position.Y.Scale
        saveSettings()
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.Insert then
        frame.Visible = not frame.Visible
    end
end)

showNotification("v1.22 Loaded! Auto-updates every 24h", Color3.fromRGB(0,170,255))
print("STELLARVORTEX v1.22 LOADED – AUTO-UPDATE ENABLED")
