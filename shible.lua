--==========================================
-- 可缩小弹窗（白色原版风格）
--==========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
local pg = lp:WaitForChild("PlayerGui", 10)
if not pg then return end

getgenv()._MYUI_RUNNING = getgenv()._MYUI_RUNNING or false
if getgenv()._MYUI_RUNNING then return end
getgenv()._MYUI_RUNNING = true

-- ScreenGui
local sg = Instance.new("ScreenGui")
sg.Name = "MyScriptUI"
sg.Parent = pg
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.DisplayOrder = 999999

-- 半透明白色遮罩
local bg = Instance.new("Frame", sg)
bg.Size = UDim2.fromScale(1, 1)
bg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bg.BackgroundTransparency = 0.65
bg.BorderSizePixel = 0

-- 主窗口（白色卡片）
local main = Instance.new("Frame", bg)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.new(0, 350, 0, 370)
main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
main.BackgroundTransparency = 0.92
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local mc = Instance.new("UICorner", main)
mc.CornerRadius = UDim.new(0, 28)

local ms = Instance.new("UIStroke", main)
ms.Color = Color3.fromRGB(140, 130, 190)
ms.Thickness = 1.5
ms.Transparency = 0.75

-- 白色渐变背景
local grad = Instance.new("UIGradient", main)
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(252, 251, 254)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(242, 239, 249)),
})
grad.Rotation = 95

-- 顶部高光线
local hl = Instance.new("Frame", main)
hl.Size = UDim2.new(1, -48, 0, 2)
hl.Position = UDim2.new(0, 24, 0, 14)
hl.BackgroundColor3 = Color3.fromRGB(215, 195, 243)
hl.BackgroundTransparency = 0.85
hl.BorderSizePixel = 0
local hlc = Instance.new("UICorner", hl)
hlc.CornerRadius = UDim.new(0, 999)

-- 左侧发光条
local lg = Instance.new("Frame", main)
lg.Size = UDim2.new(0, 2, 1, -62)
lg.Position = UDim2.new(0, 9, 0, 31)
lg.BackgroundColor3 = Color3.fromRGB(155, 115, 225)
lg.BackgroundTransparency = 0.82
lg.BorderSizePixel = 0
local lgc = Instance.new("UICorner", lg)
lgc.CornerRadius = UDim.new(0, 999)

-- 标题栏（拖动区）
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 46)
titleBar.BackgroundColor3 = Color3.fromRGB(125, 185, 232)
titleBar.BackgroundTransparency = 0.97
titleBar.BorderSizePixel = 0
titleBar.Active = true
titleBar.Draggable = true
local tbc = Instance.new("UICorner", titleBar)
tbc.CornerRadius = UDim.new(0, 28)
local tbf = Instance.new("Frame", titleBar)
tbf.Size = UDim2.new(1, 0, 0, 23)
tbf.Position = UDim2.new(0, 0, 0.52, 0)
tbf.BackgroundColor3 = Color3.fromRGB(61, 41, 93)
tbf.BackgroundTransparency = 0.96
tbf.BorderSizePixel = 0

-- 标题文字
local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 18, 0, 0)
title.BackgroundTransparency = 1
title.Text = "我的脚本"
title.TextColor3 = Color3.fromRGB(49, 33, 79)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

-- 缩小按钮（－）
local minBtn = Instance.new("TextButton", titleBar)
minBtn.Size = UDim2.new(0, 36, 0, 36)
minBtn.Position = UDim2.new(1, -78, 0, 5)
minBtn.BackgroundColor3 = Color3.fromRGB(201, 187, 222)
minBtn.BackgroundTransparency = 0.86
minBtn.Text = "－"
minBtn.TextColor3 = Color3.fromRGB(66, 47, 106)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.BorderSizePixel = 0
local minc = Instance.new("UICorner", minBtn)
minc.CornerRadius = UDim.new(0, 12)

-- 关闭按钮（✕）
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -39, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(238, 196, 198)
closeBtn.BackgroundTransparency = 0.84
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(179, 51, 53)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BorderSizePixel = 0
local clc = Instance.new("UICorner", closeBtn)
clc.CornerRadius = UDim.new(0, 12)

-- 副标题
local sub = Instance.new("TextLabel", main)
sub.Size = UDim2.new(1, -64, 0, 22)
sub.Position = UDim2.new(0, 27, 0, 52)
sub.BackgroundTransparency = 1
sub.Text = "启动保护"
sub.TextColor3 = Color3.fromRGB(131, 117, 152)
sub.Font = Enum.Font.GothamMedium
sub.TextSize = 13
sub.TextXAlignment = Enum.TextXAlignment.Left

-- 主标题
local mainTitle = Instance.new("TextLabel", main)
mainTitle.Size = UDim2.new(1, -54, 0, 44)
mainTitle.Position = UDim2.new(0, 29, 0, 76)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "欢迎使用"
mainTitle.TextColor3 = Color3.fromRGB(209, 62, 63)
mainTitle.Font = Enum.Font.GothamBold
mainTitle.TextSize = 21
mainTitle.TextXAlignment = Enum.TextXAlignment.Left

-- 描述
local desc = Instance.new("TextLabel", main)
desc.Size = UDim2.new(1, -57, 0, 40)
desc.Position = UDim2.new(0, 29, 0, 123)
desc.BackgroundTransparency = 1
desc.Text = "点击下方按钮开启功能"
desc.TextColor3 = Color3.fromRGB(29, 24, 36)
desc.Font = Enum.Font.GothamMedium
desc.TextSize = 17
desc.TextXAlignment = Enum.TextXAlignment.Left

-- 功能按钮
local function MakeBtn(text, y, color, cb)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.87, 0, 0, 43)
    btn.Position = UDim2.new(0.065, 0, 0, y)
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.94
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(241, 240, 246)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.BorderSizePixel = 0
    local bc = Instance.new("UICorner", btn)
    bc.CornerRadius = UDim.new(0, 16)
    local bs = Instance.new("UIStroke", btn)
    bs.Color = Color3.fromRGB(233, 228, 244)
    bs.Thickness = 1.5
    bs.Transparency = 0.74
    btn.MouseButton1Click:Connect(cb)
    return btn
end

MakeBtn("加速", 178, Color3.fromRGB(221, 53, 54), function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = 60
    end
end)

MakeBtn("跳高", 231, Color3.fromRGB(48, 102, 234), function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.JumpPower = 100
    end
end)

MakeBtn("重置", 284, Color3.fromRGB(122, 113, 138), function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = 16
        lp.Character.Humanoid.JumpPower = 50
    end
end)

-- 缩小后的长方形图标（屏幕正上方）
local miniBar = Instance.new("Frame", sg)
miniBar.AnchorPoint = Vector2.new(0.5, 0)
miniBar.Position = UDim2.new(0.5, 0, 0, 15)
miniBar.Size = UDim2.new(0, 188, 0, 38)
miniBar.BackgroundColor3 = Color3.fromRGB(253, 251, 256)
miniBar.BackgroundTransparency = 0.89
miniBar.BorderSizePixel = 0
miniBar.Visible = false
miniBar.Active = true
local mbc = Instance.new("UICorner", miniBar)
mbc.CornerRadius = UDim.new(0, 16)
local mbs = Instance.new("UIStroke", miniBar)
mbs.Color = Color3.fromRGB(162, 134, 204)
mbs.Thickness = 1.5
mbs.Transparency = 0.72

-- 移动手柄（✥）
local moveBtn = Instance.new("TextButton", miniBar)
moveBtn.Size = UDim2.new(0, 38, 0, 38)
moveBtn.BackgroundColor3 = Color3.fromRGB(167, 139, 214)
moveBtn.BackgroundTransparency = 0.83
moveBtn.Text = "✥"
moveBtn.TextColor3 = Color3.fromRGB(73, 52, 109)
moveBtn.Font = Enum.Font.GothamBold
moveBtn.TextSize = 18
moveBtn.BorderSizePixel = 0
moveBtn.Active = true
local mbc2 = Instance.new("UICorner", moveBtn)
mbc2.CornerRadius = UDim.new(0, 14)

-- 恢复按钮（＋）
local restBtn = Instance.new("TextButton", miniBar)
restBtn.Size = UDim2.new(0, 38, 0, 38)
restBtn.Position = UDim2.new(1, -38, 0, 0)
restBtn.BackgroundColor3 = Color3.fromRGB(186, 172, 208)
restBtn.BackgroundTransparency = 0.85
restBtn.Text = "＋"
restBtn.TextColor3 = Color3.fromRGB(71, 53, 103)
restBtn.Font = Enum.Font.GothamBold
restBtn.TextSize = 20
restBtn.BorderSizePixel = 0
restBtn.Active = true
local rbc = Instance.new("UICorner", restBtn)
rbc.CornerRadius = UDim.new(0, 14)

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
    bg.BackgroundTransparency = 1
    miniBar.Visible = true
end)

-- 恢复
restBtn.MouseButton1Click:Connect(function()
    miniBar.Visible = false
    bg.BackgroundTransparency = 0.65
    main.Visible = true
end)

-- 关闭
closeBtn.MouseButton1Click:Connect(function()
    getgenv()._MYUI_RUNNING = false
    TweenService:Create(main, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
    task.delay(0.2, function()
        if sg and sg.Parent then sg:Destroy() end
    end)
end)

-- 入场动画
main.Size = UDim2.new(0, 348, 0, 356)
TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 352, 0, 372)}):Play()

print("[UI] 加载完成")
