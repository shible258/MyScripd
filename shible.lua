--==========================================
-- 1:1 复刻 yejiaoben 启动弹窗 UI（纯界面，无功能逻辑）
--==========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    or LocalPlayer:WaitForChild("PlayerGui", 10)

if not PlayerGui then return end

-- 防重复
getgenv()._YEUI_RUNNING = getgenv()._YEUI_RUNNING or false
if getgenv()._YEUI_RUNNING then return end
getgenv()._YEUI_RUNNING = true

-- 模糊背景（和 yejiaoben 完全一样）
local blur = Instance.new("BlurEffect")
blur.Name = "ScriptStartupWarningBlur"
blur.Size = 0
blur.Parent = Lighting

TweenService:Create(blur, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 18}):Play()

-- 工具函数（和 yejiaoben 一模一样）
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
screenGui.Name = "ScriptStartupWarningUI"
screenGui.Parent = PlayerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 半透明白色遮罩（和 yejiaoben 一样）
local background = Instance.new("Frame")
background.Name = "Background"
background.Parent = screenGui
background.Position = UDim2.fromScale(0, 0)
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
background.BackgroundTransparency = 0.45
background.BorderSizePixel = 0

-- 外层阴影卡片（SoftShadow，和 yejiaoben 参数一致）
local mainShadow = Instance.new("Frame")
mainShadow.Name = "SoftShadow"
mainShadow.Parent = background
mainShadow.AnchorPoint = Vector2.new(0.5, 0.5)
mainShadow.Position = UDim2.fromScale(0.5, 0.5)
mainShadow.Size = UDim2.new(0.88, 18, 0, 330)
mainShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainShadow.BackgroundTransparency = 0.72
mainShadow.BorderSizePixel = 0

local shadowLimit = Instance.new("UISizeConstraint")
shadowLimit.MaxSize = Vector2.new(520, 355)
shadowLimit.MinSize = Vector2.new(320, 300)
shadowLimit.Parent = mainShadow

CreateCorner(mainShadow, 32)
CreateStroke(mainShadow, Color3.fromRGB(255, 255, 255), 5, 0.32)

-- 内层主卡片（Main）
local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = background
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.new(0.88, 0, 0, 308)
main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0

local mainLimit = Instance.new("UISizeConstraint")
mainLimit.MaxSize = Vector2.new(490, 335)
mainLimit.MinSize = Vector2.new(305, 290)
mainLimit.Parent = main

CreateCorner(main, 26)
CreateStroke(main, Color3.fromRGB(255, 255, 255), 2, 0.08)

-- 白色渐变（和 yejiaoben 一致）
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

-- 颜色定义（和 yejiaoben 一致）
local red = Color3.fromRGB(220, 38, 38)
local blue = Color3.fromRGB(37, 99, 235)
local black = Color3.fromRGB(18, 18, 22)
local gray = Color3.fromRGB(90, 90, 98)

-- 文字（和 yejiaoben 布局一致）
CreateText(main, "SmallTitle", "启动保护", UDim2.new(0, 28, 0, 22), UDim2.new(1, -56, 0, 24), gray, 13, Enum.Font.GothamMedium)
CreateText(main, "IdText", "检测到你的游戏id为 " .. tostring(game.PlaceId), UDim2.new(0, 28, 0, 55), UDim2.new(1, -56, 0, 42), red, 19, Enum.Font.GothamBold)
CreateText(main, "PauseText", "脚本已暂停启动，请你选择是否继续", UDim2.new(0, 28, 0, 105), UDim2.new(1, -56, 0, 40), black, 17, Enum.Font.GothamMedium)
CreateText(main, "DangerText", "如果你选择继续使用夜脚本可能会出现问题请谨慎选择", UDim2.new(0, 28, 0, 153), UDim2.new(1, -56, 0, 58), red, 16, Enum.Font.GothamBold)
CreateText(main, "MatchedText", "当前匹配：" .. tostring(game.PlaceId), UDim2.new(0, 28, 0, 212), UDim2.new(1, -56, 0, 22), gray, 12, Enum.Font.Gotham)

-- 三个按钮（和 yejiaoben 位置/颜色完全一致）
-- 取消启动（灰色描边）
local cancelButton = CreateButton(main, "CancelButton", "取消启动", UDim2.new(0, 28, 1, -60), UDim2.new(1/3, -14, 0, 42), Color3.fromRGB(245, 245, 247), black)
CreateStroke(cancelButton, Color3.fromRGB(210, 210, 218), 1.5, 0.15)

-- 加载其他脚本（蓝色）
local otherButton = CreateButton(main, "OtherScriptButton", "加载其他脚本", UDim2.new(1/3, 7, 1, -60), UDim2.new(1/3, -14, 0, 42), blue, Color3.fromRGB(255, 255, 255))
CreateStroke(otherButton, Color3.fromRGB(255, 255, 255), 1.5, 0.35)

-- 继续启动（红色）
local continueButton = CreateButton(main, "ContinueButton", "继续启动", UDim2.new(2/3, 0, 1, -60), UDim2.new(1/3, -14, 0, 42), red, Color3.fromRGB(255, 255, 255))
CreateStroke(continueButton, Color3.fromRGB(255, 255, 255), 1.5, 0.35)

-- 入场动画（和 yejiaoben 完全一致）
main.Size = UDim2.new(0.88, 0, 0, 280)
mainShadow.Size = UDim2.new(0.88, 18, 0, 302)
main.BackgroundTransparency = 1
mainShadow.BackgroundTransparency = 1

TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.88, 0, 0, 308), BackgroundTransparency = 0.1}):Play()
TweenService:Create(mainShadow, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.88, 18, 0, 330), BackgroundTransparency = 0.72}):Play()

-- 关闭逻辑（只保留关闭，不加载任何脚本）
local function Cleanup()
    TweenService:Create(blur, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0}):Play()
    TweenService:Create(main, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    TweenService:Create(mainShadow, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    task.delay(0.25, function()
        SafeDestroy(screenGui)
        SafeDestroy(blur)
        getgenv()._YEUI_RUNNING = false
    end)
end

cancelButton.MouseButton1Click:Connect(function()
    Cleanup()
end)

continueButton.MouseButton1Click:Connect(function()
    Cleanup()
end)

otherButton.MouseButton1Click:Connect(function()
    Cleanup()
end)

print("[YEUI] 弹窗已加载（纯UI版）")

