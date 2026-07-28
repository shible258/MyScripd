--==========================================
-- 1:1 复刻 yejiaoben 弹窗UI（对齐版 + 缩小功能）
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

local function SafeDestroy(instance)
    if instance and instance.Parent then instance:Destroy() end
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

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyScriptUI"
screenGui.Parent = PlayerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local background = Instance.new("Frame")
background.Name = "Background"
background.Parent = screenGui
background.Position = UDim2.fromScale(0, 0)
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
background.BackgroundTransparency = 0.45
background.BorderSizePixel = 0

local mainShadow = Instance.new("Frame")
mainShadow.Name = "SoftShadow"
mainShadow.Parent = background
mainShadow.AnchorPoint = Vector2.new(0.5, 0.5)
mainShadow.Position = UDim2.fromScale(0.5, 0.5)
mainShadow.Size = UDim2.new(0.88, 18, 0, 375)
mainShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainShadow.BackgroundTransparency = 0.72
mainShadow.BorderSizePixel = 0
local shadowLimit = Instance.new("UISizeConstraint")
shadowLimit.MaxSize = Vector2.new(570, 425)
shadowLimit.MinSize = Vector2.new(325, 328)
shadowLimit.Parent = mainShadow
CreateCorner(mainShadow, 32)
CreateStroke(mainShadow, Color3.fromRGB(255, 255, 255), 5, 0.32)

local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = background
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.new(0.88, 0, 0, 353)
main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
local mainLimit = Instance.new("UISizeConstraint")
mainLimit.MaxSize = Vector2.new(542, 415)
mainLimit.MinSize = Vector2.new(296, 312)
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
topHighlight.Name = "TopHighlight"
topHighlight.Parent = main
topHighlight.Position = UDim2.new(0, 22, 0, 11)
topHighlight.Size = UDim2.new(1, -44, 0, 2)
topHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
topHighlight.BackgroundTransparency = 0.06
topHighlight.BorderSizePixel = 0
CreateCorner(topHighlight, 999)

local leftGlow = Instance.new("Frame")
leftGlow.Name = "LeftGlow"
leftGlow.Parent = main
leftGlow.Position = UDim2.new(0, 0, 0, 28)
leftGlow.Size = UDim2.new(0, 2, 1, -56)
leftGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
leftGlow.BackgroundTransparency = 0.16
leftGlow.BorderSizePixel = 0
CreateCorner(leftGlow, 999)

local red = Color3.fromRGB(220, 38, 38)
local blue = Color3.fromRGB(37, 99, 235)
local black = Color3.fromRGB(18, 18, 22)
local gray = Color3.fromRGB(90, 90, 98)

CreateText(main, "SmallTitle", "我的脚本", UDim2.new(0, 28, 0, 22), UDim2.new(1, -56, 0, 24), gray, 13, Enum.Font.GothamMedium)
CreateText(main, "MainTitle", "欢迎使用", UDim2.new(0, 28, 0, 55), UDim2.new(1, -56, 0, 42), red, 19, Enum.Font.GothamBold)
CreateText(main, "Desc", "点击下方按钮开启功能", UDim2.new(0, 28, 0, 105), UDim2.new(1, -56, 0, 40), black, 17, Enum.Font.GothamMedium)

-- 缩小按钮（放在右上角，和关闭按钮对称）
local minBtn = CreateButton(main, "MinBtn", "－", UDim2.new(1, -154, 0, 268), UDim2.new(0, 36, 0, 36), Color3.fromRGB(158, 149, 173), Color3.fromRGB(255, 255, 255))
CreateStroke(minBtn, Color3.fromRGB(157, 147, 177), 1.5, 0.09)
CreateCorner(minBtn, 12)

-- 关闭按钮（放在右上角）
local closeBtn = CreateButton(main, "CloseBtn", "✕", UDim2.new(1, -156, 0, 306), UDim2.new(0, 36, 0, 36), Color3.fromRGB(159, 151, 174), Color3.fromRGB(161, 43, 44))
CreateStroke(closeBtn, Color3.fromRGB(159, 148, 175), 1.5, 0.04)
CreateCorner(closeBtn, 12)

-- 第一行：加速 + 跳高
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

-- 第二行：重置 + 无敌
local btnReset = CreateButton(main, "ResetBtn", "重置", UDim2.new(0, 28, 0, 220), UDim2.new(0.42, -14, 0, 42), Color3.fromRGB(245, 245, 247), black)
CreateStroke(btnReset, Color3.fromRGB(210, 210, 218), 1.5, 0.15)
btnReset.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end)

local godMode = false
local btnGod = CreateButton(main, "GodBtn", "无敌", UDim2.new(0.5, 14, 0, 220), UDim2.new(0.42, -14, 0, 42), Color3.fromRGB(255, 170, 0), Color3.fromRGB(255, 255, 255))
CreateStroke(btnGod, Color3.fromRGB(255, 255, 255), 1.5, 0.35)
btnGod.MouseButton1Click:Connect(function()
    godMode = not godMode
    if godMode then
        btnGod.Text = "无敌: 开"
        spawn(function()
            while godMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") do
                local hum = LocalPlayer.Character.Humanoid
                if hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
                task.wait(0.1)
            end
        end)
    else
        btnGod.Text = "无敌"
    end
end)

-- 缩小后的长方形图标（屏幕正上方）
local miniBar = Instance.new("Frame", screenGui)
miniBar.AnchorPoint = Vector2.new(0.5, 0)
miniBar.Position = UDim2.new(0.5, 0, 0, 15)
miniBar.Size = UDim2.new(0, 200, 0, 38)
miniBar.BackgroundColor3 = Color3.fromRGB(248, 247, 250)
miniBar.BackgroundTransparency = 0.03
miniBar.BorderSizePixel = 0
miniBar.Visible = false
miniBar.Active = true
CreateCorner(miniBar, 16)
CreateStroke(miniBar, Color3.fromRGB(170, 155, 195), 1.5, 0.02)

-- 移动手柄（✥）
local moveBtn = Instance.new("TextButton", miniBar)
moveBtn.Size = UDim2.new(0, 38, 0, 38)
moveBtn.BackgroundColor3 = Color3.fromRGB(175, 155, 205)
moveBtn.BackgroundTransparency = 0.01
moveBtn.Text = "✥"
moveBtn.TextColor3 = Color3.fromRGB(55, 40, 80)
moveBtn.Font = Enum.Font.GothamBold
moveBtn.TextSize = 18
moveBtn.BorderSizePixel = 0
moveBtn.Active = true
CreateCorner(moveBtn, 14)

-- 恢复按钮（＋）
local restBtn = Instance.new("TextButton", miniBar)
restBtn.Size = UDim2.new(0, 38, 0, 38)
restBtn.Position = UDim2.new(1, -38, 0, 0)
restBtn.BackgroundColor3 = Color3.fromRGB(185, 170, 200)
restBtn.BackgroundTransparency = 0.03
restBtn.Text = "＋"
restBtn.TextColor3 = Color3.fromRGB(60, 45, 85)
restBtn.Font = Enum.Font.GothamBold
restBtn.TextSize = 20
restBtn.BorderSizePixel = 0
restBtn.Active = true
CreateCorner(restBtn, 14)

-- 拖动 miniBar
local isDragging, dragStart, barStartPos
moveBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        barStartPos = miniBar.Position
    end
end)
moveBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        miniBar.Position = UDim2.new(barStartPos.X.Scale, barStartPos.X.Offset + delta.X, barStartPos.Y.Scale, math.max(0, barStartPos.Y.Offset + delta.Y))
    end
end)

-- 缩小
minBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    mainShadow.Visible = false
    background.BackgroundTransparency = 1
    TweenService:Create(blur, TweenInfo.new(0.15), {Size = 0}):Play()
    miniBar.Visible = true
end)

-- 恢复
restBtn.MouseButton1Click:Connect(function()
    miniBar.Visible = false
    background.BackgroundTransparency = 0.45
    TweenService:Create(blur, TweenInfo.new(0.15), {Size = 18}):Play()
    main.Visible = true
    mainShadow.Visible = true
end)

-- 关闭
closeBtn.MouseButton1Click:Connect(function()
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
main.Size = UDim2.new(0.88, 0, 0, 319)
mainShadow.Size = UDim2.new(0.88, 18, 0, 341)
main.BackgroundTransparency = 1
mainShadow.BackgroundTransparency = 1
TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.88, 0, 0, 354), BackgroundTransparency = 0.1}):Play()
TweenService:Create(mainShadow, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.88, 18, 0, 376), BackgroundTransparency = 0.72}):Play()

print("UI加载完成")
