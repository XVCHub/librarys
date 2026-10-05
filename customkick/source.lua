local LocalPlayer = game:GetService("Players").LocalPlayer
local TeleportService = game:GetService("TeleportService")

local tags = {
	blue   = function(s) return `<font color='rgb(50,150,255)'>{s}</font>` end,
	green  = function(s) return `<font color='rgb(50,255,100)'>{s}</font>` end,
	red    = function(s) return `<font color='rgb(255,60,60)'>{s}</font>` end,
	neon   = function(s) return `<font color='rgb(180,255,0)'>{s}</font>` end,
	bold   = function(s) return `<b>{s}</b>` end,
	italic = function(s) return `<i>{s}</i>` end,
}

local function hastag(msg: string): boolean
	return msg:match("%a+%((.-)%)") ~= nil
end

local function parse(msg: string): string
	return (msg:gsub("(%a+)%((.-)%)", function(tag, content)
		local fn = tags[tag]
		return fn and fn(content) or `{tag}({content})`
	end))
end

local function applyText(label, text: string, defaultSize: number)
	local rich = hastag(text)
	label.RichText = rich
	label.Text = rich and parse(text) or text
	label.TextSize = defaultSize
end

local function makebutton(parent, text: string, layoutOrder: number, primary: boolean, callback)
	local btn = Instance.new("ImageButton")
	btn.Name = text .. "Button"
	btn.BackgroundTransparency = 1
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.LayoutOrder = layoutOrder
	btn.ZIndex = 8
	btn.Image = primary and "rbxasset://textures/ui/ErrorPrompt/PrimaryButton.png" or "rbxasset://textures/ui/ErrorPrompt/SecondaryButton.png"
	btn.ScaleType = Enum.ScaleType.Slice
	btn.SliceCenter = Rect.new(8, 8, 9, 9)
	btn.ImageColor3 = primary and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(178, 178, 178)

	local label = Instance.new("TextLabel")
	label.Text = text
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.Font = Enum.Font.SourceSans
	label.TextSize = 20
	label.TextColor3 = primary and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(178, 178, 178)
	label.ZIndex = 8
	label.Parent = btn

	btn.Activated:Connect(callback)
	btn.Parent = parent
	return btn
end

local function Kick(title: string, message: string, options: {type: number?, leaveText: string?, reconnectText: string?}?)
	options = options or {}
	local kickType = options.type or 1
	local leaveText = options.leaveText or "Leave"
	local reconnectText = options.reconnectText or "Reconnect"
	LocalPlayer:Kick()
	local gui = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
	if not gui then return end
	local overlay = gui:FindFirstChild("promptOverlay")
	if not overlay then return end
	local prompt = overlay:WaitForChild("ErrorPrompt")
	local titleLabel = prompt:FindFirstChild("TitleFrame"):FindFirstChild("ErrorTitle")
	local msgFrame = prompt:FindFirstChild("MessageArea"):FindFirstChild("ErrorFrame"):FindFirstChild("ErrorMessage")
	local buttonArea = prompt:FindFirstChild("MessageArea"):FindFirstChild("ErrorFrame"):FindFirstChild("ButtonArea")

	applyText(titleLabel, title, 25)
	applyText(msgFrame, message, 20)

	for _, c in buttonArea:GetChildren() do
		if not c:IsA("UIGridLayout") then
			c:Destroy()
		end
	end

	if kickType == 1 then
		buttonArea.ButtonLayout.CellSize = UDim2.new(1, 0, 0, 36)
		makebutton(buttonArea, leaveText, 1, true, function()
			game:Shutdown()
		end)
	elseif kickType == 2 then
		buttonArea.ButtonLayout.CellSize = UDim2.new(0.48, 0, 0, 36)
		makebutton(buttonArea, leaveText, 1, false, function()
			game:Shutdown()
		end)
		makebutton(buttonArea, reconnectText, 2, true, function()
			TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
		end)
	end
end

return {Kick = Kick}
