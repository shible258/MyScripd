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

local API_URL = "https://fcbc2189cfca36aa-112-94-186-50.serveousercontent.com/verify"

local function verifyKeyOnline(key)
    local url = API_URL .. "?key=" .. key
    local response = nil
    local requestFunc = syn and syn.request or http_request or request
    if requestFunc then
        local r = requestFunc({Url = url, Method = "GET"})
        if r and r.Success then
            response = r.Body
        end
    end
    if not response then
        local success, result = pcall(HttpService.GetAsync, HttpService, url)
        if success then
            response = result
        end
    end
    if not response then
        return false, "网络错误"
    end
    local decoded = HttpService:JSONDecode(response)
    if decoded.success then
        return true, nil, decoded.expire_date
    else
        return false, decoded.error or "卡密无效"
    end
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
    Height = 330,
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
    dur = dur or 0.25
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    local t = TweenService:Create(target, TweenInfo.new(dur, style, dir), props)
    t:Play()
    return t
end

local function springTween(target, props, dur)
    dur = dur or C.Duration
    local t = TweenService:Create(target, TweenInfo.new(dur, C.Spring, Enum.EasingDirection.Out), props)
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
        makeTween(btn, {Size = orig}, 0.12, Enum.EasingStyle.Back)
    end)
    btn.MouseLeave:Connect(function()
        makeTween(btn, {Size = orig}, 0.12)
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

local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 50, 1, 50)
shadow.Position = UDim2.new(0, -25, 0, -15)
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.85
shadow.BackgroundTransparency = 1
shadow.ZIndex = -1
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 10, 10)
shadow.Parent = root

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

local expireLabel = Instance.new("TextLabel")
expireLabel.Text = "🔒 等待验证"
expireLabel.Font = Enum.Font.Gotham
expireLabel.TextSize = 12
expireLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
expireLabel.BackgroundTransparency = 1
expireLabel.Position = UDim2.new(0.35, 0, 0, 0)
expireLabel.Size = UDim2.new(0.3, 0, 1, 0)
expireLabel.TextXAlignment = Enum.TextXAlignment.Center
expireLabel.Parent = nav

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
subtitle.Text = "欢迎使用 shible 脚本\n群: 434448780"
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

local pgAnti = createPage("Anti")
local pgServer = createPage("Server")

local FuncState = {
    KickProtect = false,
    WaterWalk = false,
    TeleportPoints = {},
    SelectedPoint = nil,
    SavedPointName = "",
    ActionAnims = {
        ["无头"] = "78837807518622",
        ["直升机"] = "95301257497525",
        ["飞机"] = "82135680487389",
        ["坦克"] = "94915612757079",
        ["假死"] = "88130117312312",
        ["投降"] = "100537772865440",
        ["环绕身体"] = "109873544976020",
    }
}

local waterWalkConnection = nil
local kickHook = nil
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
        track.BackgroundColor3 = Theme.Accent
        thumb.Position = UDim2.new(1, -25, 0, 3)
    end

    local function setState(val)
        on = val
        if on then
            makeTween(track, {BackgroundColor3 = Theme.Accent}, 0.2)
            makeTween(thumb, {Position = UDim2.new(1, -25, 0, 3)}, 0.2)
        else
            makeTween(track, {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}, 0.2)
            makeTween(thumb, {Position = UDim2.new(0, 3, 0, 3)}, 0.2)
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

local function createDropdown(parent, yPos, labelText, values, defaultVal, callback)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -24, 0, 54)
    row.Position = UDim2.new(0, 12, 0, yPos)
    row.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", row)
    lbl.Text = labelText
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextColor3 = Theme.TextSecondary
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local dropdown = Instance.new("TextBox", row)
    dropdown.Size = UDim2.new(1, 0, 0, 30)
    dropdown.Position = UDim2.new(0, 0, 0, 20)
    dropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    dropdown.TextColor3 = Theme.TextPrimary
    dropdown.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 14
    dropdown.BorderSizePixel = 0
    corner(dropdown, 6)
    dropdown.ClearTextOnFocus = false

    local currentVal = defaultVal or (values and values[1]) or ""
    dropdown.Text = currentVal
    callback(currentVal)

    local listFrame = Instance.new("Frame", row)
    listFrame.Size = UDim2.new(1, 0, 0, 0)
    listFrame.Position = UDim2.new(0, 0, 0, 50)
    listFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    listFrame.BorderSizePixel = 0
    listFrame.ClipsDescendants = true
    listFrame.Visible = false
    corner(listFrame, 6)

    local listLayout = Instance.new("UIListLayout", listFrame)
    listLayout.Padding = UDim.new(0, 2)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function updateList()
        for _, child in ipairs(listFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        listFrame.Size = UDim2.new(1, 0, 0, math.min(#values * 30, 120))
        for _, val in ipairs(values or {}) do
            local item = Instance.new("TextButton", listFrame)
            item.Size = UDim2.new(1, 0, 0, 30)
            item.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            item.Text = val
            item.TextColor3 = Theme.TextPrimary
            item.Font = Enum.Font.Gotham
            item.TextSize = 13
            item.BorderSizePixel = 0
            item.AutoButtonColor = false
            item.MouseButton1Click:Connect(function()
                dropdown.Text = val
                currentVal = val
                listFrame.Visible = false
                callback(val)
            end)
        end
    end

    dropdown.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            listFrame.Visible = not listFrame.Visible
            if listFrame.Visible then
                updateList()
            end
        end
    end)

    return {
        SetValues = function(newValues)
            values = newValues
            if #values > 0 then
                currentVal = values[1]
                dropdown.Text = currentVal
                callback(currentVal)
            end
        end,
        SetValue = function(val)
            currentVal = val
            dropdown.Text = val
            callback(val)
        end,
        GetValue = function()
            return currentVal
        end
    }
end

do
    local p = pgAnti
    local y = 20
    local hdr = Instance.new("TextLabel", p)
    hdr.Text = "防检测"
    hdr.Font = Enum.Font.GothamSemibold
    hdr.TextSize = 14
    hdr.TextColor3 = Theme.TextPrimary
    hdr.BackgroundTransparency = 1
    hdr.Position = UDim2.new(0, 12, 0, y)
    hdr.Size = UDim2.new(1, -24, 0, 20)
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 30

    createToggle(p, y, "拦截踢出", function()
        return FuncState.KickProtect
    end, function(v)
        FuncState.KickProtect = v
        if v then
            if not kickHook then
                local oldKick = LocalPlayer.Kick
                kickHook = hookfunction(LocalPlayer.Kick, function(self, ...)
                    if self == LocalPlayer then
                        Notify("shible", "已拦截踢出!", 2)
                        return
                    end
                    return oldKick(self, ...)
                end)
            end
            Notify("shible", "拦截踢出已开启", 2)
        else
            if kickHook then
                LocalPlayer.Kick = kickHook
                kickHook = nil
            end
            Notify("shible", "拦截踢出已关闭", 2)
        end
    end)
end

do
    local p = pgServer
    local y = 10

    local serverHdr = Instance.new("TextLabel", p)
    serverHdr.Text = "服务器信息"
    serverHdr.Font = Enum.Font.GothamSemibold
    serverHdr.TextSize = 14
    serverHdr.TextColor3 = Theme.TextPrimary
    serverHdr.BackgroundTransparency = 1
    serverHdr.Position = UDim2.new(0, 12, 0, y)
    serverHdr.Size = UDim2.new(1, -24, 0, 20)
    serverHdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 30

    local serverName = Instance.new("TextLabel", p)
    serverName.Text = "加载中..."
    serverName.Font = Enum.Font.Gotham
    serverName.TextSize = 13
    serverName.TextColor3 = Theme.TextSecondary
    serverName.BackgroundTransparency = 1
    serverName.Position = UDim2.new(0, 12, 0, y)
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

    y = y + 30

    local div1 = Instance.new("Frame", p)
    div1.Size = UDim2.new(1, -24, 0, 1)
    div1.Position = UDim2.new(0, 12, 0, y)
    div1.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    div1.BorderSizePixel = 0
    y = y + 16

    local wwHdr = Instance.new("TextLabel", p)
    wwHdr.Text = "特殊移动"
    wwHdr.Font = Enum.Font.GothamSemibold
    wwHdr.TextSize = 14
    wwHdr.TextColor3 = Theme.TextPrimary
    wwHdr.BackgroundTransparency = 1
    wwHdr.Position = UDim2.new(0, 12, 0, y)
    wwHdr.Size = UDim2.new(1, -24, 0, 20)
    wwHdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 30

    createToggle(p, y, "水上行走", function()
        return FuncState.WaterWalk
    end, function(v)
        FuncState.WaterWalk = v
        if v then
            if waterWalkConnection then
                waterWalkConnection:Disconnect()
            end
            waterWalkConnection = RunService.Heartbeat:Connect(function()
                local char = getChar()
                local hrp = getRootPart()
                if char and hrp then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local rayParams = RaycastParams.new()
                        rayParams.FilterDescendantsInstances = {char}
                        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                        local ray = Workspace:Raycast(hrp.Position, Vector3.new(0, -5, 0), rayParams)
                        if ray then
                            local water = ray.Instance:IsA("Terrain") or ray.Instance.Name:lower():find("water")
                            if water and ray.Position.Y > hrp.Position.Y - 2 then
                                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0.5, hrp.AssemblyLinearVelocity.Z)
                            end
                        end
                    end
                end
            end)
            Notify("shible", "水上行走已开启", 2)
        else
            if waterWalkConnection then
                waterWalkConnection:Disconnect()
                waterWalkConnection = nil
            end
            Notify("shible", "水上行走已关闭", 2)
        end
    end)

    y = y + 46

    local div2 = Instance.new("Frame", p)
    div2.Size = UDim2.new(1, -24, 0, 1)
    div2.Position = UDim2.new(0, 12, 0, y)
    div2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    div2.BorderSizePixel = 0
    y = y + 16

    local tpHdr = Instance.new("TextLabel", p)
    tpHdr.Text = "传送点"
    tpHdr.Font = Enum.Font.GothamSemibold
    tpHdr.TextSize = 14
    tpHdr.TextColor3 = Theme.TextPrimary
    tpHdr.BackgroundTransparency = 1
    tpHdr.Position = UDim2.new(0, 12, 0, y)
    tpHdr.Size = UDim2.new(1, -24, 0, 20)
    tpHdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 30

    local pointNames = {"点1", "点2", "点3", "点4", "点5"}
    local pointData = {}
    local selectedPoint = "点1"

    local tpDropdown = createDropdown(p, y, "选择传送点", pointNames, "点1", function(val)
        selectedPoint = val
    end)
    y = y + 60

    createButton(p, y, "保存当前为: " .. selectedPoint, function()
        local hrp = getRootPart()
        if hrp then
            pointData[selectedPoint] = hrp.Position
            Notify("shible", "已保存传送点: " .. selectedPoint, 2)
        else
            Notify("shible", "找不到角色", 2)
        end
    end)
    y = y + 42

    createButton(p, y, "传送至: " .. selectedPoint, function()
        local pos = pointData[selectedPoint]
        local hrp = getRootPart()
        if pos and hrp then
            hrp.CFrame = CFrame.new(pos)
            Notify("shible", "已传送至: " .. selectedPoint, 2)
        elseif not pos then
            Notify("shible", "该传送点未保存", 2)
        end
    end)
    y = y + 42

    createButton(p, y, "清除所有传送点", function()
        pointData = {}
        Notify("shible", "已清除所有传送点", 2)
    end)

    y = y + 50

    local div3 = Instance.new("Frame", p)
    div3.Size = UDim2.new(1, -24, 0, 1)
    div3.Position = UDim2.new(0, 12, 0, y)
    div3.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    div3.BorderSizePixel = 0
    y = y + 16

    local actionHdr = Instance.new("TextLabel", p)
    actionHdr.Text = "人物动作"
    actionHdr.Font = Enum.Font.GothamSemibold
    actionHdr.TextSize = 14
    actionHdr.TextColor3 = Theme.TextPrimary
    actionHdr.BackgroundTransparency = 1
    actionHdr.Position = UDim2.new(0, 12, 0, y)
    actionHdr.Size = UDim2.new(1, -24, 0, 20)
    actionHdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 30

    for name, id in pairs(FuncState.ActionAnims) do
        createButton(p, y, name, function()
            local char = getChar()
            local hum = getHumanoid()
            if char and hum then
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://" .. id
                local track = hum:LoadAnimation(anim)
                track:Play()
                table.insert(animTracks, track)
                Notify("shible", "播放动作: " .. name, 2)
            end
        end)
        y = y + 42
    end

    createButton(p, y, "停止所有动作", function()
        for _, track in ipairs(animTracks) do
            pcall(function()
                track:Stop()
                track:Destroy()
            end)
        end
        animTracks = {}
        Notify("shible", "已停止所有动作", 2)
    end)

    y = y + 50

    local div4 = Instance.new("Frame", p)
    div4.Size = UDim2.new(1, -24, 0, 1)
    div4.Position = UDim2.new(0, 12, 0, y)
    div4.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    div4.BorderSizePixel = 0
    y = y + 16

    local bhHdr = Instance.new("TextLabel", p)
    bhHdr.Text = "娱乐"
    bhHdr.Font = Enum.Font.GothamSemibold
    bhHdr.TextSize = 14
    bhHdr.TextColor3 = Theme.TextPrimary
    bhHdr.BackgroundTransparency = 1
    bhHdr.Position = UDim2.new(0, 12, 0, y)
    bhHdr.Size = UDim2.new(1, -24, 0, 20)
    bhHdr.TextXAlignment = Enum.TextXAlignment.Left
    y = y + 30

    createButton(p, y, "黑洞", function()
        local success = pcall(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Super-ring-Parts-V6-28581"))()
        end)
        if success then
            Notify("shible", "黑洞已加载", 2)
        else
            Notify("shible", "黑洞加载失败", 2)
        end
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

createFuncItem("防检测", "Anti")
createFuncItem("服务器缝合", "Server")

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

local miniShadow = Instance.new("ImageLabel", mini)
miniShadow.Size = UDim2.new(1, 30, 1, 30)
miniShadow.Position = UDim2.new(0, -15, 0, -8)
miniShadow.Image = "rbxassetid://1316045217"
miniShadow.ImageTransparency = 0.88
miniShadow.BackgroundTransparency = 1
miniShadow.ZIndex = -1

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
    makeTween(blur, {Size = 0}, 0.3)
    makeTween(root, {Size = UDim2.new(0, C.Width, 0, 0), BackgroundTransparency = 1}, 0.3)
    task.wait(0.35)
    safeCall(function()
        gui:Destroy()
        blur:Destroy()
    end, "Close")
end)

local isVerified = false
local verifyPanel = nil
local inputBox = nil
local confirmVerifyBtn = nil

local overlay = Instance.new("Frame")
overlay.Name = "LockOverlay"
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundTransparency = 1
overlay.Active = true
overlay.Selectable = true
overlay.ZIndex = 10
overlay.Visible = false
overlay.Parent = funcList

local function lockLeftButtons()
    overlay.Visible = true
    for _, btn in ipairs(funcList:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.Active = false
            btn.Selectable = false
            btn.AutoButtonColor = false
            btn.BackgroundTransparency = 0.8
            btn.TextColor3 = Color3.fromRGB(100, 100, 110)
        end
    end
end

local function unlockLeftButtons()
    overlay.Visible = false
    for _, btn in ipairs(funcList:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.Active = true
            btn.Selectable = true
            btn.AutoButtonColor = false
            btn.BackgroundTransparency = 0.6
            btn.TextColor3 = Theme.TextPrimary
        end
    end
end

local function showVerifyPanel()
    for _, pg in pairs(pages) do
        pg.Visible = false
    end

    if verifyPanel then
        verifyPanel:Destroy()
        verifyPanel = nil
    end

    verifyPanel = Instance.new("Frame")
    verifyPanel.Name = "VerifyPanel"
    verifyPanel.Size = UDim2.new(1, 0, 1, 0)
    verifyPanel.Position = UDim2.new(0, 0, 0, 0)
    verifyPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    verifyPanel.BackgroundTransparency = 0.05
    verifyPanel.BorderSizePixel = 0
    verifyPanel.Parent = funcContent
    corner(verifyPanel, 12)

    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 50, 0, 50)
    icon.Position = UDim2.new(0.5, -25, 0, 20)
    icon.BackgroundTransparency = 1
    icon.Text = "🔐"
    icon.Font = Enum.Font.Gotham
    icon.TextSize = 36
    icon.Parent = verifyPanel

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 0, 28)
    titleLabel.Position = UDim2.new(0, 20, 0, 80)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "请输入卡密验证"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = verifyPanel

    inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(0.7, 0, 0, 38)
    inputBox.Position = UDim2.new(0.15, 0, 0.35, 0)
    inputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.PlaceholderText = "在此输入卡密"
    inputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 16
    inputBox.ClearTextOnFocus = true
    inputBox.BorderSizePixel = 0
    inputBox.Parent = verifyPanel
    corner(inputBox, 8)

    confirmVerifyBtn = Instance.new("TextButton")
    confirmVerifyBtn.Size = UDim2.new(0.35, 0, 0, 38)
    confirmVerifyBtn.Position = UDim2.new(0.325, 0, 0.55, 0)
    confirmVerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    confirmVerifyBtn.Text = "确定"
    confirmVerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmVerifyBtn.Font = Enum.Font.GothamBold
    confirmVerifyBtn.TextSize = 18
    confirmVerifyBtn.AutoButtonColor = false
    confirmVerifyBtn.Parent = verifyPanel
    corner(confirmVerifyBtn, 8)
    pressEffect(confirmVerifyBtn)

    local extra = Instance.new("TextLabel")
    extra.Size = UDim2.new(1, -40, 0, 20)
    extra.Position = UDim2.new(0, 20, 0.85, 0)
    extra.BackgroundTransparency = 1
    extra.Text = "联系作者获取卡密：shible"
    extra.TextColor3 = Color3.fromRGB(100, 100, 120)
    extra.Font = Enum.Font.Gotham
    extra.TextSize = 11
    extra.TextXAlignment = Enum.TextXAlignment.Center
    extra.Parent = verifyPanel

    lockLeftButtons()

    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            confirmVerifyBtn.MouseButton1Click:Fire()
        end
    end)

    confirmVerifyBtn.MouseButton1Click:Connect(function()
        local key = inputBox.Text
        if key == "" then
            Notify("⚠️ 提示", "请输入卡密", 2)
            return
        end

        confirmVerifyBtn.Active = false
        confirmVerifyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

        task.spawn(function()
            local ok, errMsg, expireDate = verifyKeyOnline(key)

            if ok then
                isVerified = true

                if expireDate == "9999-99-99" then
                    expireLabel.Text = "♾️ 永久有效"
                    expireLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                else
                    expireLabel.Text = "📅 " .. expireDate
                    expireLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
                end

                Notify("✅ 卡密验证成功", "欢迎使用 shible 脚本", 2.5)

                if verifyPanel then
                    verifyPanel:Destroy()
                    verifyPanel = nil
                end

                unlockLeftButtons()

                for _, pg in pairs(pages) do
                    pg.Visible = false
                end
            else
                confirmVerifyBtn.Active = true
                confirmVerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
                inputBox.Text = ""
                inputBox:CaptureFocus()
                Notify("❌ 卡密错误", errMsg, 2)
            end
        end)
    end)
end

confirm.MouseButton1Click:Connect(function()
    makeTween(confirm, {TextSize = 16}, 0.12)
    task.delay(0.12, function()
        makeTween(confirm, {TextSize = 14}, 0.15)
    end)

    makeTween(pageMain, {Position = UDim2.new(-1, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
    pageFunction.Visible = true
    pageFunction.Position = UDim2.new(1, 0, 0, 0)
    makeTween(pageFunction, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)

    for _, btn in ipairs(funcList:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.Active = false
            btn.BackgroundTransparency = 0.8
            btn.TextColor3 = Color3.fromRGB(100, 100, 110)
        end
    end

    showVerifyPanel()
end)

backBtn.MouseButton1Click:Connect(function()
    makeTween(pageFunction, {Position = UDim2.new(1, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
    pageMain.Visible = true
    pageMain.Position = UDim2.new(-1, 0, 0, 0)
    makeTween(pageMain, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)

    if verifyPanel then
        verifyPanel:Destroy()
        verifyPanel = nil
    end

    task.delay(0.3, function()
        pageFunction.Visible = false
    end)

    if not isVerified then
        lockLeftButtons()
    end
end)

root.Size = UDim2.new(0, C.Width, 0, C.Height)
root.BackgroundTransparency = 0.18
root.Visible = true
gui.Enabled = true

pcall(function()
    springTween(root, {Size = UDim2.new(0, C.Width, 0, C.Height), BackgroundTransparency = 0.18}, 0.5)
end)

makeTween(blur, {Size = C.Blur}, 0.5)

LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.InProgress then
        pcall(function()
            if waterWalkConnection then
                waterWalkConnection:Disconnect()
                waterWalkConnection = nil
            end
        end)
    end
end)
