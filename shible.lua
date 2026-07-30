-- ============================================================
--  shible · 完整源码（UI 保底可见 + ESP不闪 + 血条纤细 + 甩飞不碰自己）
--  【已移除碰飞】【全部甩飞→视角跟随·修复】【玩家列表·可点选·修复】【防甩飞互斥】
-- ============================================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

-- 安全获取 LocalPlayer
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
	LocalPlayer = Players.PlayerAdded:Wait()
end

-- 安全获取 PlayerGui（带超时）
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
if not PlayerGui then
	PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 15)
end

local RunService = game:GetService("RunService")

-- ====== 参数 ======
local C = {
	Width = 280,
	Height = 280,
	Radius = 22,
	Blur = 24,
	Spring = Enum.EasingStyle.Elastic,
	Duration = 0.55,
	DragSmoothness = 0.25,
	NavHeight = 44,
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
	local pressed = UDim2.new(orig.X.Scale*sx, orig.X.Offset*sx, orig.Y.Scale*sy, orig.Y.Offset*sy)
	btn.MouseButton1Down:Connect(function() makeTween(btn, {Size=pressed}, 0.08) end)
	btn.MouseButton1Up:Connect(function() makeTween(btn, {Size=orig}, 0.12, Enum.EasingStyle.Back) end)
	btn.MouseLeave:Connect(function() makeTween(btn, {Size=orig}, 0.12) end)
end

local function safeCall(fn, ctx)
	local ok, err = pcall(fn)
	if not ok then
		warn("[shible] " .. (ctx or "?") .. " 出错: " .. tostring(err))
	end
end

-- ====== 模糊背景 ======
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting
makeTween(blur, {Size = C.Blur}, 0.4)

-- ====== ScreenGui ======
local gui = Instance.new("ScreenGui")
gui.Name = "iOS_Pro_Draggable"
gui.Parent = PlayerGui
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Enabled = true

-- ====== 主容器 ======
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

-- ====== 拖拽条 ======
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

-- ====== 导航栏 ======
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
title.Size = UDim2.new(1, -80, 1, 0)
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
minBtn.Parent = nav

-- ====== 内容容器 ======
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, 0, 1, -C.NavHeight)
contentContainer.Position = UDim2.new(0, 0, 0, C.NavHeight)
contentContainer.BackgroundTransparency = 1
contentContainer.ClipsDescendants = true
contentContainer.Parent = root

-- ====== 主页面 ======
local pageMain = Instance.new("Frame")
pageMain.Size = UDim2.new(1, 0, 1, 0)
pageMain.BackgroundTransparency = 1
pageMain.Visible = true
pageMain.Parent = contentContainer

local introContainer = Instance.new("Frame")
introContainer.BackgroundTransparency = 1
introContainer.Position = UDim2.new(0, 16, 0, 8)
introContainer.Size = UDim2.new(1, -32, 1, -96)
introContainer.ClipsDescendants = false
introContainer.Parent = pageMain

local subtitle = Instance.new("TextLabel")
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
subtitle.Parent = introContainer

local function fitTextToContainer()
	local h = introContainer.AbsoluteSize.Y
	local w = introContainer.AbsoluteSize.X
	local lh = math.max(16, h / 4)
	subtitle.TextSize = math.clamp(math.floor(lh * 0.55), 12, 22)
	subtitle.TextWrapped = true
end
pcall(fitTextToContainer)
introContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() pcall(fitTextToContainer) end)

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

-- ====== 功能面板页 ======
local pageFunction = Instance.new("Frame")
pageFunction.Size = UDim2.new(1, 0, 1, 0)
pageFunction.BackgroundTransparency = 1
pageFunction.Visible = false
pageFunction.Position = UDim2.new(1, 0, 0, 0)
pageFunction.Parent = contentContainer

-- 左侧功能列表
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

-- 右侧内容区
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

-- ====== 功能页 ======
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

-- ====== 功能状态 ======
local FuncState = {
	AimEnabled = false,
	AimFOV = 45,
	AimSmooth = 20,
	ShowFovCircle = true,
	SpeedEnabled = false,
	SpeedValue = 50,
	ESPEnabled = false,
	HealthBarEnabled = false,
	SpinEnabled = false,
	SpinSpeed = 50,
	FlingLoopEnabled = false,
	FlingAllEnabled = false,
	AntiFlingEnabled = false,
}
local Flinging = false

-- ====== 辅助 ======
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

-- ====== ✅ SkidFling 甩飞核心（只推别人，不碰自己）=====
local function SkidFling(targetPlr)
	if Flinging then return end
	Flinging = true
	pcall(function()
		local char = targetPlr.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not (hrp and hum and hum.Health > 0) then return end

		-- 清掉旧的力
		for _,v in ipairs(hrp:GetChildren()) do
			if v:IsA("BodyVelocity") or v:IsA("BodyAngularVelocity") or v:IsA("BodyForce") then
				v:Destroy()
			end
		end

		-- 用 AssemblyLinearVelocity（Roblox 新版物理，不会被覆盖）
		hrp.AssemblyLinearVelocity = Vector3.new(
			math.random(-40, 40),
			420,
			math.random(-40, 40)
		)
		hrp.AssemblyAngularVelocity = Vector3.new(
			math.random(-90, 90),
			math.random(-90, 90),
			math.random(-90, 90)
		)

		-- 额外加 BodyVelocity 作为双保险
		local bv = Instance.new("BodyVelocity")
		bv.Name = "ShibleFling"
		bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
		bv.Velocity = Vector3.new(math.random(-60, 60), 380, math.random(-60, 60))
		bv.Parent = hrp
		task.delay(0.3, function() if bv and bv.Parent then bv:Destroy() end end)

		local bav = Instance.new("BodyAngularVelocity")
		bav.Name = "ShibleSpin"
		bav.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
		bav.AngularVelocity = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
		bav.Parent = hrp
		task.delay(0.4, function() if bav and bav.Parent then bav:Destroy() end end)
	end)
	task.wait(0.1)
	Flinging = false
end

-- ====== 开关组件 ======
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

	-- 让整个 track 可点击
	track.Active = true
	track.Selectable = true

	local on = false
	pcall(function() on = getState() end)
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
			makeTween(track, {BackgroundColor3 = Color3.fromRGB(60,60,65)}, 0.2)
			makeTween(thumb, {Position = UDim2.new(0, 3, 0, 3)}, 0.2)
		end
		safeCall(function() onToggle(val) end, "Toggle:"..labelText)
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			setState(not on)
		end
	end)
end

-- ====== 滑块组件 ======
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
	inputBox.TextColor3 = Color3.fromRGB(255,255,255)
	inputBox.PlaceholderText = "输入"
	inputBox.PlaceholderColor3 = Color3.fromRGB(120,120,120)
	inputBox.BackgroundColor3 = Color3.fromRGB(55,55,60)
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
	track.BackgroundColor3 = Color3.fromRGB(65,65,70)
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
	thumb.BackgroundColor3 = Color3.fromRGB(255,255,255)
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
		safeCall(function() onChanged(val) end, "Slider:"..labelText)
	end

	local function updateFromMouse()
		local mouse = UserInputService:GetMouseLocation()
		local ap = track.AbsolutePosition
		local as = track.AbsoluteSize
		local ratio = math.clamp((mouse.X - ap.X) / as.X, 0, 1)
		setVal(math.floor(minVal + ratio * (maxVal - minVal)))
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
	inputBox.FocusLost:Connect(function()
		local txt = inputBox.Text:gsub("[^0-9]", "")
		if txt == "" then txt = tostring(minVal) end
		setVal(tonumber(txt) or minVal)
	end)

	setVal(initial)
end

-- ====== 自动瞄准 ======
do
	local p = pgAim
	local y = 10

	local hdr = Instance.new("TextLabel", p)
	hdr.Text = "自动瞄准"
	hdr.Font = Enum.Font.GothamSemibold
	hdr.TextSize = 14
	hdr.TextColor3 = Theme.TextPrimary
	hdr.BackgroundTransparency = 1
	hdr.Position = UDim2.new(0, 12, 0, y)
	hdr.Size = UDim2.new(1, -24, 0, 20)
	hdr.TextXAlignment = Enum.TextXAlignment.Left

	y = y + 30
	createToggle(p, y, "启用静默自瞄", function() return FuncState.AimEnabled end, function(v)
		FuncState.AimEnabled = v
	end)

	y = y + 46
	createSlider(p, y, "瞄准 FOV", 5, 120, 45, function(v)
		FuncState.AimFOV = v
	end)

	y = y + 60
	createSlider(p, y, "平滑度", 1, 50, 20, function(v)
		FuncState.AimSmooth = v
	end)

	y = y + 60
	createToggle(p, y, "显示 FOV 圈", function() return FuncState.ShowFovCircle end, function(v)
		FuncState.ShowFovCircle = v
	end)

	local function getClosestEnemy()
		local cam = workspace.CurrentCamera
		if not cam then return nil end
		local center = Vector2.new(cam.ViewportSize.X*0.5, cam.ViewportSize.Y*0.5)
		local closest, cd = nil, math.huge
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character then
				local head = plr.Character:FindFirstChild("Head")
				local hum = plr.Character:FindFirstChild("Humanoid")
				if head and hum and hum.Health > 0 then
					local sp, onScreen = cam:WorldToScreenPoint(head.Position)
					if onScreen then
						local dx, dy = sp.X-center.X, sp.Y-center.Y
						local d = dx*dx+dy*dy
						if d < cd then cd = d; closest = head end
					end
				end
			end
		end
		return closest
	end

	RunService.RenderStepped:Connect(function()
		safeCall(function()
			if not FuncState.AimEnabled then return end
			local target = getClosestEnemy()
			if not target then return end
			local cam = workspace.CurrentCamera
			local t = 1 / ((FuncState.AimSmooth or 20)*0.6 + 1)
			local cp = cam.CFrame.Position
			local td = (target.Position - cp).Unit
			local dot = math.clamp(cam.CFrame.LookVector:Dot(td), -1, 1)
			local angle = math.acos(dot)
			if angle < 0.001 then
				cam.CFrame = CFrame.new(cp, cp + td)
				return
			end
			cam.CFrame = cam.CFrame:Lerp(CFrame.new(cp, cp+td), math.clamp(t, 0.03, 0.95))
		end, "Aim")
	end)
end

-- ====== FOV 圈 ======
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "FOV_Circle"
fovGui.ResetOnSpawn = false
fovGui.IgnoreGuiInset = true
fovGui.Parent = PlayerGui

local fovFrame = Instance.new("Frame", fovGui)
fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovFrame.Position = UDim2.fromScale(0.5, 0.5)
fovFrame.BackgroundTransparency = 1
fovFrame.Size = UDim2.new(0, 0, 0, 0)

local fovStroke = Instance.new("UIStroke", fovFrame)
fovStroke.Color = Color3.fromRGB(255,255,255)
fovStroke.Thickness = 1.6
fovStroke.Transparency = 0.12
corner(fovFrame, 999)

RunService.RenderStepped:Connect(function()
	safeCall(function()
		local cam = workspace.CurrentCamera
		if not cam then return end
		local center = Vector2.new(cam.ViewportSize.X*0.5, cam.ViewportSize.Y*0.5)
		fovFrame.Position = UDim2.fromOffset(center.X, center.Y)
		local fov = FuncState.AimFOV or 45
		local r = math.tan(math.rad(fov/2)) * (cam.ViewportSize.Y/2) * 2
		fovFrame.Size = UDim2.fromOffset(r, r)
		local vis = FuncState.AimEnabled and FuncState.ShowFovCircle
		fovFrame.Visible = vis
		fovStroke.Transparency = vis and 0.15 or 1
	end, "FOV")
end)

-- ====== 速度增强 ======
do
	local p = pgSpeed
	local y = 10

	local hdr = Instance.new("TextLabel", p)
	hdr.Text = "速度增强"
	hdr.Font = Enum.Font.GothamSemibold
	hdr.TextSize = 14
	hdr.TextColor3 = Theme.TextPrimary
	hdr.BackgroundTransparency = 1
	hdr.Position = UDim2.new(0, 12, 0, y)
	hdr.Size = UDim2.new(1, -24, 0, 20)
	hdr.TextXAlignment = Enum.TextXAlignment.Left

	y = y + 30
	createToggle(p, y, "启用加速", function() return FuncState.SpeedEnabled end, function(v)
		FuncState.SpeedEnabled = v
		local h = getHumanoid()
		if h then h.WalkSpeed = v and (FuncState.SpeedValue or 16) or 16 end
	end)

	y = y + 46
	createSlider(p, y, "移动速度 (16-700)", 16, 700, 50, function(v)
		FuncState.SpeedValue = v
		if FuncState.SpeedEnabled then
			local h = getHumanoid()
			if h then h.WalkSpeed = v end
		end
	end)

	LocalPlayer.CharacterAdded:Connect(function(char)
		safeCall(function()
			char:WaitForChild("Humanoid", 5)
			if FuncState.SpeedEnabled then
				local h = char:FindFirstChild("Humanoid")
				if h then h.WalkSpeed = FuncState.SpeedValue or 50 end
			end
		end, "SpeedCharAdd")
	end)
end

-- ====== 玩家透视 ======
do
	local p = pgESP
	local y = 10

	local hdr = Instance.new("TextLabel", p)
	hdr.Text = "玩家透视"
	hdr.Font = Enum.Font.GothamSemibold
	hdr.TextSize = 14
	hdr.TextColor3 = Theme.TextPrimary
	hdr.BackgroundTransparency = 1
	hdr.Position = UDim2.new(0, 12, 0, y)
	hdr.Size = UDim2.new(1, -24, 0, 20)
	hdr.TextXAlignment = Enum.TextXAlignment.Left

	y = y + 30
	createToggle(p, y, "全身透视", function() return FuncState.ESPEnabled end, function(v)
		FuncState.ESPEnabled = v
	end)

	y = y + 46
	createToggle(p, y, "头顶血条", function() return FuncState.HealthBarEnabled end, function(v)
		FuncState.HealthBarEnabled = v
	end)

	local cache = {}

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
		bg.BackgroundColor3 = Color3.fromRGB(20,20,20)
		bg.BackgroundTransparency = 0.15
		bg.BorderSizePixel = 0
		corner(bg, 2)

		local fill = Instance.new("Frame", bb)
		fill.Name = "Fill"
		fill.Size = UDim2.new(1, 0, 1, 0)
		fill.BackgroundColor3 = Color3.fromRGB(0,255,60)
		fill.BorderSizePixel = 0
		fill.ZIndex = 2
		corner(fill, 2)

		return bb
	end

	local function getOrCreateESP(char)
		if cache[char] and cache[char].hl and cache[char].hl.Parent == char then
			return cache[char].hl, cache[char].hb
		end
		cache[char] = nil

		local oldHL = char:FindFirstChild("ESP_Highlight")
		if oldHL then oldHL:Destroy() end
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
			if oldHB then oldHB:Destroy() end
			hb = createHealthBar(head)
		end

		cache[char] = {hl = hl, hb = hb}
		return hl, hb
	end

	local function removeESP(char)
		local entry = cache[char]
		if entry then
			pcall(function() if entry.hl then entry.hl:Destroy() end end)
			pcall(function() if entry.hb then entry.hb:Destroy() end end)
		end
		cache[char] = nil
	end

	RunService.RenderStepped:Connect(function()
		safeCall(function()
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer and plr.Character then
					local char = plr.Character
					local hum = char:FindFirstChild("Humanoid")
					local head = char:FindFirstChild("Head")

					if not hum or hum.Health <= 0 or not head then
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
									if ratio > 0.5 then
										fill.BackgroundColor3 = Color3.fromRGB(50, 215, 75)
									elseif ratio > 0.25 then
										fill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
									else
										fill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
									end
								end
							end
						end
					end
				end
			end
		end, "ESP")
	end)

	Players.PlayerRemoving:Connect(function(plr)
		if plr.Character then removeESP(plr.Character) end
	end)
end

-- ====== 飞天 ======
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
	execBtn.TextColor3 = Color3.fromRGB(255,255,255)
	execBtn.BackgroundColor3 = Theme.Accent
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
						Title = title, Text = text,
						Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150", Duration = 2
					})
				end)
				if ok then break end
				task.wait(0.2)
			end
		end)
	end

	execBtn.MouseButton1Click:Connect(function()
		makeTween(execBtn, {TextSize = 16}, 0.12)
		task.delay(0.12, function() makeTween(execBtn, {TextSize = 14}, 0.15) end)
		notify("飞行脚本", "创作者：shible")

		task.spawn(function()
			local ok, err = pcall(function()
				local fg = Instance.new("ScreenGui")
				fg.Name = "shible_Fly"
				fg.ResetOnSpawn = false
				fg.Parent = LocalPlayer:WaitForChild("PlayerGui")

				local f = Instance.new("Frame", fg)
				f.BackgroundColor3 = Color3.fromRGB(163,255,137)
				f.BorderColor3 = Color3.fromRGB(103,221,213)
				f.Position = UDim2.new(0.1,0,0.38,0)
				f.Size = UDim2.new(0,190,0,57)
				f.Active = true
				f.Draggable = true

				local up = Instance.new("TextButton", f)
				up.Size = UDim2.new(0,44,0,28); up.Text = "上升"
				up.BackgroundColor3 = Color3.fromRGB(79,255,152)

				local down = Instance.new("TextButton", f)
				down.Size = UDim2.new(0,44,0,28); down.Position = UDim2.new(0,0,0.49,0)
				down.Text = "下落"; down.BackgroundColor3 = Color3.fromRGB(215,255,121)

				local onof = Instance.new("TextButton", f)
				onof.Size = UDim2.new(0,56,0,28); onof.Position = UDim2.new(0.7,0,0.49,0)
				onof.Text = "飞"; onof.BackgroundColor3 = Color3.fromRGB(255,249,74)

				local tl = Instance.new("TextLabel", f)
				tl.Size = UDim2.new(0,100,0,28); tl.Position = UDim2.new(0.47,0,0,0)
				tl.Text = "shible"; tl.BackgroundColor3 = Color3.fromRGB(242,60,255)
				tl.TextScaled = true

				local plus = Instance.new("TextButton", f)
				plus.Size = UDim2.new(0,45,0,28); plus.Position = UDim2.new(0.23,0,0,0)
				plus.Text = "+"; plus.BackgroundColor3 = Color3.fromRGB(133,145,255)
				plus.TextScaled = true

				local spd = Instance.new("TextLabel", f)
				spd.Size = UDim2.new(0,44,0,28); spd.Position = UDim2.new(0.47,0,0.49,0)
				spd.Text = "1"; spd.BackgroundColor3 = Color3.fromRGB(255,85,0)
				spd.TextScaled = true

				local mine = Instance.new("TextButton", f)
				mine.Size = UDim2.new(0,45,0,29); mine.Position = UDim2.new(0.23,0,0.49,0)
				mine.Text = "-"; mine.BackgroundColor3 = Color3.fromRGB(123,255,247)
				mine.TextScaled = true

				local xbtn = Instance.new("TextButton", f)
				xbtn.Size = UDim2.new(0,45,0,28); xbtn.Position = UDim2.new(0,0,-1,27)
				xbtn.Text = "X"; xbtn.TextSize = 30
				xbtn.BackgroundColor3 = Color3.fromRGB(225,25,0)

				local mini = Instance.new("TextButton", f)
				mini.Size = UDim2.new(0,45,0,28); mini.Position = UDim2.new(0,44,-1,27)
				mini.Text = "-"; mini.TextSize = 40
				mini.BackgroundColor3 = Color3.fromRGB(192,150,230)

				local mini2 = Instance.new("TextButton", f)
				mini2.Size = UDim2.new(0,45,0,28); mini2.Position = UDim2.new(0,44,0,30)
				mini2.Text = "+"; mini2.TextSize = 40
				mini2.BackgroundColor3 = Color3.fromRGB(192,150,230)
				mini2.Visible = false

				local speeds = 1
				local nowe = false
				local chr = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
				local hum = chr:FindFirstChildOfClass("Humanoid")
				local moveConn, renderConn, bgObj, bvObj

				xbtn.MouseButton1Click:Connect(function() fg:Destroy() end)

				up.MouseButton1Click:Connect(function()
					if chr and chr:FindFirstChild("HumanoidRootPart") then
						chr.HumanoidRootPart.CFrame += Vector3.new(0,3,0)
					end
				end)
				down.MouseButton1Click:Connect(function()
					if chr and chr:FindFirstChild("HumanoidRootPart") then
						chr.HumanoidRootPart.CFrame += Vector3.new(0,-3,0)
					end
				end)

				mini.MouseButton1Click:Connect(function()
					for _,v in ipairs({up,down,onof,plus,spd,mine,xbtn}) do v.Visible = false end
					mini.Visible = false; mini2.Visible = true
					f.Size = UDim2.new(0,100,0,28)
					tl.Position = UDim2.new(0,0,0,0)
				end)
				mini2.MouseButton1Click:Connect(function()
					for _,v in ipairs({up,down,onof,plus,spd,mine,xbtn}) do v.Visible = true end
					mini.Visible = true; mini2.Visible = false
					f.Size = UDim2.new(0,190,0,57)
					tl.Position = UDim2.new(0.47,0,0,0)
				end)

				plus.MouseButton1Click:Connect(function() speeds += 1; spd.Text = tostring(speeds) end)
				mine.MouseButton1Click:Connect(function()
					if speeds > 1 then speeds -= 1; spd.Text = tostring(speeds)
					else spd.Text = "错误"; task.wait(0.2); spd.Text = "1" end
				end)

				local function resetHum()
					if hum then
						pcall(function()
							for _,s in pairs(Enum.HumanoidStateType:GetEnumItems()) do
								hum:SetStateEnabled(s, true)
							end
							hum.PlatformStand = false
							hum:ChangeState(Enum.HumanoidStateType.Running)
						end)
					end
					local anim = chr and chr:FindFirstChild("Animate")
					if anim then anim.Disabled = false end
				end

				local function stopFly()
					if moveConn then pcall(function() moveConn:Disconnect() end) moveConn = nil end
					if renderConn then pcall(function() renderConn:Disconnect() end) renderConn = nil end
					if bgObj then pcall(function() bgObj:Destroy() end) bgObj = nil end
					if bvObj then pcall(function() bvObj:Destroy() end) bvObj = nil end
					resetHum()
				end

				local function startFly()
					stopFly()
					chr = LocalPlayer.Character
					hum = chr and chr:FindFirstChildOfClass("Humanoid")
					if not hum then return end
					pcall(function()
						for _,s in pairs(Enum.HumanoidStateType:GetEnumItems()) do
							hum:SetStateEnabled(s, false)
						end
						hum:ChangeState(Enum.HumanoidStateType.Swimming)
					end)
					local anim = chr:FindFirstChild("Animate")
					if anim then anim.Disabled = true end

					moveConn = RunService.Heartbeat:Connect(function()
						if not nowe or not hum or hum.Health <= 0 then return end
						if hum.MoveDirection.Magnitude > 0 then
							chr:TranslateBy(hum.MoveDirection * speeds)
						end
					end)

					local torso = chr:FindFirstChild("Torso") or chr:FindFirstChild("UpperTorso")
					if torso then
						bgObj = Instance.new("BodyGyro", torso)
						bgObj.P = 9e4; bgObj.MaxTorque = Vector3.new(9e9,9e9,9e9)
						bvObj = Instance.new("BodyVelocity", torso)
						bvObj.Velocity = Vector3.zero; bvObj.MaxForce = Vector3.new(9e9,9e9,9e9)
						renderConn = RunService.RenderStepped:Connect(function()
							if not nowe or not torso.Parent then stopFly() return end
							bgObj.CFrame = workspace.CurrentCamera.CoordinateFrame
						end)
					end
				end

				LocalPlayer.CharacterAdded:Connect(function(c)
					nowe = false; onof.Text = "飞"; chr = c
					hum = chr:WaitForChild("Humanoid", 5); stopFly()
				end)

				onof.MouseButton1Click:Connect(function()
					nowe = not nowe; onof.Text = nowe and "停" or "飞"
					if nowe then startFly() else stopFly() end
				end)
			end)
			if not ok then notify("加载失败", tostring(err)) end
		end)
	end)
end

-- ====== 娱乐页 ======
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

	-- ====== 旋转 ======
	y = y + 36
	createToggle(p, y, "旋转", function() return FuncState.SpinEnabled end, function(v)
		FuncState.SpinEnabled = v
	end)

	y = y + 50
	createSlider(p, y, "旋转倍数 (10-999)", 10, 999, 50, function(v)
		FuncState.SpinSpeed = v
	end)

	-- ====== ✅ 玩家选择列表（可滚动、可点选、高亮当前选中）=====
	y = y + 80
	local selectedPlayer = "ALL"

	local playerListLabel = Instance.new("TextLabel", p)
	playerListLabel.Text = "甩飞目标:"
	playerListLabel.Font = Enum.Font.GothamSemibold
	playerListLabel.TextSize = 12
	playerListLabel.TextColor3 = Theme.TextSecondary
	playerListLabel.BackgroundTransparency = 1
	playerListLabel.Position = UDim2.new(0, 12, 0, y - 18)
	playerListLabel.Size = UDim2.new(1, -24, 0, 16)
	playerListLabel.TextXAlignment = Enum.TextXAlignment.Left

	local playerList = Instance.new("ScrollingFrame", p)
	playerList.Size = UDim2.new(1, -24, 0, 90)  -- ✅ 足够高，能看见多个玩家
	playerList.Position = UDim2.new(0, 12, 0, y)
	playerList.BackgroundColor3 = Color3.fromRGB(45,45,50)
	playerList.BackgroundTransparency = 0.3
	playerList.BorderSizePixel = 0
	playerList.ScrollBarThickness = 4
	playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
	playerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
	playerList.Parent = p
	corner(playerList, 6)

	local plistLayout = Instance.new("UIListLayout", playerList)
	plistLayout.SortOrder = Enum.SortOrder.LayoutOrder
	plistLayout.Padding = UDim.new(0, 2)

	local plistPad = Instance.new("UIPadding", playerList)
	plistPad.PaddingTop = UDim.new(0, 4)
	plistPad.PaddingBottom = UDim.new(0, 4)
	plistPad.PaddingLeft = UDim.new(0, 4)
	plistPad.PaddingRight = UDim.new(0, 4)

	-- 当前选中的按钮引用（用于高亮还原）
	local selectedBtn = nil

	local function createPlayerButton(name, displayName, isAll)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -8, 0, 24)
		btn.Text = displayName
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 12
		btn.TextColor3 = Color3.fromRGB(255,255,255)
		btn.BackgroundColor3 = Color3.fromRGB(60,60,67)
		btn.BackgroundTransparency = 0.2
		btn.BorderSizePixel = 0
		btn.AutoButtonColor = false
		btn.Parent = playerList
		corner(btn, 4)

		btn.MouseEnter:Connect(function()
			if selectedBtn ~= btn then
				makeTween(btn, {BackgroundColor3 = Color3.fromRGB(80,80,90)}, 0.1)
			end
		end)
		btn.MouseLeave:Connect(function()
			if selectedBtn ~= btn then
				makeTween(btn, {BackgroundColor3 = Color3.fromRGB(60,60,67)}, 0.1)
			end
		end)

		btn.MouseButton1Click:Connect(function()
			-- 还原上一个
			if selectedBtn and selectedBtn ~= btn then
				makeTween(selectedBtn, {BackgroundColor3 = Color3.fromRGB(60,60,67)}, 0.15)
			end
			-- 高亮当前
			selectedBtn = btn
			makeTween(btn, {BackgroundColor3 = Theme.Accent}, 0.15)

			if isAll then
				selectedPlayer = "ALL"
			else
				-- 找到对应的 Player 对象
				for _, plr in ipairs(Players:GetPlayers()) do
					if plr.Name == name then
						selectedPlayer = plr
						break
					end
				end
			end
		end)

		return btn
	end

	local function refreshPlayerList()
		-- 清空旧按钮
		for _, child in ipairs(playerList:GetChildren()) do
			if child:IsA("TextButton") then child:Destroy() end
		end
		selectedBtn = nil
		selectedPlayer = "ALL"

		-- ALL 按钮
		createPlayerButton("ALL", "👥 ALL（全部玩家）", true)

		-- 每个玩家一个按钮
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				createPlayerButton(plr.Name, plr.Name, false)
			end
		end
	end

	-- 初始刷新
	refreshPlayerList()
	Players.PlayerAdded:Connect(function() refreshPlayerList() end)
	Players.PlayerRemoving:Connect(function() refreshPlayerList() end)

	local function resolveTarget()
		return selectedPlayer
	end

	-- ====== 甩飞一次 ======
	y = y + 100  -- ✅ 留出列表空间
	local flingBtn = Instance.new("TextButton", p)
	flingBtn.Size = UDim2.new(1, -24, 0, 34)
	flingBtn.Position = UDim2.new(0, 12, 0, y)
	flingBtn.Text = "甩飞一次"
	flingBtn.BackgroundColor3 = Theme.Accent
	flingBtn.TextColor3 = Color3.fromRGB(255,255,255)
	flingBtn.Font = Enum.Font.GothamSemibold
	flingBtn.TextSize = 13
	flingBtn.AutoButtonColor = false
	corner(flingBtn, 8)
	pressEffect(flingBtn)

	flingBtn.MouseButton1Click:Connect(function()
		local t = resolveTarget()
		if t == "ALL" then
			for _,plr in ipairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer then
					SkidFling(plr)
					repeat task.wait() until not Flinging
					task.wait(0.1)
				end
			end
		elseif t and typeof(t) == "Instance" then
			SkidFling(t)
		end
	end)

	-- ====== 循环甩飞 ======
	y = y + 48
	createToggle(p, y, "循环甩飞", function() return FuncState.FlingLoopEnabled end, function(v)
		if v then
			FuncState.AntiFlingEnabled = false
			FuncState.FlingLoopEnabled = true
		else
			FuncState.FlingLoopEnabled = false
		end
	end)

	task.spawn(function()
		while true do
			safeCall(function()
				if FuncState.FlingLoopEnabled and not Flinging then
					local t = resolveTarget()
					if t == "ALL" then
						for _,plr in ipairs(Players:GetPlayers()) do
							if plr ~= LocalPlayer then
								SkidFling(plr)
								break
							end
						end
					elseif t and typeof(t) == "Instance" then
						SkidFling(t)
					end
				end
			end, "FlingLoop")
			task.wait(0.5)
		end
	end)

	-- ====== ✅ 全部甩飞 · 视角跟随（修复版）=====
	y = y + 56
	createToggle(p, y, "全部甩飞（视角跟随）", function() return FuncState.FlingAllEnabled end, function(v)
		if v then
			FuncState.AntiFlingEnabled = false
			FuncState.FlingAllEnabled = true
		else
			FuncState.FlingAllEnabled = false
		end
	end)

	task.spawn(function()
		while true do
			safeCall(function()
				if not FuncState.FlingAllEnabled then return end
				local cam = workspace.CurrentCamera
				if not cam then return end

				local lookVec = cam.CFrame.LookVector
				-- ✅ 确保方向向量有效
				if lookVec.Magnitude < 0.001 then
					lookVec = Vector3.new(0, 0, -1)
				end
				lookVec = lookVec.Unit

				for _, plr in ipairs(Players:GetPlayers()) do
					if plr ~= LocalPlayer and plr.Character then
						local char = plr.Character
						local hrp = char:FindFirstChild("HumanoidRootPart")
						local hum = char:FindFirstChildOfClass("Humanoid")
						if hrp and hum and hum.Health > 0 then
							-- 清理旧的力
							for _, v in ipairs(hrp:GetChildren()) do
								if v:IsA("BodyVelocity") and v.Name == "ShibleFling" then v:Destroy() end
								if v:IsA("BodyAngularVelocity") and v.Name == "ShibleFlingSpin" then v:Destroy() end
								if v:IsA("BodyForce") and v.Name == "ShibleFlingForce" then v:Destroy() end
							end

							-- ✅ 加一点随机散射，避免所有人完全同一轨迹
							local scatter = Vector3.new(
								math.random(-15, 15) / 100,
								math.random(5, 25) / 100,
								math.random(-15, 15) / 100
							)
							local dir = (lookVec + scatter).Unit

							-- ✅ 用 AssemblyLinearVelocity（新版物理系统，不会被覆盖）
							hrp.AssemblyLinearVelocity = dir * 450 + Vector3.new(0, 280, 0)

							-- ✅ BodyVelocity 双保险
							local bv = Instance.new("BodyVelocity")
							bv.Name = "ShibleFling"
							bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
							bv.Velocity = dir * 450 + Vector3.new(0, 280, 0)
							bv.Parent = hrp
							task.delay(0.3, function() if bv and bv.Parent then bv:Destroy() end end)

							-- ✅ 额外加 BodyForce 持续推（防止被重力立刻拉回来）
							local bf = Instance.new("BodyForce")
							bf.Name = "ShibleFlingForce"
							bf.Force = dir * 50000 + Vector3.new(0, 30000, 0)
							bf.Parent = hrp
							task.delay(0.25, function() if bf and bf.Parent then bf:Destroy() end end)

							-- 旋转
							local bav = Instance.new("BodyAngularVelocity")
							bav.Name = "ShibleFlingSpin"
							bav.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
							bav.AngularVelocity = Vector3.new(
								math.random(-120,120),
								math.random(-120,120),
								math.random(-120,120)
							)
							bav.Parent = hrp
							task.delay(0.4, function() if bav and bav.Parent then bav:Destroy() end end)
						end
					end
				end
			end, "FlingAll_CameraFollow")
			task.wait(0.35)
		end
	end)

	-- ====== ✅ 防甩飞（与甩飞互斥）=====
	y = y + 56
	createToggle(p, y, "防甩飞", function() return FuncState.AntiFlingEnabled end, function(v)
		if v then
			FuncState.FlingLoopEnabled = false
			FuncState.FlingAllEnabled = false
			FuncState.AntiFlingEnabled = true
		else
			FuncState.AntiFlingEnabled = false
		end
	end)

	local antiFlingConn = nil
	local lastPos = nil

	task.spawn(function()
		while true do
			safeCall(function()
				if FuncState.AntiFlingEnabled then
					if antiFlingConn then return end
					antiFlingConn = RunService.Heartbeat:Connect(function()
						pcall(function()
							local char = LocalPlayer.Character
							if not char then lastPos = nil return end
							local hrp = char:FindFirstChild("HumanoidRootPart")
							if not hrp then lastPos = nil return end
							local hum = char:FindFirstChildOfClass("Humanoid")
							if not hum or hum.Health <= 0 then lastPos = nil return end

							local vel = hrp.Velocity
							local moveDir = hum.MoveDirection
							local isMoving = moveDir.Magnitude > 0.1

							-- ✅ 检测异常速度（被甩飞的特征）
							if not isMoving and vel.Magnitude > 120 then
								hrp.AssemblyLinearVelocity = Vector3.new(0, math.min(hrp.Velocity.Y, 0), 0)
								hrp.Velocity = Vector3.new(0, math.min(hrp.Velocity.Y, 0), 0)
								hrp.RotVelocity = Vector3.zero
								hrp.AssemblyAngularVelocity = Vector3.zero
							end

							-- ✅ 位置回滚（防止瞬移）
							if lastPos then
								local dist = (hrp.Position - lastPos).Magnitude
								if dist > 40 then
									hrp.CFrame = CFrame.new(lastPos)
									hrp.AssemblyLinearVelocity = Vector3.zero
									hrp.Velocity = Vector3.zero
									hrp.RotVelocity = Vector3.zero
								end
							end
							lastPos = hrp.Position
						end)
					end)
				else
					if antiFlingConn then pcall(function() antiFlingConn:Disconnect() end) antiFlingConn = nil end
					lastPos = nil
				end
			end, "AntiFling")
			task.wait(0.1)
		end
	end)

	LocalPlayer.CharacterAdded:Connect(function()
		safeCall(function()
			if antiFlingConn then pcall(function() antiFlingConn:Disconnect() end) antiFlingConn = nil end
			lastPos = nil
			FuncState.AntiFlingEnabled = false
		end, "CharAdd:AntiFling")
	end)

	-- ====== 旋转循环 ======
	RunService.RenderStepped:Connect(function(dt)
		safeCall(function()
			if not FuncState.SpinEnabled then return end
			local rp = getRootPart()
			if rp then
				rp.CFrame *= CFrame.Angles(0, math.rad((FuncState.SpinSpeed or 50)*dt*60), 0)
			end
		end, "Spin")
	end)
end

-- ====== 左侧功能列表 ======
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

	local lbl = Instance.new("TextLabel", item)
	lbl.Text = name
	lbl.Font = Enum.Font.GothamSemibold
	lbl.TextSize = 13
	lbl.TextColor3 = Theme.TextPrimary
	lbl.BackgroundTransparency = 1
	lbl.Size = UDim2.new(1, -12, 1, 0)
	lbl.Position = UDim2.new(0, 12, 0, 0)
	lbl.TextXAlignment = Enum.TextXAlignment.Left

	item.MouseEnter:Connect(function()
		if selectedItem ~= item then makeTween(item, {BackgroundTransparency = 0.35}, 0.15) end
	end)
	item.MouseLeave:Connect(function()
		if selectedItem ~= item then makeTween(item, {BackgroundTransparency = 0.6}, 0.15) end
	end)
	item.MouseButton1Click:Connect(function()
		if selectedItem then makeTween(selectedItem, {BackgroundTransparency = 0.6}, 0.2) end
		selectedItem = item
		makeTween(item, {BackgroundTransparency = 0.2}, 0.2)
		for _,pg in pairs(pages) do pg.Visible = false end
		pages[key].Visible = true
	end)
end

createFuncItem("自动瞄准", "Aim")
createFuncItem("速度增强", "Speed")
createFuncItem("玩家透视", "ESP")
createFuncItem("飞天",     "Fly")
createFuncItem("娱乐",     "Fun")

task.defer(function()
	safeCall(function()
		for _, btn in ipairs(funcList:GetChildren()) do
			if btn:IsA("TextButton") then btn.MouseButton1Click:Fire() break end
		end
	end, "DefaultSelect")
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
	for _,c in ipairs(frame:GetChildren()) do
		if c:IsA("ImageLabel") then shadowObj = c break end
	end

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startMousePos = input.Position
			startFramePos = frame.Position
			if shadowObj then
				makeTween(shadowObj, {ImageTransparency = 0.7, Size = shadowObj.Size + UDim2.new(0,10,0,10)}, 0.15)
			end
			makeTween(frame, {Size = frame.Size + UDim2.new(0,4,0,2)}, 0.15)
		end
	end)

	frame.InputEnded:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false
			if shadowObj then
				makeTween(shadowObj, {ImageTransparency = 0.85, Size = shadowObj.Size - UDim2.new(0,10,0,10)}, 0.2)
			end
			makeTween(frame, {Size = frame.Size - UDim2.new(0,4,0,2)}, 0.2)
		end
	end)

	local lastPos = frame.Position

	RunService.RenderStepped:Connect(function()
		safeCall(function()
			if dragging and startMousePos then
				local mouse = UserInputService:GetMouseLocation()
				local delta = mouse - startMousePos
				local newX = startFramePos.X.Offset + delta.X
				local newY = startFramePos.Y.Offset + delta.Y
				if clampY then newY = math.max(0, newY) end
				local ss = gui.AbsoluteSize
				local fs = frame.AbsoluteSize
				newX = math.clamp(newX, -fs.X/2, ss.X - fs.X/2)
				local target = UDim2.new(0, newX, 0, newY)
				lastPos = UDim2.new(
					lastPos.X.Scale + (target.X.Scale - lastPos.X.Scale)*smoothness,
					lastPos.X.Offset + (target.X.Offset - lastPos.X.Offset)*smoothness,
					lastPos.Y.Scale + (target.Y.Scale - lastPos.Y.Scale)*smoothness,
					lastPos.Y.Offset + (target.Y.Offset - lastPos.Y.Offset)*smoothness
				)
				frame.Position = lastPos
			end
		end, "Drag")
	end)
end

DragSystem.enable(root)
DragSystem.enable(mini)

-- ====== 按钮逻辑 ======
minBtn.MouseButton1Click:Connect(function()
	makeTween(root, {Size = UDim2.new(0,C.Width,0,0), BackgroundTransparency = 1}, 0.25)
	makeTween(blur, {Size = 6}, 0.25)
	task.delay(0.2, function()
		root.Visible = false
		mini.Visible = true
		mini.Size = UDim2.new(0,140,0,40)
		mini.BackgroundTransparency = 1
		makeTween(mini, {Size = UDim2.new(0,160,0,48), BackgroundTransparency = 0.12}, 0.3, Enum.EasingStyle.Back)
	end)
end)

restore.MouseButton1Click:Connect(function()
	mini.Visible = false
	root.Visible = true
	makeTween(blur, {Size = C.Blur}, 0.25)
	makeTween(root, {Size = UDim2.new(0,C.Width,0,C.Height), BackgroundTransparency = 0.18}, 0.4)
end)

closeBtn.MouseButton1Click:Connect(function()
	makeTween(blur, {Size = 0}, 0.3)
	makeTween(root, {Size = UDim2.new(0,C.Width,0,0), BackgroundTransparency = 1}, 0.3)
	task.wait(0.35)
	safeCall(function()
		local fg = PlayerGui:FindFirstChild("FOV_Circle")
		if fg then fg:Destroy() end
		gui:Destroy()
		blur:Destroy()
	end, "Close")
end)

confirm.MouseButton1Click:Connect(function()
	makeTween(confirm, {TextSize = 16}, 0.12)
	task.delay(0.12, function() makeTween(confirm, {TextSize = 14}, 0.15) end)
	makeTween(pageMain, {Position = UDim2.new(-1,0,0,0)}, 0.3, Enum.EasingStyle.Quint)
	pageFunction.Visible = true
	pageFunction.Position = UDim2.new(1,0,0,0)
	makeTween(pageFunction, {Position = UDim2.new(0,0,0,0)}, 0.3, Enum.EasingStyle.Quint)
end)

backBtn.MouseButton1Click:Connect(function()
	makeTween(pageFunction, {Position = UDim2.new(1,0,0,0)}, 0.3, Enum.EasingStyle.Quint)
	pageMain.Visible = true
	pageMain.Position = UDim2.new(-1,0,0,0)
	makeTween(pageMain, {Position = UDim2.new(0,0,0,0)}, 0.3, Enum.EasingStyle.Quint)
	task.delay(0.3, function() pageFunction.Visible = false end)
end)

-- ====== 入场动画 ======
root.Size = UDim2.new(0, C.Width, 0, C.Height)
root.BackgroundTransparency = 0.18
root.Visible = true
gui.Enabled = true

pcall(function()
	springTween(root, {Size = UDim2.new(0,C.Width,0,C.Height), BackgroundTransparency = 0.18}, 0.5)
end)
makeTween(blur, {Size = C.Blur}, 0.5)

print("[shible] UI 加载完成 ✅（视角跟随甩飞·已修复 | 玩家列表·可点选 | 防甩飞互斥）")
