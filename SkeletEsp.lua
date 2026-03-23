-- Made by lleeoonn111 Discord> lleeoonn11
-- Join the discord |NO Discord Jet|
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Skeletons = {}
local MAX_DISTANCE = 500

local Bones = {
    {"Head","UpperTorso"},
    {"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},
    {"UpperTorso","RightUpperArm"},
    {"LeftUpperArm","LeftLowerArm"},
    {"RightUpperArm","RightLowerArm"},
    {"LowerTorso","LeftUpperLeg"},
    {"LowerTorso","RightUpperLeg"},
    {"LeftUpperLeg","LeftLowerLeg"},
    {"RightUpperLeg","RightLowerLeg"}
}

local function RemoveSkeleton(player)
    if Skeletons[player] then
        for _,line in pairs(Skeletons[player]) do
            line:Remove()
        end
        Skeletons[player] = nil
    end
end

local function CreateSkeleton(player)
    if player == LocalPlayer then return end
    
    RemoveSkeleton(player)

    local Lines = {}
    
    for i = 1,#Bones do
        local Line = Drawing.new("Line")
        Line.Color = Color3.fromRGB(0,170,255)
        Line.Thickness = 2
        Line.Transparency = 1
        Line.Visible = false
        table.insert(Lines,Line)
    end
    
    Skeletons[player] = Lines
end

local function SetupCharacter(player, character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        humanoid.Died:Connect(function()
            RemoveSkeleton(player)
        end)
    end

    CreateSkeleton(player)
end

local function SetupPlayer(player)
    if player == LocalPlayer then return end

    player.CharacterAdded:Connect(function(character)
        task.wait(1)
        SetupCharacter(player, character)
    end)

    player.CharacterRemoving:Connect(function()
        RemoveSkeleton(player)
    end)

    if player.Character then
        SetupCharacter(player, player.Character)
    end
end

for _,p in pairs(Players:GetPlayers()) do
    SetupPlayer(p)
end

Players.PlayerAdded:Connect(SetupPlayer)
Players.PlayerRemoving:Connect(RemoveSkeleton)

RunService.RenderStepped:Connect(function()
    for player,lines in pairs(Skeletons) do
        if player.Character 
        and player.Character:FindFirstChild("HumanoidRootPart")
        and LocalPlayer.Character
        and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then
                for _,line in pairs(lines) do
                    line.Visible = false
                end
                continue
            end

            local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            
            if distance > MAX_DISTANCE then
                for _,line in pairs(lines) do
                    line.Visible = false
                end
                continue
            end
            
            for i,bone in pairs(Bones) do
                local a = player.Character:FindFirstChild(bone[1])
                local b = player.Character:FindFirstChild(bone[2])
                
                if a and b then
                    local A,onScreenA = Camera:WorldToViewportPoint(a.Position)
                    local B,onScreenB = Camera:WorldToViewportPoint(b.Position)
                    
                    if onScreenA and onScreenB then
                        lines[i].From = Vector2.new(A.X,A.Y)
                        lines[i].To = Vector2.new(B.X,B.Y)
                        lines[i].Visible = true
                    else
                        lines[i].Visible = false
                    end
                else
                    lines[i].Visible = false
                end
            end
        else
            RemoveSkeleton(player)
        end
    end
end)
