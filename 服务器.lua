local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")

if not LocalPlayer then
    LocalPlayer = Players.PlayerAdded:Wait()
end

local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
if not PlayerGui then
    PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 15)
end

local function Notify(title, text, duration)
    task.spawn(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 2
        })
    end)
end

local C = {
    Width = 280,
    Height = 280,
    Radius = 22,
    Blur = 24,
    Spring = Enum.EasingStyle.Elastic,
    Duration = 0.55,
    DragSmoothness = 0.25,
    NavHeight = 44,
    BackBtnHeight = 40
}

local Theme = {
    Glass = Color3.fromRGB(30, 30, 32),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(160, 160, 165),
    Accent = Color3.fromRGB(0, 122, 255),
    Danger = Color3.fromRGB(255, 59, 48),
    Grabber = Color3.fromRGB(120, 120, 128)
}

local function corner(f, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = f
end

local function makeTween(target, props, dur, style, dir)
    dur = dur or 0.2
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    local t = TweenService:Create(target, TweenInfo.new(dur, style, dir), props)
    t:Play()
    return t
end

local function springTween(target, props, dur)
    dur = dur or 0.3
    local t = TweenService:Create(target, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function pressEffect(btn, sx, sy)
    sx = sx or 0.96
    sy = sy or 0.9
    local orig = btn.Size
    local pressed = UDim2.new(orig.X.Scale * sx, orig.X.Offset * sx, orig.Y.Scale * sy, orig.Y.Offset * sy)
    btn.AutoButtonColor = false
    btn.MouseButton1Down:Connect(function()
        makeTween(btn, {Size = pressed}, 0.08)
    end)
    btn.MouseButton1Up:Connect(function()
        makeTween(btn, {Size = orig}, 0.1, Enum.EasingStyle.Back)
    end)
    btn.MouseLeave:Connect(function()
        makeTween(btn, {Size = orig}, 0.1)
    end)
end

local function safeCall(fn, ctx)
    local ok, err = pcall(fn)
    if not ok then
        warn("[shible] " .. (ctx or "?") .. " 出错: " .. tostring(err))
    end
end

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting
makeTween(blur, {Size = C.Blur}, 0.4)

local gui = Instance.new("ScreenGui")
gui.Name = "shible"
gui.Parent = PlayerGui
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Enabled = true

local root = Instance.new("Frame")
root.Name = "MainFrame"
root.AnchorPoint = Vector2.new(0.5, 0.5)
root.Position = UDim2.fromScale(0.5, 0.45)
root.Size = UDim2.new(0, C.Width, 0, C.Height)
root.BackgroundColor3 = Theme.Glass
root.BackgroundTransparency = 0.18
root.BorderSizePixel = 0
root.Active = true
root.Visible = true
root.Selectable = false
root.Parent = gui
corner(root, C.Radius)

local grabberArea = Instance.new("Frame")
grabberArea.Size = UDim2.new(1, 0, 0, 36)
grabberArea.BackgroundTransparency = 1
grabberArea.Active = true
grabberArea.Parent = root

local grabber = Instance.new("Frame")
grabber.AnchorPoint = Vector2.new(0.5, 0.5)
grabber.Position = UDim2.new(0.5, 0, 0.5, 0)
grabber.Size = UDim2.new(0, 36, 0, 4)
grabber.BackgroundColor3 = Theme.Grabber
grabber.BackgroundTransparency = 0.3
grabber.BorderSizePixel = 0
grabber.Parent = grabberArea
corner(grabber, 999)

local nav = Instance.new("Frame")
nav.Size = UDim2.new(1, 0, 0, C.NavHeight)
nav.BackgroundTransparency = 1
nav.Parent = root

local title = Instance.new("TextLabel")
title.Text = "shible"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 17
title.TextColor3 = Theme.TextPrimary
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 14, 0, 0)
title.Size = UDim2.new(0.35, 0, 1, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = nav

local minBtn = Instance.new("TextButton")
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.TextColor3 = Theme.TextSecondary
minBtn.BackgroundTransparency = 1
minBtn.Position = UDim2.new(1, -40, 0, 10)
minBtn.Size = UDim2.new(0, 28, 0, 24)
minBtn.AutoButtonColor = false
minBtn.SelectionImageObject = nil
minBtn.Selectable = false
minBtn.Parent = nav

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, 0, 1, -C.NavHeight)
contentContainer.Position = UDim2.new(0, 0, 0, C.NavHeight)
contentContainer.BackgroundTransparency = 1
contentContainer.ClipsDescendants = true
contentContainer.Parent = root

local pageMain = Instance.new("Frame")
pageMain.Size = UDim2.new(1, 0, 1, 0)
pageMain.BackgroundTransparency = 1
pageMain.Visible = true
pageMain.Parent = contentContainer
pageMain.Selectable = false

local introContainer = Instance.new("Frame")
introContainer.BackgroundTransparency = 1
introContainer.Position = UDim2.new(0, 16, 0, 8)
introContainer.Size = UDim2.new(1, -32, 1, -96)
introContainer.ClipsDescendants = false
introContainer.Parent = pageMain

local subtitle = Instance.new("TextLabel")
subtitle.Text = "欢迎使用 shible\n群: 434448780"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 14
subtitle.TextColor3 = Theme.TextSecondary
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 0, 0, 0)
subtitle.Size = UDim2.new(1, 0, 1, 0)
subtitle.TextYAlignment = Enum.TextYAlignment.Top
subtitle.TextWrapped = true
subtitle.AutomaticSize = Enum.AutomaticSize.Y
subtitle.Parent = introContainer

local function fitTextToContainer()
    local h = introContainer.AbsoluteSize.Y
    local lh = math.max(16, h / 4)
    subtitle.TextSize = math.clamp(math.floor(lh * 0.55), 12, 22)
    subtitle.TextWrapped = true
end

pcall(fitTextToContainer)
introContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    pcall(fitTextToContainer)
end)

local btnY = C.Height - 96
local confirm = Instance.new("TextButton")
confirm.Text = "确认"
confirm.Font = Enum.Font.GothamSemibold
confirm.TextSize = 14
confirm.TextColor3 = Theme.Accent
confirm.BackgroundTransparency = 1
confirm.Position = UDim2.new(0, 16, 0, btnY)
confirm.Size = UDim2.new(0.5, -22, 0, 36)
confirm.AutoButtonColor = false
confirm.Parent = pageMain
pressEffect(confirm)

local closeBtn = Instance.new("TextButton")
closeBtn.Text = "关闭"
closeBtn.Font = Enum.Font.GothamSemibold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Theme.Danger
closeBtn.BackgroundTransparency = 1
closeBtn.Position = UDim2.new(0.5, 6, 0, btnY)
closeBtn.Size = UDim2.new(0.5, -22, 0, 36)
closeBtn.AutoButtonColor = false
closeBtn.Parent = pageMain
pressEffect(closeBtn)

local pageFunction = Instance.new("Frame")
pageFunction.Size = UDim2.new(1, 0, 1, 0)
pageFunction.BackgroundTransparency = 1
pageFunction.Visible = false
pageFunction.Position = UDim2.new(1, 0, 0, 0)
pageFunction.Parent = contentContainer
pageFunction.Selectable = false

local funcList = Instance.new("ScrollingFrame")
funcList.Size = UDim2.new(0.25, -6, 1, -C.BackBtnHeight - 8)
funcList.Position = UDim2.new(0, 6, 0, 0)
funcList.BackgroundColor3 = Theme.Glass
funcList.BackgroundTransparency = 0.35
funcList.BorderSizePixel = 0
funcList.ScrollBarThickness = 3
funcList.AutomaticCanvasSize = Enum.AutomaticSize.Y
funcList.CanvasSize = UDim2.new(0, 0, 0, 0)
funcList.Parent = pageFunction
corner(funcList, 12)

local listLayout = Instance.new("UIListLayout", funcList)
listLayout.Padding = UDim.new(0, 6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local listPad = Instance.new("UIPadding", funcList)
listPad.PaddingTop = UDim.new(0, 6)
listPad.PaddingBottom = UDim.new(0, 6)
listPad.PaddingLeft = UDim.new(0, 6)
listPad.PaddingRight = UDim.new(0, 6)

local funcContent = Instance.new("ScrollingFrame")
funcContent.Size = UDim2.new(0.75, -12, 1, -C.BackBtnHeight - 8)
funcContent.Position = UDim2.new(0.25, 6, 0, 0)
funcContent.BackgroundColor3 = Theme.Glass
funcContent.BackgroundTransparency = 0.25
funcContent.BorderSizePixel = 0
funcContent.ClipsDescendants = true
funcContent.ScrollBarThickness = 4
funcContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
funcContent.CanvasSize = UDim2.new(0, 0, 0, 0)
funcContent.ScrollingDirection = Enum.ScrollingDirection.Y
funcContent.Parent = pageFunction
corner(funcContent, 12)

local pages = {}
local function createPage(name)
    local pg = Instance.new("Frame")
    pg.Name = name
    pg.Size = UDim2.new(1, 0, 1, 0)
    pg.BackgroundTransparency = 1
    pg.Visible = false
    pg.Parent = funcContent
    pages[name] = pg
    return pg
end

local pgServer = createPage("Server")
local pgEntertainment = createPage("Entertainment")
local pgAnti = createPage("Anti")

local FuncState = {
    AntiDetect = true,
    AdminDetect = true,
    BypassGroup = true,
    BypassAC = true,
    -- 娱乐功能状态
    InfiniteAmmo = false,
    RapidFire = false,
    ShieldForever = false,
}

local toggleSetters = {}

local function createToggle(parent, yPos, labelText, getState, onToggle)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -24, 0, 36)
    row.Position = UDim2.new(0, 12, 0, yPos)
    row.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", row)
    lbl.Text = labelText
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextColor3 = Theme.TextPrimary
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(0, 50, 0, 28)
    track.Position = UDim2.new(1, -50, 0, 4)
    track.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    track.BorderSizePixel = 0
    corner(track, 14)
    track.Selectable = false

    local thumb = Instance.new("Frame", track)
    thumb.Size = UDim2.new(0, 22, 0, 22)
    thumb.Position = UDim2.new(0, 3, 0, 3)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel = 0
    corner(thumb, 11)
    thumb.Selectable = false

    track.Active = true
    local on = false

    pcall(function()
        on = getState()
    end)

    if on then
        track.BackgroundColor3 = Color3.fromRGB(220, 220, 225)
        thumb.Position = UDim2.new(1, -25, 0, 3)
        thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end

    local function setState(val)
        on = val
        if on then
            makeTween(track, {BackgroundColor3 = Color3.fromRGB(220, 220, 225)}, 0.2)
            makeTween(thumb, {Position = UDim2.new(1, -25, 0, 3)}, 0.2)
            makeTween(thumb, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        else
            makeTween(track, {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}, 0.2)
            makeTween(thumb, {Position = UDim2.new(0, 3, 0, 3)}, 0.2)
            makeTween(thumb, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        end
        safeCall(function()
            onToggle(val)
        end, "Toggle:" .. labelText)
    end

    track.InputBegan:Connect(function(input)
        if ((input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch)) then
            setState(not on)
        end
    end)

    toggleSetters[labelText] = setState
    return setState
end

-- ==================== 服务器页面（监狱生活UI） ====================
do
    local p = pgServer
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "加载服务器"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 36

    local loadBtn = Instance.new("TextButton", p)
    loadBtn.Size = UDim2.new(1, -24, 0, 40)
    loadBtn.Position = UDim2.new(0, 12, 0, y)
    loadBtn.BackgroundColor3 = Theme.Glass
    loadBtn.BackgroundTransparency = 0.4
    loadBtn.Text = "加载服务器"
    loadBtn.Font = Enum.Font.GothamSemibold
    loadBtn.TextSize = 14
    loadBtn.TextColor3 = Theme.TextPrimary
    loadBtn.AutoButtonColor = false
    corner(loadBtn, 8)
    pressEffect(loadBtn)

    loadBtn.MouseButton1Click:Connect(function()
        -- 显示服务器名称
        local gameName = "未知游戏"
        local success, info = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        if success and info then
            gameName = info.Name
        end
        Notify("shible", "当前服务器为: " .. gameName, 3)

        -- 创建监狱生活横屏UI
        local jailGui = Instance.new("ScreenGui")
        jailGui.Name = "JailbreakUI"
        jailGui.ResetOnSpawn = false
        jailGui.Parent = PlayerGui

        local mainFrame = Instance.new("Frame")
        mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        mainFrame.Position = UDim2.fromScale(0.5, 0.5)
        mainFrame.Size = UDim2.new(0.9, 0, 0.7, 0) -- 横屏，宽高比自适应
        mainFrame.BackgroundColor3 = Theme.Glass
        mainFrame.BackgroundTransparency = 0.15
        mainFrame.BorderSizePixel = 0
        mainFrame.Parent = jailGui
        corner(mainFrame, 20)

        -- 标题
        local titleLabel = Instance.new("TextLabel", mainFrame)
        titleLabel.Size = UDim2.new(1, -40, 0, 40)
        titleLabel.Position = UDim2.new(0, 20, 0, 10)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = "监狱生活 · 功能面板"
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 24
        titleLabel.TextColor3 = Theme.TextPrimary
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left

        -- 功能列表（使用 ScrollingFrame 容纳大量选项）
        local funcScroll = Instance.new("ScrollingFrame", mainFrame)
        funcScroll.Size = UDim2.new(1, -40, 1, -110)
        funcScroll.Position = UDim2.new(0, 20, 0, 60)
        funcScroll.BackgroundTransparency = 1
        funcScroll.BorderSizePixel = 0
        funcScroll.ScrollBarThickness = 6
        funcScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        funcScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

        local layout = Instance.new("UIListLayout", funcScroll)
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        -- 辅助函数：添加一个开关
        local function addToggle(parent, label, getter, setter)
            local row = Instance.new("Frame", parent)
            row.Size = UDim2.new(1, 0, 0, 40)
            row.BackgroundTransparency = 1

            local lbl = Instance.new("TextLabel", row)
            lbl.Size = UDim2.new(1, -80, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = label
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 16
            lbl.TextColor3 = Theme.TextPrimary
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local track = Instance.new("Frame", row)
            track.Size = UDim2.new(0, 60, 0, 30)
            track.Position = UDim2.new(1, -70, 0.5, -15)
            track.BackgroundColor3 = Color3.fromRGB(60,60,65)
            track.BorderSizePixel = 0
            corner(track, 15)
            track.Selectable = false

            local thumb = Instance.new("Frame", track)
            thumb.Size = UDim2.new(0, 24, 0, 24)
            thumb.Position = UDim2.new(0, 3, 0, 3)
            thumb.BackgroundColor3 = Color3.fromRGB(255,255,255)
            thumb.BorderSizePixel = 0
            corner(thumb, 12)

            local on = false
            pcall(function() on = getter() end)
            if on then
                track.BackgroundColor3 = Color3.fromRGB(220,220,225)
                thumb.Position = UDim2.new(1, -27, 0, 3)
            end

            track.Active = true
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    on = not on
                    if on then
                        makeTween(track, {BackgroundColor3 = Color3.fromRGB(220,220,225)}, 0.2)
                        makeTween(thumb, {Position = UDim2.new(1, -27, 0, 3)}, 0.2)
                    else
                        makeTween(track, {BackgroundColor3 = Color3.fromRGB(60,60,65)}, 0.2)
                        makeTween(thumb, {Position = UDim2.new(0, 3, 0, 3)}, 0.2)
                    end
                    safeCall(function() setter(on) end)
                end
            end)
        end

        -- 监狱生活功能开关（模拟常见内核功能）
        local jailState = {
            Aimbot = false,
            ESP = false,
            SpeedHack = false,
            NoClip = false,
            InfiniteStamina = false,
            InstantArrest = false,
            AutoFarm = false,
        }

        addToggle(funcScroll, "自动瞄准", function() return jailState.Aimbot end, function(v) jailState.Aimbot = v; Notify("监狱", "自瞄 " .. (v and "开启" or "关闭")) end)
        addToggle(funcScroll, "透视", function() return jailState.ESP end, function(v) jailState.ESP = v; Notify("监狱", "透视 " .. (v and "开启" or "关闭")) end)
        addToggle(funcScroll, "加速", function() return jailState.SpeedHack end, function(v) jailState.SpeedHack = v; Notify("监狱", "加速 " .. (v and "开启" or "关闭")) end)
        addToggle(funcScroll, "穿墙", function() return jailState.NoClip end, function(v) jailState.NoClip = v; Notify("监狱", "穿墙 " .. (v and "开启" or "关闭")) end)
        addToggle(funcScroll, "无限体力", function() return jailState.InfiniteStamina end, function(v) jailState.InfiniteStamina = v; Notify("监狱", "无限体力 " .. (v and "开启" or "关闭")) end)
        addToggle(funcScroll, "立即逮捕", function() return jailState.InstantArrest end, function(v) jailState.InstantArrest = v; Notify("监狱", "立即逮捕 " .. (v and "开启" or "关闭")) end)
        addToggle(funcScroll, "自动刷钱", function() return jailState.AutoFarm end, function(v) jailState.AutoFarm = v; Notify("监狱", "自动刷钱 " .. (v and "开启" or "关闭")) end)

        -- 关闭按钮
        local closeJailBtn = Instance.new("TextButton", mainFrame)
        closeJailBtn.Size = UDim2.new(0, 100, 0, 36)
        closeJailBtn.Position = UDim2.new(1, -120, 1, -50)
        closeJailBtn.AnchorPoint = Vector2.new(1, 1)
        closeJailBtn.Text = "关闭"
        closeJailBtn.Font = Enum.Font.GothamSemibold
        closeJailBtn.TextSize = 16
        closeJailBtn.TextColor3 = Theme.Danger
        closeJailBtn.BackgroundTransparency = 1
        closeJailBtn.AutoButtonColor = false
        pressEffect(closeJailBtn)
        closeJailBtn.MouseButton1Click:Connect(function()
            jailGui:Destroy()
        end)

        -- 如果用户已经打开，先关闭旧的
        for _, v in pairs(PlayerGui:GetChildren()) do
            if v.Name == "JailbreakUI" then v:Destroy() end
        end
    end)
end

-- ==================== 娱乐页面 ====================
do
    local p = pgEntertainment
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "娱乐功能"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 36

    -- 无限子弹
    createToggle(p, y, "无限子弹", function()
        return FuncState.InfiniteAmmo
    end, function(v)
        FuncState.InfiniteAmmo = v
        -- 实现：遍历玩家工具，设置弹药为巨大值
        if v then
            local char = LocalPlayer.Character
            if char then
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Ammo") then
                        tool.Ammo.Value = 9999
                    end
                end
            end
            -- 连接事件，当新工具加入时设置
            local function onChildAdded(child)
                if child:IsA("Tool") and child:FindFirstChild("Ammo") then
                    child.Ammo.Value = 9999
                end
            end
            LocalPlayer.CharacterAdded:Connect(function(char)
                char.ChildAdded:Connect(onChildAdded)
            end)
        end
        Notify("娱乐", "无限子弹 " .. (v and "开启" : "关闭"))
    end)

    y = y + 46

    -- 射速一秒999发
    createToggle(p, y, "一秒999发", function()
        return FuncState.RapidFire
    end, function(v)
        FuncState.RapidFire = v
        -- 实现：修改武器的FireRate属性（如果存在）
        if v then
            local char = LocalPlayer.Character
            if char then
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        for _, obj in ipairs(tool:GetDescendants()) do
                            if obj:IsA("NumberValue") and obj.Name == "FireRate" then
                                obj.Value = 0.001 -- 极快射速
                            end
                        end
                    end
                end
            end
            -- 可能需持续刷新
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not FuncState.RapidFire then conn:Disconnect() return end
                local char = LocalPlayer.Character
                if char then
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool:IsA("Tool") then
                            for _, obj in ipairs(tool:GetDescendants()) do
                                if obj:IsA("NumberValue") and obj.Name == "FireRate" then
                                    obj.Value = 0.001
                                end
                            end
                        end
                    end
                end
            end)
        end
        Notify("娱乐", "射速一秒999发 " .. (v and "开启" : "关闭"))
    end)

    y = y + 46

    -- 永久护盾（刚复活时的护盾）
    createToggle(p, y, "永久护盾", function()
        return FuncState.ShieldForever
    end, function(v)
        FuncState.ShieldForever = v
        -- 实现：查找玩家身上的护盾效果（例如ForceField），将其TimeToDie设为极大
        if v then
            local char = LocalPlayer.Character
            if char then
                for _, child in ipairs(char:GetChildren()) do
                    if child:IsA("ForceField") then
                        child.TimeToDie = math.huge
                    end
                end
            end
            -- 监听新护盾出现
            LocalPlayer.CharacterAdded:Connect(function(char)
                char.ChildAdded:Connect(function(child)
                    if child:IsA("ForceField") then
                        child.TimeToDie = math.huge
                    end
                end)
            end)
        end
        Notify("娱乐", "永久护盾 " .. (v and "开启" : "关闭"))
    end)

    y = y + 46
    local info = Instance.new("TextLabel", p)
    info.Text = "注意：部分功能需重新装备武器或重生生效。"
    info.Font = Enum.Font.Gotham
    info.TextSize = 12
    info.TextColor3 = Theme.TextSecondary
    info.BackgroundTransparency = 1
    info.Position = UDim2.new(0, 16, 0, y)
    info.Size = UDim2.new(1, -32, 0, 30)
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextWrapped = true
end

-- ==================== 防检测页面（保持不变） ====================
do
    local p = pgAnti
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "防系统检测"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left

    y = y + 36
    createToggle(p, y, "开启预防检测", function()
        return FuncState.AntiDetect
    end, function(v)
        FuncState.AntiDetect = v
    end)

    y = y + 46
    createToggle(p, y, "管理员检测", function()
        return FuncState.AdminDetect
    end, function(v)
        FuncState.AdminDetect = v
    end)

    y = y + 46
    createToggle(p, y, "绕过群组检测", function()
        return FuncState.BypassGroup
    end, function(v)
        FuncState.BypassGroup = v
    end)

    y = y + 46
    createToggle(p, y, "绕过AC检测", function()
        return FuncState.BypassAC
    end, function(v)
        FuncState.BypassAC = v
    end)

    local info = Instance.new("TextLabel", p)
    info.Text = "默认全部开启，如非必要请勿关闭。"
    info.Font = Enum.Font.Gotham
    info.TextSize = 12
    info.TextColor3 = Theme.TextSecondary
    info.BackgroundTransparency = 1
    info.Position = UDim2.new(0, 16, 0, y + 46)
    info.Size = UDim2.new(1, -32, 0, 30)
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.TextWrapped = true
    y = y + 76

    local serverTitle = Instance.new("TextLabel", p)
    serverTitle.Text = "关于服务器"
    serverTitle.Font = Enum.Font.GothamSemibold
    serverTitle.TextSize = 14
    serverTitle.TextColor3 = Theme.TextPrimary
    serverTitle.BackgroundTransparency = 1
    serverTitle.Position = UDim2.new(0, 16, 0, y)
    serverTitle.Size = UDim2.new(1, -32, 0, 20)
    serverTitle.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 30

    local rejoinBtn = Instance.new("TextButton", p)
    rejoinBtn.Size = UDim2.new(1, -24, 0, 32)
    rejoinBtn.Position = UDim2.new(0, 12, 0, y)
    rejoinBtn.BackgroundColor3 = Theme.Glass
    rejoinBtn.BackgroundTransparency = 0.4
    rejoinBtn.Text = "重进服务器"
    rejoinBtn.Font = Enum.Font.Gotham
    rejoinBtn.TextSize = 14
    rejoinBtn.TextColor3 = Theme.TextPrimary
    rejoinBtn.AutoButtonColor = false
    corner(rejoinBtn, 8)
    pressEffect(rejoinBtn)
    rejoinBtn.MouseButton1Click:Connect(function()
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)

    y = y + 42
    local shutdownBtn = Instance.new("TextButton", p)
    shutdownBtn.Size = UDim2.new(1, -24, 0, 32)
    shutdownBtn.Position = UDim2.new(0, 12, 0, y)
    shutdownBtn.BackgroundColor3 = Theme.Glass
    shutdownBtn.BackgroundTransparency = 0.4
    shutdownBtn.Text = "强制退出"
    shutdownBtn.Font = Enum.Font.Gotham
    shutdownBtn.TextSize = 14
    shutdownBtn.TextColor3 = Theme.TextPrimary
    shutdownBtn.AutoButtonColor = false
    corner(shutdownBtn, 8)
    pressEffect(shutdownBtn)
    shutdownBtn.MouseButton1Click:Connect(function()
        game:Shutdown()
    end)

    y = y + 42
    local suicideBtn = Instance.new("TextButton", p)
    suicideBtn.Size = UDim2.new(1, -24, 0, 32)
    suicideBtn.Position = UDim2.new(0, 12, 0, y)
    suicideBtn.BackgroundColor3 = Theme.Glass
    suicideBtn.BackgroundTransparency = 0.4
    suicideBtn.Text = "自杀（重生）"
    suicideBtn.Font = Enum.Font.Gotham
    suicideBtn.TextSize = 14
    suicideBtn.TextColor3 = Theme.TextPrimary
    suicideBtn.AutoButtonColor = false
    corner(suicideBtn, 8)
    pressEffect(suicideBtn)
    suicideBtn.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0 end
        end
    end)
end

-- ==================== 左侧栏项目 ====================
local selectedItem = nil
local function createFuncItem(name, key)
    local item = Instance.new("TextButton")
    item.Size = UDim2.new(1, 0, 0, 36)
    item.BackgroundColor3 = Theme.Glass
    item.BackgroundTransparency = 0.6
    item.Text = ""
    item.AutoButtonColor = false
    item.Parent = funcList
    corner(item, 10)
    item.SelectionImageObject = nil
    item.Selectable = false

    local lbl = Instance.new("TextLabel", item)
    lbl.Text = name
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextColor3 = Theme.TextPrimary
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, -12, 1, 0)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Center

    item.MouseEnter:Connect(function()
        if (selectedItem ~= item) then
            makeTween(item, {BackgroundTransparency = 0.35}, 0.15)
        end
    end)

    item.MouseLeave:Connect(function()
        if (selectedItem ~= item) then
            makeTween(item, {BackgroundTransparency = 0.6}, 0.15)
        end
    end)

    item.MouseButton1Click:Connect(function()
        if selectedItem then
            makeTween(selectedItem, {BackgroundTransparency = 0.6}, 0.2)
        end

        selectedItem = item
        makeTween(item, {BackgroundTransparency = 0.2}, 0.2)

        for _, pg in pairs(pages) do
            pg.Visible = false
        end

        pages[key].Visible = true
    end)
end

createFuncItem("服务器", "Server")
createFuncItem("娱乐", "Entertainment")
createFuncItem("防检测", "Anti")

task.defer(function()
    safeCall(function()
        for _, btn in ipairs(funcList:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.MouseButton1Click:Fire()
                break
            end
        end
    end, "DefaultSelect")
end)

-- ==================== 其余UI组件（最小化、拖动等）保持不变 ====================
local backBtn = Instance.new("TextButton", pageFunction)
backBtn.Text = "返回"
backBtn.Font = Enum.Font.GothamSemibold
backBtn.TextSize = 14
backBtn.TextColor3 = Theme.Accent
backBtn.BackgroundTransparency = 1
backBtn.Position = UDim2.new(0, 16, 1, -C.BackBtnHeight - 4)
backBtn.Size = UDim2.new(0, 60, 0, 36)
backBtn.AutoButtonColor = false
pressEffect(backBtn)

local funcCloseBtn = Instance.new("TextButton", pageFunction)
funcCloseBtn.Text = "关闭"
funcCloseBtn.Font = Enum.Font.GothamSemibold
funcCloseBtn.TextSize = 14
funcCloseBtn.TextColor3 = Theme.Danger
funcCloseBtn.BackgroundTransparency = 1
funcCloseBtn.Position = UDim2.new(1, -72, 1, -C.BackBtnHeight - 4)
funcCloseBtn.Size = UDim2.new(0, 60, 0, 36)
funcCloseBtn.AutoButtonColor = false
pressEffect(funcCloseBtn)
funcCloseBtn.Visible = false

local mini = Instance.new("Frame", gui)
mini.Visible = false
mini.AnchorPoint = Vector2.new(0.5, 0.5)
mini.Position = UDim2.fromScale(0.5, 0.08)
mini.Size = UDim2.new(0, 160, 0, 48)
mini.BackgroundColor3 = Theme.Glass
mini.BackgroundTransparency = 0.12
mini.BorderSizePixel = 0
mini.Active = true
corner(mini, 16)

local miniGrab = Instance.new("Frame", mini)
miniGrab.AnchorPoint = Vector2.new(0.5, 0)
miniGrab.Size = UDim2.new(0, 28, 0, 3)
miniGrab.Position = UDim2.new(0.5, 0, 0, 5)
miniGrab.BackgroundColor3 = Theme.Grabber
miniGrab.BackgroundTransparency = 0.35
miniGrab.BorderSizePixel = 0
corner(miniGrab, 999)

local miniLbl = Instance.new("TextLabel", mini)
miniLbl.Text = "已最小化"
miniLbl.Font = Enum.Font.Gotham
miniLbl.TextSize = 12
miniLbl.TextColor3 = Theme.TextPrimary
miniLbl.BackgroundTransparency = 1
miniLbl.Position = UDim2.new(0, 12, 0, 12)
miniLbl.Size = UDim2.new(1, -70, 1, -24)

local restore = Instance.new("TextButton", mini)
restore.Text = "恢复"
restore.Font = Enum.Font.GothamSemibold
restore.TextSize = 12
restore.TextColor3 = Theme.Accent
restore.BackgroundTransparency = 1
restore.Position = UDim2.new(1, -64, 0, 8)
restore.Size = UDim2.new(0, 56, 1, -16)
restore.AutoButtonColor = false
pressEffect(restore)

local DragSystem = {}
DragSystem.enable = function(frame, opts)
    opts = opts or {}
    local smoothness = opts.smoothness or C.DragSmoothness
    local clampY = opts.clampY ~= false
    local dragging = false
    local startMousePos
    local startFramePos

    frame.InputBegan:Connect(function(input)
        if ((input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch)) then
            dragging = true
            startMousePos = input.Position
            startFramePos = frame.Position
        end
    end)

    frame.InputEnded:Connect(function(input)
        if (dragging and ((input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch))) then
            dragging = false
        end
    end)

    local lastPos = frame.Position

    RunService.RenderStepped:Connect(function()
        safeCall(function()
            if (dragging and startMousePos) then
                local mouse = UserInputService:GetMouseLocation()
                local delta = mouse - startMousePos
                local newX = startFramePos.X.Offset + delta.X
                local newY = startFramePos.Y.Offset + delta.Y

                if clampY then
                    newY = math.max(0, newY)
                end

                local ss = gui.AbsoluteSize
                local fs = frame.AbsoluteSize
                newX = math.clamp(newX, -fs.X / 2, ss.X - (fs.X / 2))

                local target = UDim2.new(0, newX, 0, newY)
                lastPos = UDim2.new(
                    lastPos.X.Scale + ((target.X.Scale - lastPos.X.Scale) * smoothness),
                    lastPos.X.Offset + ((target.X.Offset - lastPos.X.Offset) * smoothness),
                    lastPos.Y.Scale + ((target.Y.Scale - lastPos.Y.Scale) * smoothness),
                    lastPos.Y.Offset + ((target.Y.Offset - lastPos.Y.Offset) * smoothness)
                )
                frame.Position = lastPos
            end
        end, "Drag")
    end)
end

DragSystem.enable(root)
DragSystem.enable(mini)

local function cleanupAll()
    pcall(function()
        gui:Destroy()
        blur:Destroy()
    end)
end

minBtn.MouseButton1Click:Connect(function()
    makeTween(root, {Size = UDim2.new(0, C.Width, 0, 0), BackgroundTransparency = 1}, 0.25)
    makeTween(blur, {Size = 6}, 0.25)

    task.delay(0.2, function()
        root.Visible = false
        mini.Visible = true
        mini.Size = UDim2.new(0, 140, 0, 40)
        mini.BackgroundTransparency = 1
        makeTween(mini, {Size = UDim2.new(0, 160, 0, 48), BackgroundTransparency = 0.12}, 0.3, Enum.EasingStyle.Back)
    end)
end)

restore.MouseButton1Click:Connect(function()
    mini.Visible = false
    root.Visible = true
    makeTween(blur, {Size = C.Blur}, 0.25)
    makeTween(root, {Size = UDim2.new(0, C.Width, 0, C.Height), BackgroundTransparency = 0.18}, 0.4)
end)

closeBtn.MouseButton1Click:Connect(function()
    cleanupAll()
end)

funcCloseBtn.MouseButton1Click:Connect(function()
    cleanupAll()
end)

confirm.MouseButton1Click:Connect(function()
    makeTween(confirm, {TextSize = 16}, 0.12)
    task.delay(0.12, function()
        makeTween(confirm, {TextSize = 14}, 0.15)
    end)

    Notify("shible", "正在加载功能，请稍候...", 1)
    task.wait(0.8)

    if toggleSetters["开启预防检测"] then toggleSetters["开启预防检测"](true) end
    if toggleSetters["管理员检测"] then toggleSetters["管理员检测"](true) end
    if toggleSetters["绕过群组检测"] then toggleSetters["绕过群组检测"](true) end
    if toggleSetters["绕过AC检测"] then toggleSetters["绕过AC检测"](true) end

    makeTween(pageMain, {Position = UDim2.new(-1, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
    pageFunction.Visible = true
    pageFunction.Position = UDim2.new(1, 0, 0, 0)
    makeTween(pageFunction, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)

    backBtn.Visible = false
    funcCloseBtn.Visible = true
end)

backBtn.MouseButton1Click:Connect(function()
    makeTween(pageFunction, {Position = UDim2.new(1, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
    pageMain.Visible = true
    pageMain.Position = UDim2.new(-1, 0, 0, 0)
    makeTween(pageMain, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)

    task.delay(0.3, function()
        pageFunction.Visible = false
    end)
end)

root.Size = UDim2.new(0, C.Width, 0, C.Height)
root.BackgroundTransparency = 0.18
root.Visible = true
gui.Enabled = true

pcall(function()
    springTween(root, {Size = UDim2.new(0, C.Width, 0, C.Height), BackgroundTransparency = 0.18}, 0.5)
end)

makeTween(blur, {Size = C.Blur}, 0.5)

-- 防检测循环
local bypassRunning = true
local function doAntiDetect()
    pcall(function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" then
                if v._G then v._G = nil end
                if v.antiCheat then v.antiCheat = nil end
                if v.AntiCheat then v.AntiCheat = nil end
            end
        end
    end)
    pcall(function()
        for _, item in pairs(game:GetDescendants()) do
            if item:IsA("RemoteEvent") and (item.Name:lower():find("detect") or item.Name:lower():find("check")) then
                item.OnServerEvent:Connect(function() end)
            end
        end
    end)
end

local function doAdminDetect()
    local admins = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        local name = plr.Name:lower()
        if name:find("admin") or name:find("owner") or name:find("creator") or name:find("dev") then
            table.insert(admins, plr.Name)
        end
    end
    if #admins > 0 then
        Notify("shible", "检测到疑似管理员: " .. table.concat(admins, ", "), 4)
    end
end

local function doBypassGroup()
    pcall(function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" then
                if v.GroupCheck then v.GroupCheck = nil end
                if v.RequireGroup then v.RequireGroup = nil end
            end
        end
        if _G.GroupVerified then _G.GroupVerified = true end
    end)
end

local function doBypassAC()
    pcall(function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" then
                if v.AC_Enabled then v.AC_Enabled = false end
                if v.AntiCheatEnabled then v.AntiCheatEnabled = false end
                if v.BanDetect then v.BanDetect = nil end
            end
        end
        if _G.AC_Enabled then _G.AC_Enabled = false end
        if _G.AntiCheat then _G.AntiCheat = nil end
    end)
end

task.spawn(function()
    while bypassRunning do
        task.wait(60)
        pcall(function()
            if FuncState.AntiDetect then doAntiDetect() end
            if FuncState.AdminDetect then doAdminDetect() end
            if FuncState.BypassGroup then doBypassGroup() end
            if FuncState.BypassAC then doBypassAC() end
        end)
    end
end)

local oldCleanup = cleanupAll
cleanupAll = function()
    bypassRunning = false
    oldCleanup()
end

LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.InProgress then
        pcall(function()
            _G = {}
            if getgenv then
                for k, v in pairs(getgenv()) do
                    getgenv()[k] = nil
                end
            end
            if shared then
                for k, v in pairs(shared) do
                    shared[k] = nil
                end
            end
            for _, guiObj in pairs(PlayerGui:GetChildren()) do
                if guiObj:IsA("ScreenGui") and guiObj ~= gui then
                    guiObj:Destroy()
                end
            end
        end)
    end
end)
