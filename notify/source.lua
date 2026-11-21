local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Theme = {
	Background = Color3.fromRGB(20, 20, 20),
	Text = Color3.fromRGB(240, 240, 240),
	Stroke = Color3.fromRGB(55, 55, 55),
	Shadow = Color3.fromRGB(10, 10, 10),
}

local Positions = {
	["Bottom Right"] = { anchor = Vector2.new(1, 1), pos = UDim2.new(1, -20, 1, -20), valign = Enum.VerticalAlignment.Bottom },
	["Bottom Left"] = { anchor = Vector2.new(0, 1), pos = UDim2.new(0, 20,  1, -20), valign = Enum.VerticalAlignment.Bottom },
	["Top Right"] = { anchor = Vector2.new(1, 0), pos = UDim2.new(1, -20, 0, 20),  valign = Enum.VerticalAlignment.Top },
	["Top Left"] = { anchor = Vector2.new(0, 0), pos = UDim2.new(0, 20,  0, 20),  valign = Enum.VerticalAlignment.Top },
}

local ShadowAsset do
	local path = "notify_shadow.png"
	if getcustomasset and writefile then
		local req = request or http_request or (http and http.request)
		if req then
			local ok, res = pcall(req, {
				Url = "https://raw.githubusercontent.com/XVCHub/librarys/main/notify/assets/shadow.png",
				Method = "GET",
			})
			if ok and res and res.StatusCode == 200 then
				pcall(writefile, path, res.Body)
			end
		end
	end
	local ok, id = getcustomasset and pcall(getcustomasset, path)
	ShadowAsset = (ok and id) or "rbxassetid://3523728077"
end

local function protect(gui)
	gui.ResetOnSpawn = false
	if gethui then
		gui.Parent = gethui()
	elseif get_hidden_gui then
		gui.Parent = get_hidden_gui()
	else
		gui.Parent = CoreGui
	end
end

local function asset(id)
	if type(id) == "number" then
		if getcustomasset then
			local ok, r = pcall(getcustomasset, tostring(id))
			if ok and r and #r > 0 then return r end
		end
		return "rbxassetid://" .. tostring(id)
	end
	if type(id) == "string" then
		if id:sub(1, 13) == "rbxassetid://" then return id end
		if getcustomasset then
			local ok, r = pcall(getcustomasset, id)
			if ok and r and #r > 0 then return r end
		end
	end
	return "rbxassetid://0"
end

local gui = Instance.new("ScreenGui")
gui.Name = "NotifyLib"
gui.DisplayOrder = 999
protect(gui)

local containers = {}

local function getContainer(position)
	if containers[position] then return containers[position] end

	local cfg = Positions[position] or Positions["Bottom Right"]

	local frame = Instance.new("Frame")
	frame.Name = "Container_" .. position
	frame.AnchorPoint = cfg.anchor
	frame.Position = cfg.pos
	frame.Size = UDim2.new(0, 310, 1, -40)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Parent = gui

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = cfg.valign
	layout.Padding = UDim.new(0, 8)
	layout.Parent = frame

	containers[position] = { frame = frame, layout = layout }
	return containers[position]
end

local function notify(title, content, icon, duration, position, button, close)
	position = position or "Bottom Right"
	local c = getContainer(position)
	local frame = c.frame
	local layout = c.layout
	local isBottom = position == "Bottom Right" or position == "Bottom Left"

	task.spawn(function()
		local n = Instance.new("Frame")
		n.Name = "Notification"
		n.Size = UDim2.new(1, 0, 0, 0)
		n.BackgroundColor3 = Theme.Background
		n.BackgroundTransparency = 1
		n.BorderSizePixel = 0
		n.ClipsDescendants = true
		n.LayoutOrder = if isBottom then -os.clock() * 1000 else os.clock() * 1000
		n.ZIndex = 10
		n.Parent = frame

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 20)
		corner.Parent = n

		local stroke = Instance.new("UIStroke")
		stroke.Color = Theme.Stroke
		stroke.Thickness = 1
		stroke.Transparency = 1
		stroke.Parent = n

		local shadow = Instance.new("ImageLabel")
		shadow.Name = "Shadow"
		shadow.Image = ShadowAsset
		shadow.ImageColor3 = Theme.Shadow
		shadow.ImageTransparency = 1
		shadow.BackgroundTransparency = 1
		shadow.AnchorPoint = Vector2.new(0.5, 0.5)
		shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
		shadow.Size = UDim2.new(1.11, 0, 1.92, 0)
		shadow.ZIndex = 9
		shadow.Parent = n

		local hasIcon = icon ~= nil
		local hasClose = close ~= false
		local hasButton = type(button) == "table"
		local leftPad = hasIcon and 72 or 20

		local iconLabel
		if hasIcon then
			iconLabel = Instance.new("ImageLabel")
			iconLabel.Name = "Icon"
			iconLabel.Image = asset(icon)
			iconLabel.ImageColor3 = Theme.Text
			iconLabel.BackgroundTransparency = 1
			iconLabel.AnchorPoint = Vector2.new(0, 0.5)
			iconLabel.Position = UDim2.new(0, 20, 0.5, 0)
			iconLabel.Size = UDim2.new(0, 32, 0, 32)
			iconLabel.ImageTransparency = 1
			iconLabel.ZIndex = 11
			iconLabel.Parent = n
		end

		local dismissed = false

		if hasClose then
			local closeBtn = Instance.new("TextButton")
			closeBtn.Name = "Close"
			closeBtn.Text = "×"
			closeBtn.Font = Enum.Font.GothamBold
			closeBtn.TextSize = 18
			closeBtn.TextColor3 = Theme.Text
			closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			closeBtn.BackgroundTransparency = 0.5
			closeBtn.AutoButtonColor = false
			closeBtn.AnchorPoint = Vector2.new(1, 0)
			closeBtn.Position = UDim2.new(1, -10, 0, 10)
			closeBtn.Size = UDim2.new(0, 22, 0, 22)
			closeBtn.ZIndex = 13
			closeBtn.Parent = n

			local cc = Instance.new("UICorner")
			cc.CornerRadius = UDim.new(1, 0)
			cc.Parent = closeBtn

			closeBtn.Activated:Connect(function()
				dismissed = true
			end)
		end

		local titleLabel = Instance.new("TextLabel")
		titleLabel.Name = "Title"
		titleLabel.Text = tostring(title or "")
		titleLabel.Font = Enum.Font.GothamBold
		titleLabel.TextSize = 16
		titleLabel.TextColor3 = Theme.Text
		titleLabel.TextTransparency = 1
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.TextWrapped = true
		titleLabel.BackgroundTransparency = 1
		titleLabel.Position = UDim2.new(0, leftPad, 0, 15)
		titleLabel.Size = UDim2.new(1, -(leftPad + (hasClose and 40 or 15)), 0, 16)
		titleLabel.ZIndex = 11
		titleLabel.Parent = n

		local contentLabel = Instance.new("TextLabel")
		contentLabel.Name = "Content"
		contentLabel.Text = tostring(content or "")
		contentLabel.Font = Enum.Font.Gotham
		contentLabel.TextSize = 15
		contentLabel.TextColor3 = Theme.Text
		contentLabel.TextTransparency = 1
		contentLabel.TextXAlignment = Enum.TextXAlignment.Left
		contentLabel.TextWrapped = true
		contentLabel.BackgroundTransparency = 1
		contentLabel.Position = UDim2.new(0, leftPad, 0, 32)
		contentLabel.Size = UDim2.new(1, -(leftPad + 15), 1, -40)
		contentLabel.ZIndex = 11
		contentLabel.Parent = n

		local btnHeight = 0

		if hasButton then
			btnHeight = 32
			local btn = Instance.new("TextButton")
			btn.Text = tostring(button.Text or "Button")
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 14
			btn.TextColor3 = Theme.Text
			btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			btn.AutoButtonColor = false
			btn.Size = UDim2.new(1, -(leftPad + 15), 0, btnHeight)
			btn.ZIndex = 12
			btn.Parent = n

			local bc = Instance.new("UICorner")
			bc.CornerRadius = UDim.new(0, 8)
			bc.Parent = btn

			local bs = Instance.new("UIStroke")
			bs.Color = Theme.Stroke
			bs.Thickness = 1
			bs.Parent = btn

			btn.MouseEnter:Connect(function()
				TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(55, 55, 55) }):Play()
			end)
			btn.MouseLeave:Connect(function()
				TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(40, 40, 40) }):Play()
			end)
			btn.Activated:Connect(function()
				if type(button.Callback) == "function" then
					button.Callback()
				end
				dismissed = true
			end)
		end

		task.wait()

		local contentH = contentLabel.TextBounds.Y
		local titleH = titleLabel.TextBounds.Y
		local totalH = 15 + math.max(titleH, 16) + 4 + contentH + (hasButton and (btnHeight + 12) or 10)
		totalH = math.max(totalH, hasIcon and 60 or 50)

		if hasButton then
			local btn = n:FindFirstChildOfClass("TextButton")
			if btn then
				btn.Position = UDim2.new(0, leftPad, 0, 15 + math.max(titleH, 16) + 4 + contentH + 8)
			end
		end
		n.Size = UDim2.new(1, -60, 0, -layout.Padding.Offset)
		TweenService:Create(n, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {
			Size = UDim2.new(1, 0, 0, totalH),
			BackgroundTransparency = 0.45,
		}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { Transparency = 0.95 }):Play()
		TweenService:Create(shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { ImageTransparency = 0.82 }):Play()
		task.wait(0.15)
		TweenService:Create(titleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
		task.wait(0.05)
		if iconLabel then
			TweenService:Create(iconLabel, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { ImageTransparency = 0 }):Play()
		end
		task.wait(0.05)
		TweenService:Create(contentLabel, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 0.35 }):Play()
		local wait = duration or math.min(math.max(#tostring(content) * 0.1 + 2.5, 3), 10)
		local elapsed = 0
		while elapsed < wait and not dismissed do
			elapsed += task.wait(0.05)
		end
		TweenService:Create(n, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { BackgroundTransparency = 1 }):Play()
		TweenService:Create(stroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), { Transparency = 1 }):Play()
		TweenService:Create(shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { ImageTransparency = 1 }):Play()
		TweenService:Create(titleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
		TweenService:Create(contentLabel, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { TextTransparency = 1 }):Play()
		if iconLabel then
			TweenService:Create(iconLabel, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { ImageTransparency = 1 }):Play()
		end
		TweenService:Create(n, TweenInfo.new(1, Enum.EasingStyle.Exponential), { Size = UDim2.new(1, -90, 0, 0) }):Play()
		task.wait(1)
		TweenService:Create(n, TweenInfo.new(1, Enum.EasingStyle.Exponential), { Size = UDim2.new(1, -90, 0, -layout.Padding.Offset) }):Play()
		n.Visible = false
		n:Destroy()
	end)
end

return notify
