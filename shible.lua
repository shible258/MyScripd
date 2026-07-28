--==========================================
-- shible.lua — 启动保护 + 功能脚本加载器
-- 取消启动 / 加载其他脚本(弹窗输入URL) / 继续启动(按PlaceId自动加载)
--==========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

if not PlayerGui then return end

getgenv()._SHIBLE_RUNNING = getgenv()._SHIBLE_RUNNING or false
if getgenv()._SHIBLE_RUNNING then return end
getgenv()._SHIBLE_RUNNING = true

-- ========== 内置脚本映射表（按 PlaceId）==========
local SCRIPT_MAP = {
    [189707] = "https://raw.githubusercontent.com/shible258/MyScripd/main/nds.lua",
    -- [其他游戏ID] = "https://raw.githubusercontent.com/xxx/xxx.lua",
}

-- ========== 模糊背景 ==========
local blur = Instance.new("BlurEffect")
blur.Name = "ShibleBlur"
blur.Size = 0
blur.Parent = Lighting

TweenService:Create(
    blur,
    TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    { Size = 18 }
):Play()

-- ========== 工具函数 ==========
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

-- ========== 通用清理 ==========
local function Cleanup()
    TweenService:Create(blur,
        TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = 0 }
    ):Play()
    TweenService:Create(main,
        TweenInfo.new(0.2), { BackgroundTransparency = 1 }
    ):Play()
    TweenService:Create(shadow,
        TweenInfo.new(0.2), { BackgroundTransparency = 1 }
    ):Play()

    task.delay(0.25, function()
        SafeDestroy(screenGui)
        SafeDestroy(blur)
        getgenv()._SHIBLE_RUNNING = false
    end)
end

-- ========== 加载脚本 ==========
local function LoadScript(url)
    if not url or url == "" then
        warn("[Shible] 脚本 URL 为空")
        return
    end

    local ok, err = pcall(function()
        local src = game:HttpGet(url)
        if src and src ~= "" then
            local func = loadstring(src)
            if func then
                func()
            else
                error("脚本编译失败")
            end
        else
            error("HttpGet 返回为空")
        end
    end)

    if not ok then
        warn("[Shible] 脚本加载失败:", err)
    end
end

-- ========== ScreenGui ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ShibleUI"
screenGui.Parent = PlayerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999

local background = Instance.new("Frame")
background.Parent = screenGui
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
background.BackgroundTransparency = 0.45
background.BorderSizePixel = 0

local shadow = Instance.new("Frame")
shadow.Parent = background
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.fromScale(0.5, 0.5)
shadow.Size = UDim2.new(0.88, 18, 0, 330)
shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shadow.BackgroundTransparency = 0.72
shadow.BorderSizePixel = 0
CreateCorner(shadow, 32)
CreateStroke(shadow, Color3.fromRGB(255, 255, 255), 5, 0.32)

local shadowLimit = Instance.new("UISizeConstraint")
shadowLimit.MaxSize = Vector2.new(520, 355)
shadowLimit.MinSize = Vector2.new(320, 300)
shadowLimit.Parent = shadow

local main = Instance.new("Frame")
main.Parent = background
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.new(0.88, 0, 0, 308)
main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
CreateCorner(main, 26)
CreateStroke(main, Color3.fromRGB(255, 255, 255), 2, 0.08)

local mainLimit = Instance.new("UISizeConstraint")
mainLimit.MaxSize = Vector2.new(490, 335)
mainLimit.MinSize = Vector2.new(305, 290)
mainLimit.Parent = main

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(236, 240, 248)),
})
grad.Rotation = 90
grad.Parent = main

local hl = Instance.new("Frame")
hl.Parent = main
hl.Position = UDim2.new(0, 22, 0, 11)
hl.Size = UDim2.new(1, -44, 0, 2)
hl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
hl.BackgroundTransparency = 0.06
hl.BorderSizePixel = 0
CreateCorner(hl, 999)

-- ========== 颜色 ==========
local red   = Color3.fromRGB(220, 38, 38)
local blue  = Color3.fromRGB(37, 99, 235)
local black = Color3.fromRGB(18, 18, 22)
local gray  = Color3.fromRGB(90, 90, 98)

-- ========== 文字 ==========
CreateText(main, "SmallTitle", "启动保护",
    UDim2.new(0, 28, 0, 22), UDim2.new(1, -56, 0, 24),
    gray, 13, Enum.Font.GothamMedium)

CreateText(main, "IdText", "检测到你的游戏ID为 " .. tostring(game.PlaceId),
    UDim2.new(0, 28, 0, 55), UDim2.new(1, -56, 0, 42),
    red, 19, Enum.Font.GothamBold)

CreateText(main, "PauseText", "脚本已暂停启动，请你选择是否继续",
    UDim2.new(0, 28, 0, 105), UDim2.new(1, -56, 0, 40),
    black, 17, Enum.Font.GothamMedium)

CreateText(main, "DangerText", "如果你选择继续使用夜脚本可能会出现问题请谨慎选择",
    UDim2.new(0, 28, 0, 153), UDim2.new(1, -56, 0, 58),
    red, 16, Enum.Font.GothamBold)

CreateText(main, "MatchedText", "当前匹配：" .. tostring(game.PlaceId),
    UDim2.new(0, 28, 0, 212), UDim2.new(1, -56, 0, 22),
    gray, 12, Enum.Font.Gotham)

-- ========== 按钮 ==========
local cancelBtn = CreateButton(main, "CancelButton", "取消启动",
    UDim2.new(0, 28, 1, -60), UDim2.new(1/3, -14, 0, 42),
    Color3.fromRGB(245, 245, 247), black)
CreateStroke(cancelBtn, Color3.fromRGB(210, 210, 218), 1.5, 0.15)

local otherBtn = CreateButton(main, "OtherScriptButton", "加载其他脚本",
    UDim2.new(1/3, 7, 1, -60), UDim2.new(1/3, -14, 0, 42),
    blue, Color3.fromRGB(255, 255, 255))
CreateStroke(otherBtn, Color3.fromRGB(255, 255, 255), 1.5, 0.35)

local continueBtn = CreateButton(main, "ContinueButton", "继续启动",
    UDim2.new(2/3, 0, 1, -60), UDim2.new(1/3, -14, 0, 42),
    red, Color3.fromRGB(255, 255, 255))
CreateStroke(continueBtn, Color3.fromRGB(255, 255, 255), 1.5, 0.35)

-- ========== 入场动画 ==========
main.Size = UDim2.new(0.88, 0, 0, 280)
shadow.Size = UDim2.new(0.88, 18, 0, 302)
main.BackgroundTransparency = 1
shadow.BackgroundTransparency = 1

TweenService:Create(main,
    TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    { Size = UDim2.new(0.88, 0, 0, 308), BackgroundTransparency = 0.1 }
):Play()

TweenService:Create(shadow,
    TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    { Size = UDim2.new(0.88, 18, 0, 330), BackgroundTransparency = 0.72 }
):Play()

-- ========== 按钮逻辑 ==========

-- 取消
cancelBtn.MouseButton1Click:Connect(function()
    Cleanup()
end)

-- 继续启动（按 PlaceId 自动匹配）
continueBtn.MouseButton1Click:Connect(function()
    local url = SCRIPT_MAP[game.PlaceId]
    if url then
        LoadScript(url)
    else
        warn("[Shible] 当前游戏 PlaceId " .. tostring(game.PlaceId) .. " 未配置功能脚本")
    end
    Cleanup()
end)

-- 加载其他脚本（弹输入框）
otherBtn.MouseButton1Click:Connect(function()
    Cleanup()
    task.delay(0.3, function()
        local inputGui = Instance.new("ScreenGui")
        inputGui.Name = "ShibleInputUI"
        inputGui.Parent = PlayerGui
        inputGui.ResetOnSpawn = false
        inputGui.IgnoreGuiInset = true
        inputGui.DisplayOrder = 999999

        local inputBg = Instance.new("Frame")
        inputBg.Parent = inputGui
        inputBg.AnchorPoint = Vector2.new(0.5, 0.5)
        inputBg.Position = UDim2.fromScale(0.5, 0.5)
        inputBg.Size = UDim2.new(0, 420, 0, 180)
        inputBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        inputBg.BackgroundTransparency = 0.08
        inputBg.BorderSizePixel = 0
        CreateCorner(inputBg, 20)
        CreateStroke(inputBg, Color3.fromRGB(255, 255, 255), 2, 0.08)

        local ig = Instance.new("UIGradient")
        ig.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(236, 240, 248)),
        })
        ig.Rotation = 90
        ig.Parent = inputBg

        local title = Instance.new("TextLabel")
        title.Parent = inputBg
        title.Position = UDim2.new(0, 20, 0, 14)
        title.Size = UDim2.new(1, -40, 0, 24)
        title.BackgroundTransparency = 1
        title.Text = "输入功能脚本 URL"
        title.TextColor3 = red
        title.TextSize = 16
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left

        local inputBox = Instance.new("TextBox")
        inputBox.Parent = inputBg
        inputBox.Position = UDim2.new(0, 20, 0, 55)
        inputBox.Size = UDim2.new(1, -40, 0, 36)
        inputBox.BackgroundColor3 = Color3.fromRGB(245, 245, 247)
        inputBox.BackgroundTransparency = 0.02
        inputBox.BorderSizePixel = 0
        inputBox.Text = ""
        inputBox.PlaceholderText = "粘贴 .lua 直链..."
        inputBox.PlaceholderColor3 = gray
        inputBox.TextColor3 = black
        inputBox.TextSize = 13
        inputBox.Font = Enum.Font.Gotham
        inputBox.ClearTextOnFocus = true
        inputBox.TextXAlignment = Enum.TextXAlignment.Left
        CreateCorner(inputBox, 10)
        CreateStroke(inputBox, Color3.fromRGB(210, 210, 218), 1.2, 0.1)

        local confirmBtn = CreateButton(inputBg, "ConfirmBtn", "确认加载",
            UDim2.new(0, 20, 1, -50), UDim2.new(0.48, 0, 0, 38),
            blue, Color3.fromRGB(255, 255, 255))
        CreateStroke(confirmBtn, Color3.fromRGB(255, 255, 255), 1.3, 0.3)

        local cancelInputBtn = CreateButton(inputBg, "CancelInputBtn", "取消",
            UDim2.new(0.52, 8, 1, -50), UDim2.new(0.48, -28, 0, 38),
            Color3.fromRGB(245, 245, 247), black)
        CreateStroke(cancelInputBtn, Color3.fromRGB(210, 210, 218), 1.3, 0.15)

        confirmBtn.MouseButton1Click:Connect(function()
            LoadScript(inputBox.Text)
            SafeDestroy(inputGui)
        end)

        cancelInputBtn.MouseButton1Click:Connect(function()
            SafeDestroy(inputGui)
        end)
    end)
end)

print("[Shible] 启动保护弹窗已加载")
