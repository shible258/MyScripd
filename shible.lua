local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- ====== 高级参数 ======
local C = {
	Width = 280,
	Height = 280,
	Radius = 22,
	Blur = 24,
	Spring = Enum.EasingStyle.Elastic,
	Duration = 0.55,
	DragSmoothness = 0.25,
	NavHeight = 44,
	FuncPanelGap = 0,
	BackBtnHeight = 40,
}

local Theme = {
	Glass = Color3.fromRGB(30, 30, 32),
	TextPrimary = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(160, 160, 165),
	Accent = Color3.fromRGB(0, 122, 255),
	Danger = Color3.fromRGB(255, 59, 48),
	Grabber = Color3.fromRGB(120, 120, 128),
}

-- ====== 工具函数 ======
local function corner(f, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = f
end

local function spring(target, props, dur)
	dur = dur or C.Duration
	return TweenService:Create(target, TweenInfo.new(dur, C.Spring, Enum.EasingDirection.Out), props)
end

local function tween(target, props, dur, style, dir)
	dur = dur or 0.25
	style = style or Enum.EasingStyle.Quad
	dir = dir or Enum.EasingDirection.Out
	return TweenService:Create(target, TweenInfo.new(dur, style, dir), props)
end

local function pressEffect(btn, scaleX, scaleY)
	scaleX = scaleX or 0.96
	scaleY = scaleY or 0.9
	local origSize = btn.Size
	local pressedSize = UDim2.new(
		origSize.X.Scale * scaleX, origSize.X.Offset * scaleX,
		origSize.Y.Scale * scaleY, origSize.Y.Offset * scaleY
	)
	btn.MouseButton1Down:Connect(function()
		tween(btn, {Size = pressedSize}, 0.08):Play()
	end)
	btn.MouseButton1Up:Connect(function()
		tween(btn, {Size = origSize}, 0.12, Enum.EasingStyle.Back):Play()
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, {Size = origSize}, 0.12):Play()
	end)
end

-- ====== 模糊背景 ======
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0
tween(blur, {Size = C.Blur}, 0.4):Play()

-- ====== ScreenGui ======
local gui = Instance.new("ScreenGui")
gui.Name = "iOS_Pro_Draggable"
gui.Parent = PlayerGui
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ====== 主容器 ======
local root = Instance.new("Frame", gui)
root.AnchorPoint = Vector2.new(0.5, 0.5)
root.Position = UDim2.fromScale(0.5, 0.45)
root.Size = UDim2.new(0, C.Width, 0, C.Height)
root.BackgroundColor3 = Theme.Glass
root.BackgroundTransparency = 0.18
root.BorderSizePixel = 0
root.Active = true
corner(root, C.Radius)

local shadow = Instance.new("ImageLabel", root)
shadow.Size = UDim2.new(1, 50, 1, 50)
shadow.Position = UDim2.new(0, -25, 0, -15)
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.85
shadow.BackgroundTransparency = 1
shadow.ZIndex = -1
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 10, 10)

-- ====== 拖拽条 ======
local grabberArea = Instance.new("Frame", root)
grabberArea.Name = "GrabberArea"
grabberArea.Size = UDim2.new(1, 0, 0, 36)
grabberArea.BackgroundTransparency = 1
grabberArea.Active = true

local grabber = Instance.new("Frame", grabberArea)
grabber.AnchorPoint = Vector2.new(0.5, 0.5)
grabber.Position = UDim2.new(0.5, 0, 0.5, 0)
grabber.Size = UDim2.new(0, 36, 0, 4)
grabber.BackgroundColor3 = Theme.Grabber
grabber.BackgroundTransparency = 0.3
grabber.BorderSizePixel = 0
corner(grabber, 999)

-- ====== 导航栏 ======
local nav = Instance.new("Frame", root)
nav.Size = UDim2.new(1, 0, 0, C.NavHeight)
nav.BackgroundTransparency = 1

local title = Instance.new("TextLabel", nav)
title.Text = "shible"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 17
title.TextColor3 = Theme.TextPrimary
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 14, 0, 0)
title.Size = UDim2.new(1, -80, 1, 0)
title.TextXAlignment = Enum.TextXAlignment.Left

local minBtn = Instance.new("TextButton", nav)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.TextColor3 = Theme.TextSecondary
minBtn.BackgroundTransparency = 1
minBtn.Position = UDim2.new(1, -40, 0, 10)
minBtn.Size = UDim2.new(0, 28, 0, 24)
minBtn.AutoButtonColor = false

-- ====== 内容容器 ======
local contentContainer = Instance.new("Frame", root)
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, 0, 1, -C.NavHeight)
contentContainer.Position = UDim2.new(0, 0, 0, C.NavHeight)
contentContainer.BackgroundTransparency = 1
contentContainer.ClipsDescendants = true

-- ====== 主页面 ======
local pageMain = Instance.new("Frame", contentContainer)
pageMain.Name = "Page_Main"
pageMain.Size = UDim2.new(1, 0, 1, 0)
pageMain.BackgroundTransparency = 1

local introContainer = Instance.new("Frame", pageMain)
introContainer.Name = "IntroContainer"
introContainer.BackgroundTransparency = 1
introContainer.Position = UDim2.new(0, 16, 0, 8)
introContainer.Size = UDim2.new(1, -32, 1, -96)
introContainer.ClipsDescendants = false

local subtitle = Instance.new("TextLabel", introContainer)
subtitle.Text = "欢迎使用\n请进🐧:434448780"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 14
subtitle.TextColor3 = Theme.TextSecondary
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 0, 0, 0)
subtitle.Size = UDim2.new(1, 0, 1, 0)
subtitle.TextYAlignment = Enum.TextYAlignment.Top
subtitle.TextWrapped = true
subtitle.AutomaticSize = Enum.AutomaticSize.Y

local function fitTextToContainer()
	local containerHeight = introContainer.AbsoluteSize.Y
	local containerWidth = introContainer.AbsoluteSize.X
	local lineHeight = math.max(16, containerHeight / 4)
	local fontSize = math.clamp(math.floor(lineHeight * 0.55), 12, 22)
	subtitle.TextSize = fontSize
	subtitle.TextWrapped = true
end

task.defer(fitTextToContainer)
pageMain:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitTextToContainer)
introContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitTextToContainer)

local btnY = C.Height - 96

local confirm = Instance.new("TextButton", pageMain)
confirm.Text = "确认"
confirm.Font = Enum.Font.GothamSemibold
confirm.TextSize = 14
confirm.TextColor3 = Theme.Accent
confirm.BackgroundTransparency = 1
confirm.Position = UDim2.new(0, 16, 0, btnY)
confirm.Size = UDim2.new(0.5, -22, 0, 36)
confirm.AutoButtonColor = false
pressEffect(confirm)

local closeBtn = Instance.new("TextButton", pageMain)
closeBtn.Text = "关闭"
closeBtn.Font = Enum.Font.GothamSemibold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Theme.Danger
closeBtn.BackgroundTransparency = 1
closeBtn.Position = UDim2.new(0.5, 6, 0, btnY)
closeBtn.Size = UDim2.new(0.5, -22, 0, 36)
closeBtn.AutoButtonColor = false
pressEffect(closeBtn)

-- ====== 功能面板 ======
local pageFunction = Instance.new("Frame", contentContainer)
pageFunction.Name = "Page_Function"
pageFunction.Size = UDim2.new(1, 0, 1, 0)
pageFunction.BackgroundTransparency = 1
pageFunction.Visible = false
pageFunction.Position = UDim2.new(1, 0, 0, 0)

local panelY = C.NavHeight + C.FuncPanelGap
local panelBottomReserved = C.BackBtnHeight

-- ====== 左侧功能列表 ======
local funcList = Instance.new("ScrollingFrame", pageFunction)
funcList.Name = "FuncList"
funcList.Size = UDim2.new(0.25, -6, 1, -panelBottomReserved - 8)
funcList.Position = UDim2.new(0, 6, 0, 0)
funcList.BackgroundColor3 = Theme.Glass
funcList.BackgroundTransparency = 0.35
funcList.BorderSizePixel = 0
funcList.ScrollBarThickness = 3
funcList.AutomaticCanvasSize = Enum.AutomaticSize.Y
funcList.CanvasSize = UDim2.new(0, 0, 0, 0)
corner(funcList, 12)

local listLayout = Instance.new("UIListLayout", funcList)
listLayout.Padding = UDim.new(0, 6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local listPadding = Instance.new("UIPadding", funcList)
listPadding.PaddingTop = UDim.new(0, 6)
listPadding.PaddingBottom = UDim.new(0, 6)
listPadding.PaddingLeft = UDim.new(0, 6)
listPadding.PaddingRight = UDim.new(0, 6)

-- ====== 右侧内容容器 ======
local funcContent = Instance.new("Frame", pageFunction)
funcContent.Name = "FuncContent"
funcContent.Size = UDim2.new(0.75, -12, 1, -panelBottomReserved - 8)
funcContent.Position = UDim2.new(0.25, 6, 0, 0)
funcContent.BackgroundColor3 = Theme.Glass
funcContent.BackgroundTransparency = 0.25
funcContent.BorderSizePixel = 0
funcContent.ClipsDescendants = true
corner(funcContent, 12)

-- ====== 创建功能页 ======
local function createContentPage(name)
	local page = Instance.new("Frame")
	page.Name = name.."_Page"
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = funcContent
	return page
end

local pages = {
	Aim = createContentPage("Aim"),
	Speed = createContentPage("Speed"),
	Resource = createContentPage("Resource"),
	Fly = createContentPage("Fly"),
}

-- ====== 功能状态存储 ======
local FuncState = {
	AimEnabled = false,
	SpeedEnabled = false,
	SpeedValue = 16,
	HealthBarEnabled = false,
	ShowFovCircle = true,
	FlyEnabled = false,
	FlySpeed = 80,
}

-- ====== 工具：创建 iOS 风格开关按钮 ======
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

	local thumb = Instance.new("Frame", track)
	thumb.Size = UDim2.new(0, 22, 0, 22)
	thumb.Position = UDim2.new(0, 3, 0, 3)
	thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	thumb.BorderSizePixel = 0
	corner(thumb, 11)

	local on = getState()
	if on then
		track.BackgroundColor3 = Theme.Accent
		thumb.Position = UDim2.new(1, -25, 0, 3)
	end

	local function setState(val)
		on = val
		if on then
			tween(track, {BackgroundColor3 = Theme.Accent}, 0.2):Play()
			tween(thumb, {Position = UDim2.new(1, -25, 0, 3)}, 0.2):Play()
		else
			tween(track, {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}, 0.2):Play()
			tween(thumb, {Position = UDim2.new(0, 3, 0, 3)}, 0.2):Play()
		end
		onToggle(val)
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			setState(not on)
		end
	end)

	return {setState = setState, getState = function() return on end}
end

-- ====== 工具：创建滑块 ======
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
	lbl.Size = UDim2.new(0.45, 0, 0, 18)
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

	local thumbShadow = Instance.new("Frame", track)
	thumbShadow.Size = UDim2.new(0, 22, 0, 22)
	thumbShadow.Position = UDim2.new(0, -11, 0, -5)
	thumbShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	thumbShadow.BackgroundTransparency = 0.7
	thumbShadow.BorderSizePixel = 0
	thumbShadow.ZIndex = 3
	corner(thumbShadow, 11)

	local dragging = false

	local function setVal(val, fromInput)
		val = math.floor(math.clamp(val, minVal, maxVal))
		local ratio = (val - minVal) / (maxVal - minVal)
		if inputBox.Text ~= tostring(val) then
			inputBox.Text = tostring(val)
		end
		thumb.Position = UDim2.new(ratio, -9, 0, -3)
		fill.Size = UDim2.new(ratio, 0, 1, 0)
		onChanged(val)
	end

	local function updateFromMouse()
		local mouse = UserInputService:GetMouseLocation()
		local trackAbsPos = track.AbsolutePosition
		local trackAbsSize = track.AbsoluteSize
		local ratio = math.clamp((mouse.X - trackAbsPos.X) / trackAbsSize.X, 0, 1)
		local val = math.floor(minVal + ratio * (maxVal - minVal))
		setVal(val, false)
	end

	track.MouseButton1Down:Connect(function()
		dragging = true
		updateFromMouse()
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateFromMouse()
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	local function applyInput()
		local txt = inputBox.Text:gsub("[^0-9%-]", "")
		if txt == "" or txt == "-" then txt = tostring(minVal) end
		local val = tonumber(txt) or minVal
		setVal(val, true)
	end

	inputBox.FocusLost:Connect(function()
		applyInput()
	end)

	setVal(initial, true)

	return {update = function(v) setVal(v, true) end}
end

-- ====== 获取本地玩家 ======
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

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

-- ====== 自动瞄准（静默）=====
do
	local p = pages.Aim
	local y = 10

	local titleLbl = Instance.new("TextLabel", p)
	titleLbl.Text = "自动瞄准"
	titleLbl.Font = Enum.Font.GothamSemibold
	titleLbl.TextSize = 14
	titleLbl.TextColor3 = Theme.TextPrimary
	titleLbl.BackgroundTransparency = 1
	titleLbl.Position = UDim2.new(0, 12, 0, y)
	titleLbl.Size = UDim2.new(1, -24, 0, 20)
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left

	y = y + 30
	local aimToggle = createToggle(p, y, "启用静默自瞄", function() return FuncState.AimEnabled end, function(val)
		FuncState.AimEnabled = val
	end)

	y = y + 46
	local fovSlider = createSlider(p, y, "瞄准 FOV", 5, 120, 45, function(val)
		FuncState.AimFOV = val
	end)
	FuncState.AimFOV = 45

	y = y + 60
	local smoothSlider = createSlider(p, y, "平滑度", 1, 50, 20, function(val)
		FuncState.AimSmooth = val
	end)
	FuncState.AimSmooth = 20

	local function getClosestEnemy()
		local cam = workspace.CurrentCamera
		local center = Vector2.new(cam.ViewportSize.X * 0.5, cam.ViewportSize.Y * 0.5)
		local closest, closestDist = nil, math.huge

		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				local char = plr.Character
				if char then
					local head = char:FindFirstChild("Head")
					local hum = char:FindFirstChild("Humanoid")
					if head and hum and hum.Health > 0 then
						local screenPos, onScreen = cam:WorldToScreenPoint(head.Position)
						if onScreen then
							local dx = screenPos.X - center.X
							local dy = screenPos.Y - center.Y
							local dist = dx*dx + dy*dy
							if dist < closestDist then
								closestDist = dist
								closest = head
							end
						end
					end
				end
			end
		end
		return closest
	end

	RunService.RenderStepped:Connect(function()
		if not FuncState.AimEnabled then return end
		local target = getClosestEnemy()
		if not target then return end

		local cam = workspace.CurrentCamera
		local smoothVal = FuncState.AimSmooth or 20
		local t = 1 / (smoothVal * 0.6 + 1)

		local camPos = cam.CFrame.Position
		local targetPos = target.Position
		local targetDir = (targetPos - camPos).Unit
		local currentDir = cam.CFrame.LookVector
		local dot = math.clamp(currentDir:Dot(targetDir), -1, 1)
		local angle = math.acos(dot)

		if angle < 0.001 then
			cam.CFrame = CFrame.new(camPos, camPos + targetDir)
			return
		end

		local targetCFrame = CFrame.new(camPos, camPos + targetDir)
		cam.CFrame = cam.CFrame:Lerp(targetCFrame, math.clamp(t, 0.03, 0.95))
	end)
end

-- ====== 速度增强 ======
do
	local p = pages.Speed
	local y = 10

	local titleLbl = Instance.new("TextLabel", p)
	titleLbl.Text = "速度增强"
	titleLbl.Font = Enum.Font.GothamSemibold
	titleLbl.TextSize = 14
	titleLbl.TextColor3 = Theme.TextPrimary
	titleLbl.BackgroundTransparency = 1
	titleLbl.Position = UDim2.new(0, 12, 0, y)
	titleLbl.Size = UDim2.new(1, -24, 0, 20)
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left

	y = y + 30
	local speedToggle = createToggle(p, y, "启用加速", function() return FuncState.SpeedEnabled end, function(val)
		FuncState.SpeedEnabled = val
		local h = getHumanoid()
		if h then
			h.WalkSpeed = val and (FuncState.SpeedValue or 16) or 16
		end
	end)

	y = y + 46
	local speedSlider = createSlider(p, y, "移动速度 (16-700)", 16, 700, 50, function(val)
		FuncState.SpeedValue = val
		if FuncState.SpeedEnabled then
			local h = getHumanoid()
			if h then h.WalkSpeed = val end
		end
	end)

	LocalPlayer.CharacterAdded:Connect(function(char)
		char:WaitForChild("Humanoid")
		if FuncState.SpeedEnabled then
			local h = char:FindFirstChild("Humanoid")
			if h then h.WalkSpeed = FuncState.SpeedValue or 50 end
		end
	end)
end

-- ====== 玩家透视 ======
do
	local p = pages.Resource
	local y = 10

	local titleLbl = Instance.new("TextLabel", p)
	titleLbl.Text = "玩家透视"
	titleLbl.Font = Enum.Font.GothamSemibold
	titleLbl.TextSize = 14
	titleLbl.TextColor3 = Theme.TextPrimary
	titleLbl.BackgroundTransparency = 1
	titleLbl.Position = UDim2.new(0, 12, 0, y)
	titleLbl.Size = UDim2.new(1, -24, 0, 20)
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left

	y = y + 30
	local espToggle = createToggle(p, y, "全身透视", function() return FuncState.ESPEnabled end, function(val)
		FuncState.ESPEnabled = val
	end)

	y = y + 46
	local healthBarToggle = createToggle(p, y, "头顶血条", function() return FuncState.HealthBarEnabled end, function(val)
		FuncState.HealthBarEnabled = val
	end)

	local function clearAll()
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character then
				local hl = plr.Character:FindFirstChild("ESP_Highlight")
				if hl then hl:Destroy() end
				local head = plr.Character:FindFirstChild("Head")
				if head then
					local hb = head:FindFirstChild("ESP_HealthBar")
					if hb then hb:Destroy() end
				end
			end
		end
	end

	local function createHealthBar(plr, head)
		local bb = Instance.new("BillboardGui")
		bb.Name = "ESP_HealthBar"
		bb.Size = UDim2.new(0, 70, 0, 14)
		bb.StudsOffset = Vector3.new(0, 1.5, 0)
		bb.Adornee = head
		bb.AlwaysOnTop = true
		bb.MaxDistance = 500
		bb.Parent = head

		local bg = Instance.new("Frame", bb)
		bg.Size = UDim2.new(1, 0, 1, 0)
		bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		bg.BorderSizePixel = 0
		local bgCorner = Instance.new("UICorner", bg)
		bgCorner.CornerRadius = UDim.new(0, 4)

		local fill = Instance.new("Frame", bb)
		fill.Name = "Fill"
		fill.Size = UDim2.new(1, 0, 1, 0)
		fill.BackgroundColor3 = Color3.fromRGB(0, 255, 60)
		fill.BorderSizePixel = 0
		local fillCorner = Instance.new("UICorner", fill)
		fillCorner.CornerRadius = UDim.new(0, 4)

		local pctLabel = Instance.new("TextLabel", bb)
		pctLabel.Name = "PctLabel"
		pctLabel.Size = UDim2.new(1, 0, 1, 0)
		pctLabel.BackgroundTransparency = 1
		pctLabel.Text = "100%"
		pctLabel.Font = Enum.Font.GothamBold
		pctLabel.TextSize = 9
		pctLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		pctLabel.TextStrokeTransparency = 0.4
	end

	local function updateHealthBars()
		if not FuncState.HealthBarEnabled then return end
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				local char = plr.Character
				if char then
					local head = char:FindFirstChild("Head")
					local hum = char:FindFirstChild("Humanoid")
					if head and hum and hum.Health > 0 then
						local bb = head:FindFirstChild("ESP_HealthBar")
						if not bb then
							pcall(function() createHealthBar(plr, head) end)
							bb = head:FindFirstChild("ESP_HealthBar")
						end
						if bb then
							local fill = bb:FindFirstChild("Fill")
							local pctLabel = bb:FindFirstChild("PctLabel")
							local ratio = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
							if fill then
								fill.Size = UDim2.new(ratio, 0, 1, 0)
								if ratio > 0.5 then
									fill.BackgroundColor3 = Color3.fromRGB(0, 255, 60)
								elseif ratio > 0.25 then
									fill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
								else
									fill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
								end
							end
							if pctLabel then
								pctLabel.Text = math.floor(ratio * 100) .. "%"
							end
						end
					end
				end
			end
		end
	end

	local function createHighlightESP(plr, char)
		local hl = char:FindFirstChild("ESP_Highlight")
		if hl then hl:Destroy() end
		hl = Instance.new("Highlight")
		hl.Name = "ESP_Highlight"
		hl.Adornee = char
		hl.FillColor = Color3.fromRGB(255, 0, 0)
		hl.FillTransparency = 0.5
		hl.OutlineColor = Color3.fromRGB(255, 50, 50)
		hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		hl.Parent = char
	end

	local function updateESP()
		clearAll()
		if not (FuncState.ESPEnabled or FuncState.HealthBarEnabled) then return end
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				local char = plr.Character
				if char then
					local head = char:FindFirstChild("Head")
					local hum = char:FindFirstChild("Humanoid")
					if head and hum and hum.Health > 0 then
						if FuncState.ESPEnabled then
							pcall(function() createHighlightESP(plr, char) end)
						end
						if FuncState.HealthBarEnabled then
							pcall(function() createHealthBar(plr, head) end)
						end
					end
				end
			end
		end
	end

	spawn(function()
		while true do
			if FuncState.HealthBarEnabled then
				pcall(updateHealthBars)
			end
			wait(0.1)
		end
	end)

	spawn(function()
		while true do
			updateESP()
			wait(1)
		end
	end)

	Players.PlayerAdded:Connect(function(plr)
		plr.CharacterAdded:Connect(function()
			task.wait(0.5)
			updateESP()
		end)
	end)
end

-- ====== 飞天（单按钮执行飞行脚本）=====
do
	local p = pages.Fly
	local y = 20

	local titleLbl = Instance.new("TextLabel", p)
	titleLbl.Text = "shible · 飞行"
	titleLbl.Font = Enum.Font.GothamSemibold
	titleLbl.TextSize = 14
	titleLbl.TextColor3 = Theme.TextPrimary
	titleLbl.BackgroundTransparency = 1
	titleLbl.Position = UDim2.new(0, 12, 0, y)
	titleLbl.Size = UDim2.new(1, -24, 0, 20)
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left

	y = y + 36

	local execBtn = Instance.new("TextButton", p)
	execBtn.Text = "启动飞行"
	execBtn.Font = Enum.Font.GothamSemibold
	execBtn.TextSize = 14
	execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	execBtn.BackgroundColor3 = Theme.Accent
	execBtn.AutoButtonColor = false
	execBtn.Position = UDim2.new(0, 12, 0, y)
	execBtn.Size = UDim2.new(1, -24, 0, 40)
	corner(execBtn, 10)
	pressEffect(execBtn)

	-- 通知函数
	local function sendNotification(title, text)
		task.spawn(function()
			local success = false
			local retryTimes = 0
			while not success and retryTimes < 5 do
				retryTimes += 1
				success = pcall(function()
					game:GetService("StarterGui"):SetCore("SendNotification", {
						Title = title,
						Text = text,
						Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150",
						Duration = 2
					})
				end)
				if not success then
					task.wait(0.2)
				end
			end
		end)
	end

	execBtn.MouseButton1Click:Connect(function()
		spring(execBtn, {TextSize = 16}, 0.15)
		task.delay(0.15, function()
			spring(execBtn, {TextSize = 14}, 0.2)
		end)

		task.spawn(function()
			local success, err = pcall(function()
				local main = Instance.new("ScreenGui")
				main.Name = "shible飞行"
				main.ResetOnSpawn = false
				main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

				local Frame = Instance.new("Frame", main)
				Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
				Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
				Frame.Position = UDim2.new(0.1, 0, 0.38, 0)
				Frame.Size = UDim2.new(0, 190, 0, 57)
				Frame.Active = true
				Frame.Draggable = true

				local up = Instance.new("TextButton", Frame)
				up.Size = UDim2.new(0, 44, 0, 28)
				up.Text = "上升"
				up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)

				local down = Instance.new("TextButton", Frame)
				down.Size = UDim2.new(0, 44, 0, 28)
				down.Position = UDim2.new(0, 0, 0.49, 0)
				down.Text = "下落"
				down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)

				local onof = Instance.new("TextButton", Frame)
				onof.Size = UDim2.new(0, 56, 0, 28)
				onof.Position = UDim2.new(0.7, 0, 0.49, 0)
				onof.Text = "飞"
				onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)

				local TextLabel = Instance.new("TextLabel", Frame)
				TextLabel.Size = UDim2.new(0, 100, 0, 28)
				TextLabel.Position = UDim2.new(0.47, 0, 0, 0)
				TextLabel.Text = "shible"
				TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
				TextLabel.TextScaled = true

				local plus = Instance.new("TextButton", Frame)
				plus.Size = UDim2.new(0, 45, 0, 28)
				plus.Position = UDim2.new(0.23, 0, 0, 0)
				plus.Text = "+"
				plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
				plus.TextScaled = true

				local speed = Instance.new("TextLabel", Frame)
				speed.Size = UDim2.new(0, 44, 0, 28)
				speed.Position = UDim2.new(0.47, 0, 0.49, 0)
				speed.Text = "1"
				speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
				speed.TextScaled = true

				local mine = Instance.new("TextButton", Frame)
				mine.Size = UDim2.new(0, 45, 0, 29)
				mine.Position = UDim2.new(0.23, 0, 0.49, 0)
				mine.Text = "-"
				mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
				mine.TextScaled = true

				local closebutton = Instance.new("TextButton", Frame)
				closebutton.Size = UDim2.new(0, 45, 0, 28)
				closebutton.Position = UDim2.new(0, 0, -1, 27)
				closebutton.Text = "X"
				closebutton.TextSize = 30
				closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)

				local mini = Instance.new("TextButton", Frame)
				mini.Size = UDim2.new(0, 45, 0, 28)
				mini.Position = UDim2.new(0, 44, -1, 27)
				mini.Text = "-"
				mini.TextSize = 40
				mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)

				local mini2 = Instance.new("TextButton", Frame)
				mini2.Size = UDim2.new(0, 45, 0, 28)
				mini2.Position = UDim2.new(0, 44, 0, 30)
				mini2.Text = "+"
				mini2.TextSize = 40
				mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
				mini2.Visible = false

				local speaker = game.Players.LocalPlayer
				local chr = speaker.Character or speaker.CharacterAdded:Wait()
				local hum = chr:FindFirstChildOfClass("Humanoid")
				local nowe = false
				local speeds = 1

				sendNotification("飞行脚本", "创作者：shible")

				closebutton.MouseButton1Click:Connect(function()
					main:Destroy()
				end)

				up.MouseButton1Click:Connect(function()
					if chr and chr:FindFirstChild("HumanoidRootPart") then
						chr.HumanoidRootPart.CFrame += Vector3.new(0, 3, 0)
					end
				end)

				down.MouseButton1Click:Connect(function()
					if chr and chr:FindFirstChild("HumanoidRootPart") then
						chr.HumanoidRootPart.CFrame += Vector3.new(0, -3, 0)
					end
				end)

				mini.MouseButton1Click:Connect(function()
					for _, v in ipairs({up, down, onof, plus, speed, mine, closebutton}) do
						v.Visible = false
					end
					mini.Visible = false
					mini2.Visible = true
					Frame.Size = UDim2.new(0, 100, 0, 28)
					TextLabel.Position = UDim2.new(0, 0, 0, 0)
				end)

				mini2.MouseButton1Click:Connect(function()
					for _, v in ipairs({up, down, onof, plus, speed, mine, closebutton}) do
						v.Visible = true
					end
					mini.Visible = true
					mini2.Visible = false
					Frame.Size = UDim2.new(0, 190, 0, 57)
					TextLabel.Position = UDim2.new(0.47, 0, 0, 0)
				end)

				plus.MouseButton1Click:Connect(function()
					speeds += 1
					speed.Text = tostring(speeds)
				end)

				mine.MouseButton1Click:Connect(function()
					if speeds > 1 then
						speeds -= 1
						speed.Text = tostring(speeds)
					else
						speed.Text = "错误"
						task.wait(0.2)
						speed.Text = "1"
					end
				end)

				local moveConn, renderConn, bgObj, bvObj

				local function resetHumanoid()
					if hum then
						for _, s in pairs(Enum.HumanoidStateType:GetEnumItems()) do
							hum:SetStateEnabled(s, true)
						end
						hum.PlatformStand = false
						hum:ChangeState(Enum.HumanoidStateType.Running)
					end
					if chr and chr:FindFirstChild("Animate") then
						chr.Animate.Disabled = false
					end
				end

				local function stopFlight()
					if moveConn then moveConn:Disconnect() moveConn = nil end
					if renderConn then renderConn:Disconnect() renderConn = nil end
					if bgObj then bgObj:Destroy() bgObj = nil end
					if bvObj then bvObj:Destroy() bvObj = nil end
					resetHumanoid()
				end

				local function startFlight()
					stopFlight()
					if not hum then return end

					chr = speaker.Character
					hum = chr:FindFirstChildOfClass("Humanoid")
					if not hum then return end

					for _, s in pairs(Enum.HumanoidStateType:GetEnumItems()) do
						hum:SetStateEnabled(s, false)
					end
					hum:ChangeState(Enum.HumanoidStateType.Swimming)
					if chr:FindFirstChild("Animate") then
						chr.Animate.Disabled = true
					end

					moveConn = game:GetService("RunService").Heartbeat:Connect(function()
						if not nowe or not hum or hum.Health <= 0 then return end
						if hum.MoveDirection.Magnitude > 0 then
							chr:TranslateBy(hum.MoveDirection * speeds)
						end
					end)

					local torso = chr:FindFirstChild("Torso") or chr:FindFirstChild("UpperTorso")
					if torso then
						bgObj = Instance.new("BodyGyro", torso)
						bgObj.P = 9e4
						bgObj.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
						bvObj = Instance.new("BodyVelocity", torso)
						bvObj.Velocity = Vector3.zero
						bvObj.MaxForce = Vector3.new(9e9, 9e9, 9e9)

						renderConn = game:GetService("RunService").RenderStepped:Connect(function()
							if not nowe or not torso or not torso.Parent then
								stopFlight()
								return
							end
							bgObj.CFrame = workspace.CurrentCamera.CoordinateFrame
						end)
					end
				end

				speaker.CharacterAdded:Connect(function(newChr)
					nowe = false
					onof.Text = "飞"
					chr = newChr
					hum = chr:WaitForChild("Humanoid")
					stopFlight()
				end)

				onof.MouseButton1Click:Connect(function()
					nowe = not nowe
					onof.Text = nowe and "停" or "飞"
					if nowe then
						startFlight()
					else
						stopFlight()
					end
				end)
			end)

			if success then
				sendNotification("功能召唤", "飞行脚本已成功加载")
			else
				sendNotification("加载失败", "飞行脚本出错："..tostring(err))
			end
		end)
	end)
end

-- ====== 初始化功能列表 ======
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

	local label = Instance.new("TextLabel", item)
	label.Text = name
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 13
	label.TextColor3 = Theme.TextPrimary
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -12, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.TextXAlignment = Enum.TextXAlignment.Left

	item.MouseEnter:Connect(function()
		if selectedItem ~= item then
			tween(item, {BackgroundTransparency = 0.35}, 0.15):Play()
		end
	end)

	item.MouseLeave:Connect(function()
		if selectedItem ~= item then
			tween(item, {BackgroundTransparency = 0.6}, 0.15):Play()
		end
	end)

	item.MouseButton1Click:Connect(function()
		if selectedItem then
			tween(selectedItem, {BackgroundTransparency = 0.6}, 0.2):Play()
		end
		selectedItem = item
		tween(item, {BackgroundTransparency = 0.2}, 0.2):Play()

		for _, p in pairs(pages) do p.Visible = false end
		pages[key].Visible = true
	end)
end

local funcMap = {
	{Name = "自动瞄准", Key = "Aim"},
	{Name = "速度增强", Key = "Speed"},
	{Name = "玩家透视", Key = "Resource"},
	{Name = "飞天",     Key = "Fly"},
}

for _, v in ipairs(funcMap) do
	createFuncItem(v.Name, v.Key)
end

task.defer(function()
	for _, btn in ipairs(funcList:GetChildren()) do
		if btn:IsA("TextButton") then
			btn.MouseButton1Click:Fire()
			break
		end
	end
end)

-- ====== 返回按钮 ======
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

-- ====== 迷你面板 ======
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

local miniGrabber = Instance.new("Frame", mini)
miniGrabber.AnchorPoint = Vector2.new(0.5, 0)
miniGrabber.Size = UDim2.new(0, 28, 0, 3)
miniGrabber.Position = UDim2.new(0.5, 0, 0, 5)
miniGrabber.BackgroundColor3 = Theme.Grabber
miniGrabber.BackgroundTransparency = 0.35
miniGrabber.BorderSizePixel = 0
corner(miniGrabber, 999)

local miniLabel = Instance.new("TextLabel", mini)
miniLabel.Text = "已最小化"
miniLabel.Font = Enum.Font.Gotham
miniLabel.TextSize = 12
miniLabel.TextColor3 = Theme.TextPrimary
miniLabel.BackgroundTransparency = 1
miniLabel.Position = UDim2.new(0, 12, 0, 12)
miniLabel.Size = UDim2.new(1, -70, 1, -24)

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

-- ====== 拖拽系统 ======
local DragSystem = {}

function DragSystem.enable(frame, opts)
	opts = opts or {}
	local smoothness = opts.smoothness or C.DragSmoothness
	local clampY = opts.clampY ~= false

	local dragging = false
	local startMousePos
	local startFramePos

	local shadowObj
	for _, c in ipairs(frame:GetChildren()) do
		if c:IsA("ImageLabel") then shadowObj = c break end
	end

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startMousePos = input.Position
			startFramePos = frame.Position

			if shadowObj then
				tween(shadowObj, {ImageTransparency = 0.7, Size = shadowObj.Size + UDim2.new(0,10,0,10)}, 0.15):Play()
			end
			tween(frame, {Size = frame.Size + UDim2.new(0,4,0,2)}, 0.15):Play()
		end
	end)

	frame.InputEnded:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false
			if shadowObj then
				tween(shadowObj, {ImageTransparency = 0.85, Size = shadowObj.Size - UDim2.new(0,10,0,10)}, 0.2):Play()
			end
			tween(frame, {Size = frame.Size - UDim2.new(0,4,0,2)}, 0.2):Play()
		end
	end)

	local lastPos = UDim2.new()

	RunService.RenderStepped:Connect(function()
		if dragging and startMousePos then
			local mouse = UserInputService:GetMouseLocation()
			local delta = mouse - startMousePos
			local newX = startFramePos.X.Offset + delta.X
			local newY = startFramePos.Y.Offset + delta.Y

			if clampY then newY = math.max(0, newY) end

			local screenSize = gui.AbsoluteSize
			local frameSize = frame.AbsoluteSize
			newX = math.clamp(newX, -frameSize.X/2, screenSize.X-frameSize.X/2)

			local targetPos = UDim2.new(0, newX, 0, newY)
			lastPos = UDim2.new(
				lastPos.X.Scale + (targetPos.X.Scale - lastPos.X.Scale)*smoothness,
				lastPos.X.Offset + (targetPos.X.Offset - lastPos.X.Offset)*smoothness,
				lastPos.Y.Scale + (targetPos.Y.Scale - lastPos.Y.Scale)*smoothness,
				lastPos.Y.Offset + (targetPos.Y.Offset - lastPos.Y.Offset)*smoothness
			)
			frame.Position = lastPos
		end
	end)
end

DragSystem.enable(root)
DragSystem.enable(mini)

-- ====== 按钮逻辑 ======
minBtn.MouseButton1Click:Connect(function()
	tween(root, {Size = UDim2.new(0,C.Width,0,0), BackgroundTransparency = 1}, 0.25):Play()
	tween(blur, {Size = 6}, 0.25):Play()
	task.delay(0.2, function()
		root.Visible = false
		mini.Visible = true
		mini.Size = UDim2.new(0,140,0,40)
		mini.BackgroundTransparency = 1
		tween(mini, {Size = UDim2.new(0,160,0,48), BackgroundTransparency = 0.12}, 0.3, Enum.EasingStyle.Back):Play()
	end)
end)

restore.MouseButton1Click:Connect(function()
	mini.Visible = false
	root.Visible = true
	tween(blur, {Size = C.Blur}, 0.25):Play()
	root.Size = UDim2.new(0,C.Width,0,0)
	root.BackgroundTransparency = 1
	spring(root, {Size = UDim2.new(0,C.Width,0,C.Height), BackgroundTransparency = 0.18}):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
	tween(blur, {Size = 0}, 0.3):Play()
	spring(root, {Size = UDim2.new(0,C.Width,0,0), BackgroundTransparency = 1}):Play()
	task.wait(0.45)
	local fovGui = PlayerGui:FindFirstChild("FOV_Circle")
	if fovGui then fovGui:Destroy() end
	gui:Destroy()
	blur:Destroy()
end)

confirm.MouseButton1Click:Connect(function()
	spring(confirm, {TextSize = 16}, 0.15)
	task.delay(0.15, function()
		spring(confirm, {TextSize = 14}, 0.2)
	end)

	tween(pageMain, {Position = UDim2.new(-1,0,0,0)}, 0.3, Enum.EasingStyle.Quint):Play()
	pageFunction.Visible = true
	pageFunction.Position = UDim2.new(1,0,0,0)
	tween(pageFunction, {Position = UDim2.new(0,0,0,0)}, 0.3, Enum.EasingStyle.Quint):Play()
end)

backBtn.MouseButton1Click:Connect(function()
	tween(pageFunction, {Position = UDim2.new(1,0,0,0)}, 0.3, Enum.EasingStyle.Quint):Play()
	pageMain.Visible = true
	pageMain.Position = UDim2.new(-1,0,0,0)
	tween(pageMain, {Position = UDim2.new(0,0,0,0)}, 0.3, Enum.EasingStyle.Quint):Play()
	task.delay(0.3, function()
		pageFunction.Visible = false
	end)
end)

-- ====== 入场动画 ======
root.Size = UDim2.new(0,C.Width,0,0)
root.BackgroundTransparency = 1
spring(root, {Size = UDim2.new(0,C.Width,0,C.Height), BackgroundTransparency = 0.18}):Play()
tween(blur, {Size = C.Blur}, 0.5):Play()

print("iOS 高级拖拽 UI 加载完成")
