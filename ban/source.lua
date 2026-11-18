local Players = game:GetService("Players")
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

local function label(parent, pos, size, color, text)
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
	return l
end

local Module = {}

function Module.Ban(BanData: {
	title: string?,
	reason: string?,
	duration: string?,
	timeLeft: string?,
	discord: string?,
	discordText: string?,
})
	BanData = BanData or {}

	local conns = {}

	local gui = Instance.new("ScreenGui")
	gui.Name = "BanGui"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  gui.Parent = gethui() or plr.PlayerGui

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

	label(frame,
		UDim2.new(0, 0, 0.125, 0),
		UDim2.new(1, 0, 0.4, 0),
		Color3.new(1, 1, 1),
		"Reason: " .. (BanData.reason or "N/A")
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

	if BanData.timeLeft then
		local tl = Instance.new("TextLabel")
		tl.Size = UDim2.new(1, 0, 0.15, 0)
		tl.Position = UDim2.new(0, 0, 0.65, 0)
		tl.BackgroundTransparency = 1
		tl.TextColor3 = Color3.new(1, 1, 1)
		tl.TextScaled = true
		tl.TextWrapped = true
		tl.FontFace = font
		tl.Text = `You will automatically be unbanned in\n{BanData.timeLeft}`
		tl.Parent = frame
	end

	if BanData.discord then
		local appeal = Instance.new("TextLabel")
		appeal.Size = UDim2.new(1, 0, 0.1, 0)
		appeal.Position = UDim2.new(0, 0, 0.9, 0)
		appeal.BackgroundTransparency = 1
		appeal.RichText = true
		appeal.Text = `<u>{BanData.discordText or "Appeal this ban on our Discord server."}</u>`
		appeal.TextColor3 = Color3.fromRGB(114, 137, 218)
		appeal.TextScaled = true
		appeal.FontFace = font
		appeal.Parent = frame

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

	conns[#conns + 1] = okay.MouseButton1Click:Connect(function()
		for _, c in conns do c:Disconnect() end
		table.clear(conns)
		gui:Destroy()
	end)
end

return Module
