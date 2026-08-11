local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
subtitle.Text = "欢迎使用\n进QQ群:434448780"
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
confirm.Text = "启动"
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

local pgLive = createPage("Live")
local pgAnti = createPage("Anti")

local FuncState = {
    AntiDetect = true,
    AdminDetect = true,
    BypassGroup = true,
    BypassAC = true,
    FogRemoved = false,
    NoCooldown = false,
    ServerChecked = false,
    CurrentServer = "",
    IsInGame = false,
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
        pcall(function()
            onToggle(val)
        end)
    end

    track.InputBegan:Connect(function(input)
        if ((input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch)) then
            if not FuncState.ServerChecked then
                Notify("shible", "请先点击「启动」检测服务器", 2)
                return
            end
            setState(not on)
        end
    end)

    toggleSetters[labelText] = setState
    return setState
end

-- ========== 检测服务器 ==========
local function checkServer()
    Notify("shible", "正在检测服务器...", 1)
    task.wait(0.5)
    
    local serverName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    if serverName == "" or not serverName then
        serverName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Title
    end
    if serverName == "" or not serverName then
        serverName = "未知服务器"
    end
    
    FuncState.CurrentServer = serverName
    FuncState.ServerChecked = true
    Notify("shible", "当前服务器为: " .. serverName, 3)
    return serverName
end

-- ========== 检测是否有斧子 ==========
local function checkHasAxe()
    local char = LocalPlayer.Character
    if not char then return false end
    for _, child in pairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local name = child.Name:lower()
            if name:find("斧") or name:find("axe") then
                return true
            end
        end
    end
    return false
end

-- ========== 拦截 swing_axe 远程事件 ==========
local function hookSwingAxe()
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("remotes")
        if remotes then
            local swingAxe = remotes:FindFirstChild("swing_axe")
            if swingAxe then
                -- 保存原始方法
                local oldFireServer = swingAxe.FireServer
                swingAxe.FireServer = function(self, ...)
                    if FuncState.NoCooldown and checkHasAxe() then
                        -- 无冷却开启时，不执行原始调用，直接返回
                        return
                    end
                    -- 否则正常执行
                    return oldFireServer(self, ...)
                end
                print("[shible] swing_axe 已拦截")
            end
        end
    end)
end

-- ========== "活了七天" 页面 ==========
do
    local p = pgLive
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "活了七天"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 36

    -- 除雾
    local fogConn = nil
    local function toggleFog(enable)
        if enable and not FuncState.IsInGame then
            Notify("shible", "请进入局内再开启除雾", 2)
            task.wait(0.1)
            if toggleSetters["除雾"] then
                toggleSetters["除雾"](false)
            end
            return
        end
        
        FuncState.FogRemoved = enable
        if enable then
            if not fogConn then
                fogConn = RunService.Heartbeat:Connect(function()
                    if not FuncState.FogRemoved then 
                        fogConn:Disconnect()
                        fogConn = nil
                        return 
                    end
                    pcall(function()
                        Lighting.FogEnd = 999999
                        Lighting.FogStart = 999999
                        local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
                        if atmos then
                            atmos.Density = 0
                        end
                    end)
                end)
            end
        else
            if fogConn then
                fogConn:Disconnect()
                fogConn = nil
            end
            pcall(function()
                Lighting.FogEnd = 100000
                Lighting.FogStart = 0
                local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
                if atmos then
                    atmos.Density = 0.4
                end
            end)
        end
    end

    createToggle(p, y, "除雾", function()
        return FuncState.FogRemoved
    end, function(v)
        toggleFog(v)
    end)

    y = y + 46

    -- 无冷却（拦截 swing_axe）
    local function toggleNoCooldown(enable)
        if enable then
            local hasAxe = checkHasAxe()
            if not hasAxe then
                Notify("shible", "请先手持斧子再开启无冷却", 2)
                task.wait(0.1)
                if toggleSetters["无冷却"] then
                    toggleSetters["无冷却"](false)
                end
                return
            end
        end
        
        FuncState.NoCooldown = enable
        if enable then
            Notify("shible", "无冷却已开启，斧子无后摇", 2)
            hookSwingAxe()
        else
            Notify("shible", "无冷却已关闭", 2)
        end
    end

    createToggle(p, y, "无冷却", function()
        return FuncState.NoCooldown
    end, function(v)
        toggleNoCooldown(v)
    end)

    y = y + 46
    local info = Instance.new("TextLabel", p)
    info.Text = "除雾需进入局内；无冷却需手持斧子，开启后砍树无后摇"
    info.Font = Enum.Font.Gotham
    info.TextSize = 12
    info.TextColor3 = Theme.TextSecondary
    info.BackgroundTransparency = 1
    info.Position = UDim2.new(0, 16, 0, y)
    info.Size = UDim2.new(1, -32, 0, 30)
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.TextWrapped = true
end

-- ========== "防检测" 页面 ==========
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
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0 end
        end
    end)
end

-- ========== 左侧列表 ==========
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

createFuncItem("活了七天", "Live")
createFuncItem("防检测", "Anti")

task.defer(function()
    pcall(function()
        for _, btn in ipairs(funcList:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.MouseButton1Click:Fire()
                break
            end
        end
    end)
end)

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
        pcall(function()
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
        end)
    end)
end

DragSystem.enable(root)
DragSystem.enable(mini)

local function cleanupAll()
    pcall(function()
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h.WalkSpeed = 16
        end
        gui:Destroy()
        blur:Destroy()
    end)
end

minBtn.MouseButton1Click:Connect(function()
    makeTween(root, {Size = UDim2.new(0, C.Width, 0, 0), BackgroundTransparency = 1}, 0.25)
    makeTween(blur, {Size = 6}, 0.25)

    task.delay(0.2, function()
        root.Visible = false
