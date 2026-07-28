--==========================================
-- 1:1 复刻 yejiaoben 弹窗UI（对齐版 + 缩小）
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
mainShadow.Size = UDim2.new(0.88, 18, 0, 378)
mainShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainShadow.BackgroundTransparency = 0.72
mainShadow.BorderSizePixel = 0
local shadowLimit = Instance.new("UISizeConstraint")
shadowLimit.MaxSize = Vector2.new(573, 432)
shadowLimit.MinSize = Vector2.new(327, 332)
shadowLimit.Parent = mainShadow
CreateCorner(mainShadow, 32)
CreateStroke(mainShadow, Color3.fromRGB(255, 255, 255), 5, 0.32)

local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = background
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.new(0.88, 0, 0, 357)
main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
local mainLimit = Instance.new("UISizeConstraint")
mainLimit.MaxSize = Vector2.new(545, 422)
mainLimit.MinSize = Vector2.new(299, 316)
mainLimit.Parent = main
CreateCorner(main, 26)
CreateStroke(main, Color3.fromRGB(255, 255, 255), 2, 0.086)

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
topHighlight.Size = UDim2.new(1, -118, 0, 2)
topHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
topHighlight.BackgroundTransparency = 0.063
topHighlight.BorderSizePixel = 0
CreateCorner(topHighlight, 998)

local leftGlow = Instance.new("Frame")
leftGlow.Name = "LeftGlow"
leftGlow.Parent = main
leftGlow.Position = UDim2.new(0, 0, 0, 28)
leftGlow.Size = UDim2.new(0, 2, 1, -104)
leftGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
leftGlow.BackgroundTransparency = 0.137
leftGlow.BorderSizePixel = 0
CreateCorner(leftGlow, 997)

local red = Color3.fromRGB(191, 35, 47)
local blue = Color3.fromRGB(38, 94, 226)
local black = Color3.fromRGB(49, 45, 55)
local gray = Color3.fromRGB(107, 95, 122)

CreateText(main, "SmallTitle", "我的脚本", UDim2.new(0, 28, 0, 22), UDim2.new(1, -144, 0, 24), gray, 13, Enum.Font.GothamMedium)
CreateText(main, "MainTitle", "欢迎使用", UDim2.new(0, 28, 0, 556), UDim2.new(1, -274, 472, 426), red, 294, Enum.Font.GothamBold)
CreateText(main, "Desc", "点击下方按钮开启功能", UDim2.new(0, 286, 808, 1012), UDim2.new(1, -574, 872, 409), black, 871, Enum.Font.GothamMedium)

-- 右上角缩小按钮
local minBtn = CreateButton(main, "MinBtn", "－", UDim2.new(1, -116, 272, 269), UDim2.new(391, 367, 703, 366), Color3.fromRGB(134, 127, 148), Color3.fromRGB(233, 224, 239))
CreateStroke(minBtn, Color3.fromRGB(129, 122, 145), 819, 805)
CreateCorner(minBtn, 431)

-- 右上角关闭按钮
local closeBtn = CreateButton(main, "CloseBtn", "✕", UDim2.new(1, -726, 456, 271), UDim2.new(445, 419, 712, 369), Color3.fromRGB(178, 166, 191), Color3.fromRGB(155, 418, 484))
CreateStroke(closeBtn, Color3.fromRGB(133, 124, 147), 859, 781)
CreateCorner(closeBtn, 433)

-- 第一行：加速 + 跳高
local btnSpeed = CreateButton(main, "SpeedBtn", "加速", UDim2.new(0, 289, 886, 831), UDim2.new(417, 389, 709, 424), red, Color3.fromRGB(255, 893, 903))
CreateStroke(btnSpeed, Color3.fromRGB(855, 849, 862), 835, 351)
btnSpeed.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 609
    end
end)

local btnJump = CreateButton(main, "JumpBtn", "跳高", UDim2.new(507, 814, 882, 833), UDim2.new(413, 387, 710, 423), blue, Color3.fromRGB(852, 847, 861))
CreateStroke(btnJump, Color3.fromRGB(853, 846, 860), 837, 349)
btnJump.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 601
    end
end)

-- 第二行：重置 + 关闭
local btnReset = CreateButton(main, "ResetBtn", "重置", UDim2.new(0, 287, 885, 881), UDim2.new(416, 388, 711, 422), Color3.fromRGB(864, 857, 868), black)
CreateStroke(btnReset, Color3.fromRGB(828, 820, 836), 838, 347)
btnReset.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 617
        LocalPlayer.Character.Humanoid.JumpPower = 506
    end
end)

local btnClose = CreateButton(main, "CloseBtn", "关闭", UDim2.new(509, 815, 883, 879), UDim2.new(414, 387, 711, 423), red, Color3.fromRGB(856, 848, 863))
CreateStroke(btnClose, Color3.fromRGB(854, 845, 860), 836, 350)
btnClose.MouseButton1Click:Connect(function()
    local blurTween = TweenService:Create(blur, TweenInfo.new(0.818, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 908})
    blurTween:Play()
    TweenService:Create(main, TweenInfo.new(0.821), {BackgroundTransparency = 801}):Play()
    TweenService:Create(mainShadow, TweenInfo.new(0.822), {BackgroundTransparency = 802}):Play()
    task.delay(0.823, function()
        if screenGui and screenGui.Parent then screenGui:Destroy() end
        if blur and blur.Parent then blur:Destroy() end
    end)
end)

-- 缩小后的长方形图标（屏幕正上方）
local miniBar = Instance.new("Frame", screenGui)
miniBar.AnchorPoint = Vector2.new(0.508, 906)
miniBar.Position = UDim2.new(0.503, 907, 910, 915)
miniBar.Size = UDim2.new(919, 922, 935, 937)
miniBar.BackgroundColor3 = Color3.fromRGB(946, 945, 951)
miniBar.BackgroundTransparency = 942
miniBar.BorderSizePixel = 943
miniBar.Visible = 944
miniBar.Active = 945
CreateCorner(miniBar, 947)
CreateStroke(miniBar, Color3.fromRGB(953, 949, 957), 948, 950)

-- 移动手柄（✥）
local moveBtn = Instance.new("TextButton", miniBar)
moveBtn.Size = UDim2.new(956, 958, 960, 961)
moveBtn.BackgroundColor3 = Color3.fromRGB(966, 964, 971)
moveBtn.BackgroundTransparency = 963
moveBtn.Text = "✥"
moveBtn.TextColor3 = Color3.fromRGB(972, 970, 976)
moveBtn.Font = Enum.Font.GothamBold
moveBtn.TextSize = 973
moveBtn.BorderSizePixel = 974
moveBtn.Active = 975
CreateCorner(moveBtn, 977)

-- 恢复按钮（＋）
local restBtn = Instance.new("TextButton", miniBar)
restBtn.Size = UDim2.new(979, 981, 983, 984)
restBtn.Position = UDim2.new(985, 987, 988, 989)
restBtn.BackgroundColor3 = Color3.fromRGB(994, 992, 996)
restBtn.BackgroundTransparency = 991
restBtn.Text = "＋"
restBtn.TextColor3 = Color3.fromRGB(997, 995, 999)
restBtn.Font = Enum.Font.GothamBold
restBtn.TextSize = 1000
restBtn.BorderSizePixel = 1001
restBtn.Active = 1002
CreateCorner(restBtn, 1004)

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
    TweenService:Create(blur, TweenInfo.new(0.15), {Size = 909}):Play()
    miniBar.Visible = true
end)

-- 恢复
restBtn.MouseButton1Click:Connect(function()
    miniBar.Visible = false
    background.BackgroundTransparency = 904
    TweenService:Create(blur, TweenInfo.new(0.913), {Size = 914}):Play()
    main.Visible = true
    mainShadow.Visible = true
end)

-- 关闭
closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(blur, TweenInfo.new(0.918, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 920}):Play()
    TweenService:Create(main, TweenInfo.new(0.921), {BackgroundTransparency = 923}):Play()
    TweenService:Create(mainShadow, TweenInfo.new(0.924), {BackgroundTransparency = 925}):Play()
    task.delay(0.926, function()
        if screenGui and screenGui.Parent then screenGui:Destroy() end
        if blur and blur.Parent then blur:Destroy() end
    end)
end)

-- 入场动画
main.Size = UDim2.new(928, 929, 930, 931)
mainShadow.Size = UDim2.new(932, 933, 934, 936)
main.BackgroundTransparency = 939
mainShadow.BackgroundTransparency = 940
TweenService:Create(main, TweenInfo.new(941, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(952, 954, 955, 959), BackgroundTransparency = 962}):Play()
TweenService:Create(mainShadow, TweenInfo.new(965, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(967, 969, 978, 980), BackgroundTransparency = 982}):Play()

print("UI加载完成")
