--[[
    ImGui Style Floating Window - Roblox Lua Version
    适用于注入器执行的 Roblox Lua 脚本
    音量键控制改为快捷键控制
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ============ 配置 ============
local CONFIG = {
    WindowSize = UDim2.new(0, 320, 0, 420),
    CornerRadius = 12,
    Colors = {
        Bg = Color3.fromRGB(30, 30, 30),
        BgLight = Color3.fromRGB(37, 37, 37),
        BgDark = Color3.fromRGB(21, 21, 21),
        Border = Color3.fromRGB(58, 58, 58),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(170, 170, 170),
        Accent = Color3.fromRGB(45, 137, 239),
        AccentHover = Color3.fromRGB(92, 173, 255),
        AccentActive = Color3.fromRGB(26, 107, 196),
        Success = Color3.fromRGB(76, 175, 80),
        Danger = Color3.fromRGB(244, 67, 54),
        Header = Color3.fromRGB(45, 45, 45),
        TabActive = Color3.fromRGB(45, 137, 239),
        TabInactive = Color3.fromRGB(42, 42, 42),
        InputBg = Color3.fromRGB(26, 26, 26),
        InputBorder = Color3.fromRGB(58, 58, 58),
        Separator = Color3.fromRGB(58, 58, 58),
    }
}

-- ============ 变量 ============
local floatWindow = nil
local guiHolder = nil
local isVisible = false
local isDragging = false
local currentPage = 1
local dragStartPos = nil
local windowStartPos = nil
local tabButtons = {}
local page1, page2, page3 = nil, nil, nil
local checkboxStates = {}
local sliderValue = 50
local inputText = ""

-- ============ UI 工具函数 ============
function CreateRoundRect(color, cornerRadius)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    if cornerRadius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, cornerRadius)
        corner.Parent = frame
    end
    return frame
end

function CreateScrollingFrame()
    local frame = Instance.new("ScrollingFrame")
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 4
    frame.ScrollBarImageColor3 = CONFIG.Colors.Accent
    frame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    return frame
end

function CreateSeparator()
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -20, 0, 1)
    sep.Position = UDim2.new(0, 10, 0, 0)
    sep.BackgroundColor3 = CONFIG.Colors.Separator
    sep.BackgroundTransparency = 0
    sep.BorderSizePixel = 0
    return sep
end

function CreateLabel(text, color, size, bold)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.TextColor3 = color or CONFIG.Colors.Text
    label.TextSize = size or 14
    label.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 0)
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    return label
end

function CreateButton(text, color, width, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.TextColor3 = CONFIG.Colors.Text
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.BackgroundColor3 = color or CONFIG.Colors.Accent
    btn.Size = UDim2.new(width or 1, 0, 0, 36)
    btn.AutomaticSize = Enum.AutomaticSize.None
    btn.BorderSizePixel = 0
    btn.TextXAlignment = Enum.TextXAlignment.Center
    btn.TextYAlignment = Enum.TextYAlignment.Center
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = CONFIG.Colors.AccentHover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color or CONFIG.Colors.Accent}):Play()
    end)
    
    return btn
end

function CreateInput(placeholder)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 38)
    frame.BackgroundColor3 = CONFIG.Colors.InputBg
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = frame
    
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 0, 1, 0)
    border.BackgroundTransparency = 1
    border.BorderSizePixel = 1
    border.BorderColor3 = CONFIG.Colors.InputBorder
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 4)
    borderCorner.Parent = border
    border.Parent = frame
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -20, 1, 0)
    input.Position = UDim2.new(0, 10, 0, 0)
    input.BackgroundTransparency = 1
    input.Text = ""
    input.PlaceholderText = placeholder
    input.PlaceholderColor3 = CONFIG.Colors.TextDim
    input.TextColor3 = CONFIG.Colors.Text
    input.TextSize = 14
    input.Font = Enum.Font.Gotham
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.TextYAlignment = Enum.TextYAlignment.Center
    input.Parent = frame
    
    input:GetPropertyChangedSignal("Text"):Connect(function()
        inputText = input.Text
    end)
    
    return frame, input
end

function CreateCheckbox(label, defaultState)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    
    local uiList = Instance.new("UIListLayout")
    uiList.FillDirection = Enum.FillDirection.Horizontal
    uiList.VerticalAlignment = Enum.VerticalAlignment.Center
    uiList.HorizontalAlignment = Enum.HorizontalAlignment.Left
    uiList.Padding = UDim.new(0, 10)
    uiList.Parent = frame
    
    local checkBox = Instance.new("ImageButton")
    checkBox.Size = UDim2.new(0, 20, 0, 20)
    checkBox.BackgroundColor3 = CONFIG.Colors.InputBg
    checkBox.BackgroundTransparency = 0
    checkBox.BorderSizePixel = 0
    checkBox.Image = ""
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = checkBox
    
    local checkmark = Instance.new("ImageLabel")
    checkmark.Size = UDim2.new(0, 14, 0, 14)
    checkmark.Position = UDim2.new(0.5, -7, 0.5, -7)
    checkmark.BackgroundTransparency = 1
    checkmark.Image = "rbxassetid://404874811"
    checkmark.ImageColor3 = CONFIG.Colors.Text
    checkmark.Visible = defaultState or false
    checkmark.Parent = checkBox
    
    local label = Instance.new("TextLabel")
    label.Text = label
    label.TextColor3 = CONFIG.Colors.Text
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0, 200, 0, 30)
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local state = defaultState or false
    
    checkBox.MouseButton1Click:Connect(function()
        state = not state
        checkmark.Visible = state
        checkboxStates[label] = state
        checkBox.BackgroundColor3 = state and CONFIG.Colors.Accent or CONFIG.Colors.InputBg
    end)
    
    checkBox.Parent = frame
    label.Parent = frame
    
    return frame, state
end

function CreateSlider(label, min, max, defaultVal)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundTransparency = 1
    
    local labelFrame = Instance.new("Frame")
    labelFrame.Size = UDim2.new(1, 0, 0, 20)
    labelFrame.BackgroundTransparency = 1
    labelFrame.Parent = frame
    
    local lbl = Instance.new("TextLabel")
    lbl.Text = label
    lbl.TextColor3 = CONFIG.Colors.Text
    lbl.TextSize = 14
    lbl.Font = Enum.Font.Gotham
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = labelFrame
    
    local valText = Instance.new("TextLabel")
    valText.Text = tostring(defaultVal or min)
    valText.TextColor3 = CONFIG.Colors.Accent
    valText.TextSize = 14
    valText.Font = Enum.Font.Gotham
    valText.BackgroundTransparency = 1
    valText.Size = UDim2.new(0.3, 0, 1, 0)
    valText.TextXAlignment = Enum.TextXAlignment.Right
    valText.Parent = labelFrame
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 0, 28)
    track.BackgroundColor3 = CONFIG.Colors.SliderTrack or CONFIG.Colors.InputBg
    track.BackgroundTransparency = 0
    track.BorderSizePixel = 0
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = track
    track.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    fill.BackgroundColor3 = CONFIG.Colors.Accent
    fill.BackgroundTransparency = 0
    fill.BorderSizePixel = 0
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill
    fill.Parent = track
    
    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 16, 0, 16)
    thumb.Position = UDim2.new(0.5, -8, 0.5, -8)
    thumb.BackgroundColor3 = CONFIG.Colors.Accent
    thumb.BorderSizePixel = 0
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb
    thumb.Parent = track
    
    local value = defaultVal or 50
    
    local function updateSlider(newVal)
        value = math.clamp(newVal, min, max)
        local pct = (value - min) / (max - min)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        thumb.Position = UDim2.new(pct, -8, 0.5, -8)
        valText.Text = tostring(math.round(value))
        sliderValue = value
    end
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            updateSlider(min + pct * (max - min))
        end
    end)
    
    track.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and input.UserInputState == Enum.UserInputState.Change then
            local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            updateSlider(min + pct * (max - min))
        end
    end)
    
    return frame
end

-- ============ 页面构建 ============
function BuildPage1()
    local page = CreateScrollingFrame()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -24, 0, 0)
    container.Position = UDim2.new(0, 12, 0, 8)
    container.BackgroundTransparency = 1
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.Parent = page
    
    local welcome = CreateLabel("Welcome to ImGui Style UI", CONFIG.Colors.Accent, 18, true)
    welcome.Parent = container
    
    local desc = CreateLabel("Volume+ to show, Volume- to hide\nThis is a floating window with ImGui-style interface.", CONFIG.Colors.TextDim, 12)
    desc.Parent = container
    
    local sep1 = CreateSeparator()
    sep1.Parent = container
    
    local btnLayout = Instance.new("Frame")
    btnLayout.Size = UDim2.new(1, 0, 0, 44)
    btnLayout.BackgroundTransparency = 1
    btnLayout.Parent = container
    
    local btn1 = CreateButton("Button 1", CONFIG.Colors.Accent, 0.48, function()
        print("[ImGui] Button 1 clicked!")
    end)
    btn1.Position = UDim2.new(0, 0, 0, 4)
    btn1.Parent = btnLayout
    
    local btn2 = CreateButton("Button 2", CONFIG.Colors.Success, 0.48, function()
        print("[ImGui] Button 2 clicked!")
    end)
    btn2.Position = UDim2.new(0.52, 0, 0, 4)
    btn2.Parent = btnLayout
    
    local inputFrame, inputBox = CreateInput("Enter text here...")
    inputFrame.Parent = container
    
    local cbFrame1, cb1 = CreateCheckbox("Enable Feature A", true)
    cbFrame1.Parent = container
    
    local cbFrame2, cb2 = CreateCheckbox("Enable Feature B", false)
    cbFrame2.Parent = container
    
    local slider1 = CreateSlider("Float Value", 0, 100, 50)
    slider1.Parent = container
    
    return page
end

function BuildPage2()
    local page = CreateScrollingFrame()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -24, 0, 0)
    container.Position = UDim2.new(0, 12, 0, 8)
    container.BackgroundTransparency = 1
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.Parent = page
    
    local title = CreateLabel("Settings", CONFIG.Colors.Accent, 18, true)
    title.Parent = container
    
    local sep = CreateSeparator()
    sep.Parent = container
    
    local settings = {
        {"Auto Start", true},
        {"Show Notifications", true},
        {"Dark Mode", true},
        {"Sound Effects", false},
        {"Vibration", true},
        {"Background Service", true},
    }
    
    for _, setting in ipairs(settings) do
        local cbFrame, _ = CreateCheckbox(setting[1], setting[2])
        cbFrame.Parent = container
    end
    
    local sep2 = CreateSeparator()
    sep2.Parent = container
    
    local saveBtn = CreateButton("Save Settings", CONFIG.Colors.Success, 1, function()
        print("[ImGui] Settings saved!")
    end)
    saveBtn.Parent = container
    
    return page
end

function BuildPage3()
    local page = CreateScrollingFrame()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -24, 0, 0)
    container.Position = UDim2.new(0, 12, 0, 8)
    container.BackgroundTransparency = 1
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.Parent = page
    
    local title = CreateLabel("About", CONFIG.Colors.Accent, 18, true)
    title.Parent = container
    
    local sep = CreateSeparator()
    sep.Parent = container
    
    local info = CreateLabel(
        "ImGui Style Floating Window\nVersion: 1.0.0\n\nFeatures:\n- Volume+ to show\n- Volume- to hide\n- Multi-page navigation\n- ImGui-style UI components\n- Smooth animations\n- Draggable window\n\nDesigned for Roblox Lua Injection",
        CONFIG.Colors.Text, 12
    )
    info.Parent = container
    
    return page
end

-- ============ 切换页面 ============
function SwitchPage(pageNum)
    currentPage = pageNum
    local pages = {page1, page2, page3}
    
    for i, btn in ipairs(tabButtons) do
        if i == pageNum then
            btn.TextColor3 = CONFIG.Colors.Text
            btn.BackgroundColor3 = CONFIG.Colors.TabActive
        else
            btn.TextColor3 = CONFIG.Colors.TextDim
            btn.BackgroundColor3 = CONFIG.Colors.TabInactive
        end
    end
    
    for i, p in ipairs(pages) do
        p.Visible = (i == pageNum)
    end
end

-- ============ 构建主窗口 ============
function BuildFloatWindow()
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = CONFIG.WindowSize
    mainFrame.BackgroundColor3 = CONFIG.Colors.Bg
    mainFrame.BackgroundTransparency = 0
    mainFrame.BorderSizePixel = 0
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, CONFIG.CornerRadius)
    mainCorner.Parent = mainFrame
    
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 0, 1, 0)
    border.BackgroundTransparency = 1
    border.BorderSizePixel = 1
    border.BorderColor3 = CONFIG.Colors.Border
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, CONFIG.CornerRadius)
    borderCorner.Parent = border
    border.Parent = mainFrame
    
    -- ===== 标题栏 =====
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 44)
    titleBar.BackgroundColor3 = CONFIG.Colors.Header
    titleBar.BackgroundTransparency = 0
    titleBar.BorderSizePixel = 0
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, CONFIG.CornerRadius)
    titleCorner.Parent = titleBar
    titleBar.Parent = mainFrame
    
    local icon = Instance.new("Frame")
    icon.Size = UDim2.new(0, 14, 0, 14)
    icon.Position = UDim2.new(0, 12, 0.5, -7)
    icon.BackgroundColor3 = CONFIG.Colors.Accent
    icon.BackgroundTransparency = 0
    icon.BorderSizePixel = 0
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 3)
    iconCorner.Parent = icon
    icon.Parent = titleBar
    
    local titleText = CreateLabel("ImGui Panel", CONFIG.Colors.Text, 16, true)
    titleText.Position = UDim2.new(0, 32, 0, 10)
    titleText.Size = UDim2.new(0.7, 0, 0, 24)
    titleText.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -36, 0.5, -15)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = CONFIG.Colors.Danger
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.BackgroundTransparency = 1
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function()
        HideFloatWindow()
    end)
    
    -- 标题栏拖拽
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStartPos = input.Position
            if floatWindow then
                windowStartPos = floatWindow.Position
            end
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if isDragging and floatWindow and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStartPos
            floatWindow.Position = UDim2.new(
                0, windowStartPos.X.Offset + delta.X,
                0, windowStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- ===== 标签栏 =====
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 42)
    tabBar.Position = UDim2.new(0, 0, 0, 44)
    tabBar.BackgroundColor3 = CONFIG.Colors.BgDark
    tabBar.BackgroundTransparency = 0
    tabBar.BorderSizePixel = 0
    tabBar.Parent = mainFrame
    
    local tabNames = {"Home", "Settings", "About"}
    local tabWidth = 1 / #tabNames
    tabButtons = {}
    
    for i, name in ipairs(tabNames) do
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(tabWidth, -8, 1, -8)
        tabBtn.Position = UDim2.new((i-1) * tabWidth + 0.02, 0, 0, 4)
        tabBtn.Text = name
        tabBtn.TextColor3 = i == 1 and CONFIG.Colors.Text or CONFIG.Colors.TextDim
        tabBtn.TextSize = 14
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.BackgroundColor3 = i == 1 and CONFIG.Colors.TabActive or CONFIG.Colors.TabInactive
        tabBtn.BackgroundTransparency = 0
        tabBtn.BorderSizePixel = 0
        tabBtn.TextXAlignment = Enum.TextXAlignment.Center
        tabBtn.TextYAlignment = Enum.TextYAlignment.Center
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = tabBtn
        
        tabBtn.MouseButton1Click:Connect(function()
            SwitchPage(i)
        end)
        
        tabBtn.Parent = tabBar
        table.insert(tabButtons, tabBtn)
    end
    
    -- ===== 内容区域 =====
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, 0, 1, -86)
    contentContainer.Position = UDim2.new(0, 0, 0, 86)
    contentContainer.BackgroundColor3 = CONFIG.Colors.Bg
    contentContainer.BackgroundTransparency = 0
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = mainFrame
    
    page1 = BuildPage1()
    page1.Size = UDim2.new(1, 0, 1, 0)
    page1.Parent = contentContainer
    
    page2 = BuildPage2()
    page2.Size = UDim2.new(1, 0, 1, 0)
    page2.Parent = contentContainer
    page2.Visible = false
    
    page3 = BuildPage3()
    page3.Size = UDim2.new(1, 0, 1, 0)
    page3.Parent = contentContainer
    page3.Visible = false
    
    -- ===== 状态栏 =====
    local statusBar = Instance.new("Frame")
    statusBar.Size = UDim2.new(1, 0, 0, 28)
    statusBar.Position = UDim2.new(0, 0, 1, -28)
    statusBar.BackgroundColor3 = CONFIG.Colors.BgDark
    statusBar.BackgroundTransparency = 0
    statusBar.BorderSizePixel = 0
    statusBar.Parent = mainFrame
    
    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, 6, 0, 6)
    statusDot.Position = UDim2.new(0, 12, 0.5, -3)
    statusDot.BackgroundColor3 = CONFIG.Colors.Success
    statusDot.BackgroundTransparency = 0
    statusDot.BorderSizePixel = 0
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = statusDot
    statusDot.Parent = statusBar
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -20, 1, 0)
    statusText.Position = UDim2.new(0, 24, 0, 0)
    statusText.Text = "Ready"
    statusText.TextColor3 = CONFIG.Colors.TextDim
    statusText.TextSize = 12
    statusText.Font = Enum.Font.Gotham
    statusText.BackgroundTransparency = 1
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.TextYAlignment = Enum.TextYAlignment.Center
    statusText.Parent = statusBar
    
    return mainFrame
end

-- ============ 显示/隐藏 ============
function ShowFloatWindow()
    if isVisible then return end
    
    guiHolder = Instance.new("ScreenGui")
    guiHolder.Name = "ImGuiFloatWindow"
    guiHolder.ResetOnSpawn = false
    guiHolder.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    floatWindow = BuildFloatWindow()
    floatWindow.Position = UDim2.new(0.5, -160, 0.5, -210)
    floatWindow.Parent = guiHolder
    
    -- 入场动画
    floatWindow.BackgroundTransparency = 1
    TweenService:Create(floatWindow, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    
    isVisible = true
    print("[ImGui] Window shown")
end

function HideFloatWindow()
    if not isVisible then return end
    
    TweenService:Create(floatWindow, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
    wait(0.15)
    
    if guiHolder then
        guiHolder:Destroy()
        guiHolder = nil
    end
    floatWindow = nil
    isVisible = false
    print("[ImGui] Window hidden")
end

function ToggleFloatWindow()
    if isVisible then
        HideFloatWindow()
    else
        ShowFloatWindow()
    end
end

-- ============ 快捷键控制 ============
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Ctrl + F12 切换
    if input.KeyCode == Enum.KeyCode.F12 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        ToggleFloatWindow()
    end
    
    -- Home 键显示，End 键隐藏
    if input.KeyCode == Enum.KeyCode.Home then
        ShowFloatWindow()
    end
    
    if input.KeyCode == Enum.KeyCode.End then
        HideFloatWindow()
    end
end)

-- ============ 初始化 ============
print("[ImGui] Floating Window loaded!")
print("[ImGui] Controls:")
print("  Home - Show Window")
print("  End  - Hide Window")
print("  Ctrl+F12 - Toggle Window")
print("  Drag title bar to move window")
