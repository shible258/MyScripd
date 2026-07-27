-- 按钮：跳高
local btnJump = Instance.new("TextButton", f)
btnJump.Size = UDim2.new(1, -30, 0, 45)
btnJump.Position = UDim2.new(0, 15, 0, 165)
btnJump.Text = "跳高"
btnJump.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btnJump.TextColor3 = Color3.fromRGB(255, 255, 255)

btnJump.MouseButton1Click:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.JumpPower = 100
    end
end)

-- 按钮：关闭菜单
local btnClose = Instance.new("TextButton", f)
btnClose.Size = UDim2.new(1, -30, 0, 45)
btnClose.Position = UDim2.new(0, 15, 0, 220)
btnClose.Text = "关闭菜单"
btnClose.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
btnClose.TextColor3 = Color3.fromRGB(255, 255, 255)

btnClose.MouseButton1Click:Connect(function()
    sg:Destroy()
end)

