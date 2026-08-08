local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local MarketplaceService = game:GetService("MarketplaceService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

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
    btn.SelectionImageObject = nil
    btn.Selectable = false
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

local function SafeLoad(url, name, fallbackUrls)
    name = name or "远程脚本"
    local urls = {url}
    if fallbackUrls then
        for _, u in ipairs(fallbackUrls) do
            table.insert(urls, u)
        end
    end

    for attempt, currentUrl in ipairs(urls) do
        local body = nil
        
        pcall(function()
            body = game:HttpGet(currentUrl)
        end)

        if not body or #body < 10 then
            pcall(function()
                body = HttpService:GetAsync(currentUrl)
            end)
        end

        if not body or #body < 10 then
            pcall(function()
                local r = (syn and syn.request) or http_request or request
                if r then
                    local resp = r({Url = currentUrl, Method = "GET"})
                    if resp and (resp.Success or resp.StatusCode == 200) then
                        body = resp.Body
                    end
                end
            end)
        end

        if body and #body > 10 then
            local func, err = loadstring(body)
            if func then
                local ok, e = pcall(func)
                if ok then
                    print("[SafeLoad] " .. name .. " 加载成功")
                    Notify("shible", name .. " 加载成功", 2)
                    return true
                else
                    warn("[SafeLoad] " .. name .. " 执行错误: " .. tostring(e))
                end
            else
                warn("[SafeLoad] " .. name .. " 编译错误: " .. tostring(err))
            end
        else
            warn("[SafeLoad] " .. name .. " 尝试 URL " .. currentUrl .. " 失败")
        end

        if attempt < #urls then
            Notify("shible", "正在切换备用源加载 " .. name .. " ...", 1)
            task.wait(0.5)
        end
    end

    Notify("shible", name .. " 加载失败，请检查网络或 URL", 3)
    return false
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

local pgAim = createPage("Aim")
local pgSpeed = createPage("Speed")
local pgESP = createPage("ESP")
local pgFly = createPage("Fly")
local pgFun = createPage("Fun")
local pgAnti = createPage("Anti")
local pgAction = createPage("Action")
local pgServer = createPage("Server")

local FuncState = {
    SpeedEnabled = false,
    SpeedValue = 50,
    ESPEnabled = false,
    HealthBarEnabled = false,
    DistanceEnabled = false,
    SpinEnabled = false,
    SpinSpeed = 50,
    AntiDetect = true,
    AdminDetect = true,
    BypassGroup = true,
    Mode = 1,
    AntennaEnabled = false,
    RadarEnabled = false,
    BypassAC = true,
    WallCheck = false,
    AntiFall = false,
    Noclip = false,
    ShibleAimLoaded = false,
    BlackHoleLoaded = false,
    FECarLoaded = false,
    InkLoaded = false,
    R6Loaded = false,
    R15Loaded = false,
    MapTeleport = false,
    ESPMaster = false,
    FlingLoaded = false,
}

local animTracks = {}

local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoid()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getRootPart()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function createButton(parent, yPos, labelText, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -24, 0, 32)
    btn.Position = UDim2.new(0, 12, 0, yPos)
    btn.BackgroundColor3 = Theme.Glass
    btn.BackgroundTransparency = 0.4
    btn.Text = labelText
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextColor3 = Theme.TextPrimary
    btn.AutoButtonColor = false
    corner(btn, 8)
    pressEffect(btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

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

local function createSlider(parent, yPos, labelText, minVal, maxVal, initial, onChanged)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -24, 0, 54)
    row.Position = UDim2.new(0, 12, 0, yPos)
    row.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", row)
    lbl.Text = labelText
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextColor3 = Theme.TextPrimary
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.Size = UDim2.new(0, 45, 0, 18)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local inputBox = Instance.new("TextBox", row)
    inputBox.Text = tostring(initial)
    inputBox.Font = Enum.Font.GothamBold
    inputBox.TextSize = 12
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.PlaceholderText = "输入"
    inputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    inputBox.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
    inputBox.BackgroundTransparency = 0.2
    inputBox.Position = UDim2.new(1, -56, 0, -1)
    inputBox.Size = UDim2.new(0, 56, 0, 22)
    inputBox.TextXAlignment = Enum.TextXAlignment.Center
    inputBox.ClearTextOnFocus = true
    inputBox.BorderSizePixel = 0
    inputBox.ZIndex = 5
    corner(inputBox, 5)

    local track = Instance.new("TextButton", row)
    track.Size = UDim2.new(1, 0, 0, 12)
    track.Position = UDim2.new(0, 0, 0, 30)
    track.BackgroundColor3 = Color3.fromRGB(65, 65, 70)
    track.BorderSizePixel = 0
    track.Text = ""
    track.AutoButtonColor = false
    corner(track, 6)
    track.SelectionImageObject = nil
    track.Selectable = false
    track.ZIndex = 2

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 3
    corner(fill, 6)

    local thumb = Instance.new("Frame", track)
    thumb.Size = UDim2.new(0, 18, 0, 18)
    thumb.Position = UDim2.new(0, -9, 0, -3)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel = 0
    thumb.ZIndex = 4
    corner(thumb, 9)

    local dragging = false

    local function setVal(val)
        val = math.floor(math.clamp(val, minVal, maxVal))
        local ratio = (val - minVal) / (maxVal - minVal)
        inputBox.Text = tostring(val)
        thumb.Position = UDim2.new(ratio, -9, 0, -3)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        safeCall(function()
            onChanged(val)
        end, "Slider:" .. labelText)
    end

    local function updateFromMouse()
        local mouse = UserInputService:GetMouseLocation()
        local ap = track.AbsolutePosition
        local as = track.AbsoluteSize
        local ratio = math.clamp((mouse.X - ap.X) / as.X, 0, 1)
        setVal(math.floor(minVal + (ratio * (maxVal - minVal))))
    end

    track.MouseButton1Down:Connect(function()
        dragging = true
        updateFromMouse()
    end)

    UserInputService.InputChanged:Connect(function(input)
        if (dragging and ((input.UserInputType == Enum.UserInputType.MouseMovement) or (input.UserInputType == Enum.UserInputType.Touch))) then
            updateFromMouse()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if ((input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch)) then
            dragging = false
        end
    end)

    inputBox.FocusLost:Connect(function()
        local txt = inputBox.Text:gsub("[^0-9]", "")
        if (txt == "") then
            txt = tostring(minVal)
        end
        setVal(tonumber(txt) or minVal)
    end)

    setVal(initial)
end

do
    local p = pgAim
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "玩家自瞄"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 30

    local originalCameraMode = nil
    local originalCameraCFrame = nil
    local scriptLoaded = false
    local aimURL = "https://raw.githubusercontent.com/odhdshhe/bu/refs/heads/main/%E6%9C%88%E4%BA%AE%E5%8A%A0%E5%AF%86%E8%BF%87%E7%9A%84%E6%9E%97%E7%9A%84%E8%87%AA%E7%9E%84.lua"

    createToggle(p, y, "静默自瞄", function()
        return scriptLoaded
    end, function(v)
        if v then
            local cam = workspace.CurrentCamera
            if cam then
                originalCameraMode = cam.CameraType
                originalCameraCFrame = cam.CFrame
            end
            scriptLoaded = SafeLoad(aimURL, "静默自瞄")
            if not scriptLoaded then
                toggleSetters["静默自瞄"](false)
            end
        else
            local cam = workspace.CurrentCamera
            if cam then
                pcall(function()
                    if originalCameraMode then
                        cam.CameraType = originalCameraMode
                    else
                        cam.CameraType = Enum.CameraType.Custom
                    end
                end)
                pcall(function()
                    if originalCameraCFrame then
                        cam.CFrame = originalCameraCFrame
                    end
                end)
            end
            pcall(function()
                getgenv().AimbotEnabled = false
            end)
            pcall(function()
                getgenv().SilentAim = false
            end)
            pcall(function()
                getgenv()._G.AimbotEnabled = false
            end)
            scriptLoaded = false
        end
    end)

    y = y + 46
    local bulletTrackLoaded = false
    local bulletTrackURL = "https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/%E5%AD%90%E8%BF%BD"

    createToggle(p, y, "子弹追踪", function()
        return bulletTrackLoaded
    end, function(v)
        if v then
            bulletTrackLoaded = SafeLoad(bulletTrackURL, "子弹追踪")
            if not bulletTrackLoaded then
                toggleSetters["子弹追踪"](false)
            end
        else
            pcall(function()
                getgenv().BulletTrackEnabled = false
            end)
            pcall(function()
                _G.BulletTrackEnabled = false
            end)
            bulletTrackLoaded = false
        end
    end)
end

do
    local p = pgSpeed
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "人物移速"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 30

    createToggle(p, y, "启用加速", function()
        return FuncState.SpeedEnabled
    end, function(v)
        FuncState.SpeedEnabled = v
        local h = getHumanoid()
        if h then
            h.WalkSpeed = (v and FuncState.SpeedValue) or 16
        end
    end)

    y = y + 46
    createSlider(p, y, "移速 (16-700)", 16, 700, 50, function(v)
        FuncState.SpeedValue = v
    end)

    RunService.Heartbeat:Connect(function()
        if FuncState.SpeedEnabled then
            local h = getHumanoid()
            if (h and (h.WalkSpeed ~= FuncState.SpeedValue)) then
                h.WalkSpeed = FuncState.SpeedValue
            end
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.1)
        local h = char:FindFirstChild("Humanoid")
        if (h and FuncState.SpeedEnabled) then
            h.WalkSpeed = FuncState.SpeedValue
        end
    end)
end

do
    local p = pgESP
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "人物功能"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 30

    createToggle(p, y, "全身透视", function()
        return FuncState.ESPEnabled
    end, function(v)
        FuncState.ESPEnabled = v
    end)

    y = y + 46
    createToggle(p, y, "头顶血条", function()
        return FuncState.HealthBarEnabled
    end, function(v)
        FuncState.HealthBarEnabled = v
    end)

    y = y + 46
    createToggle(p, y, "距离显示", function()
        return FuncState.DistanceEnabled
    end, function(v)
        FuncState.DistanceEnabled = v
    end)

    y = y + 46
    createToggle(p, y, "人物天线", function()
        return FuncState.AntennaEnabled
    end, function(v)
        FuncState.AntennaEnabled = v
    end)

    y = y + 46
    createToggle(p, y, "玩家雷达", function()
        return FuncState.RadarEnabled
    end, function(v)
        FuncState.RadarEnabled = v
    end)

    y = y + 46
    createToggle(p, y, "一键启动", function()
        return FuncState.ESPMaster
    end, function(v)
        FuncState.ESPMaster = v
        FuncState.ESPEnabled = v
        FuncState.HealthBarEnabled = v
        FuncState.DistanceEnabled = v
        FuncState.AntennaEnabled = v
        FuncState.RadarEnabled = v
    end)

    local cache = {}
    local antennaLines = {}
    local useDrawing = pcall(function()
        return Drawing.new("Line")
    end)

    if not useDrawing then
        warn("[人物天线] 当前环境不支持 Drawing，天线将无法使用")
    end

    local radarFrame = nil
    local radarPoints = {}
    local radarRadiusPixels = 85
    local radarWorldRange = 300

    local function createRadar()
        if radarFrame then
            return
        end
        radarFrame = Instance.new("Frame")
        radarFrame.Name = "Radar"
        radarFrame.Size = UDim2.new(0, 180, 0, 180)
        radarFrame.AnchorPoint = Vector2.new(1, 0)
        radarFrame.Position = UDim2.new(1, -10, 0, 10)
        radarFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        radarFrame.BackgroundTransparency = 0.4
        radarFrame.BorderSizePixel = 0
        radarFrame.ClipsDescendants = true
        radarFrame.Visible = false
        radarFrame.ZIndex = 2
        radarFrame.Parent = gui
        corner(radarFrame, 90)

        local cross = Instance.new("Frame", radarFrame)
        cross.Size = UDim2.new(1, 0, 0, 1)
        cross.Position = UDim2.new(0, 0, 0.5, 0)
        cross.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        cross.BackgroundTransparency = 0.6
        cross.BorderSizePixel = 0

        local cross2 = Instance.new("Frame", radarFrame)
        cross2.Size = UDim2.new(0, 1, 1, 0)
        cross2.Position = UDim2.new(0.5, 0, 0, 0)
        cross2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        cross2.BackgroundTransparency = 0.6
        cross2.BorderSizePixel = 0

        local maxDist = radarWorldRange
        local ringDistances = {150, 300}

        for _, dist in ipairs(ringDistances) do
            local ratio = dist / maxDist
            local ring = Instance.new("Frame", radarFrame)
            ring.Size = UDim2.new(2 * ratio, 0, 2 * ratio, 0)
            ring.Position = UDim2.new(0.5 - ratio, 0, 0.5 - ratio, 0)
            ring.BackgroundTransparency = 1
            ring.BorderSizePixel = 1
            ring.BorderColor3 = Color3.fromRGB(255, 255, 255)
            ring.BorderTransparency = 0.4
            ring.Visible = true
            corner(ring, 90)
        end

        local border = Instance.new("Frame", radarFrame)
        border.Size = UDim2.new(1, 0, 1, 0)
        border.BackgroundTransparency = 1
        border.BorderSizePixel = 2
        border.BorderColor3 = Color3.fromRGB(255, 255, 255)
        border.BorderTransparency = 0.2        border.BorderMode = Enum.BorderMode.Inset
        corner(border, 90)
    end

    local function updateRadar()
        if not FuncState.RadarEnabled then
            if radarFrame then
                radarFrame.Visible = false
            end
            for _, point in pairs(radarPoints) do
                point:Destroy()
            end
            radarPoints = {}
            return
        end

        if not radarFrame then
            createRadar()
        end

        if not radarFrame then
            return
        end

        local myRoot = getRootPart()
        if not myRoot then
            radarFrame.Visible = false
            return
        end

        radarFrame.Visible = true
        local myPos = myRoot.Position
        local radarSize = radarFrame.AbsoluteSize

        if ((radarSize.X == 0) or (radarSize.Y == 0)) then
            return
        end

        local maxDist = radarWorldRange

        for _, point in pairs(radarPoints) do
            point:Destroy()
        end
        radarPoints = {}

        local camera = workspace.CurrentCamera
        local camCF = camera.CFrame
        local forward = camCF.LookVector
        forward = Vector3.new(forward.X, 0, forward.Z).Unit
        if forward.Magnitude < 0.01 then forward = Vector3.new(1,0,0) end
        local right = Vector3.new(forward.Z, 0, -forward.X)

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end
            if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
                continue
            end
            if plr.Character then
                local char = plr.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")

                if hrp then
                    local targetPos = hrp.Position
                    local diff = targetPos - myPos
                    local horizontalDist = math.sqrt((diff.X ^ 2) + (diff.Z ^ 2))

                    if (horizontalDist <= maxDist) then
                        local dirWorld = Vector3.new(diff.X, 0, diff.Z).Unit
                        if dirWorld.Magnitude < 0.01 then continue end
                        local fwdComp = dirWorld:Dot(forward)
                        local rightComp = dirWorld:Dot(right)
                        local angle = math.atan2(rightComp, fwdComp)

                        local normalizedDist = horizontalDist / maxDist
                        local pixelOffsetX = normalizedDist * radarRadiusPixels * math.sin(angle)
                        local pixelOffsetY = -normalizedDist * radarRadiusPixels * math.cos(angle)

                        local point = Instance.new("ImageLabel")
                        point.Size = UDim2.new(0, 7, 0, 7)
                        point.AnchorPoint = Vector2.new(0.5, 0.5)
                        point.Position = UDim2.new(0.5, pixelOffsetX, 0.5, pixelOffsetY)
                        point.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                        point.BackgroundTransparency = 0
                        point.BorderSizePixel = 0
                        point.ZIndex = 3
                        point.Parent = radarFrame
                        corner(point, 4)
                        radarPoints[plr] = point
                    end
                end
            end
        end
    end

    local function createHealthBar(head)
        local bb = Instance.new("BillboardGui")
        bb.Name = "ESP_HB"
        bb.Size = UDim2.new(0, 55, 0, 5)
        bb.StudsOffset = Vector3.new(0, 1.3, 0)
        bb.Adornee = head
        bb.AlwaysOnTop = true
        bb.MaxDistance = 500
        bb.Enabled = false
        bb.Parent = head

        local bg = Instance.new("Frame", bb)
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        bg.BackgroundTransparency = 0.15
        bg.BorderSizePixel = 0
        corner(bg, 2)

        local fill = Instance.new("Frame", bb)
        fill.Name = "Fill"
        fill.Size = UDim2.new(1, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 255, 60)
        fill.BorderSizePixel = 0
        fill.ZIndex = 2
        corner(fill, 2)

        return bb
    end

    local function getOrCreateESP(char)
        if (cache[char] and cache[char].hl and (cache[char].hl.Parent == char)) then
            return cache[char].hl, cache[char].hb
        end

        cache[char] = nil
        local oldHL = char:FindFirstChild("ESP_Highlight")
        if oldHL then
            oldHL:Destroy()
        end

        local hl = Instance.new("Highlight")
        hl.Name = "ESP_Highlight"
        hl.Adornee = char
        hl.FillColor = Color3.fromRGB(255, 50, 50)
        hl.FillTransparency = 0.5
        hl.OutlineColor = Color3.fromRGB(255, 100, 100)
        hl.OutlineTransparency = 0.05
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Enabled = false
        hl.Parent = char

        local hb
        local head = char:FindFirstChild("Head")

        if head then
            local oldHB = head:FindFirstChild("ESP_HB")
            if oldHB then
                oldHB:Destroy()
            end
            hb = createHealthBar(head)
        end

        cache[char] = {hl = hl, hb = hb}
        return hl, hb
    end

    local function removeESP(char)
        local entry = cache[char]

        if entry then
            pcall(function()
                if entry.hl then
                    entry.hl:Destroy()
                end
            end)
            pcall(function()
                if entry.hb then
                    entry.hb:Destroy()
                end
            end)
        end

        local hrp = char:FindFirstChild("HumanoidRootPart")

        if hrp then
            local d = hrp:FindFirstChild("ESP_Distance")
            if d then
                d:Destroy()
            end
        end

        cache[char] = nil
    end

    local espFrameCounter = 0
    RunService.RenderStepped:Connect(function()
        espFrameCounter = espFrameCounter + 1
        if espFrameCounter % 2 ~= 0 then return end

        safeCall(function()
            local myRoot = getRootPart()

            if (not FuncState.AntennaEnabled or not myRoot) then
                for _, line in pairs(antennaLines) do
                    pcall(function()
                        line:Remove()
                    end)
                end
                antennaLines = {}
            end

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr == LocalPlayer then continue end
                if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
                    continue
                end
                if plr.Character then
                    local char = plr.Character
                    local hum = char:FindFirstChild("Humanoid")
                    local head = char:FindFirstChild("Head")

                    if (not hum or (hum.Health <= 0) or not head) then
                        removeESP(char)
                    else
                        local hl, hb = getOrCreateESP(char)

                        if hl then
                            hl.Enabled = FuncState.ESPEnabled
                        end

                        if hb then
                            hb.Enabled = FuncState.HealthBarEnabled

                            if FuncState.HealthBarEnabled then
                                local fill = hb:FindFirstChild("Fill")

                                if fill then
                                    local ratio = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                                    fill.Size = UDim2.new(ratio, 0, 1, 0)

                                    if (ratio > 0.5) then
                                        fill.BackgroundColor3 = Color3.fromRGB(50, 215, 75)
                                    elseif (ratio > 0.25) then
                                        fill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
                                    else
                                        fill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                                    end
                                end

                                if (myRoot and head) then
                                    local dist = (myRoot.Position - head.Position).Magnitude
                                    local scale = math.clamp(8 / math.max(dist, 1), 0.3, 1.3)
                                    local newWidth = math.floor(55 * scale)
                                    local newHeight = math.floor(5 * scale)
                                    hb.Size = UDim2.new(0, newWidth, 0, newHeight)
                                end
                            end
                        end

                        local hrp = char:FindFirstChild("HumanoidRootPart")

                        if (FuncState.DistanceEnabled and hrp and myRoot) then
                            local distStuds = (myRoot.Position - hrp.Position).Magnitude
                            local distMeters = distStuds * 0.28
                            local distGui = hrp:FindFirstChild("ESP_Distance")

                            if not distGui then
                                distGui = Instance.new("BillboardGui")
                                distGui.Name = "ESP_Distance"
                                distGui.Size = UDim2.new(0, 100, 0, 20)
                                distGui.StudsOffset = Vector3.new(0, -3, 0)
                                distGui.Adornee = hrp
                                distGui.AlwaysOnTop = true
                                distGui.MaxDistance = 500
                                distGui.Enabled = true
                                distGui.Parent = hrp

                                local textLabel = Instance.new("TextLabel", distGui)
                                textLabel.Size = UDim2.new(1, 0, 1, 0)
                                textLabel.BackgroundTransparency = 1
                                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                                textLabel.Font = Enum.Font.GothamBold
                                textLabel.TextSize = 13
                                textLabel.TextStrokeTransparency = 0.5
                            else
                                distGui.Enabled = true
                            end

                            local textLabel = distGui:FindFirstChild("TextLabel")

                            if textLabel then
                                textLabel.Text = string.format("%.1f m", distMeters)
                            end
                        elseif hrp then
                            local existing = hrp:FindFirstChild("ESP_Distance")
                            if existing then
                                existing:Destroy()
                            end
                        end

                        -- 人物天线 - 连接到自瞄瞄准位置
                        if (FuncState.AntennaEnabled and myRoot) then
                            local camera = workspace.CurrentCamera
                            if camera then
                                local viewportSize = camera.ViewportSize
                                local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)

                                for _, otherPlr in ipairs(Players:GetPlayers()) do
                                    if otherPlr == LocalPlayer then continue end
                                    if otherPlr.Team and LocalPlayer.Team and otherPlr.Team == LocalPlayer.Team then continue end
                                    local otherChar = otherPlr.Character
                                    if otherChar then
                                        local head = otherChar:FindFirstChild("Head")
                                        if head then
                                            -- 瞄准头部位置（自瞄瞄准点）
                                            local aimPos = head.Position + Vector3.new(0, 0, 0)
                                            local screenPos, onScreen = camera:WorldToScreenPoint(aimPos)
                                            local line = antennaLines[otherPlr]
                                            
                                            if onScreen then
                                                if not line then
                                                    line = Drawing.new("Line")
                                                    line.Thickness = 2
                                                    line.Color = Color3.new(1, 1, 1)
                                                    line.Transparency = 1
                                                    line.Visible = true
                                                    antennaLines[otherPlr] = line
                                                end
                                                line.From = center
                                                line.To = Vector2.new(screenPos.X, screenPos.Y)
                                                line.Visible = true
                                            elseif line then
                                                line.Visible = false
                                            end
                                        end
                                    end
                                end

                                for otherPlr, line in pairs(antennaLines) do
                                    if not otherPlr.Character or not otherPlr.Character:FindFirstChild("Head") then
                                        pcall(function() line:Remove() end)
                                        antennaLines[otherPlr] = nil
                                    end
                                end
                            end
                        else
                            for _, line in pairs(antennaLines) do
                                pcall(function() line:Remove() end)
                            end
                            antennaLines = {}
                        end
                    end
                end
            end

            updateRadar()
        end, "ESP")
    end)

    Players.PlayerRemoving:Connect(function(plr)
        if plr.Character then
            removeESP(plr.Character)
        end

        local line = antennaLines[plr]
        if line then
            pcall(function()
                line:Remove()
            end)
            antennaLines[plr] = nil
        end

        local point = radarPoints[plr]
        if point then
            point:Destroy()
            radarPoints[plr] = nil
        end
    end)
end

do
    local p = pgFly
    local y = 20
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "shible · 飞行"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 36

    local execBtn = Instance.new("TextButton", p)
    execBtn.Text = "启动飞行"
    execBtn.Font = Enum.Font.GothamSemibold
    execBtn.TextSize = 14
    execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    execBtn.BackgroundColor3 = Theme.Glass
    execBtn.BackgroundTransparency = 0.2
    execBtn.AutoButtonColor = false
    execBtn.Position = UDim2.new(0, 12, 0, y)
    execBtn.Size = UDim2.new(1, -24, 0, 40)
    corner(execBtn, 10)
    pressEffect(execBtn)

    local function notify(title, text)
        task.spawn(function()
            for i = 1, 5 do
                local ok = pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = title,
                        Text = text,
                        Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150",
                        Duration = 2
                    })
                end)

                if ok then
                    break
                end

                task.wait(0.2)
            end
        end)
    end

    execBtn.MouseButton1Click:Connect(function()
        makeTween(execBtn, {TextSize = 16}, 0.12)
        task.delay(0.12, function()
            makeTween(execBtn, {TextSize = 14}, 0.15)
        end)
        notify("IOS脚本", "创作者：shible")

        task.spawn(function()
            local ok, err = pcall(function()
                local fg = Instance.new("ScreenGui")
                fg.Name = "shible_Fly"
                fg.ResetOnSpawn = false
                fg.Parent = LocalPlayer:WaitForChild("PlayerGui")

                local f = Instance.new("Frame", fg)
                f.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
                f.BorderColor3 = Color3.fromRGB(103, 221, 213)
                f.Position = UDim2.new(0.1, 0, 0.38, 0)
                f.Size = UDim2.new(0, 190, 0, 57)
                f.Active = true
                f.Draggable = true

                local up = Instance.new("TextButton", f)
                up.Size = UDim2.new(0, 44, 0, 28)
                up.Text = "上升"
                up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)

                local down = Instance.new("TextButton", f)
                down.Size = UDim2.new(0, 44, 0, 28)
                down.Position = UDim2.new(0, 0, 0.49, 0)
                down.Text = "下落"
                down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)

                local onof = Instance.new("TextButton", f)
                onof.Size = UDim2.new(0, 56, 0, 28)
                onof.Position = UDim2.new(0.7, 0, 0.49, 0)
                onof.Text = "飞"
                onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)

                local tl = Instance.new("TextLabel", f)
                tl.Size = UDim2.new(0, 100, 0, 28)
                tl.Position = UDim2.new(0.47, 0, 0, 0)
                tl.Text = "shible"
                tl.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
                tl.TextScaled = true

                local plus = Instance.new("TextButton", f)
                plus.Size = UDim2.new(0, 45, 0, 28)
                plus.Position = UDim2.new(0.23, 0, 0, 0)
                plus.Text = "+"
                plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
                plus.TextScaled = true

                local spd = Instance.new("TextLabel", f)
                spd.Size = UDim2.new(0, 44, 0, 28)
                spd.Position = UDim2.new(0.47, 0, 0.49, 0)
                spd.Text = "1"
                spd.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
                spd.TextScaled = true

                local mine = Instance.new("TextButton", f)
                mine.Size = UDim2.new(0, 45, 0, 29)
                mine.Position = UDim2.new(0.23, 0, 0.49, 0)
                mine.Text = "-"
                mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
                mine.TextScaled = true

                local xbtn = Instance.new("TextButton", f)
                xbtn.Size = UDim2.new(0, 45, 0, 28)
                xbtn.Position = UDim2.new(0, 0, -1, 27)
                xbtn.Text = "X"
                xbtn.TextSize = 30
                xbtn.BackgroundColor3 = Color3.fromRGB(225, 25, 0)

                local mini = Instance.new("TextButton", f)
                mini.Size = UDim2.new(0, 45, 0, 28)
                mini.Position = UDim2.new(0, 44, -1, 27)
                mini.Text = "-"
                mini.TextSize = 40
                mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)

                local mini2 = Instance.new("TextButton", f)
                mini2.Size = UDim2.new(0, 45, 0, 28)
                mini2.Position = UDim2.new(0, 44, 0, 30)
                mini2.Text = "+"
                mini2.TextSize = 40
                mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
                mini2.Visible = false

                for _, btn in ipairs(f:GetDescendants()) do
                    if btn:IsA("TextButton") then
                        btn.AutoButtonColor = false
                        btn.SelectionImageObject = nil
                        btn.Selectable = false
                    end
                end

                local speeds = 1
                local nowe = false
                local chr = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hum = chr:FindFirstChildOfClass("Humanoid")
                local moveConn, renderConn, bgObj, bvObj

                xbtn.MouseButton1Click:Connect(function()
                    fg:Destroy()
                end)

                up.MouseButton1Click:Connect(function()
                    if (chr and chr:FindFirstChild("HumanoidRootPart")) then
                        chr.HumanoidRootPart.CFrame = chr.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    end
                end)

                down.MouseButton1Click:Connect(function()
                    if (chr and chr:FindFirstChild("HumanoidRootPart")) then
                        chr.HumanoidRootPart.CFrame = chr.HumanoidRootPart.CFrame + Vector3.new(0, -3, 0)
                    end
                end)

                mini.MouseButton1Click:Connect(function()
                    for _, v in ipairs({up, down, onof, plus, spd, mine, xbtn}) do
                        v.Visible = false
                    end
                    mini.Visible = false
                    mini2.Visible = true
                    f.Size = UDim2.new(0, 100, 0, 28)
                    tl.Position = UDim2.new(0, 0, 0, 0)
                end)

                mini2.MouseButton1Click:Connect(function()
                    for _, v in ipairs({up, down, onof, plus, spd, mine, xbtn}) do
                        v.Visible = true
                    end
                    mini.Visible = true
                    mini2.Visible = false
                    f.Size = UDim2.new(0, 190, 0, 57)
                    tl.Position = UDim2.new(0.47, 0, 0, 0)
                end)

                plus.MouseButton1Click:Connect(function()
                    speeds = speeds + 1
                    spd.Text = tostring(speeds)
                end)

                mine.MouseButton1Click:Connect(function()
                    if (speeds > 1) then
                        speeds = speeds - 1
                        spd.Text = tostring(speeds)
                    else
                        spd.Text = "错误"
                        task.wait(0.2)
                        spd.Text = "1"
                    end
                end)

                local function resetHum()
                    if hum then
                        pcall(function()
                            for _, s in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                                hum:SetStateEnabled(s, true)
                            end
                            hum.PlatformStand = false
                            hum:ChangeState(Enum.HumanoidStateType.Running)
                        end)
                    end

                    local anim = chr and chr:FindFirstChild("Animate")
                    if anim then
                        anim.Disabled = false
                    end
                end

                local function stopFly()
                    if moveConn then
                        pcall(function()
                            moveConn:Disconnect()
                        end)
                        moveConn = nil
                    end

                    if renderConn then
                        pcall(function()
                            renderConn:Disconnect()
                        end)
                        renderConn = nil
                    end

                    if bgObj then
                        pcall(function()
                            bgObj:Destroy()
                        end)
                        bgObj = nil
                    end

                    if bvObj then
                        pcall(function()
                            bvObj:Destroy()
                        end)
                        bvObj = nil
                    end

                    resetHum()
                end

                local function startFly()
                    stopFly()
                    chr = LocalPlayer.Character
                    hum = chr and chr:FindFirstChildOfClass("Humanoid")

                    if not hum then
                        return
                    end

                    pcall(function()
                        for _, s in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                            hum:SetStateEnabled(s, false)
                        end
                        hum:ChangeState(Enum.HumanoidStateType.Swimming)
                    end)

                    local anim = chr:FindFirstChild("Animate")
                    if anim then
                        anim.Disabled = true
                    end

                    moveConn = RunService.Heartbeat:Connect(function()
                        if (not nowe or not hum or (hum.Health <= 0)) then
                            return
                        end

                        if (hum.MoveDirection.Magnitude > 0) then
                            chr:TranslateBy(hum.MoveDirection * speeds)
                        end
                    end)

                    local torso = chr:FindFirstChild("Torso") or chr:FindFirstChild("UpperTorso")

                    if torso then
                        bgObj = Instance.new("BodyGyro", torso)
                        bgObj.P = 90000
                        bgObj.MaxTorque = Vector3.new(8999999488, 8999999488, 8999999488)

                        bvObj = Instance.new("BodyVelocity", torso)
                        bvObj.Velocity = Vector3.zero
                        bvObj.MaxForce = Vector3.new(8999999488, 8999999488, 8999999488)

                        renderConn = RunService.RenderStepped:Connect(function()
                            if (not nowe or not torso.Parent) then
                                stopFly()
                                return
                            end
                            bgObj.CFrame = workspace.CurrentCamera.CoordinateFrame
                        end)
                    end
                end

                LocalPlayer.CharacterAdded:Connect(function(c)
                    nowe = false
                    onof.Text = "飞"
                    chr = c
                    hum = chr:WaitForChild("Humanoid", 5)
                    stopFly()
                end)

                onof.MouseButton1Click:Connect(function()
                    nowe = not nowe
                    onof.Text = (nowe and "停") or "飞"

                    if nowe then
                        startFly()
                    else
                        stopFly()
                    end
                end)
            end)

            if not ok then
                notify("加载失败", tostring(err))
            end
        end)
    end)
end

do
    local p = pgFun
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "娱乐"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left

    y = y + 36
    createToggle(p, y, "旋转", function()
        return FuncState.SpinEnabled
    end, function(v)
        FuncState.SpinEnabled = v
    end)

    y = y + 50
    createSlider(p, y, "旋转倍数 (10-999)", 10, 999, 50, function(v)
        FuncState.SpinSpeed = v
    end)

    y = y + 50
    createToggle(p, y, "甩飞所有", function()
        return FuncState.FlingLoaded
    end, function(v)
        if v then
            FuncState.FlingLoaded = SafeLoad("https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/%E7%94%A9%E9%A3%9E", "甩飞所有")
            if not FuncState.FlingLoaded then
                toggleSetters["甩飞所有"](false)
            end
        else
            pcall(function()
                getgenv().FlingAllEnabled = false
            end)
            pcall(function()
                _G.FlingAllEnabled = false
            end)
            FuncState.FlingLoaded = false
        end
    end)

    y = y + 42
    createToggle(p, y, "防掉落伤害", function() return FuncState.AntiFall end, function(v)
        FuncState.AntiFall = v
        if v then
            local char = getChar()
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local conn
                conn = RunService.Heartbeat:Connect(function()
                    if not FuncState.AntiFall or not root or not root.Parent then
                        if conn then conn:Disconnect() end
                        return
                    end
                    local vel = root.AssemblyLinearVelocity
                    root.AssemblyLinearVelocity = Vector3.zero
                    task.wait(0.016)
                    root.AssemblyLinearVelocity = vel
                end)
                if not p._antiFallConn then p._antiFallConn = {} end
                p._antiFallConn[char] = conn
            end
        else
            if p._antiFallConn then
                for char, conn in pairs(p._antiFallConn) do
                    if conn then conn:Disconnect() end
                end
                p._antiFallConn = {}
            end
        end
    end)

    y = y + 42
    createButton(p, y, "黑洞", function()
        SafeLoad("https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/%E9%BB%91%E6%B4%9E", "黑洞")
    end)

    RunService.RenderStepped:Connect(function(dt)
        safeCall(function()
            if not FuncState.SpinEnabled then
                return
            end
            local rp = getRootPart()
            if rp then
                rp.CFrame = rp.CFrame * CFrame.Angles(0, math.rad((FuncState.SpinSpeed or 50) * dt * 60), 0)
            end
        end, "Spin")
    end)
end

do
    local p = pgAction
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "人物动作"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 36

    local function addActionBtn(label, id)
        local btn = Instance.new("TextButton", p)
        btn.Size = UDim2.new(1, -24, 0, 32)
        btn.Position = UDim2.new(0, 12, 0, y)
        btn.BackgroundColor3 = Theme.Glass
        btn.BackgroundTransparency = 0.4
        btn.Text = label
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.TextColor3 = Theme.TextPrimary
        btn.AutoButtonColor = false
        corner(btn, 8)
        pressEffect(btn)
        btn.MouseButton1Click:Connect(function()
            local char = getChar()
            if char and char:FindFirstChildOfClass("Humanoid") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://" .. id
                local track = hum:LoadAnimation(anim)
                track:Play()
                table.insert(animTracks, track)
            end
        end)
        return btn
    end

    local actions = {
        {"环绕身体动作", "109873544976020"},
        {"无头", "78837807518622"},
        {"直升机", "95301257497525"},
        {"飞机", "82135680487389"},
        {"坦克", "94915612757079"},
        {"假死", "88130117312312"},
        {"投降", "100537772865440"},
    }

    for _, act in ipairs(actions) do
        addActionBtn(act[1], act[2])
        y = y + 42
    end

    -- 添加 r6道馆 和 r15道馆
    createButton(p, y, "r6道馆", function()
        SafeLoad("https://pastefy.app/wa3v2Vgm/raw", "r6道馆")
    end)
    y = y + 42

    createButton(p, y, "r15道馆", function()
        SafeLoad("https://pastefy.app/YZoglOyJ/raw", "r15道馆")
    end)
    y = y + 42

    local closeBtnAction = Instance.new("TextButton", p)
    closeBtnAction.Size = UDim2.new(1, -24, 0, 32)
    closeBtnAction.Position = UDim2.new(0, 12, 0, y)
    closeBtnAction.BackgroundColor3 = Theme.Glass
    closeBtnAction.BackgroundTransparency = 0.4
    closeBtnAction.Text = "停止所有动作"
    closeBtnAction.Font = Enum.Font.Gotham
    closeBtnAction.TextSize = 14
    closeBtnAction.TextColor3 = Theme.TextPrimary
    closeBtnAction.AutoButtonColor = false
    corner(closeBtnAction, 8)
    pressEffect(closeBtnAction)
    closeBtnAction.MouseButton1Click:Connect(function()
        for _, track in ipairs(animTracks) do
            pcall(function()
                track:Stop()
                track:Destroy()
            end)
        end
        animTracks = {}
        local char = getChar()
        if char and char:FindFirstChildOfClass("Humanoid") then
            local hum = char:FindFirstChildOfClass("Humanoid")
            pcall(function()
                hum:LoadAnimation(Instance.new("Animation")):Stop()
            end)
        end
        Notify("shible", "已停止所有动作", 2)
    end)
end

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
        local char = getChar()
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0 end
        end
    end)
end

do
    local p = pgServer
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "服务器缝合"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left

    local serverName = Instance.new("TextLabel", p)
    serverName.Text = "加载中..."
    serverName.Font = Enum.Font.Gotham
    serverName.TextSize = 13
    serverName.TextColor3 = Theme.TextSecondary
    serverName.BackgroundTransparency = 1
    serverName.Position = UDim2.new(0, 12, 0, y + 30)
    serverName.Size = UDim2.new(1, -24, 0, 20)
    serverName.TextXAlignment = Enum.TextXAlignment.Left

    task.spawn(function()
        local ok, info = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        if ok and info then
            serverName.Text = "当前服务器: " .. info.Name
        else
            serverName.Text = "当前服务器: 未知"
        end
    end)

    y = y + 60

    local div1 = Instance.new("Frame", p)
    div1.Size = UDim2.new(1, -24, 0, 1)
    div1.Position = UDim2.new(0, 12, 0, y)
    div1.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    div1.BorderSizePixel = 0
    y = y + 16

    local inkBtn = Instance.new("TextButton", p)
    inkBtn.Size = UDim2.new(1, -24, 0, 32)
    inkBtn.Position = UDim2.new(0, 12, 0, y)
    inkBtn.BackgroundColor3 = Theme.Glass
    inkBtn.BackgroundTransparency = 0.4
    inkBtn.Text = "墨水游戏（Rb）"
    inkBtn.Font = Enum.Font.Gotham
    inkBtn.TextSize = 14
    inkBtn.TextColor3 = Theme.TextPrimary
    inkBtn.AutoButtonColor = false
    corner(inkBtn, 8)
    pressEffect(inkBtn)
    inkBtn.MouseButton1Click:Connect(function()
        SafeLoad("https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/ink", "墨水游戏")
    end)

    y = y + 42
    local qbBtn = Instance.new("TextButton", p)
    qbBtn.Size = UDim2.new(1, -24, 0, 32)
    qbBtn.Position = UDim2.new(0, 12, 0, y)
    qbBtn.BackgroundColor3 = Theme.Glass
    qbBtn.BackgroundTransparency = 0.4
    qbBtn.Text = "QB火箭发射器"
    qbBtn.Font = Enum.Font.Gotham
    qbBtn.TextSize = 14
    qbBtn.TextColor3 = Theme.TextPrimary
    qbBtn.AutoButtonColor = false
    corner(qbBtn, 8)
    pressEffect(qbBtn)
    qbBtn.MouseButton1Click:Connect(function()
        SafeLoad("https://raw.githubusercontent.com/xinhaoxian2/QB/main/QB%E7%81%AB%E7%AE%AD%E5%8F%91%E5%B0%84%E6%A8%A1%E6%8B%9F%E5%99%A8.lua", "QB火箭发射器")
    end)

    y = y + 42
    local dizzyBtn = Instance.new("TextButton", p)
    dizzyBtn.Size = UDim2.new(1, -24, 0, 32)
    dizzyBtn.Position = UDim2.new(0, 12, 0, y)
    dizzyBtn.BackgroundColor3 = Theme.Glass
    dizzyBtn.BackgroundTransparency = 0.4
    dizzyBtn.Text = "Dizzy HUB脚本"
    dizzyBtn.Font = Enum.Font.Gotham
    dizzyBtn.TextSize = 14
    dizzyBtn.TextColor3 = Theme.TextPrimary
    dizzyBtn.AutoButtonColor = false
    corner(dizzyBtn, 8)
    pressEffect(dizzyBtn)
    dizzyBtn.MouseButton1Click:Connect(function()
        SafeLoad("https://raw.githubusercontent.com/dizyhvh/rbx_scripts/main/321_blast_off_simulator", "Dizzy HUB")
    end)
end

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

createFuncItem("自瞄", "Aim")
createFuncItem("移速", "Speed")
createFuncItem("人物功能", "ESP")
createFuncItem("飞行", "Fly")
createFuncItem("娱乐", "Fun")
createFuncItem("人物动作", "Action")
createFuncItem("服务器缝合", "Server")
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

        if waterWalkConnection then
            waterWalkConnection:Disconnect()
            waterWalkConnection = nil
        end
        if pgFun._antiFallConn then
            for _, conn in pairs(pgFun._antiFallConn) do
                if conn then conn:Disconnect() end
            end
            pgFun._antiFallConn = {}
        end
        local h = getHumanoid()
        if h then
            h.WalkSpeed = 16
        end
        for _, track in ipairs(animTracks) do
            pcall(function()
                track:Stop()
                track:Destroy()
            end)
        end
        animTracks = {}
        for _, line in pairs(antennaLines) do
            pcall(function() line:Remove() end)
        end
        antennaLines = {}
        for _, point in pairs(radarPoints) do
            pcall(function() point:Destroy() end)
        end
        radarPoints = {}
        for char, entry in pairs(cache) do
            pcall(function()
                if entry.hl then entry.hl:Destroy() end
                if entry.hb then entry.hb:Destroy() end
            end)
        end
        cache = {}
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
            if waterWalkConnection then
                waterWalkConnection:Disconnect()
                waterWalkConnection = nil
            end
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
            local char = getChar()
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = 16
                    hum.JumpPower = 50
                end
            end
        end)
    end
end)
