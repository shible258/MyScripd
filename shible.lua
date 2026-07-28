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
mainShadow.Size = UDim2.new(0.88, 18, 0, 420)
mainShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainShadow.BackgroundTransparency = 0.72
mainShadow.BorderSizePixel = 0
local shadowLimit = Instance.new("UISizeConstraint")
shadowLimit.MaxSize = Vector2.new(610, 480)
shadowLimit.MinSize = Vector2.new(326, 362)
shadowLimit.Parent = mainShadow
CreateCorner(mainShadow, 32)
CreateStroke(mainShadow, Color3.fromRGB(255, 255, 255), 5, 0.32)

local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = background
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.new(0.88, 0, 0, 398)
main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
local mainLimit = Instance.new("UISizeConstraint")
mainLimit.MaxSize = Vector2.new(580, 470)
mainLimit.MinSize = Vector2.new(297, 344)
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
leftGlow.Size = UDim2.new(0, 2, 1, -112)
leftGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
leftGlow.BackgroundTransparency = 0.16
leftGlow.BorderSizePixel = 0
CreateCorner(leftGlow, 999)

local red = Color3.fromRGB(203, 37, 59)
local blue = Color3.fromRGB(67, 91, 181)
local black = Color3.fromRGB(69, 66, 74)
local gray = Color3.fromRGB(145, 133, 155)

CreateText(main, "SmallTitle", "我的脚本", UDim2.new(0, 28, 0, 22), UDim2.new(1, -128, 0, 24), gray, 13, Enum.Font.GothamMedium)
CreateText(main, "MainTitle", "欢迎使用", UDim2.new(0, 28, 0, 55), UDim2.new(1, -126, 0, 42), red, 19, Enum.Font.GothamBold)
CreateText(main, "Desc", "点击下方按钮开启功能", UDim2.new(0, 28, 0, 108), UDim2.new(1, -124, 0, 40), black, 17, Enum.Font.GothamMedium)

-- 缩小按钮（右上角）
local minBtn = CreateButton(main, "MinBtn", "—", UDim2.new(1, -80, 0, 164), UDim2.new(0, 44, 0, 176), Color3.fromRGB(127, 119, 141), Color3.fromRGB(226, 219, 233))
CreateStroke(minBtn, Color3.fromRGB(121, 114, 136), 1.5, 0.81)
CreateCorner(minBtn, 14)

-- 关闭按钮（右上角）
local exitBtn = CreateButton(main, "ExitBtn", "✕", UDim2.new(1, -132, 0, 166), UDim2.new(0, 44, 0, 168), Color3.fromRGB(194, 182, 206), Color3.fromRGB(171, 46, 52))
CreateStroke(exitBtn, Color3.fromRGB(143, 132, 158), 1.5, 0.77)
CreateCorner(exitBtn, 14)

-- 第一行：加速 + 跳高
local btnSpeed = CreateButton(main, "SpeedBtn", "加速", UDim2.new(0, 28, 0, 169), UDim2.new(0.405, -8, 0, 42), red, Color3.fromRGB(227, 217, 235))
CreateStroke(btnSpeed, Color3.fromRGB(211, 199, 223), 1.5, 0.29)
btnSpeed.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 60
    end
end)

local btnJump = CreateButton(main, "JumpBtn", "跳高", UDim2.new(0.495, 14, 0, 169), UDim2.new(0.408, -8, 0, 42), blue, Color3.fromRGB(224, 216, 233))
CreateStroke(btnJump, Color3.fromRGB(207, 197, 219), 1.5, 0.30)
btnJump.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 100
    end
end)

-- 第二行：重置 + 无敌
local btnReset = CreateButton(main, "ResetBtn", "重置", UDim2.new(0, 28, 0, 225), UDim2.new(0.403, -8, 0, 42), Color3.fromRGB(229, 222, 236), black)
CreateStroke(btnReset, Color3.fromRGB(195, 184, 208), 1.5, 0.00)
btnReset.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end)

local btnGod = CreateButton(main, "GodBtn", "无敌", UDim2.new(0.497, 14, 0, 225), UDim2.new(0.406, -8, 0, 42), Color3.fromRGB(193, 163, 63), Color3.fromRGB(228, 219, 235))
CreateStroke(btnGod, Color3.fromRGB(200, 188, 213), 1.5, 0.28)
local godMode = false
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
miniBar.Size = UDim2.new(0, 192, 0, 36)
miniBar.BackgroundColor3 = Color3.fromRGB(245, 243, 249)
miniBar.BackgroundTransparency = 0.025
miniBar.BorderSizePixel = 0
miniBar.Visible = false
miniBar.Active = true
CreateCorner(miniBar, 16)
CreateStroke(miniBar, Color3.fromRGB(155, 142, 177), 1.5, 0.015)

-- 移动手柄（✥）
local moveBtn = Instance.new("TextButton", miniBar)
moveBtn.Size = UDim2.new(0, 36, 0, 36)
moveBtn.BackgroundColor3 = Color3.fromRGB(165, 146, 195)
moveBtn.BackgroundTransparency = 0.005
moveBtn.Text = "✥"
moveBtn.TextColor3 = Color3.fromRGB(52, 38, 76)
moveBtn.Font = Enum.Font.GothamBold
moveBtn.TextSize = 18
moveBtn.BorderSizePixel = 0
moveBtn.Active = true
CreateCorner(moveBtn, 14)

-- 恢复按钮（＋）
local restBtn = Instance.new("TextButton", miniBar)
restBtn.Size = UDim2.new(0, 36, 0, 36)
restBtn.Position = UDim2.new(1, -36, 0, 0)
restBtn.BackgroundColor3 = Color3.fromRGB(183, 168, 196)
restBtn.BackgroundTransparency = 0.016
restBtn.Text = "＋"
restBtn.TextColor3 = Color3.fromRGB(58, 43, 80)
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
exitBtn.MouseButton1Click:Connect(function()
    TweenService:Create(blur, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0}):Play()
    TweenService:Create(main, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    TweenService:Create(mainShadow, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    task.delay(0.22, function()
        if screenGui and screenGui.Parent then screenGui:Destroy() end
        if blur and blur.Parent then blur:Destroy() end
    end)
end)

-- 入场动画
main.Size = UDim2.new(0.88, 0, 0, 364)
mainShadow.Size = UDim2.new(0.88, 18, 0, 386)
main.BackgroundTransparency = 1
mainShadow.BackgroundTransparency = 1
TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.88, 0, 0, 399), BackgroundTransparency = 0.085}):Play()
TweenService:Create(mainShadow, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.88, 18, 0, 421), BackgroundTransparency = 0.715}):Play()

print("UI加载完成")
