local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- ====== 高级参数 ======
local C = {
	Width = 280,
	Height = 200,
	Radius = 22,
	Blur = 24,
	Spring = Enum.EasingStyle.Elastic,
	Duration = 0.55,
	DragSmoothness = 0.25, -- 拖动平滑度（越低越跟手）
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

-- 按压反馈
local function pressEffect(btn, scaleX, scaleY)
	scaleX = scaleX or 0.96
	scaleY = scaleY or 0.9
	local origSize = btn.Size
	local pressedSize = UDim2.new(
		origSize.X.Scale * scaleX, origSize.X.Offset * scaleX,
		origSize.Y.Scale * scaleY, origSize.Y.Offset * scaleY
	)
	btn.MouseButton1Down:Connect(function()
		tween(btn, {Size = pressedSize}, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
	end)
	btn.MouseButton1Up:Connect(function()
		tween(btn, {Size = origSize}, 0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
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

-- ====== 主容器（毛玻璃面板）======
local root = Instance.new("Frame", gui)
root.AnchorPoint = Vector2.new(0.5, 0.5)
root.Position = UDim2.fromScale(0.5, 0.45)
root.Size = UDim2.new(0, C.Width, 0, C.Height)
root.BackgroundColor3 = Theme.Glass
root.BackgroundTransparency = 0.18
root.BorderSizePixel = 0
root.Active = true -- 关键：允许接收输入
root.Selectable = true
corner(root, C.Radius)

-- 微投影（阴影）
local shadow = Instance.new("ImageLabel", root)
shadow.Size = UDim2.new(1, 50, 1, 50)
shadow.Position = UDim2.new(0, -25, 0, -15)
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.85
shadow.BackgroundTransparency = 1
shadow.ZIndex = -1
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 10, 10)

-- ====== 顶部拖拽条（Grabber）======
local grabberArea = Instance.new("Frame", root)
grabberArea.Name = "GrabberArea"
grabberArea.Size = UDim2.new(1, 0, 0, 36)
grabberArea.Position = UDim2.new(0, 0, 0, 0)
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
nav.Size = UDim2.new(1, 0, 0, 44)
nav.Position = UDim2.new(0, 0, 0, 0)
nav.BackgroundTransparency = 1

local title = Instance.new("TextLabel", nav)
title.Text = "shible"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 15
title.TextColor3 = Theme.TextPrimary
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 16, 0, 12)
title.Size = UDim2.new(1, -80, 0, 20)

local minBtn = Instance.new("TextButton", nav)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.TextColor3 = Theme.TextSecondary
minBtn.BackgroundTransparency = 1
minBtn.Position = UDim2.new(1, -40, 0, 10)
minBtn.Size = UDim2.new(0, 28, 0, 24)
minBtn.AutoButtonColor = false

-- ====== 内容区域 ======
local contentY = 52
local subtitle = Instance.new("TextLabel", root)
subtitle.Text = "欢迎使用\n界面已就绪"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 13
subtitle.TextColor3 = Theme.TextSecondary
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 16, 0, contentY)
subtitle.Size = UDim2.new(1, -32, 0, 50)
subtitle.TextYAlignment = Enum.TextYAlignment.Top
subtitle.TextWrapped = true

-- ====== 按钮区域 ======
local btnY = C.Height - 56

-- 确认按钮
local confirm = Instance.new("TextButton", root)
confirm.Text = "确认"
confirm.Font = Enum.Font.GothamSemibold
confirm.TextSize = 14
confirm.TextColor3 = Theme.Accent
confirm.BackgroundTransparency = 1
confirm.Position = UDim2.new(0, 16, 0, btnY)
confirm.Size = UDim2.new(0.5, -22, 0, 36)
confirm.AutoButtonColor = false
pressEffect(confirm)

-- 关闭按钮
local closeBtn = Instance.new("TextButton", root)
closeBtn.Text = "关闭"
closeBtn.Font = Enum.Font.GothamSemibold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Theme.Danger
closeBtn.BackgroundTransparency = 1
closeBtn.Position = UDim2.new(0.5, 6, 0, btnY)
closeBtn.Size = UDim2.new(0.5, -22, 0, 36)
closeBtn.AutoButtonColor = false
pressEffect(closeBtn)

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

-- 迷你面板投影
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
pressEffect(restore, 0.92, 0.85)

-- ====== 拖拽系统 ======
local DragSystem = {}

function DragSystem.enable(frame, opts)
	opts = opts or {}
	local smoothness = opts.smoothness or C.DragSmoothness
	local clampY = opts.clampY or true

	local dragging = false
	local startMousePos
	local startFramePos

	-- 拖动时放大阴影（iOS 浮起效果）
	local children = frame:GetChildren()
	local shadowObj
	for _, c in ipairs(children) do
		if c:IsA("ImageLabel") then
			shadowObj = c
			break
		end
	end

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
		   input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startMousePos = input.Position
			startFramePos = frame.Position

			-- 浮起效果
			if shadowObj then
				tween(shadowObj, {ImageTransparency = 0.7, Size = shadowObj.Size + UDim2.new(0, 10, 0, 10)}, 0.15):Play()
			end
			-- 轻微放大
			tween(frame, {Size = frame.Size + UDim2.new(0, 4, 0, 2)}, 0.15):Play()
		end
	end)

	frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
		   input.UserInputType == Enum.UserInputType.Touch then
			dragging = false

			-- 恢复阴影
			if shadowObj then
				tween(shadowObj, {ImageTransparency = 0.85, Size = shadowObj.Size - UDim2.new(0, 10, 0, 10)}, 0.2):Play()
			end
			-- 恢复大小
			tween(frame, {Size = frame.Size - UDim2.new(0, 4, 0, 2)}, 0.2):Play()
		end
	end)
	
	local RunService = game:GetService("RunService")
	local lastPos = UDim2.new()

	RunService.RenderStepped:Connect(function()
		if dragging and startMousePos then
			local mouse = UserInputService:GetMouseLocation()
			local delta = mouse - startMousePos

			local newX = startFramePos.X.Offset + delta.X
			local newY = startFramePos.Y.Offset + delta.Y

			-- 限制 Y 不超出屏幕顶部
			if clampY then
				newY = math.max(0, newY)
			end

			-- 限制 X 不超出屏幕左右
			local screenSize = gui.AbsoluteSize
			local frameSize = frame.AbsoluteSize
			newX = math.clamp(newX, -frameSize.X / 2, screenSize.X - frameSize.X / 2)

			local targetPos = UDim2.new(0, newX, 0, newY)

			-- 平滑插值（Lerp）
			lastPos = UDim2.new(
				lastPos.X.Scale + (targetPos.X.Scale - lastPos.X.Scale) * smoothness,
				lastPos.X.Offset + (targetPos.X.Offset - lastPos.X.Offset) * smoothness,
				lastPos.Y.Scale + (targetPos.Y.Scale - lastPos.Y.Scale) * smoothness,
				lastPos.Y.Offset + (targetPos.Y.Offset - lastPos.Y.Offset) * smoothness
			)

			frame.Position = lastPos
		end
	end)
end

-- 启用拖拽（主面板用 grabber 区域，迷你面板用整个面板）
DragSystem.enable(root, {clampY = true, smoothness = 0.3})
DragSystem.enable(mini, {clampY = true, smoothness = 0.3})

-- ====== 按钮逻辑 ======
minBtn.MouseButton1Click:Connect(function()
	-- 缩小动画
	tween(root, {Size = UDim2.new(0, C.Width, 0, 0), BackgroundTransparency = 1}, 0.25):Play()
	tween(blur, {Size = 6}, 0.25):Play()
	task.delay(0.2, function()
		root.Visible = false
		mini.Visible = true
		-- 迷你面板弹出
		mini.Size = UDim2.new(0, 140, 0, 40)
		mini.BackgroundTransparency = 1
		tween(mini, {Size = UDim2.new(0, 160, 0, 48), BackgroundTransparency = 0.12}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
	end)
end)

restore.MouseButton1Click:Connect(function()
	mini.Visible = false
	root.Visible = true
	tween(blur, {Size = C.Blur}, 0.25):Play()
	-- 恢复弹入
	root.Size = UDim2.new(0, C.Width, 0, 0)
	root.BackgroundTransparency = 1
	spring(root, {Size = UDim2.new(0, C.Width, 0, C.Height), BackgroundTransparency = 0.18}, 0.5):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
	tween(blur, {Size = 0}, 0.3):Play()
	spring(root, {Size = UDim2.new(0, C.Width, 0, 0), BackgroundTransparency = 1}):Play()
	task.wait(0.45)
	gui:Destroy()
	blur:Destroy()
end)

confirm.MouseButton1Click:Connect(function()
	-- 按钮微动效
	spring(confirm, {TextSize = 16}, 0.15):Play()
	task.delay(0.15, function()
		spring(confirm, {TextSize = 14}, 0.2):Play()
	end)
	print("确认按钮被点击")
end)

-- ====== 入场动画 ======
root.Size = UDim2.new(0, C.Width, 0, 0)
root.BackgroundTransparency = 1
spring(root, {Size = UDim2.new(0, C.Width, 0, C.Height), BackgroundTransparency = 0.18}, 0.6):Play()

-- 模糊渐进
tween(blur, {Size = C.Blur}, 0.5):Play()

print("iOS 高级拖拽 UI 加载完成")
