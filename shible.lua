--==========================================
-- 最终版：彩色玻璃拟态 + 拖动 + 缩放 + 多功能
--==========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")

-- 防重复注入
getgenv()._HUB_RUNNING = getgenv()._HUB_RUNNING or false
if getgenv()._HUB_RUNNING then return end
getgenv()._HUB_RUNNING = true

-- 等待角色
local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
local pg = lp:WaitForChild("PlayerGui", 15)
if not pg then warn("[Hub] PlayerGui 获取失败") return end

local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid", 10)
if not hum then warn("[Hub] Humanoid 获取失败") return end

-- 模糊背景
local blur = Instance.new("BlurEffect")
blur.Name = "HubBlur"
blur.Size = 0
blur.Parent = Lighting
TweenService:Create(blur, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 14}):Play()

--================ 工具函数 ================
local function SafeDestroy(inst)
    if inst and inst.Parent then inst:Destroy() end
end

local function MakeCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function MakeStroke(parent, color, thick, transp)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thick
    s.Transparency = transp or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function MakeText(parent, name, text, pos, size, color, fontSize, font)
    local t = Instance.new("TextLabel")
    t.Name = name
    t.Parent = parent
    t.Position = pos
    t.Size = size
    t.BackgroundTransparency = 1
    t.BorderSizePixel = 0
    t.Text = text
    t.TextColor3 = color
    t.TextSize = fontSize
    t.Font = font
    t.TextWrapped = true
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextYAlignment = Enum.TextYAlignment.Center
    return t
end

--================ ScreenGui ================
local sg = Instance.new("ScreenGui")
sg.Name = "GlassHubUI"
sg.Parent = pg
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.DisplayOrder = 999999
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 半透明遮罩
local bg = Instance.new("Frame")
bg.Parent = sg
bg.Size = UDim2.fromScale(1, 1)
bg.Position = UDim2.fromScale(0, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BackgroundTransparency = 0.5
bg.BorderSizePixel = 0
bg.Active = true

--================ 主窗口 ================
local main = Instance.new("Frame")
main.Parent = bg
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.new(0, 340, 0, 460)
main.BackgroundColor3 = Color3.fromRGB(25, 15, 50)
main.BackgroundTransparency = 0.05
main.BorderSizePixel = 0
main.Active = true

MakeCorner(main, 20)
local mainStroke = MakeStroke(main, Color3.fromRGB(160, 100, 255), 2, 0.15)

-- 紫蓝渐变
local mainGrad = Instance.new("UIGradient")
mainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 20, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 15, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 10, 35)),
})
mainGrad.Rotation = 135
mainGrad.Parent = main

--================ 标题栏（拖动区） ================
local titleBar = Instance.new("Frame")
titleBar.Parent = main
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
titleBar.BackgroundTransparency = 0.08
titleBar.BorderSizePixel = 0
titleBar.Active = true

local titleCorner = MakeCorner(titleBar, 20)

-- 盖住下半圆角
local titleFix = Instance.new("Frame")
titleFix.Parent = titleBar
titleFix.Size = UDim2.new(1, 0, 0, 20)
titleFix.Position = UDim2.new(0, 0, 0.5, 0)
titleFix.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
titleFix.BackgroundTransparency = 0.08
titleFix.BorderSizePixel = 0

-- 标题文字
local titleText = Instance.new("TextLabel")
titleText.Parent = titleBar
titleText.Size = UDim2.new(1, -80, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "✦ 全能Hub ✦"
titleText.TextColor3 = Color3.fromRGB(230, 210, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 17
titleText.TextXAlignment = Enum.TextXAlignment.Left

-- 关闭按钮（标题栏右上角）
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.Size = UDim2.new(0, 34, 0, 34)
closeBtn.Position = UDim2.new(1, -36, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
closeBtn.BackgroundTransparency = 0.1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
MakeCorner(closeBtn, 10)

--================ 拖动逻辑 ================
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

--================ 缩放手柄 ================
local resizeHandle = Instance.new("TextButton")
resizeHandle.Parent = main
resizeHandle.Size = UDim2.new(0, 22, 0, 22)
resizeHandle.Position = UDim2.new(1, -24, 1, -24)
resizeHandle.BackgroundColor3 = Color3.fromRGB(160, 100, 255)
resizeHandle.BackgroundTransparency = 0.2
resizeHandle.Text = "⤡"
resizeHandle.TextColor3 = Color3.fromRGB(255, 255, 255)
resizeHandle.Font = Enum.Font.GothamBold
resizeHandle.TextSize = 12
resizeHandle.BorderSizePixel = 0
resizeHandle.Active = true
MakeCorner(resizeHandle, 6)

local resizing, resizeStart, origSize
resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStart = input.Position
        origSize = main.Size
    end
end)
resizeHandle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - resizeStart
        local newW = math.clamp(origSize.X.Offset + delta.X, 300, 650)
        local newH = math.clamp(origSize.Y.Offset + delta.Y, 370, 780)
        main.Size = UDim2.new(0, newW, 0, newH)
        for _, child in ipairs(main:GetChildren()) do
            if child:IsA("TextButton") and child ~= resizeHandle and child ~= closeBtn then
                local idx = child.LayoutOrder
                if idx > 0 then
                    child.Position = UDim2.new(0.04, 0, 0, 48 + (idx - 1) * 50)
                    child.Size = UDim2.new(0.915, 0, 0, 44)
                end
            end
        end
    end
end)

--================ 按钮工厂 ================
local btnCount = 0
local function MakeBtn(text, color, callback)
    btnCount = btnCount + 1
    local btn = Instance.new("TextButton")
    btn.Parent = main
    btn.LayoutOrder = btnCount
    btn.Size = UDim2.new(0.905, 0, 0, 44)
    btn.Position = UDim2.new(0.045, 0, 0, 48 + (btnCount - 1) * 50)
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.09
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.AutoButtonColor = true
    MakeCorner(btn, 12)
    MakeStroke(btn, Color3.fromRGB(255, 255, 255), 1.5, 0.375)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 0.085}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        local ok, err = pcall(callback)
        if not ok then warn("[Hub] 功能错误:", err) end
    end)

    return btn
end

--================ 功能区 ================

-- 飞行
local flying = false
local flyBV
MakeBtn("🚀 飞行: 关", Color3.fromRGB(37, 99, 235), function()
    flying = not flying
    local btn = main:FindFirstChild("FlyBtn")
    if flying then
        if btn then btn.Text = "🚀 飞行: 开" end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            flyBV.Velocity = Vector3.new(0, 0, 0)
            flyBV.Parent = hrp
            spawn(function()
                while flying and flyBV and flyBV.Parent do
                    local dir = Vector3.new(0, 0, 0)
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 50, 0) end
                    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir + Vector3.new(0, -50, 0) end
                    if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + workspace.CurrentCamera.CFrame.LookVector * 50 end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - workspace.CurrentCamera.CFrame.LookVector * 50 end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - workspace.CurrentCamera.CFrame.RightVector * 50 end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + workspace.CurrentCamera.CFrame.RightVector * 50 end
                    flyBV.Velocity = dir
                    task.wait(0.035)
                end
            end)
        end
    else
        if btn then btn.Text = "🚀 飞行: 关" end
        if flyBV then flyBV:Destroy() end
    end
end).Name = "FlyBtn"

-- 加速
MakeBtn("⚡ 加速 (60)", Color3.fromRGB(22, 163, 74), function()
    hum.WalkSpeed = 60
end)

-- 跳高
MakeBtn("🦘 跳高 (120)", Color3.fromRGB(217, 119, 6), function()
    hum.JumpPower = 120
end)

-- 夜视
MakeBtn("🌙 夜视", Color3.fromRGB(15, 23, 42), function()
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 2
end)

-- 穿墙
MakeBtn("👻 穿墙", Color3.fromRGB(120, 40, 200), function()
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end)

-- 瞬移到鼠标
MakeBtn("📍 瞬移(鼠标)", Color3.fromRGB(6, 148, 162), function()
    local mouse = lp:GetMouse()
    if mouse and mouse.Hit then
        char:SetPrimaryPartCFrame(CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0)))
    end
end)

-- 无冷却
MakeBtn("💨 无冷却", Color3.fromRGB(190, 18, 90), function()
    hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
    hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
    hum.AutoRotate = true
end)

-- 清除所有效果
MakeBtn("🧹 清除效果", Color3.fromRGB(75, 85, 99), function()
    hum.WalkSpeed = 16
    hum.JumpPower = 50
    if flyBV then flyBV:Destroy() flyBV = nil end
    flying = false
    local flyBtn = main:FindFirstChild("FlyBtn")
    if flyBtn then flyBtn.Text = "🚀 飞行: 关" end
    Lighting.Ambient = Color3.fromRGB(128, 128, 128)
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    Lighting.Brightness = 1
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end)

-- 关闭脚本
MakeBtn("🗑 关闭脚本", Color3.fromRGB(220, 38, 38), function()
    getgenv()._HUB_RUNNING = false
    TweenService:Create(blur, TweenInfo.new(0.2), {Size = 0}):Play()
    TweenService:Create(main, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    task.delay(0.25, function()
        SafeDestroy(sg)
        SafeDestroy(blur)
    end)
end)

--================ 标题栏关闭按钮 ================
closeBtn.MouseButton1Click:Connect(function()
    getgenv()._HUB_RUNNING = false
    TweenService:Create(blur, TweenInfo.new(0.2), {Size = 0}):Play()
    TweenService:Create(main, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    task.delay(0.25, function()
        SafeDestroy(sg)
        SafeDestroy(blur)
    end)
end)

--================ 入场动画 ================
main.Size = UDim2.new(0, 338, 0, 448)
TweenService:Create(main, TweenInfo.new(0.365, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 342, 0, 462)}):Play()

print("[Hub] 加载完成 - 共 " .. btnCount .. " 个功能")
