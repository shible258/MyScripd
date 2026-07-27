--==========================================
-- 可缩小/移动/恢复的弹窗 UI
--==========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    or LocalPlayer:WaitForChild("PlayerGui", 10)

local blur = Instance.new("BlurEffect")
blur.Name = "ScriptStartupWarningBlur"
blur.Size = 0
blur.Parent = Lighting
TweenService:Create(blur, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 18}):Play()

local function SafeDestroy(inst)
    if inst and inst.Parent then inst:Destroy() end
end

local function CreateCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function CreateStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function CreateText(parent, name, text, position, size, color, textSize, font)
    local t = Instance.new("TextLabel")
    t.Name = name
    t.Parent = parent
    t.Position = position
    t.Size = size
    t.BackgroundTransparency = 1
    t.BorderSizePixel = 0
    t.Text = text
    t.TextColor3 = color
    t.TextSize = textSize
    t.Font = font
    t.TextWrapped = true
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextYAlignment = Enum.TextYAlignment.Center
    return t
end

local function CreateButton(parent, name, text, position, size, bgColor, textColor)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Parent = parent
    b.Position = position
    b.Size = size
    b.BackgroundColor3 = bgColor
    b.BackgroundTransparency = 0.06
    b.BorderSizePixel = 0
    b.AutoButtonColor = true
    b.Text = text
    b.TextColor3 = textColor
    b.TextSize = 14
    b.Font = Enum.Font.GothamBold
    b.TextWrapped = true
    CreateCorner(b, 14)
    return b
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyScriptUI"
screenGui.Parent = PlayerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 遮罩
local background = Instance.new("Frame")
background.Name = "Background"
background.Parent = screenGui
background.Position = UDim2.fromScale(0, 0)
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
background.BackgroundTransparency = 0.45
background.BorderSizePixel = 0

-- 外层阴影
local mainShadow = Instance.new("Frame")
mainShadow.Name = "SoftShadow"
mainShadow.Parent = background
mainShadow.AnchorPoint = Vector2.new(0.5, 0.5)
mainShadow.Position = UDim2.fromScale(0.5, 0.5)
mainShadow.Size = UDim2.new(0.88, 18, 0, 345)
mainShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainShadow.BackgroundTransparency = 0.72
mainShadow.BorderSizePixel = 0
local shadowLimit = Instance.new("UISizeConstraint")
shadowLimit.MaxSize = Vector2.new(540, 395)
shadowLimit.MinSize = Vector2.new(325, 300)
shadowLimit.Parent = mainShadow
CreateCorner(mainShadow, 32)
CreateStroke(mainShadow, Color3.fromRGB(255, 255, 255), 5, 0.32)

-- 主窗口
local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = background
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.new(0.88, 0, 0, 323)
main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
local mainLimit = Instance.new("UISizeConstraint")
mainLimit.MaxSize = Vector2.new(510, 385)
mainLimit.MinSize = Vector2.new(298, 285)
mainLimit.Parent = main
CreateCorner(main, 26)
CreateStroke(main, Color3.fromRGB(255, 255, 255), 2, 0.08)

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(236, 240, 248)),
})
gradient.Rotation = 90
gradient.Parent = main

local topHighlight = Instance.new("Frame")
topHighlight.Parent = main
topHighlight.Position = UDim2.new(0, 22, 0, 11)
topHighlight.Size = UDim2.new(1, -44, 0, 2)
topHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
topHighlight.BackgroundTransparency = 0.06
topHighlight.BorderSizePixel = 0
CreateCorner(topHighlight, 999)

local leftGlow = Instance.new("Frame")
leftGlow.Parent = main
leftGlow.Position = UDim2.new(0, 0, 0, 28)
leftGlow.Size = UDim2.new(0, 2, 1, -56)
leftGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
leftGlow.BackgroundTransparency = 0.16
leftGlow.BorderSizePixel = 0
CreateCorner(leftGlow, 999)

-- 颜色
local red = Color3.fromRGB(220, 38, 38)
local blue = Color3.fromRGB(37, 99, 235)
local black = Color3.fromRGB(18, 18, 22)
local gray = Color3.fromRGB(90, 90, 98)

-- 标题文字
CreateText(main, "SmallTitle", "我的脚本", UDim2.new(0, 28, 0, 22), UDim2.new(1, -56, 0, 24), gray, 13, Enum.Font.GothamMedium)
CreateText(main, "MainTitle", "欢迎使用", UDim2.new(0, 28, 0, 55), UDim2.new(1, -56, 0, 42), red, 19, Enum.Font.GothamBold)
CreateText(main, "Desc", "点击下方按钮开启功能", UDim2.new(0, 28, 0, 105), UDim2.new(1, -56, 0, 40), black, 17, Enum.Font.GothamMedium)

-- 标题栏（拖动区，也承载缩小/关闭按钮）
local titleBar = Instance.new("Frame")
titleBar.Parent = main
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
titleBar.BackgroundTransparency = 0.08
titleBar.BorderSizePixel = 0
titleBar.Active = true
titleBar.Draggable = true
CreateCorner(titleBar, 18)
local titleFix = Instance.new("Frame")
titleFix.Parent = titleBar
titleFix.Size = UDim2.new(1, 0, 0, 16)
titleFix.Position = UDim2.new(0, 0, 0.5, 0)
titleFix.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
titleFix.BackgroundTransparency = 0.08
titleFix.BorderSizePixel = 0

-- 关闭按钮（标题栏右上）
local closeBtn = CreateButton(titleBar, "CloseBtn", "✕", UDim2.new(1, -68, 0, 1), UDim2.new(0, 32, 0, 30), red, Color3.fromRGB(255, 255, 255))
CreateCorner(closeBtn, 10)

-- 缩小按钮（标题栏右二）
local minimizeBtn = CreateButton(titleBar, "MinimizeBtn", "－", UDim2.new(1, -34, 0, 1), UDim2.new(0, 32, 0, 30), Color3.fromRGB(80, 80, 90), Color3.fromRGB(255, 255, 255))
CreateCorner(minimizeBtn, 10)

-- 功能按钮
local btnSpeed = CreateButton(main, "SpeedBtn", "加速", UDim2.new(0, 28, 0, 165), UDim2.new(0.42, -14, 0, 42), red, Color3.fromRGB(255, 255, 255))
CreateStroke(btnSpeed, Color3.fromRGB(255, 255, 255), 1.5, 0.35)
btnSpeed.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 60
    end
end)

local btnJump = CreateButton(main, "JumpBtn", "跳高", UDim2.new(0.5, 14, 0, 165), UDim2.new(0.42, -14, 0, 42), blue, Color3.fromRGB(255, 255, 255))
CreateStroke(btnJump, Color3.fromRGB(255, 255, 255), 1.5, 0.35)
btnJump.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 100
    end
end)

local btnReset = CreateButton(main, "ResetBtn", "重置", UDim2.new(0, 28, 0, 220), UDim2.new(0.42, -14, 0, 42), Color3.fromRGB(245, 245, 247), black)
CreateStroke(btnReset, Color3.fromRGB(210, 210, 218), 1.5, 0.15)
btnReset.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end)

local btnClose = CreateButton(main, "CloseBtn2", "关闭", UDim2.new(0.5, 14, 0, 220), UDim2.new(0.42, -14, 0, 42), red, Color3.fromRGB(255, 255, 255))
CreateStroke(btnClose, Color3.fromRGB(255, 255, 255), 1.5, 0.35)
btnClose.MouseButton1Click:Connect(function()
    TweenService:Create(blur, TweenInfo.new(0.18), {Size = 0}):Play()
    TweenService:Create(main, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    TweenService:Create(mainShadow, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    task.delay(0.25, function()
        SafeDestroy(screenGui)
        SafeDestroy(blur)
    end)
end)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(blur, TweenInfo.new(0.18), {Size = 0}):Play()
    TweenService:Create(main, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    TweenService:Create(mainShadow, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    task.delay(0.25, function()
        SafeDestroy(screenGui)
        SafeDestroy(blur)
    end)
end)

--================ 缩小 / 恢复 逻辑 ================
local minimized = false

-- 缩小后的长方形图标（屏幕正上方）
local miniBar = Instance.new("Frame")
miniBar.Parent = background
miniBar.AnchorPoint = Vector2.new(0.5, 0)
miniBar.Position = UDim2.new(0.5, 0, 0, 10)  -- 屏幕正上方
miniBar.Size = UDim2.new(0, 200, 0, 36)
miniBar.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
miniBar.BackgroundTransparency = 0.08
miniBar.BorderSizePixel = 0
miniBar.Visible = false
miniBar.Active = true
CreateCorner(miniBar, 14)
CreateStroke(miniBar, Color3.fromRGB(255, 255, 255), 1.5, 0.3)

-- 移动图标（✥，在长方形内左侧）
local moveHandle = Instance.new("TextButton")
moveHandle.Parent = miniBar
moveHandle.Size = UDim2.new(0, 36, 0, 36)
moveHandle.Position = UDim2.new(0, 0, 0, 0)
moveHandle.BackgroundColor3 = Color3.fromRGB(120, 70, 220)
moveHandle.BackgroundTransparency = 0.1
moveHandle.Text = "✥"
moveHandle.TextColor3 = Color3.fromRGB(255, 255, 255)
moveHandle.Font = Enum.Font.GothamBold
moveHandle.TextSize = 16
moveHandle.BorderSizePixel = 0
moveHandle.Active = true
CreateCorner(moveHandle, 12)

-- 恢复按钮（＋，在长方形内右侧）
local restoreBtn = Instance.new("TextButton")
restoreBtn.Parent = miniBar
restoreBtn.Size = UDim2.new(0, 36
