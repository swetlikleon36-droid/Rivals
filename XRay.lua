-- Made by lleeoonn111 Discord> lleeoonn11
-- Join the discord |NO Discord Jet|
-- LocalScript (StarterPlayerScripts)

local Players = game:GetService("Players")

-- Function to add highlight to a character
local function addHighlight(character)
	if character:FindFirstChild("PlayerHighlight") then return end
	
	local highlight = Instance.new("Highlight")
	highlight.Name = "PlayerHighlight"
	highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red fill
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White outline
	highlight.FillTransparency = 0.5
	highlight.OutlineTransparency = 0
	highlight.Parent = character
end

-- Function to handle player
local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function(character)
		addHighlight(character)
	end)
	
	-- If character already exists
	if player.Character then
		addHighlight(player.Character)
	end
end

-- Apply to existing players
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

local tracers = {}

local function createTracer(player)
	if player == LocalPlayer then return end
	
	local line = Drawing.new("Line")
	line.Thickness = 2
	line.Color = Color3.fromRGB(255, 0, 0)
	line.Transparency = 1
	line.Visible = false
	
	tracers[player] = line
end

local function removeTracer(player)
	if tracers[player] then
		tracers[player]:Remove()
		tracers[player] = nil
	end
end

-- Spieler hinzufügen
for _, player in ipairs(Players:GetPlayers()) do
	createTracer(player)
end

Players.PlayerAdded:Connect(createTracer)
Players.PlayerRemoving:Connect(removeTracer)

RunService.RenderStepped:Connect(function()
	for player, line in pairs(tracers) do
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local root = player.Character.HumanoidRootPart
			local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
			
			if onScreen then
				line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
				line.To = Vector2.new(pos.X, pos.Y)
				line.Visible = true
			else
				line.Visible = false
			end
		else
			line.Visible = false
		end
	end
end)

-- Apply to new players
Players.PlayerAdded:Connect(onPlayerAdded)
