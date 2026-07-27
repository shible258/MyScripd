--==========================================
-- 可缩小弹窗（轻量版，Delta 友好）
--==========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
local pg = lp:WaitForChild("PlayerGui", 10)
if not pg then return end

-- 防重复
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

-- 遮罩
local bg = Instance.new("Frame", sg)
bg.Size = UDim2.fromScale(1, 1)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BackgroundTransparency = 0.45
bg.BorderSizePixel = 0

-- 主窗口
local main = Instance.new("Frame", bg)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.new(0, 320, 0, 300)
main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
main.BackgroundTransparency = 0.08
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local mc = Instance.new("UICorner", main)
mc.CornerRadius = UDim.new(0, 22)

local ms = Instance.new("UIStroke", main)
ms.Color = Color3.fromRGB(255, 255, 255)
ms.Thickness = 2
ms.Transparency = 0.1

-- 标题栏
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
titleBar.BackgroundTransparency = 0.08
titleBar.BorderSizePixel = 0
titleBar.Active = true
titleBar.Draggable = true
local tc = Instance.new("UICorner", titleBar)
tc.CornerRadius = UDim.new(0, 22)
local tf = Instance.new("Frame", titleBar)
tf.Size = UDim2.new(1, 0, 0, 18)
tf.Position = UDim2.new(0, 0, 0.5, 0)
tf.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
tf.BackgroundTransparency = 0.08
tf.BorderSizePixel = 0

-- 标题文字
local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "我的脚本"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left

-- 缩小按钮（－）
local minBtn = Instance.new("TextButton", titleBar)
minBtn.Size = UDim2.new(0, 34, 0, 34)
minBtn.Position = UDim2.new(1, -70, 0, 1)
minBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
minBtn.BackgroundTransparency = 0.1
minBtn.Text = "－"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.BorderSizePixel = 0
local minc = Instance.new("UICorner", minBtn)
minc.CornerRadius = UDim.new(0, 10)

-- 关闭按钮（✕）
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 34, 0, 34)
closeBtn.Position = UDim2.new(1, -36, 0, 1)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
closeBtn.BackgroundTransparency = 0.1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
local clc = Instance.new("UICorner", closeBtn)
clc.CornerRadius = UDim.new(0, 10)

-- 功能按钮（演示用）
local function MakeDemoBtn(text, y, color, cb)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.875, 0, 0, 42)
    btn.Position = UDim2.new(0.0625, 0, 0, y)
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.08
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.BorderSizePixel = 0
    local bc = Instance.new("UICorner", btn)
    bc.CornerRadius = UDim.new(0, 14)
    local bs = Instance.new("UIStroke", btn)
    bs.Color = Color3.fromRGB(255, 255, 255)
    bs.Thickness = 1.5
    bs.Transparency = 0.4
    btn.MouseButton1Click:Connect(cb)
    return btn
end

MakeDemoBtn("加速", 55, Color3.fromRGB(220, 38, 38), function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = 60
    end
end)

MakeDemoBtn("跳高", 110, Color3.fromRGB(37, 99, 235), function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.JumpPower = 100
    end
end)

MakeDemoBtn("重置", 165, Color3.fromRGB(100, 100, 110), function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = 16
        lp.Character.Humanoid.JumpPower = 50
    end
end)

-- 缩小后的长方形图标（屏幕正上方）
local miniBar = Instance.new("Frame", sg)
miniBar.AnchorPoint = Vector2.new(0.5, 0)
miniBar.Position = UDim2.new(0.5, 0, 0, 15)
miniBar.Size = UDim2.new(0, 180, 0, 34)
miniBar.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
miniBar.BackgroundTransparency = 0.08
miniBar.BorderSizePixel = 0
miniBar.Visible = false
miniBar.Active = true
local mbCorner = Instance.new("UICorner", miniBar)
mbCorner.CornerRadius = UDim.new(0, 14)
local mbStroke = Instance.new("UIStroke", miniBar)
mbStroke.Color = Color3.fromRGB(255, 255, 255)
mbStroke.Thickness = 1.5
mbStroke.Transparency = 0.3

-- 移动手柄（✥）
local moveBtn = Instance.new("TextButton", miniBar)
moveBtn.Size = UDim2.new(0, 34, 0, 34)
moveBtn.BackgroundColor3 = Color3.fromRGB(120, 70, 220)
moveBtn.BackgroundTransparency = 0.1
moveBtn.Text = "✥"
moveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
moveBtn.Font = Enum.Font.GothamBold
moveBtn.TextSize = 16
moveBtn.BorderSizePixel = 0
moveBtn.Active = true
local mbc = Instance.new("UICorner", moveBtn)
mbc.CornerRadius = UDim.new(0, 12)

-- 恢复按钮（＋）
local restBtn = Instance.new("TextButton", miniBar)
restBtn.Size = UDim2.new(0, 34, 0, 34)
restBtn.Position = UDim2.new(1, -34, 0, 0)
restBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
restBtn.BackgroundTransparency = 0.1
restBtn.Text = "＋"
restBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
restBtn.Font = Enum.Font.GothamBold
restBtn.TextSize = 18
restBtn.BorderSizePixel = 0
restBtn.Active = true
local rbc = Instance.new("UICorner", restBtn)
rbc.CornerRadius = UDim.new(0, 12)

-- 拖动 miniBar（通过 moveBtn）
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
    bg.BackgroundTransparency = 0.45
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
main.Size = UDim2.new(0, 318, 0, 288)
TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 322, 0, 301)}):Play()

print("[UI] 加载完成")

