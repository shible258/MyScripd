--==========================================
-- 1:1 复刻 yejiaoben 弹窗UI（单份，无重复）
--==========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    or LocalPlayer:WaitForChild("PlayerGui", 10)

-- 模糊背景
local blur = Instance.new("BlurEffect")
blur.Name = "ScriptStartupWarningBlur"
blur.Size = 0
blur.Parent = Lighting

TweenService:Create(blur, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 18}):Play()

-- 工具函数
local function SafeDestroy(instance)
    if instance and instance.Parent then
        instance:Destroy()
    end
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function CreateText(parent, name, text, position, size, color, textSize, font)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Parent = parent
    label.Position = position
    label.Size = size
    label.BackgroundTransparency = 1
    label.BorderSizePixel = 0
    label.Text = text
    label.TextColor3 = color
    label.TextSize = textSize
    label.Font = font
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    return label
end

local function CreateButton(parent, name, text, position, size, bgColor, textColor)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = parent
    button.Position = position
    button.Size = size
    button.BackgroundColor3 = bgColor
    button.BackgroundTransparency = 0.06
    button.BorderSizePixel = 0
    button.AutoButtonColor = true
    button.Text = text
    button.TextColor3 = textColor
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.TextWrapped = true
    CreateCorner(button, 14)
    return button
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyScriptUI"
screenGui.Parent = PlayerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 半透明白色遮罩
local background = Instance.new("Frame")
background.Name = "Background"
background.Parent = screenGui
background.Position = UDim2.fromScale(0, 0)
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
background.BackgroundTransparency = 0.45
background.BorderSizePixel = 0

-- 外层阴影卡片
local mainShadow = Instance.new("Frame")
mainShadow.Name = "SoftShadow"
mainShadow.Parent = background
mainShadow.AnchorPoint = Vector2.new(0.5, 0.5)
mainShadow.Position = UDim2.fromScale(0.5, 0.5)
mainShadow.Size = UDim2.new(0.88, 18, 0, 390)
mainShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainShadow.BackgroundTransparency = 0.72
mainShadow.BorderSizePixel = 0

local shadowLimit = Instance.new("UISizeConstraint")
shadowLimit.MaxSize = Vector2.new(560, 430)
shadowLimit.MinSize = Vector2.new(320, 310)
shadowLimit.Parent = mainShadow

CreateCorner(mainShadow, 32)
CreateStroke(mainShadow, Color3.fromRGB(255, 255, 255), 5, 0.32)

-- 内层主卡片
local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = background
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.new(0.88, 0, 0, 368)
main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0

local mainLimit = Instance.new("UISizeConstraint")
mainLimit.MaxSize = Vector2.new(530, 410)
mainLimit.MinSize = Vector2.new(295, 290)
mainLimit.Parent = main

CreateCorner(main, 26)
CreateStroke(main, Color3.fromRGB(255, 255, 255), 2, 0.08)

-- 白色渐变
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(236, 240, 248)),
})
gradient.Rotation = 90
gradient.Parent = main

-- 顶部高光线
local topHighlight = Instance.new("Frame")
topHighlight.Name = "TopHighlight"
topHighlight.Parent = main
topHighlight.Position = UDim2.new(0, 22, 0, 11)
topHighlight.Size = UDim2.new(1, -44, 0, 2)
topHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
topHighlight.BackgroundTransparency = 0.06
topHighlight.BorderSizePixel = 0
CreateCorner(topHighlight, 999)

-- 左侧蓝色发光条
local leftGlow = Instance.new("Frame")
leftGlow.Name = "LeftGlow"
leftGlow.Parent = main
leftGlow.Position = UDim2.new(0, 0, 0, 28)
leftGlow.Size = UDim2.new(0, 2, 1, -56)
leftGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
leftGlow.BackgroundTransparency = 0.16
leftGlow.BorderSizePixel = 0
CreateCorner(leftGlow, 999)

-- 颜色定义
local red = Color3.fromRGB(220, 38, 38)
local blue = Color3.fromRGB(37, 99, 235)
local black = Color3.fromRGB(18, 18, 22)
local gray = Color3.fromRGB(90, 90, 98)

-- 标题文字
CreateText(main, "SmallTitle", "我的脚本", UDim2.new(0, 28, 0, 22), UDim2.new(1, -56, 0, 24), gray, 13, Enum.Font.GothamMedium)
CreateText(main, "MainTitle", "欢迎使用", UDim2.new(0, 28, 0, 55), UDim2.new(1, -56, 0, 42), red, 19, Enum.Font.GothamBold)
CreateText(main, "Desc", "点击下方按钮开启功能", UDim2.new(0, 28, 0, 105), UDim2.new(1, -56, 0, 40), black, 17, Enum.Font.GothamMedium)

-- 加速按钮（红色）
local btnSpeed = CreateButton(main, "SpeedBtn", "加速", UDim2.new(0, 28, 0, 165), UDim2.new(0.42, -14, 0, 42), red, Color3.fromRGB(255, 255, 255))
CreateStroke(btnSpeed, Color3.fromRGB(255, 255, 255), 1.5, 0.35)

btnSpeed.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 60
    end
end)

-- 跳高按钮（蓝色）
local btnJump = CreateButton(main, "JumpBtn", "跳高", UDim2.new(0.5, 14, 0, 165), UDim2.new(0.42, -14, 0, 42), blue, Color3.fromRGB(255, 255, 255))
CreateStroke(btnJump, Color3.fromRGB(255, 255, 255), 1.5, 0.35)

btnJump.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 100
    end
end)

-- 重置按钮（灰色描边）
local btnReset = CreateButton(main, "ResetBtn", "重置", UDim2.new(0, 28, 0, 265), UDim2.new(0.42, -14, 0, 42), Color3.fromRGB(245, 245, 247), black)
CreateStroke(btnReset, Color3.fromRGB(210, 210, 218), 1.5, 0.15)

btnReset.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end)

-- 关闭按钮（红色）
local btnClose = CreateButton(main, "CloseBtn", "关闭", UDim2.new(0.5, 14, 0, 315), UDim2.new(0.42, -14, 0, 42), red, Color3.fromRGB(255, 255, 255))
CreateStroke(btnClose, Color3.fromRGB(255, 255, 255), 1.5, 0.35)

btnClose.MouseButton1Click:Connect(function()
    local blurTween = TweenService:Create(blur, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0})
    blurTween:Play()
    TweenService:Create(main, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    TweenService:Create(mainShadow, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    task.delay(0.22, function()
        if screenGui and screenGui.Parent then screenGui:Destroy() end
        if blur and blur.Parent then blur:Destroy() end
    end)
end)

-- 入场动画
main.Size = UDim2.new(0.88, 0, 0, 336)
mainShadow.Size = UDim2.new(0.88, 18, 0, 358)
main.BackgroundTransparency = 1
mainShadow.BackgroundTransparency = 1

TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.88, 0, 0, 368), BackgroundTransparency = 0.1}):Play()
TweenService:Create(mainShadow, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.88, 18, 0, 390), BackgroundTransparency = 0.72}):Play()

print("UI加载完成")
