local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")

local function RandomString(len)
    local s = ""
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    for i = 1, len or 12 do
        local r = math.random(1, #chars)
        s = s .. chars:sub(r, r)
    end
    return s
end

local function protect_gui(gui)
    gui.Parent = CoreGui
end

local function CreateWatermark()
    local player = Players.LocalPlayer

    if CoreGui:FindFirstChild("WatermarkGui") then
        CoreGui.WatermarkGui:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "WatermarkGui"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 10
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Main = Instance.new("Frame")
    Main.Name = RandomString()
    Main.Position = UDim2.new(1, -10, 0, 15)
    Main.AnchorPoint = Vector2.new(1, 0)
    Main.Size = UDim2.new(0, 220, 0, 32)
    Main.BackgroundTransparency = 0.05
    Main.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    Main.BorderSizePixel = 0
    Main.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.Name = RandomString()
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = Main

    local stroke = Instance.new("UIStroke")
    stroke.Name = RandomString()
    stroke.Color = Color3.fromHex("BB66FF")
    stroke.Thickness = 2
    stroke.Transparency = 0.2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = Main

    local padding = Instance.new("UIPadding")
    padding.Name = RandomString()
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 5)
    padding.Parent = Main

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = RandomString()
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextSize = 16
    textLabel.TextXAlignment = Enum.TextXAlignment.Right
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.RichText = true
    textLabel.Parent = Main

    local lastFpsUpdate = 0
    local fps = 0
    local lastPingUpdate = 0
    local ping = 0
    local startTime = tick()

    local function formatTime(seconds)
        local hours = math.floor(seconds / 3600)
        local minutes = math.floor((seconds % 3600) / 60)
        local secs = math.floor(seconds % 60)
        
        if hours > 0 then
            return string.format("%d:%02d:%02d", hours, minutes, secs)
        elseif minutes > 0 then
            return string.format("%d:%02d", minutes, secs)
        else
            return string.format("%d", secs)
        end
    end

    local function updateText()
        local now = tick()

        if now - lastFpsUpdate >= 0.77 then
            fps = math.floor(1 / RunService.RenderStepped:Wait())
            lastFpsUpdate = now
        end

        if now - lastPingUpdate >= 1 then
            ping = math.floor(player:GetNetworkPing() * 1000)
            lastPingUpdate = now
        end

        local runtime = now - startTime
        local runtimeText = formatTime(runtime)

        textLabel.Text = string.format(
            '<font color="#BB66FF">Space Hub</font> | %d fps | %d ms | %s',
            fps,
            ping,
            runtimeText
        )

        local textSize = TextService:GetTextSize(
            textLabel.ContentText,
            textLabel.TextSize,
            textLabel.Font,
            Vector2.new(math.huge, textLabel.AbsoluteSize.Y)
        )
        Main.Size = UDim2.new(0, textSize.X + 20, 0, 32)
    end

    local renderConnection = Instance.new("RBXScriptConnection")
    renderConnection = RunService.RenderStepped:Connect(updateText)
end

if game.PlaceId == 131716211654599 or game.PlaceId == 16732694052 then
    return
else
    CreateWatermark()
end
