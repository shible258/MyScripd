--==========================================
-- 1:1 复刻 yejiaoben 弹窗UI（优化版 + 缩小面板保持风格一致）
--==========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 常量配置
local CONSTANTS = {
    BlurSize = 18,
    AnimationDuration = 0.25,
    CloseAnimationDuration = 0.2,
    MainMaxSize = Vector2.new(510, 385),
    MainMinSize = Vector2.new(298, 285),
    ShadowMaxSize = Vector2.new(540, 395),
    ShadowMinSize = Vector2.new(325, 300),
    ButtonCornerRadius = 14,
    MainCornerRadius = 26,
    ShadowCornerRadius = 32,
    MiniBarWidth = 280,
    MiniBarHeight = 130,
}

-- 颜色配置
local COLORS = {
    Red = Color3.fromRGB(220, 38, 38),
    Blue = Color3.fromRGB(37, 99, 235),
    Black = Color3.fromRGB(18, 18, 22),
    Gray = Color3.fromRGB(90, 90, 98),
    White = Color3.fromRGB(255, 255, 255),
    LightGray = Color3.fromRGB(245, 245, 247),
    BorderGray = Color3.fromRGB(210, 210, 218),
    GradientStart = Color3.fromRGB(255, 255, 255),
    GradientEnd = Color3.fromRGB(238, 242, 249),
}

-- UI工具函数
local UIUtils = {}

function UIUtils.createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

function UIUtils.createStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

function UIUtils.createTextLabel(parent, name, text, position, size, color, textSize, font)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Parent = parent
    label.Position = position
    label.Size = size
    label.BackgroundTransparency = 1
    label.BorderSizePixel = 0
    label.Text = text
    label.TextColor3 = color
    label.TextSize = textSize
    label.Font = font or Enum.Font.GothamMedium
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    return label
end

function UIUtils.createButton(parent, name, text, position, size, bgColor, textColor)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = parent
    button.Position = position
    button.Size = size
    button.BackgroundColor3 = bgColor
    button.BackgroundTransparency = 0.06
    button.BorderSizePixel = 0
    button.AutoButtonColor = true
    button.Text = text
    button.TextColor3 = textColor
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.TextWrapped = true
    UIUtils.createCorner(button, CONSTANTS.ButtonCornerRadius)
    return button
end

-- 创建卡片样式（带渐变和描边）
local function styleCard(frame, radius)
    frame.BackgroundColor3 = COLORS.White
    frame.BackgroundTransparency = 0.085
    frame.BorderSizePixel = 0
    UIUtils.createCorner(frame, radius)
    UIUtils.createStroke(frame, COLORS.White, 1.8, 0.075)

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.GradientStart),
        ColorSequenceKeypoint.new(1, COLORS.GradientEnd),
    })
    gradient.Rotation = 95
    gradient.Parent = frame
end

-- 创建模糊效果
local function createBlurEffect()
    local blur = Instance.new("BlurEffect")
    blur.Name = "ScriptStartupWarningBlur"
    blur.Size = 0
    blur.Parent = Lighting
    
    TweenService:Create(
        blur, 
        TweenInfo.new(CONSTANTS.AnimationDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
        { Size = CONSTANTS.BlurSize }
    ):Play()
    
    return blur
end

-- 安全销毁实例
local function safeDestroy(instance)
    if instance and instance.Parent then
        instance:Destroy()
    end
end

-- 创建主UI
local function createMainUI(screenGui)
    -- 背景遮罩
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Parent = screenGui
    background.Position = UDim2.fromScale(0, 0)
    background.Size = UDim2.fromScale(1, 1)
    background.BackgroundColor3 = COLORS.White
    background.BackgroundTransparency = 0.47
    background.BorderSizePixel = 0

    -- 阴影层
    local mainShadow = Instance.new("Frame")
    mainShadow.Name = "SoftShadow"
    mainShadow.Parent = background
    mainShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    mainShadow.Position = UDim2.fromScale(0.5, 0.53)
    mainShadow.Size = UDim2.new(0.86, 22, 0, 348)
    mainShadow.BackgroundColor3 = COLORS.White
    mainShadow.BackgroundTransparency = 0.74
    mainShadow.BorderSizePixel = 0
    
    local shadowLimit = Instance.new("UISizeConstraint")
    shadowLimit.MaxSize = CONSTANTS.ShadowMaxSize
    shadowLimit.MinSize = CONSTANTS.ShadowMinSize
    shadowLimit.Parent = mainShadow
    
    UIUtils.createCorner(mainShadow, CONSTANTS.ShadowCornerRadius)
    UIUtils.createStroke(mainShadow, COLORS.White, 6, 0.29)

    -- 主面板
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Parent = background
    main.AnchorPoint = Vector2.new(0.5, 0.52)
    main.Position = UDim2.fromScale(0.5, 0.51)
    main.Size = UDim2.new(0.87, 0, 0, 326)
    main.BackgroundColor3 = COLORS.White
    main.BackgroundTransparency = 0.095
    main.BorderSizePixel = 0
    
    local mainLimit = Instance.new("UISizeConstraint")
    mainLimit.MaxSize = CONSTANTS.MainMaxSize
    mainLimit.MinSize = CONSTANTS.MainMinSize
    mainLimit.Parent = main
    
    styleCard(main, CONSTANTS.MainCornerRadius)

    -- 顶部高光
    local topHighlight = Instance.new("Frame")
    topHighlight.Name = "TopHighlight"
    topHighlight.Parent = main
    topHighlight.Position = UDim2.new(0, 24, 0, 10)
    topHighlight.Size = UDim2.new(1, -46, 0, 2)
    topHighlight.BackgroundColor3 = COLORS.White
    topHighlight.BackgroundTransparency = 0.055
    topHighlight.BorderSizePixel = 0
    UIUtils.createCorner(topHighlight, 888)

    -- 左侧发光条
    local leftGlow = Instance.new("Frame")
    leftGlow.Name = "LeftGlow"
    leftGlow.Parent = main
    leftGlow.Position = UDim2.new(0, 0, 0, 28)
    leftGlow.Size = UDim2.new(0, 2, 1, -54)
    leftGlow.BackgroundColor3 = COLORS.White
    leftGlow.BackgroundTransparency = 0.145
    leftGlow.BorderSizePixel = 0
    UIUtils.createCorner(leftGlow, 777)

    return background, mainShadow, main
end

-- 创建文本内容
local function createTextContent(main)
    UIUtils.createTextLabel(main, "SmallTitle", "我的脚本", 
        UDim2.new(0, 30, 0, 21), UDim2.new(1, -58, 0, 22), 
        COLORS.Gray, 13)
    
    UIUtils.createTextLabel(main, "MainTitle", "欢迎使用", 
        UDim2.new(0, 31, 0, 57), UDim2.new(1, -62, 0, 43), 
        COLORS.Red, 20, Enum.Font.GothamBold)
    
    UIUtils.createTextLabel(main, "Desc", "点击下方按钮开启功能", 
        UDim2.new(0, 30, 0, 108), UDim2.new(1, -59, 0, 41), 
        COLORS.Black, 17)
end

-- 创建功能按钮
local function createActionButtons(main)
    local buttons = {}
    
    -- 加速按钮
    local btnSpeed = UIUtils.createButton(main, "SpeedBtn", "加速", 
        UDim2.new(0, 28, 0, 168), UDim2.new(0.425, -15, 0, 44), 
        COLORS.Red, COLORS.White)
    UIUtils.createStroke(btnSpeed, COLORS.White, 1.5, 0.335)
    table.insert(buttons, btnSpeed)
    
    -- 跳高按钮
    local btnJump = UIUtils.createButton(main, "JumpBtn", "跳高", 
        UDim2.new(0.505, 14, 0, 169), UDim2.new(0.422, -14, 0, 44), 
        COLORS.Blue, COLORS.White)
    UIUtils.createStroke(btnJump, COLORS.White, 1.5, 0.332)
    table.insert(buttons, btnJump)
    
    -- 重置按钮
    local btnReset = UIUtils.createButton(main, "ResetBtn", "重置", 
        UDim2.new(0, 28, 0, 225), UDim2.new(0.423, -14, 0, 43), 
        COLORS.LightGray, COLORS.Black)
    UIUtils.createStroke(btnReset, COLORS.BorderGray, 1.5, 0.135)
    table.insert(buttons, btnReset)
    
    -- 关闭按钮
    local btnClose = UIUtils.createButton(main, "CloseBtn", "关闭", 
        UDim2.new(0.502, 14, 0, 226), UDim2.new(0.424, -15, 0, 43), 
        COLORS.Red, COLORS.White)
    UIUtils.createStroke(btnClose, COLORS.White, 1.5, 0.336)
    table.insert(buttons, btnClose)
    
    return buttons
end

-- 绑定功能逻辑
local function bindFunctionality(buttons)
    local btnSpeed, btnJump, btnReset, btnClose = unpack(buttons)
    
    btnSpeed.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = 65
        end
    end)

    btnJump.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = 120
        end
    end)

    btnReset.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = 16
            char.Humanoid.JumpPower = 70
        end
    end)

    return btnClose
end

-- 创建最小化按钮
local function createMinimizeButton(main)
    local minBtn = UIUtils.createButton(main, "MinBtn", "—", 
        UDim2.new(1, -82, 0, 13), UDim2.new(0, 34, 0, 29), 
        Color3.fromRGB(182, 172, 192), COLORS.White)
    UIUtils.createStroke(minBtn, Color3.fromRGB(203, 193, 213), 1.1, 0.215)
    return minBtn
end

-- 创建缩小面板（风格与主UI一致）
local function createMiniPanel(screenGui)
    local miniPanel = Instance.new("Frame", screenGui)
    miniPanel.Name = "MiniPanel"
    miniPanel.AnchorPoint = Vector2.new(0.5, 0)
    miniPanel.Position = UDim2.new(0.49, 0, 0, 12)
    miniPanel.Size = UDim2.new(0, CONSTANTS.MiniBarWidth, 0, CONSTANTS.MiniBarHeight)
    miniPanel.Visible = false
    miniPanel.Active = true
    miniPanel.Selectable = false
    
    styleCard(miniPanel, 20)

    -- 顶部高光（风格一致）
    local miniHL = Instance.new("Frame", miniPanel)
    miniHL.Size = UDim2.new(1, -34, 0, 2)
    miniHL.Position = UDim2.new(0, 17, 0, 8)
    miniHL.BackgroundColor3 = COLORS.White
    miniHL.BackgroundTransparency = 0.048
    miniHL.BorderSizePixel = 0
    UIUtils.createCorner(miniHL, 666)

    -- 左侧发光条（风格一致）
    local miniGlow = Instance.new("Frame", miniPanel)
    miniGlow.Size = UDim2.new(0, 1.5, 1, -24)
    miniGlow.Position = UDim2.new(0, 0, 0, 12)
    miniGlow.BackgroundColor3 = COLORS.White
    miniGlow.BackgroundTransparency = 0.125
    miniGlow.BorderSizePixel = 0
    UIUtils.createCorner(miniGlow, 555)

    -- 标题（风格一致）
    UIUtils.createTextLabel(miniPanel, "MiniSmallTitle", "我的脚本",
        UDim2.new(0, 18, 0, 14),
        UDim2.new(1, -36, 0, 18),
        COLORS.Gray, 12
    )

    UIUtils.createTextLabel(miniPanel, "MiniMainTitle", "已最小化",
        UDim2.new(0, 18, 0, 36),
        UDim2.new(1, -36, 0, 24),
        COLORS.Red, 15, Enum.Font.GothamBold
    )

    -- 恢复按钮（风格与主按钮一致）
    local restBtn = UIUtils.createButton(miniPanel, "RestoreBtn", "恢复窗口",
        UDim2.new(0.115, 0, 1, -44),
        UDim2.new(0.76, 0, 0, 34),
        COLORS.Red, COLORS.White
    )
    UIUtils.createStroke(restBtn, COLORS.White, 1.3, 0.305)

    return miniPanel, restBtn
end

-- 设置拖拽功能（整个面板可拖）
local function setupDragging(targetFrame)
    local isDragging = false
    local dragStart = nil
    local barStartPos = nil

    targetFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            barStartPos = targetFrame.Position
        end
    end)

    targetFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                          input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            targetFrame.Position = UDim2.new(
                barStartPos.X.Scale, 
                barStartPos.X.Offset + delta.X, 
                barStartPos.Y.Scale, 
                math.max(0, barStartPos.Y.Offset + delta.Y)
            )
        end
    end)
end

-- 播放入场动画
local function playEntranceAnimation(main, mainShadow)
    main.Size = UDim2.new(0.865, 0, 0, 288)
    mainShadow.Size = UDim2.new(0.855, 22, 0, 310)
    main.BackgroundTransparency = 1
    mainShadow.BackgroundTransparency = 1
    
    TweenService:Create(
        main, 
        TweenInfo.new(0.375, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
        { Size = UDim2.new(0.875, 0, 0, 328), BackgroundTransparency = 0.088 }
    ):Play()
    
    TweenService:Create(
        mainShadow, 
        TweenInfo.new(0.315, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
        { Size = UDim2.new(0.868, 24, 0, 352), BackgroundTransparency = 0.71 }
    ):Play()
end

-- 关闭UI
local function closeUI(screenGui, main, mainShadow, blur)
    local blurTween = TweenService:Create(
        blur, 
        TweenInfo.new(CONSTANTS.CloseAnimationDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
        { Size = 0 }
    )
    blurTween:Play()
    
    TweenService:Create(main, TweenInfo.new(CONSTANTS.CloseAnimationDuration), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(mainShadow, TweenInfo.new(CONSTANTS.CloseAnimationDuration), { BackgroundTransparency = 1 }):Play()
    
    task.delay(CONSTANTS.CloseAnimationDuration + 0.045, function()
        safeDestroy(screenGui)
        safeDestroy(blur)
    end)
end

-- 最小化UI
local function minimizeUI(main, mainShadow, background, blur, miniPanel)
    main.Visible = false
    mainShadow.Visible = false
    background.BackgroundTransparency = 1
    
    TweenService:Create(blur, TweenInfo.new(0.148), { Size = 0 }):Play()
    miniPanel.Visible = true
end

-- 恢复UI
local function restoreUI(main, mainShadow, background, blur, miniPanel)
    miniPanel.Visible = false
    background.BackgroundTransparency = 0.465
    
    TweenService:Create(blur, TweenInfo.new(0.152), { Size = CONSTANTS.BlurSize }):Play()
    main.Visible = true
    mainShadow.Visible = true
end

-- 主初始化函数
local function initialize()
    local blur = createBlurEffect()

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MyScriptUI"
    screenGui.Parent = PlayerGui
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 999999
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- 创建UI组件
    local background, mainShadow, main = createMainUI(screenGui)
    createTextContent(main)
    local buttons = createActionButtons(main)
    local btnClose = bindFunctionality(buttons)
    local minBtn = createMinimizeButton(main)
    local miniPanel, restBtn = createMiniPanel(screenGui)

    -- 设置拖拽
    setupDragging(miniPanel)

    -- 关闭按钮
    btnClose.MouseButton1Click:Connect(function()
        closeUI(screenGui, main, mainShadow, blur)
    end)

    -- 最小化按钮
    minBtn.MouseButton1Click:Connect(function()
        minimizeUI(main, mainShadow, background, blur, miniPanel)
    end)

    -- 恢复按钮
    restBtn.MouseButton1Click:Connect(function()
        restoreUI(main, mainShadow, background, blur, miniPanel)
    end)

    -- 入场动画
    playEntranceAnimation(main, mainShadow)

    print("UI加载完成 - 缩小面板风格一致版")
end

-- 启动
local success, err = pcall(initialize)
if not success then
    warn("UI初始化失败:", err)
end
