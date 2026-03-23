-- Made by lleeoonn111 Discord> lleeoonn11
-- Join the discord |NO Discord Jet|
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Bars = {}
local MAX_DISTANCE = 500

local function RemoveBar(player)
    if Bars[player] then
        Bars[player]:Remove()
        Bars[player] = nil
    end
end

Players.PlayerRemoving:Connect(RemoveBar)

RunService.RenderStepped:Connect(function()
    for _,player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer 
        and player.Character 
        and player.Character:FindFirstChild("Humanoid")
        and player.Character:FindFirstChild("HumanoidRootPart")
        and LocalPlayer.Character
        and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            
            local hum = player.Character.Humanoid
            local hrp = player.Character.HumanoidRootPart

            -- Wenn tot → entfernen
            if hum.Health <= 0 then
                RemoveBar(player)
                continue
            end

            -- Distanz check
            local distance = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance > MAX_DISTANCE then
                if Bars[player] then
                    Bars[player].Visible = false
                end
                continue
            end

            if not Bars[player] then
                local bar = Drawing.new("Line")
                bar.Thickness = 4
                bar.Transparency = 1
                Bars[player] = bar
            end

            local pos,visible = Camera:WorldToViewportPoint(hrp.Position)

            if visible then
                local health = hum.Health / hum.MaxHealth
                local height = 100 / pos.Z * 5

                Bars[player].From = Vector2.new(pos.X-30,pos.Y+height)
                Bars[player].To = Vector2.new(pos.X-30,pos.Y+height-(height*2*health))
                Bars[player].Color = Color3.fromRGB(255-(255*health),255*health,0)
                Bars[player].Visible = true
            else
                Bars[player].Visible = false
            end
        else
            RemoveBar(player)
        end
    end
end)
