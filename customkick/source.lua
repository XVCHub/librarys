local LocalPlayer = game:GetService("Players").LocalPlayer

local tags = {
	blue   = function(s) return `<font color='rgb(50,150,255)'>{s}</font>` end,
	green  = function(s) return `<font color='rgb(50,255,100)'>{s}</font>` end,
	red    = function(s) return `<font color='rgb(255,60,60)'>{s}</font>` end,
	neon   = function(s) return `<font color='rgb(180,255,0)'>{s}</font>` end,
	bold   = function(s) return `<b>{s}</b>` end,
	italic = function(s) return `<i>{s}</i>` end,
}

local function hasTag(msg: string): boolean
	return msg:match("%a+%((.-)%)") ~= nil
end

local function parse(msg: string): string
	return (msg:gsub("(%a+)%((.-)%)", function(tag, content)
		local fn = tags[tag]
		return fn and fn(content) or `{tag}({content})`
	end))
end

local function Kick(title: string, message: string)
	LocalPlayer:Kick()
	local gui = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
	if not gui then return end
	local prompt = gui:FindFirstChild("promptOverlay"):WaitForChild("ErrorPrompt")
	local titleLabel = prompt:FindFirstChild("TitleFrame"):FindFirstChild("ErrorTitle")
	local msgFrame = prompt:FindFirstChild("MessageArea"):FindFirstChild("ErrorFrame"):FindFirstChild("ErrorMessage")
	titleLabel.TextSize = 25
	msgFrame.TextSize = 20
	local msgHasTags = hasTag(message)
	local titleHasTags = hasTag(title)
	titleLabel.RichText = titleHasTags
	titleLabel.Text = titleHasTags and parse(title) or title
	msgFrame.RichText = msgHasTags
	msgFrame.Text = msgHasTags and parse(message) or message
end

return {Kick = Kick}
