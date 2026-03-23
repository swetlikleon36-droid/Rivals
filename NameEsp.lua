-- Made by lleeoonn111 Discord> lleeoonn11
-- Join the discord |NO Discord Jet|
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local MAX_DISTANCE = 500
local TEXT_SIZE = 14 -- klein aber lesbar

local Tags = {}

local function RemoveTag(player)
	if Tags[player] then
		Tags[player]:Destroy()
		Tags[player] = nil
	end
end

local function CreateTag(player, character)
	if player == LocalPlayer then return end
	
	local head = character:FindFirstChild("Head")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not head or not humanoid then return end
	
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "DisplayNameTag"
	billboard.Size = UDim2.new(0,200,0,40)
	billboard.StudsOffset = Vector3.new(0,2.5,0)
	billboard.AlwaysOnTop = true -- DURCH WÄNDE
	billboard.MaxDistance = MAX_DISTANCE
	billboard.LightInfluence = 0 -- immer gleich hell
	billboard.Parent = head
	
	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1,0,1,0)
	text.BackgroundTransparency = 1
	text.Text = player.DisplayName
	text.TextColor3 = Color3.fromRGB(255,255,255)
	text.TextStrokeTransparency = 0
	text.TextScaled = false -- WICHTIG (keine Größenänderung)
	text.TextSize = TEXT_SIZE -- IMMER GLEICH GROSS
	text.Font = Enum.Font.GothamBold
	text.Parent = billboard
	
	Tags[player] = billboard
	
	humanoid.Died:Connect(function()
		RemoveTag(player)
	end)
end

local function SetupPlayer(player)
	if player == LocalPlayer then return end
	
	player.CharacterAdded:Connect(function(char)
		task.wait(0.5)
		CreateTag(player, char)
	end)
	
	player.CharacterRemoving:Connect(function()
		RemoveTag(player)
	end)
	
	if player.Character then
		CreateTag(player, player.Character)
	end
end

for _,p in ipairs(Players:GetPlayers()) do
	SetupPlayer(p)
end

Players.PlayerAdded:Connect(SetupPlayer)
Players.PlayerRemoving:Connect(RemoveTag)
