-- Made by lleeoonn111 Discord> lleeoonn11
-- Join the discord |NO Discord Jet|local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Boxes = {}
local MAX_DISTANCE = 500

local function RemoveBox(player)
    if Boxes[player] then
        Boxes[player]:Remove()
        Boxes[player] = nil
    end
end

Players.PlayerRemoving:Connect(RemoveBox)

RunService.RenderStepped:Connect(function()
    for _,player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer 
        and player.Character 
        and player.Character:FindFirstChild("HumanoidRootPart")
        and player.Character:FindFirstChild("Humanoid")
        and LocalPlayer.Character
        and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            
            local hum = player.Character.Humanoid
            local hrp = player.Character.HumanoidRootPart

            -- Wenn tot → entfernen
            if hum.Health <= 0 then
                RemoveBox(player)
                continue
            end

            -- Distanz check
            local distance = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance > MAX_DISTANCE then
                if Boxes[player] then
                    Boxes[player].Visible = false
                end
                continue
            end

            if not Boxes[player] then
                local box = Drawing.new("Square")
                box.Color = Color3.fromRGB(0,170,255)
                box.Thickness = 2
                box.Filled = false
                box.Transparency = 1
                Boxes[player] = box
            end

            local size = player.Character:GetExtentsSize()
            local pos,visible = Camera:WorldToViewportPoint(hrp.Position)

            if visible then
                local scale = 1 / (pos.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 1000
                local width = size.X * scale
                local height = size.Y * scale

                Boxes[player].Size = Vector2.new(width,height)
                Boxes[player].Position = Vector2.new(pos.X-width/2,pos.Y-height/2)
                Boxes[player].Visible = true
            else
                Boxes[player].Visible = false
            end
        else
            RemoveBox(player)
        end
    end
end)
