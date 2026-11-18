local Players = cloneref(game:GetService("Players"))
local plr = Players.LocalPlayer
local font = Font.new("rbxasset://fonts/families/ComicNeueAngular.json")

local tags = {
	blue = function(t) return `<font color="#7289da">{t}</font>` end,
	green = function(t) return `<font color="#43b581">{t}</font>` end,
	red = function(t) return `<font color="#f04747">{t}</font>` end,
	neon = function(t) return `<font color="#adff2f">{t}</font>` end,
	bold = function(t) return `<b>{t}</b>` end,
	italic = function(t) return `<i>{t}</i>` end,
}

local function parse(text: string): (string, boolean)
	local hasTag = false
	local out = text:gsub("(%a+)%((.-)%)", function(tag, content)
		if tags[tag] then
			hasTag = true
			return tags[tag](content)
		end
	end)
	return out, hasTag
end

local function newLabel(parent, pos, size, color, text, maxSize)
	local parsed, hasTag = parse(text)
	local l = Instance.new("TextLabel")
	l.Size = size
	l.Position = pos
	l.BackgroundTransparency = 1
	l.TextColor3 = color
	l.TextScaled = true
	l.TextWrapped = true
	l.FontFace = font
	l.RichText = hasTag
	l.Text = parsed
	l.Parent = parent

	if maxSize then
		local c = Instance.new("UITextSizeConstraint")
		c.MaxTextSize = maxSize
		c.Parent = l
	end

	return l
end

local Module = {}

function Module.Ban(BanData: {
	title: string?,
	reason: string?,
	duration: string?,
	timeLeft: string?,
	note: string?,
	discord: string?,
	discordText: string?,
})
	BanData = BanData or {}

	local conns = {}

	local gui = Instance.new("ScreenGui")
	gui.Name = "BanGui"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = gethui()

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.5, 0, 0.5, 0)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.new(1, 1, 1)
	frame.BorderSizePixel = 0
	frame.Style = Enum.FrameStyle.DropShadow
	frame.Parent = gui

	Instance.new("UIAspectRatioConstraint").Parent = frame

	local titleParsed, titleHasTag = parse(BanData.title or "YOU HAVE BEEN BANNED!")
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, 0, 0.15, 0)
	titleLabel.Position = UDim2.new(0, 0, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.new(1, 0, 0)
	titleLabel.TextScaled = true
	titleLabel.FontFace = font
	titleLabel.RichText = titleHasTag
	titleLabel.Text = titleParsed
	titleLabel.Parent = frame
	local tc = Instance.new("UITextSizeConstraint")
	tc.MaxTextSize = 28
	tc.Parent = titleLabel

	newLabel(frame,
		UDim2.new(0, 0, 0.125, 0),
		UDim2.new(1, 0, 0.4, 0),
		Color3.new(1, 1, 1),
		"Reason: " .. (BanData.reason or "N/A"),
		22
	)

	local dur = Instance.new("TextLabel")
	dur.Size = UDim2.new(1, 0, 0.1, 0)
	dur.Position = UDim2.new(0, 0, 0.55, 0)
	dur.BackgroundTransparency = 1
	dur.RichText = true
	dur.TextColor3 = Color3.new(1, 1, 1)
	dur.TextScaled = true
	dur.FontFace = font
	dur.Text = `Your ban duration is <font color="#ff0000">{BanData.duration or "permanent"}.</font>`
	dur.Parent = frame
	local dc = Instance.new("UITextSizeConstraint")
	dc.MaxTextSize = 18
	dc.Parent = dur

	if BanData.note then
		newLabel(frame,
			UDim2.new(0, 0, 0.65, 0),
			UDim2.new(1, 0, 0.1, 0),
			Color3.fromRGB(200, 200, 200),
			BanData.note,
			14
		)
	end

	if BanData.timeLeft then
		newLabel(frame,
			UDim2.new(0, 0, BanData.note and 0.75 or 0.65, 0),
			UDim2.new(1, 0, 0.15, 0),
			Color3.new(1, 1, 1),
			`You will automatically be unbanned in\n{BanData.timeLeft}`,
			14
		)
	end

	if BanData.discord then
		local appeal = Instance.new("TextLabel")
		appeal.Size = UDim2.new(1, 0, 0.1, 0)
		appeal.Position = UDim2.new(0, 0, 0.9, 0)
		appeal.BackgroundTransparency = 1
		appeal.RichText = true
		appeal.Text = `Appeal this ban on our <u>Discord Server</u>.`
		appeal.TextColor3 = Color3.fromRGB(114, 137, 218)
		appeal.TextScaled = true
		appeal.FontFace = font
		appeal.Parent = frame
		local ac = Instance.new("UITextSizeConstraint")
		ac.MaxTextSize = 14
		ac.Parent = appeal
		conns[#conns + 1] = appeal.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				setclipboard(BanData.discord)
			end
		end)
	end

	local okay = Instance.new("TextButton")
	okay.Size = UDim2.new(0.5, 0, 0.1, 0)
	okay.Position = UDim2.new(0.5, 0, 0.81, 0)
	okay.AnchorPoint = Vector2.new(0.5, 0)
	okay.Text = "Okay :("
	okay.TextColor3 = Color3.new(1, 1, 1)
	okay.TextScaled = true
	okay.Style = Enum.ButtonStyle.RobloxButtonDefault
	okay.FontFace = font
	okay.Parent = frame
	local oc = Instance.new("UITextSizeConstraint")
	oc.MaxTextSize = 16
	oc.Parent = okay
	conns[#conns + 1] = okay.MouseButton1Click:Connect(function()
		for _, c in conns do c:Disconnect() end
		table.clear(conns)
		gui:Destroy()
	end)
end

return Module
