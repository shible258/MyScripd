local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

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

local pgJailbreak = createPage("Jailbreak")
local pgAnti = createPage("Anti")

local FuncState = {
    SpeedHack = false,
    SpeedValue = 80,
    NoClip = false,
    InfiniteAmmo = false,
    ShieldForever = false,
    Aimbot = false,
    ESP = false,
    InstantArrest = false,
    -- Anti detection
    AntiDetect = true,
    AdminDetect = true,
    BypassGroup = true,
    BypassAC = true,
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

-- 辅助函数
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoid()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- ==================== 监狱人生页面 ====================
do
    local p = pgJailbreak
    local y = 10
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "监狱人生 · 功能"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 30

    -- 加速滑块
    createSlider(p, y, "移速 (16-700)", 16, 700, 80, function(v)
        FuncState.SpeedValue = v
        if FuncState.SpeedHack then
            local hum = getHumanoid()
            if hum then
                hum.WalkSpeed = v
            end
        end
    end)

    y = y + 60

    -- 加速开关（启用/禁用加速）
    createToggle(p, y, "启用加速", function() return FuncState.SpeedHack end, function(v)
        FuncState.SpeedHack = v
        local hum = getHumanoid()
        if hum then
            hum.WalkSpeed = v and FuncState.SpeedValue or 16
        end
        Notify("监狱", "加速 " .. (v and "开启" or "关闭"))
        if v then
            LocalPlayer.CharacterAdded:Connect(function(char)
                task.wait(0.5)
                local h = char:FindFirstChildOfClass("Humanoid")
                if h and FuncState.SpeedHack then
                    h.WalkSpeed = FuncState.SpeedValue
                end
            end)
        end
    end)

    y = y + 46

    -- 穿墙（所有部件穿透，除地板/地面外）
    createToggle(p, y, "穿墙", function() return FuncState.NoClip end, function(v)
        FuncState.NoClip = v
        local char = getChar()
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    -- 排除地板（根据名称或层级）
                    local isFloor = false
                    if part.Name:lower():find("floor") or part.Name:lower():find("ground") or part.Name:lower():find("terrain") then
                        isFloor = true
                    end
                    -- 如果是地板且是开启穿墙，保持碰撞
                    if isFloor and v then
                        part.CanCollide = true
                    else
                        part.CanCollide = not v
                    end
                end
            end
        end
        Notify("监狱", "穿墙 " .. (v and "开启" or "关闭"))
        -- 持续刷新
        if v then
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not FuncState.NoClip then conn:Disconnect() return end
                local c = getChar()
                if c then
                    for _, part in ipairs(c:GetDescendants()) do
                        if part:IsA("BasePart") then
                            local isFloor = false
                            if part.Name:lower():find("floor") or part.Name:lower():find("ground") or part.Name:lower():find("terrain") then
                                isFloor = true
                            end
                            if not isFloor then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        else
            -- 恢复所有碰撞
            local char = getChar()
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end)

    y = y + 46

    -- 无限子弹 + 极速射速（修复）
    createToggle(p, y, "无限子弹+极速射速", function() return FuncState.InfiniteAmmo end, function(v)
        FuncState.InfiniteAmmo = v
        -- 处理当前工具
        local char = getChar()
        if char then
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    -- 深度遍历所有属性
                    for _, obj in ipairs(tool:GetDescendants()) do
                        if obj:IsA("IntValue") and (obj.Name == "Ammo" or obj.Name == "Ammunition") then
                            obj.Value = 9999
                        end
                        if obj:IsA("NumberValue") and (obj.Name == "FireRate" or obj.Name == "RateOfFire" or obj.Name == "Cooldown" or obj.Name == "ReloadTime") then
                            obj.Value = 0.001
                        end
                        -- 尝试属性（如果存在）
                        if tool:FindFirstChild("Ammo") then
                            local ammo = tool.Ammo
                            if ammo:IsA("IntValue") then ammo.Value = 9999 end
                        end
                    end
                end
            end
        end
        -- 持续监听新工具
        if v then
            local function onChildAdded(child)
                if child:IsA("Tool") then
                    task.wait(0.1)
                    for _, obj in ipairs(child:GetDescendants()) do
                        if obj:IsA("IntValue") and (obj.Name == "Ammo" or obj.Name == "Ammunition") then
                            obj.Value = 9999
                        end
                        if obj:IsA("NumberValue") and (obj.Name == "FireRate" or obj.Name == "RateOfFire" or obj.Name == "Cooldown" or obj.Name == "ReloadTime") then
                            obj.Value = 0.001
                        end
                    end
                    if child:FindFirstChild("Ammo") then
                        local ammo = child.Ammo
                        if ammo:IsA("IntValue") then ammo.Value = 9999 end
                    end
                end
            end
            LocalPlayer.CharacterAdded:Connect(function(char)
                char.ChildAdded:Connect(onChildAdded)
            end)
            -- 持续刷新
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not FuncState.InfiniteAmmo then conn:Disconnect() return end
                local c = getChar()
                if c then
                    for _, tool in ipairs(c:GetChildren()) do
                        if tool:IsA("Tool") then
                            for _, obj in ipairs(tool:GetDescendants()) do
                                if obj:IsA("IntValue") and (obj.Name == "Ammo" or obj.Name == "Ammunition") then
                                    obj.Value = 9999
                                end
                                if obj:IsA("NumberValue") and (obj.Name == "FireRate" or obj.Name == "RateOfFire" or obj.Name == "Cooldown" or obj.Name == "ReloadTime") then
                                    obj.Value = 0.001
                                end
                            end
                            if tool:FindFirstChild("Ammo") then
                                local ammo = tool.Ammo
                                if ammo:IsA("IntValue") then ammo.Value = 9999 end
                            end
                        end
                    end
                end
            end)
        end
        Notify("娱乐", "无限子弹+极速射速 " .. (v and "开启" or "关闭"))
    end)

    y = y + 46

    -- 永久护盾（修复）
    createToggle(p, y, "永久护盾", function() return FuncState.ShieldForever end, function(v)
        FuncState.ShieldForever = v
        if v then
            local char = getChar()
            if char then
                for _, child in ipairs(char:GetChildren()) do
                    if child:IsA("ForceField") then
                        child.TimeToDie = math.huge
                    end
                end
            end
            -- 监听所有新出现的ForceField
            local function onForceFieldAdded(obj)
                if obj:IsA("ForceField") then
                    obj.TimeToDie = math.huge
                end
            end
            -- 监听角色新增子项
            LocalPlayer.CharacterAdded:Connect(function(char)
                char.ChildAdded:Connect(onForceFieldAdded)
                -- 检查已有的
                for _, child in ipairs(char:GetChildren()) do
                    if child:IsA("ForceField") then
                        child.TimeToDie = math.huge
                    end
                end
            end)
            -- 也监听Workspace中的护盾（可能由其他脚本生成）
            -- 但主要看角色身上
        end
        Notify("娱乐", "永久护盾 " .. (v and "开启" or "关闭"))
    end)

    y = y + 46

    -- 立即逮捕（点击玩家重生）
    local arrestBtn = Instance.new("TextButton", p)
    arrestBtn.Size = UDim2.new(1, -24, 0, 36)
    arrestBtn.Position = UDim2.new(0, 12, 0, y)
    arrestBtn.BackgroundColor3 = Theme.Glass
    arrestBtn.BackgroundTransparency = 0.4
    arrestBtn.Text = "立即逮捕（点击目标）"
    arrestBtn.Font = Enum.Font.GothamSemibold
    arrestBtn.TextSize = 14
    arrestBtn.TextColor3 = Theme.TextPrimary
    arrestBtn.AutoButtonColor = false
    corner(arrestBtn, 8)
    pressEffect(arrestBtn)

    local arrestMode = false
    arrestBtn.MouseButton1Click:Connect(function()
        arrestMode = not arrestMode
        arrestBtn.BackgroundColor3 = arrestMode and Color3.fromRGB(255, 0, 0) or Theme.Glass
        arrestBtn.Text = arrestMode and "逮捕模式（点击玩家）" or "立即逮捕（点击目标）"
        Notify("监狱", arrestMode and "逮捕模式已开启，点击玩家逮捕" or "逮捕模式已关闭")
        if arrestMode then
            -- 连接鼠标点击
            local connection
            connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mouse = UserInputService:GetMouseLocation()
                    -- 获取鼠标下的对象
                    local target = game:GetService("CoreGui"):FindFirstChildWhichIsA("ScreenGui") -- 用其他方式
                    -- 更好的方式：使用Workspace.CurrentCamera:ScreenPointToRay
                    local camera = workspace.CurrentCamera
                    local ray = camera:ScreenPointToRay(mouse.X, mouse.Y)
                    local hit, position = workspace:FindPartOnRay(ray, LocalPlayer.Character)
                    if hit then
                        local character = hit.Parent
                        if character and character:FindFirstChild("Humanoid") then
                            local plr = Players:GetPlayerFromCharacter(character)
                            if plr and plr ~= LocalPlayer then
                                local hum = character:FindFirstChildOfClass("Humanoid")
                                if hum then
                                    hum.Health = 0
                                    Notify("监狱", "逮捕了 " .. plr.Name, 2)
                                    arrestMode = false
                                    arrestBtn.BackgroundColor3 = Theme.Glass
                                    arrestBtn.Text = "立即逮捕（点击目标）"
                                    connection:Disconnect()
                                end
                            end
                        end
                    end
                end
            end)
            -- 保存连接以便取消
            arrestBtn._connection = connection
        else
            if arrestBtn._connection then
                arrestBtn._connection:Disconnect()
                arrestBtn._connection = nil
            end
        end
    end)

    y = y + 50

    -- 其他占位功能（自瞄、透视）
    createToggle(p, y, "自动瞄准", function() return FuncState.Aimbot end, function(v)
        FuncState.Aimbot = v
        Notify("监狱", "自瞄 " .. (v and "开启" or "关闭") .. "（需适配游戏）")
    end)

    y = y + 46
    createToggle(p, y, "透视", function() return FuncState.ESP end, function(v)
        FuncState.ESP = v
        Notify("监狱", "透视 " .. (v and "开启" or "关闭") .. "（需适配游戏）")
    end)

    y = y + 46
    local info = Instance.new("TextLabel", p)
    info.Text = "加速滑块可调，穿墙避开地板，无限子弹/护盾已修复，逮捕点击生效。"
    info.Font = Enum.Font.Gotham
    info.TextSize = 12
    info.TextColor3 = Theme.TextSecondary
    info.BackgroundTransparency = 1
    info.Position = UDim2.new(0, 16, 0, y)
    info.Size = UDim2.new(1, -32, 0, 30)
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextWrapped = true
end

-- ==================== 防检测页面（不变） ====================
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
    createToggle(p, y, "开启预防检测", function() return FuncState.AntiDetect end, function(v) FuncState.AntiDetect = v end)
    y = y + 46
    createToggle(p, y, "管理员检测", function() return FuncState.AdminDetect end, function(v) FuncState.AdminDetect = v end)
    y = y + 46
    createToggle(p, y, "绕过群组检测", function() return FuncState.BypassGroup end, function(v) FuncState.BypassGroup = v end)
    y = y + 46
    createToggle(p, y, "绕过AC检测", function() return FuncState.BypassAC end, function(v) FuncState.BypassAC = v end)

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

createFuncItem("监狱人生", "Jailbreak")
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

-- ==================== 其余UI组件 ====================
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
