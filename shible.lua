-- shible.lua（可直接 loadstring 执行版）

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

if not PlayerGui then return end

-- 防重复执行
getgenv()._SHIBLE_RUNNING = getgenv()._SHIBLE_RUNNING or false
if getgenv()._SHIBLE_RUNNING then return end
getgenv()._SHIBLE_RUNNING = true

-- 模糊背景
local blur = Instance.new("BlurEffect")
blur.Name = "ShibleBlur"
blur.Size = 0
blur.Parent = Lighting

TweenService:Create(
    blur,
    TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    { Size = 18 }
):Play()

-- 工具函数
local function SafeDestroy(inst)
    if inst and inst.Parent then inst:Destroy() end
end

local function CreateCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
end

local function CreateStroke(parent, color, thickness, trans)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness
    s.Transparency = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
end

local function CreateText(parent, name, text, pos, size, color, textSize, font)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Parent = parent
    label.Position = pos
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

local function CreateButton(parent, name, text, pos, size, bg, fg)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = parent
    btn.Position = pos
    btn.Size = size
    btn.BackgroundColor3 = bg
    btn.BackgroundTransparency = 0.06
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    btn.Text = text
    btn.TextColor3 = fg
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.TextWrapped = true
    CreateCorner(btn, 14)
    return btn
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ShibleUI"
screenGui.Parent = PlayerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999

-- 背景
local background = Instance.new("Frame")
background.Parent = screenGui
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Color3.fromRGB(255,255,255)
background.BackgroundTransparency = 0.45

-- 阴影
local shadow = Instance.new("Frame")
shadow.Parent = background
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.fromScale(0.5, 0.5)
shadow.Size = UDim2.new(0.88, 18, 0, 330)
shadow.BackgroundColor3 = Color3.fromRGB(255,255,255)
shadow.BackgroundTransparency = 0.72
CreateCorner(shadow, 32)
CreateStroke(shadow, Color3.fromRGB(255,255,255), 5, 0.32)

-- 主面板
local main = Instance.new("Frame")
main.Parent = background
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.new(0.88, 0, 0, 308)
main.BackgroundColor3 = Color3.fromRGB(255,255,255)
main.BackgroundTransparency = 0.1
CreateCorner(main, 26)
CreateStroke(main, Color3.fromRGB(255,255,255), 2, 0.08)

-- 渐变
local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(236,240,248)),
})
grad.Rotation = 90
grad.Parent = main

-- 高光
local hl = Instance.new("Frame")
hl.Parent = main
hl.Position = UDim2.new(0,22,0,11)
hl.Size = UDim2.new(1,-44,0,2)
hl.BackgroundColor3 = Color3.fromRGB(255,255,255)
hl.BackgroundTransparency = 0.06
CreateCorner(hl, 999)

-- 颜色
local red = Color3.fromRGB(220,38,38)
local blue = Color3.fromRGB(37,99,235)
local black = Color3.fromRGB(18,18,22)
local gray = Color3.fromRGB(90,90,98)

-- 文字
CreateText(main, "T1", "启动保护",
    UDim2.new(0,28,0,22), UDim2.new(1,-56,0,24),
    gray, 13, Enum.Font.GothamMedium)

CreateText(main, "T2", "检测到你的游戏ID为 "..tostring(game.PlaceId),
    UDim2.new(0,28,0,55), UDim2.new(1,-56,0,42),
    red, 19, Enum.Font.GothamBold)

CreateText(main, "T3", "脚本已暂停启动，请你选择是否继续",
    UDim2.new(0,28,0,105), UDim2.new(1,-56,0,40),
    black, 17, Enum.Font.GothamMedium)

CreateText(main, "T4", "继续使用夜脚本可能会出现问题，请谨慎选择",
    UDim2.new(0,28,0,153), UDim2.new(1,-56,0,58),
    red, 16, Enum.Font.GothamBold)

CreateText(main, "T5", "当前匹配："..tostring(game.PlaceId),
    UDim2.new(0,28,0,212), UDim2.new(1,-56,0,22),
    gray, 12, Enum.Font.Gotham)

-- 按钮
local cancelBtn = CreateButton(main, "Cancel", "取消启动",
    UDim2.new(0,28,1,-60), UDim2.new(1/3,-14,0,42),
    Color3.fromRGB(245,245,247), black)
CreateStroke(cancelBtn, Color3.fromRGB(210,210,218), 1.5, 0.15)

local otherBtn = CreateButton(main, "Other", "加载其他脚本",
    UDim2.new(1/3,7,1,-60), UDim2.new(1/3,-14,0,42),
    blue, Color3.fromRGB(255,255,255))
CreateStroke(otherBtn, Color3.fromRGB(255,255,255), 1.5, 0.35)

local contBtn = CreateButton(main, "Continue", "继续启动",
    UDim2.new(2/3,0,1,-60), UDim2.new(1/3,-14,0,42),
    red, Color3.fromRGB(255,255,255))
CreateStroke(contBtn, Color3.fromRGB(255,255,255), 1.5, 0.35)

-- 动画
main.Size = UDim2.new(0.88,0,0,280)
shadow.Size = UDim2.new(0.88,18,0,302)
main.BackgroundTransparency = 1
shadow.BackgroundTransparency = 1

TweenService:Create(main,
    TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {Size = UDim2.new(0.88,0,0,308), BackgroundTransparency = 0.1}
):Play()

TweenService:Create(shadow,
    TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {Size = UDim2.new(0.88,18,0,330), BackgroundTransparency = 0.72}
):Play()

-- 关闭
local function Cleanup()
    TweenService:Create(blur,
        TweenInfo.new(0.18), {Size = 0}):Play()
    TweenService:Create(main,
        TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    TweenService:Create(shadow,
        TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()

    task.delay(0.25, function()
        SafeDestroy(screenGui)
        SafeDestroy(blur)
        getgenv()._SHIBLE_RUNNING = false
    end)
end

cancelBtn.MouseButton1Click:Connect(Cleanup)
contBtn.MouseButton1Click:Connect(Cleanup)
otherBtn.MouseButton1Click:Connect(Cleanup)

print("[Shible] UI 已加载")
