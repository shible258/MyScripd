local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

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
subtitle.Text = "欢迎使用 shible\n防检测专用版"
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
confirm.Text = "进入"
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
    ThirdPerson = false,
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
            setState(not on)
        end
    end)

    toggleSetters[labelText] = setState
    return setState
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

    -- 除雾（持久循环）
    local fogConn = nil
    local function toggleFog(enable)
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

    -- 无冷却：移除动作后摇（砍树摆动等）
    local cooldownConn = nil
    local function toggleNoCooldown(enable)
        FuncState.NoCooldown = enable
        if enable then
            if not cooldownConn then
                cooldownConn = RunService.Heartbeat:Connect(function()
                    if not FuncState.NoCooldown then
                        cooldownConn:Disconnect()
                        cooldownConn = nil
                        return
                    end
                    pcall(function()
                        local char = LocalPlayer.Character
                        if not char then return end
                        
                        -- 移除动画后摇：强制停止所有动画并立即重置
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            -- 重置人类状态，打断当前动作
                            hum:ChangeState(Enum.HumanoidStateType.Running)
                            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                            hum:ChangeState(Enum.HumanoidStateType.Running)
                            
                            -- 清除所有加载的动画轨道
                            if hum.Animator then
                                local animator = hum.Animator
                                for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                                    pcall(function()
                                        track:Stop(0)
                                        track:Destroy()
                                    end)
                                end
                            end
                            
                            -- 强制重置平台站立状态
                            hum.PlatformStand = false
                        end
                        
                        -- 查找并强制结束所有工具/武器的冷却和动画
                        for _, tool in pairs(char:GetChildren()) do
                            if tool:IsA("Tool") then
                                -- 重置工具动画
                                pcall(function()
                                    if tool:FindFirstChild("Handle") then
                                        local handle = tool.Handle
                                        if handle:FindFirstChild("Weld") then
                                            local weld = handle.Weld
                                            weld.Part1 = char:FindFirstChild("HumanoidRootPart")
                                        end
                                    end
                                end)
                            end
                        end
                        
                        -- 重置所有 NumberValue 中的冷却
                        for _, obj in pairs(char:GetDescendants()) do
                            if obj:IsA("NumberValue") then
                                local name = obj.Name:lower()
                                if name:find("cooldown") or name:find("cd") or name:find("cool") or name:find("冷") or name:find("swing") or name:find("后摇") then
                                    obj.Value = 0
                                end
                            end
                            -- 重置属性
                            pcall(function()
                                if obj:GetAttribute("Cooldown") then
                                    obj:SetAttribute("Cooldown", 0)
                                end
                                if obj:GetAttribute("CD") then
                                    obj:SetAttribute("CD", 0)
                                end
                                if obj:GetAttribute("SwingCooldown") then
                                    obj:SetAttribute("SwingCooldown", 0)
                                end
                            end)
                        end
                    end)
                end)
            end
        else
            if cooldownConn then
                cooldownConn:Disconnect()
                cooldownConn = nil
            end
        end
    end

    createToggle(p, y, "无冷却", function()
        return FuncState.NoCooldown
    end, function(v)
        toggleNoCooldown(v)
    end)

    y = y + 46

    -- 强制第三人称
    local thirdPersonConn = nil
    local function toggleThirdPerson(enable)
        FuncState.ThirdPerson = enable
        if enable then
            if not thirdPersonConn then
                thirdPersonConn = RunService.Heartbeat:Connect(function()
                    if not FuncState.ThirdPerson then
                        thirdPersonConn:Disconnect()
                        thirdPersonConn = nil
                        return
                    end
                    pcall(function()
                        local cam = Workspace.CurrentCamera
                        if cam then
                            -- 强制设置为第三人称
                            cam.CameraType = Enum.CameraType.Fixed
                            cam.CameraType = Enum.CameraType.Custom
                            
                            local char = LocalPlayer.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                local root = char.HumanoidRootPart
                                -- 计算第三人称视角位置
                                local offset = cam.CFrame.LookVector * -10
                                local targetPos = root.Position + Vector3.new(0, 2, 0) + offset
                                cam.CFrame = CFrame.new(targetPos, root.Position + Vector3.new(0, 1.5, 0))
                            end
                        end
                    end)
                end)
            end
        else
            if thirdPersonConn then
                thirdPersonConn:Disconnect()
                thirdPersonConn = nil
            end
            -- 恢复第一人称
            pcall(function()
                local cam = Workspace.CurrentCamera
                if cam then
                    cam.CameraType = Enum.CameraType.Custom
                end
            end)
        end
    end

    createToggle(p, y, "强制第三人称", function()
        return FuncState.ThirdPerson
    end, function(v)
        toggleThirdPerson(v)
    end)

    y = y + 46
    local info = Instance.new("TextLabel", p)
    info.Text = "除雾持续清除雾效；无冷却移除动作后摇；强制第三人称锁定视角。"
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

-- ========== "防检测" 页面（不变） ==========
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
    local t = TweenService:Create(root, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, C.Width, 0, C.Height),
        BackgroundTransparency = 0.18
    })
    t:Play()
end)

makeTween(blur, {Size = C.Blur}, 0.5)

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
            for _, guiObj in pairs(PlayerGui:GetChildren()) do
                if guiObj:IsA("ScreenGui") and guiObj ~= gui then
                    guiObj:Destroy()
                end
            end
        end)
    end
end)
