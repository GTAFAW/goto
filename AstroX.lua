local AstroXUI = loadstring(game:HttpGet("https://github.com/SoyAdriYT/AstroX/raw/main/LibraryUI/AstroXUI.lua"))()

local Stats = game:GetService('Stats')

local Players = game:GetService('Players')

local RunService = game:GetService('RunService')

local ReplicatedStorage = game:GetService('ReplicatedStorage')

local Nurysium_Util = loadstring(game:HttpGet('https://raw.githubusercontent.com/SoyAdriYT/AstroX/main/Scripts/FuntionsBall.lua'))()

local local_player = Players.LocalPlayer

local camera = workspace.CurrentCamera

local nurysium_Data = nil

local hit_Sound = nil

local closest_Entity = nil

local parry_remote = nil

getgenv().aura_Enabled = false

getgenv().hit_sound_Enabled = false

getgenv().hit_effect_Enabled = false

getgenv().night_mode_Enabled = false

getgenv().trail_Enabled = false

getgenv().self_effect_Enabled = false

local Services = {

    game:GetService('AdService'),

    game:GetService('SocialService')

}

function initializate(dataFolder_name: string)
    local nurysium_Data = Instance.new('Folder', game:GetService('CoreGui'))
    nurysium_Data.Name = dataFolder_name

    hit_Sound = Instance.new('Sound', nurysium_Data)
    hit_Sound.Volume = 5
end

local function get_closest_entity(Object: Part)

    task.spawn(function()

        local closest

        local max_distance = math.huge

        for index, entity in workspace.Alive:GetChildren() do

            if entity.Name ~= Players.LocalPlayer.Name then

                local distance = (Object.Position - entity.HumanoidRootPart.Position).Magnitude

                if distance < max_distance then

                    closest_Entity = entity

                    max_distance = distance

                end

            end

        end

        return closest_Entity

    end)

end

function resolve_parry_Remote()

    for _, value in Services do

        local temp_remote = value:FindFirstChildOfClass('RemoteEvent')

        if not temp_remote then

            continue

        end

        if not temp_remote.Name:find('\n') then

            continue

        end

        parry_remote = temp_remote

    end

end

local aura_table = {

    canParry = true,

    is_Spamming = false,

    parry_Range = 0,

    spam_Range = 0,  

    hit_Count = 0,

    hit_Time = tick(),

    ball_Warping = tick(),

    is_ball_Warping = false

}

function setHitSound(soundId)
    hit_Sound.SoundId = soundId
end

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if getgenv().hit_sound_Enabled then
        hit_Sound:Play()
    end

    if getgenv().hit_effect_Enabled then

        local hit_effect = game:GetObjects("rbxassetid://17407244385")[1]

        hit_effect.Parent = Nurysium_Util.getBall()

        hit_effect:Emit(3)

        

        task.delay(5, function()

            hit_effect:Destroy()

        end)

    end

end)

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function()

    aura_table.hit_Count += 1

    task.delay(0.15, function()

        aura_table.hit_Count -= 1

    end)

end)

workspace:WaitForChild("Balls").ChildRemoved:Connect(function(child)

    aura_table.hit_Count = 0

    aura_table.is_ball_Warping = false

    aura_table.is_Spamming = false

end)

task.defer(function()

    game:GetService("RunService").Heartbeat:Connect(function()

        if not local_player.Character then

            return

        end

        if getgenv().trail_Enabled then

            local trail = game:GetObjects("rbxassetid://17483658369")[1]

            trail.Name = 'nurysium_fx'

            if local_player.Character.PrimaryPart:FindFirstChild('nurysium_fx') then

                return

            end

            local Attachment0 = Instance.new("Attachment", local_player.Character.PrimaryPart)

            local Attachment1 = Instance.new("Attachment", local_player.Character.PrimaryPart)

            Attachment0.Position = Vector3.new(0, -2.411, 0)

            Attachment1.Position = Vector3.new(0, 2.504, 0)

            trail.Parent = local_player.Character.PrimaryPart

            trail.Attachment0 = Attachment0

            trail.Attachment1 = Attachment1

        else

            

            if local_player.Character.PrimaryPart:FindFirstChild('nurysium_fx') then

                local_player.Character.PrimaryPart['nurysium_fx']:Destroy()

            end

        end

    end)

end)

task.defer(function()

    while task.wait(1) do

        if getgenv().night_mode_Enabled then

            game:GetService("TweenService"):Create(game:GetService("Lighting"), TweenInfo.new(3), {ClockTime = 3.9}):Play()

        else

            game:GetService("TweenService"):Create(game:GetService("Lighting"), TweenInfo.new(3), {ClockTime = 13.5}):Play()

        end

    end

end)

task.spawn(function()
    RunService.PreRender:Connect(function()
        if not getgenv().aura_Enabled then
            return
        end

        if closest_Entity then
            if workspace.Alive:FindFirstChild(closest_Entity.Name) and workspace.Alive:FindFirstChild(closest_Entity.Name).Humanoid.Health > 0 then
                if aura_table.is_Spamming then
                    if local_player:DistanceFromCharacter(closest_Entity.HumanoidRootPart.Position) <= aura_table.spam_Range then
                        parry_remote:FireServer(
                            0.5,
                            CFrame.new(camera.CFrame.Position, Vector3.zero),
                            {[closest_Entity.Name] = closest_Entity.HumanoidRootPart.Position},
                            {closest_Entity.HumanoidRootPart.Position.X, closest_Entity.HumanoidRootPart.Position.Y},
                            false
                        )
                    end
                end
            end
        end
    end)

    RunService.Heartbeat:Connect(function()
        if not getgenv().aura_Enabled then
            return
        end

        local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10
        local self = Nurysium_Util.getBall()

        if not self then
            return
        end

        self:GetAttributeChangedSignal('target'):Once(function()
            aura_table.canParry = true
        end)

        if self:GetAttribute('target') ~= local_player.Name or not aura_table.canParry then
            return
        end

        get_closest_entity(local_player.Character.PrimaryPart)

        local player_Position = local_player.Character.PrimaryPart.Position
        local ball_Position = self.Position
        local ball_Velocity = self.AssemblyLinearVelocity

        if self:FindFirstChild('zoomies') then
            ball_Velocity = self.zoomies.VectorVelocity
        end

        local ball_Direction = (local_player.Character.PrimaryPart.Position - ball_Position).Unit
        local ball_Distance = local_player:DistanceFromCharacter(ball_Position)
        local ball_Dot = ball_Direction:Dot(ball_Velocity.Unit)
        local ball_Speed = ball_Velocity.Magnitude
        local ball_speed_Limited = math.min(ball_Speed / 1000, 0.1)
        local ball_predicted_Distance = (ball_Distance - ping / 15.5) - (ball_Speed / 3.5)
        local target_Position = closest_Entity.HumanoidRootPart.Position
        local target_Distance = local_player:DistanceFromCharacter(target_Position)
        local target_distance_Limited = math.min(target_Distance / 10000, 0.1)
        local target_Direction = (local_player.Character.PrimaryPart.Position - closest_Entity.HumanoidRootPart.Position).Unit
        local target_Velocity = closest_Entity.HumanoidRootPart.AssemblyLinearVelocity
        local target_isMoving = target_Velocity.Magnitude > 0
        local target_Dot = target_isMoving and math.max(target_Direction:Dot(target_Velocity.Unit), 0)

        aura_table.spam_Range = math.max(ping / 10, 15) + ball_Speed / 7
        aura_table.parry_Range = math.max(math.max(ping, 4) + ball_Speed / 3.5, 9.5)
        aura_table.is_Spamming = aura_table.hit_Count > 1 or ball_Distance < 13.5

        if ball_Dot < -0.2 then
            aura_table.ball_Warping = tick()
        end

        task.spawn(function()
            if (tick() - aura_table.ball_Warping) >= 0.15 + target_distance_Limited - ball_speed_Limited or ball_Distance <= 10 then
                aura_table.is_ball_Warping = false
                return
            end
            aura_table.is_ball_Warping = true
        end)

        if ball_Distance <= aura_table.parry_Range and not aura_table.is_Spamming and not aura_table.is_ball_Warping then
          
            local curve_intensity = 1.5
            local random_curve = Vector3.new(
                math.random(-150, 150) * curve_intensity,
                math.random(-150, 150) * curve_intensity,
                math.random(-150, 150) * curve_intensity
            )

            local parry_CFrame
            if getgenv().auto_curve_Enabled and math.random() < 0.9 then
                parry_CFrame = CFrame.new(camera.CFrame.Position, target_Position + random_curve)
            else
                parry_CFrame = CFrame.new(camera.CFrame.Position, target_Position)
            end

            parry_remote:FireServer(
                0.5,
                parry_CFrame,
                {[closest_Entity.Name] = target_Position},
                {target_Position.X, target_Position.Y},
                false
            )

            aura_table.canParry = false
            aura_table.hit_Time = tick()
            aura_table.hit_Count += 1

            task.delay(0.15, function()
                aura_table.hit_Count -= 1
            end)
        end

        task.spawn(function()
            repeat
                RunService.Heartbeat:Wait()
            until (tick() - aura_table.hit_Time) >= 1
            aura_table.canParry = true
        end)
    end)
end)

initializate('nurysium_temp')

spawn(function()
    while true do
        wait(0.01)
        if getgenv().ASC then
            game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalSwordCrate)
        end
    end
end)

spawn(function()
    while true do
        wait(0.01)
        if getgenv().AEC then
            game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalExplosionCrate)
        end
    end
end)

spawn(function()
    local TweenService = game:GetService("TweenService")
    local plr = game.Players.LocalPlayer
    local Ball = workspace:WaitForChild("Balls")
    local currentTween = nil

    while true do
        wait(0.001)
        if getgenv().FB then
            local ball = Ball:FindFirstChildOfClass("Part")
            local char = plr.Character
            if ball and char then
                local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false, 0)
                local distance = (char.PrimaryPart.Position - ball.Position).magnitude
                if distance <= 1000 then 
                    if currentTween then
                        currentTween:Pause()
                    end
                    currentTween = TweenService:Create(char.PrimaryPart, tweenInfo, {CFrame = ball.CFrame})
                    currentTween:Play()
                end
            end
        else
            if currentTween then
                currentTween:Pause()
                currentTween = nil
            end
        end
    end
end)

function GetMouse()
    local UserInputService = game:GetService("UserInputService")
    return UserInputService:GetMouseLocation()
end

function GetClosestPlayer()
    local closestDistance = math.huge
    local closestTarget = nil
    for _, v in pairs(game:GetService("Workspace").Alive:GetChildren()) do
        if v and v:FindFirstChild("HumanoidRootPart") and v ~= game.Players.LocalPlayer.Character then
            local humanoidRootPart = v.HumanoidRootPart
            local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestTarget = v
            end
        end
    end
    return closestTarget
end

spawn(function()
    while task.wait() do
        if PlayerSaftey then
            if game.Players.LocalPlayer.Character.Parent.Name == "Dead" then return end
            pcall(function()
                local closestPlayer = GetClosestPlayer()
                if closestPlayer and (closestPlayer.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= PlayerSaftey_Distance then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = closestPlayer.HumanoidRootPart.CFrame * CFrame.new(-25, 0, -PlayerSaftey_Distance)
                end
            end)
        end
    end
end)

function GetBall()
    for _, v in pairs(game:GetService("Workspace").Balls:GetChildren()) do
        if v:IsA("Part") then
            return v
        end
    end
    return nil
end

function GetBallFromPlayerPos(Ball)
    return (Ball.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
end

local function getSpeed(part)
    if part:IsA("BasePart") then
        local speed = part.Velocity.Magnitude
        if speed > 1 then
            return part, speed
        end
        return nil, nil
    else
        print("The provided instance is not a BasePart.")
        return nil, nil
    end
end

local function measureVerticalDistance(humanoidRootPart, targetPart)
    local humanoidRootPartY = humanoidRootPart.Position.Y
    local targetPartY = targetPart.Position.Y
    local verticalDistance = math.abs(humanoidRootPartY - targetPartY)
    return verticalDistance
end

function GetHotKey()
    for _, v in pairs(game.Players.LocalPlayer.PlayerGui.Hotbar.Block.HotkeyFrame:GetChildren()) do
        if v:IsA("TextLabel") then
            return v.Text
        end
    end
    return ""
end

local text = game.Players.LocalPlayer.PlayerGui.Hotbar.Block.HotkeyFrame.F
local KeyCodeBlock = text.Text
text:GetPropertyChangedSignal("Text"):Connect(function()
    KeyCodeBlock = text.Text
end)

local CanSlash = false
local BallSpeed = 0

spawn(function()
    while task.wait() do
        if RandAutoaParry[tostring(RandRNG)] then
            pcall(function()
                for _, v in pairs(game:GetService("Workspace").Balls:GetChildren()) do
                    if v:IsA("Part") then
                        if not game.Players.LocalPlayer.Character:FindFirstChild("Highlight") then return end
                        local part, speed = getSpeed(v)
                        if part and speed then
                            local minDistance = 2.5 * (speed * 0.1) + 2
                            if minDistance == 0 or minDistance <= 20 then
                                BallSpeed = 23
                            elseif minDistance > 20 and minDistance <= 88 then
                                BallSpeed = 2.5 * (speed * 0.1) + 5
                            elseif minDistance > 88 and minDistance <= 110 then
                                BallSpeed = 90
                            end
                            if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - part.Position).Magnitude <= BallSpeed then 
                                CanSlash = true
                            else
                                CanSlash = false
                            end
                        end
                    end
                end
                
                if CanSlash then
                    if math.random(1, 5) == 5 then
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    else
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode[KeyCodeBlock], false, game)
                    end
                    CanSlash = false
                end
            end)
        end
    end
end)

spawn(function()
    while task.wait() do
        if AutoWalk then
            pcall(function()
                local player = game.Players.LocalPlayer
                local character = player.Character

                if character and character.Parent and character.Parent.Name ~= "Dead" then
                    local targetPosition
                    for _, v in pairs(game:GetService("Workspace").Balls:GetChildren()) do
                        if v:IsA("Part") then
                            local part, speed = getSpeed(v)
                            if part and speed and speed > 5 then
                                targetPosition = part.Position + Vector3.new(AutoWalkDistanceX, 0, AutoWalkDistanceZ)
                                break
                            end
                        end
                    end

                    if not targetPosition then
                        for _, p in pairs(game:GetService("Workspace").Alive:GetChildren()) do
                            if p ~= character then
                                targetPosition = p.HumanoidRootPart.Position + Vector3.new(AutoWalkDistanceX, 0, AutoWalkDistanceZ)
                                break
                            end
                        end
                    end

                    if targetPosition then
                        character.Humanoid:MoveTo(targetPosition)
                    end
                end
            end)
        end

        if AutoDoubleJump then
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if humanoid:GetState() == Enum.HumanoidStateType.Freefall or humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                    wait(0.1)
                else
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    wait(0.3)
                end
            end
        end
    end
end)

spawn(function()
    while task.wait() do
        if ClosestPlayer_var then
            pcall(function()
                if game.Players.LocalPlayer.Character.Parent.Name == "Dead" then return end
                local closestPlayer = GetClosestPlayer()
                if closestPlayer then
                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closestPlayer.Head.Position)
                end
            end)
        end
    end
end)

spawn(function()
    while task.wait(math.random(1, 2)) do
        if RandomTeleports then
            pcall(function()
                if game.Players.LocalPlayer.Character.Parent.Name == "Dead" then return end
                for _, v in pairs(game:GetService("Workspace").Balls:GetChildren()) do
                    if v:IsA("Part") then
                        local part, speed = getSpeed(v)
                        if part and speed then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(TeleportDistanceX, 0, TeleportDistanceZ)
                        end
                    end
                end
            end)
        end
    end
end)

local Title1 = "AstroX"
local Key2 = "https://discord.gg/yZTduXkhMn"

local MarketplaceService = game:GetService("MarketplaceService")
local success, gameInfo = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)

local gameName = success and gameInfo.Name or "Unknown Game"

local Window = AstroXUI:Window(Title1, gameName)

local Tab = Window:Tab("Home")
local Tab2 = Window:Tab("Player")
local Tab3 = Window:Tab("Main")
local Tab4 = Window:Tab("Combat")
local Tab5 = Window:Tab("Shop")
local Tab7 = Window:Tab("Settings")

Tab:Label("Join our discord.")
Tab:Label("Creators G - MX2 and Alexisback.")
Tab:line()
Tab:Button("Copy link discord", function()
    setclipboard(Key2)
end)

getgenv().Walkspeed = 36
getgenv().FOV = 70
getgenv().loopW = false
getgenv().loopFOV = false

Tab2:Slider("Speed", 0, 1000, 36, function(value)
    getgenv().Walkspeed = value
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end)
end)

Tab2:Slider("Fov", 0, 1000, 70, function(value)
    getgenv().FOV = value
    pcall(function()
        game:GetService("Workspace").Camera.FieldOfView = value
    end)
end)

Tab2:line()

Tab2:Toggle("Loop Speed", false, function(state)
    getgenv().loopW = state
    if state then
        loopWConnection = game:GetService("RunService").Heartbeat:Connect(function()
            pcall(function()
                local player = game:GetService("Players").LocalPlayer
                if player and player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.WalkSpeed = getgenv().Walkspeed
                end
            end)
        end)
    else
        if loopWConnection then
            loopWConnection:Disconnect()
        end
    end
end)

Tab2:Toggle("Loop Fov", false, function(state)
    getgenv().loopFOV = state
    if state then
        loopFOVConnection = game:GetService("RunService").Heartbeat:Connect(function()
            pcall(function()
                game:GetService("Workspace").Camera.FieldOfView = getgenv().FOV
            end)
        end)
    else
        if loopFOVConnection then
            loopFOVConnection:Disconnect()
        end
    end
end)

Tab3:Toggle("Auto Walk", false, function(t)
    AutoWalk = t
end)

Tab3:Toggle("Player Safety", false, function(t)
    PlayerSaftey = t
end)

Tab3:line()

Tab3:Slider("Player Safety Distance", 0, 50, 10, function(t)
    PlayerSaftey_Distance = t
end)

Tab3:Slider("Auto Walk Distance X", -40, 40, 12, function(t)
    AutoWalkDistanceX = t
end)

Tab3:Slider("Auto Walk Distance Z", -40, 40, 14, function(t)
    AutoWalkDistanceZ = t
end)

Tab3:line()

Tab3:Toggle("Auto Jump", false, function(t)
    AutoDoubleJump = t
end)

Tab4:Toggle("Auto Parry AI", false, function(toggled)
    resolve_parry_Remote()
        
    getgenv().aura_Enabled = toggled
end)

Tab4:Toggle("Hit Effect AI", false, function(toggled)
    getgenv().hit_effect_Enabled = toggled
end)

Tab4:line()

Tab4:Toggle("Trial AI", false, function(toggled)
    getgenv().trail_Enabled = toggled
end)

Tab4:Toggle("Self Effect AI", false, function(toggled)
    getgenv().self_effect_Enabled = toggled
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

local hitremote
for _, v in pairs(game:GetDescendants()) do
    if v and v.Name:find("\n") and v:IsA("RemoteEvent") then
        hitremote = v
        break
    end
end

local spamFrequency = 0.001
local maxSpamRate = 100
local minSpamRate = 1000
local spamRate = maxSpamRate
local debounce = false
local SpamOn = false
local lastSpamTime = tick()
local heartbeatConnection

local cframes = {}
for i = 1, 50 do
    table.insert(cframes, CFrame.new(math.random(-1000, 1000), math.random(0, 200), math.random(-200, 200)))
end

local function getPlayerPositions()
    local playersPos = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:IsDescendantOf(game.Workspace:FindFirstChild("Alive")) then
            local pos = player.Character.PrimaryPart.Position + Vector3.new(10, 10, 10)
            playersPos[player.Name] = pos
        end
    end
    return playersPos
end

local function getClosestPlayer()
    local closestPlayer
    local minDist = math.huge
    local playerPositions = getPlayerPositions()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and playerPositions[player.Name] then
            local dist = LocalPlayer:DistanceFromCharacter(playerPositions[player.Name])
            if dist < minDist then
                minDist = dist
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end

local Spam = Instance.new("ScreenGui")
local BG = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Toggle = Instance.new("TextButton")
local StatusPF = Instance.new("TextLabel")
local Status = Instance.new("TextLabel")

local SpamOn = false

Spam.Name = "Spam"
Spam.Parent = CoreGui
Spam.Enabled = false

BG.Name = "BG"
BG.Parent = Spam
BG.BackgroundColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
BG.BorderColor3 = Color3.new(0.0588235, 0.0588235, 0.0588235)
BG.BorderSizePixel = 2
BG.Position = UDim2.new(0.5, -75, 0.5, -63)
BG.Size = UDim2.new(0, 120, 0, 90)
BG.Active = true
BG.Draggable = true

Title.Name = "Title"
Title.Parent = BG
Title.BackgroundColor3 = Color3.new(0.266667, 0.00392157, 0.627451)
Title.BorderColor3 = Color3.new(0.180392, 0, 0.431373)
Title.BorderSizePixel = 2
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.Highway
Title.Text = "Spam"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.FontSize = Enum.FontSize.Size24
Title.TextSize = 23
Title.TextStrokeColor3 = Color3.new(0.180392, 0, 0.431373)
Title.TextStrokeTransparency = 0

Toggle.Parent = BG
Toggle.BackgroundColor3 = Color3.new(0.266667, 0.00392157, 0.627451)
Toggle.BorderColor3 = Color3.new(0.180392, 0, 0.431373)
Toggle.BorderSizePixel = 2
Toggle.Position = UDim2.new(0.5, -58, 0.6, -20)
Toggle.Size = UDim2.new(0, 117, 0, 30)
Toggle.Font = Enum.Font.Highway
Toggle.FontSize = Enum.FontSize.Size18
Toggle.Text = "Toggle"
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.TextSize = 18
Toggle.TextStrokeColor3 = Color3.new(0.180392, 0, 0.431373)
Toggle.TextStrokeTransparency = 0

StatusPF.Name = "StatusPF"
StatusPF.Parent = BG
StatusPF.BackgroundColor3 = Color3.new(1, 1, 1)
StatusPF.BackgroundTransparency = 1
StatusPF.Position = UDim2.new(0.5, -40, 0.85, -15)
StatusPF.Size = UDim2.new(0, 60, 0, 33)
StatusPF.Font = Enum.Font.Highway
StatusPF.FontSize = Enum.FontSize.Size18
StatusPF.Text = "Status:"
StatusPF.TextColor3 = Color3.new(1, 1, 1)
StatusPF.TextSize = 18
StatusPF.TextStrokeColor3 = Color3.new(0.333333, 0.333333, 0.333333)
StatusPF.TextStrokeTransparency = 0
StatusPF.TextWrapped = true

Status.Name = "Status"
Status.Parent = BG
Status.BackgroundColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0.5, 0, 0.84, -13)
Status.Size = UDim2.new(0, 50, 0, 33)
Status.Font = Enum.Font.Highway
Status.FontSize = Enum.FontSize.Size18
Status.Text = "Off"
Status.TextColor3 = Color3.new(1, 0, 0)
Status.TextSize = 15
Status.TextWrapped = true

local CreditsGui = Instance.new("ScreenGui")
local CreditsBG = Instance.new("Frame")
local CreditsText = Instance.new("TextLabel")

CreditsGui.Name = "CreditsGui"
CreditsGui.Parent = CoreGui

CreditsBG.Name = "CreditsBG"
CreditsBG.Parent = CreditsGui
CreditsBG.BackgroundColor3 = Color3.new(0, 0, 0)
CreditsBG.BackgroundTransparency = 1
CreditsBG.Position = UDim2.new(1, -159, 1, -34)
CreditsBG.Size = UDim2.new(0, 150, 0, 30)

CreditsText.Name = "CreditsText"
CreditsText.Parent = CreditsBG
CreditsText.BackgroundColor3 = Color3.new(1, 1, 1)
CreditsText.BackgroundTransparency = 1
CreditsText.Size = UDim2.new(1, 0, 1, 0)
CreditsText.Font = Enum.Font.SourceSans
CreditsText.FontSize = Enum.FontSize.Size18
CreditsText.Text = "Created by G - MX2 and Alexisback."
CreditsText.TextColor3 = Color3.new(1, 1, 1)
CreditsText.TextSize = 14
CreditsText.TextStrokeColor3 = Color3.new(0.196078, 0.196078, 0.196078)
CreditsText.TextStrokeTransparency = 0
CreditsText.TextWrapped = true

local function UpdateToggleVisual()
    Toggle.Text = SpamOn and "On" or "Off"
    local color = SpamOn and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)

    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tweenGoal = { TextStrokeColor3 = color, TextColor3 = color }

    local toggleTween = TweenService:Create(Toggle, tweenInfo, tweenGoal)
    toggleTween:Play()

    Status.Text = SpamOn and "On" or "Off"
    Status.TextColor3 = color
end

local function fireHitRemote()
    if debounce then return end
    debounce = true
    delay(0.05, function() debounce = false end)

    local args = {
        [1] = 0.5,
        [2] = cframes[math.random(1, #cframes)],
        [3] = getClosestPlayer() and {[tostring(getClosestPlayer().Name)] = getClosestPlayer().Character.PrimaryPart.Position} or getPlayerPositions(),
        [4] = {
            [1] = math.random(300, 700),
            [2] = math.random(300, 700),
            [3] = math.random(300, 700),
        }
    }
    if hitremote then
        hitremote:FireServer(unpack(args))
    end
end

local function spamRoutine()
    while SpamOn do
        if tick() - lastSpamTime >= spamFrequency then
            fireHitRemote()
            lastSpamTime = tick()
        end
        task.wait(spamFrequency)
    end
end

Toggle.MouseButton1Click:Connect(function()
    SpamOn = not SpamOn
    UpdateToggleVisual()
    if SpamOn then
        heartbeatConnection = RunService.Heartbeat:Connect(spamRoutine)
    else
        if heartbeatConnection then
            heartbeatConnection:Disconnect()
        end
    end
end)


Tab4:Toggle("Manual Spam", false, function(Value)
    Spam.Enabled = Value
end)

getgenv().ViewParryArea = false
getgenv().ParryRange = 10
local maxRange = 25

local Stats = game:GetService('Stats')
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local local_player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local Nurysium_Util = loadstring(game:HttpGet('https://raw.githubusercontent.com/SoyAdriYT/AstroX/main/Scripts/FuntionsBall.lua'))()
local closest_Entity = nil
local connection

local function get_closest_entity_in_camera_direction()
    local closest
    local max_distance = math.huge
    local camera_direction = camera.CFrame.LookVector

    for _, entity in workspace.Alive:GetChildren() do
        if entity.Name ~= Players.LocalPlayer.Name then
            local direction_to_entity = (entity.HumanoidRootPart.Position - camera.CFrame.Position).Unit
            local angle = math.acos(camera_direction:Dot(direction_to_entity))

            if angle < math.rad(30) then
                local distance = (camera.CFrame.Position - entity.HumanoidRootPart.Position).Magnitude
                if distance < max_distance then
                    closest_Entity = entity
                    max_distance = distance
                end
            end
        end
    end
end

local function ViewParryArea()
    local BallParry = Instance.new("Part", workspace)
    BallParry.Name = "Parry Range <Alexis.isback00 or AstroX>"
    BallParry.Material = Enum.Material.ForceField
    BallParry.CastShadow = false
    BallParry.CanCollide = false
    BallParry.Anchored = true
    BallParry.BrickColor = BrickColor.new("Bright blue")
    BallParry.Shape = Enum.PartType.Ball

    local PartFind = workspace:FindFirstChild(BallParry.Name)
    if PartFind and PartFind ~= BallParry then
        PartFind:Destroy()
    end

    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer

    local isExpanding = false
    local Range = getgenv().ParryRange
    local initialRange = getgenv().ParryRange

    connection = RunService.Heartbeat:Connect(function()
        if not getgenv().ViewParryArea then
            connection:Disconnect()
            BallParry:Destroy()
            return
        end

        local plrChar = Player.Character
        local plrPP = plrChar and plrChar:FindFirstChild("HumanoidRootPart")

        BallParry.BrickColor = BrickColor.new("Bright blue")

        if plrPP then
            BallParry.Position = plrPP.Position
        else
            BallParry.Position = Vector3.new(1000, 1000, 1000)
        end

        local self = Nurysium_Util.getBall()
        if self then
            local ball_Velocity = self.AssemblyLinearVelocity

            if self:FindFirstChild('zoomies') then
                ball_Velocity = self.zoomies.VectorVelocity
            end

            local ball_Position = self.Position
            local ball_Direction = (ball_Position - plrPP.Position).Unit
            local ball_Speed = ball_Velocity.Magnitude
            local ball_Dot = ball_Direction:Dot(ball_Velocity.Unit)

            local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10
            local max_parry_Range = math.max(math.max(ping, 4) + ball_Speed / 1.5, maxRange)

            if ball_Dot < 0 then
                if not isExpanding then
                    Range = initialRange
                    isExpanding = true
                end
                Range = math.min(Range + ball_Speed / 5, max_parry_Range)
            else
                if isExpanding then
                    Range = getgenv().ParryRange
                    isExpanding = false
                end
            end

            BallParry.Size = Vector3.new(Range, Range, Range)
        end
    end)
end

Tab4:line()

Tab4:Toggle("Visualizer Ball AI", false, function(toggled)
    getgenv().ViewParryArea = toggled
    if toggled then
        ViewParryArea()
    elseif connection then
        connection:Disconnect()
        local existingPart = workspace:FindFirstChild("Parry Range <Alexis.isback00 or AstroX>")
        if existingPart then
            existingPart:Destroy()
        end
    end
end)

Tab4:Slider("Distance Parry AI", 0, 1000, 1, function(value)
end)

Tab4:Toggle("Follow Ball AI", false, function(state)
    getgenv().FB = state
end)

Tab4:Dropdown("Select Sound", {"DC-15X", "Neverlose", "Minecraft", "MinecraftHit2", "Teamfortress Bonk", "Teamfortress Bell"}, function(selected)
    if selected == "DC-15X" then
        setHitSound('rbxassetid://936447863')
    elseif selected == "Neverlose" then
        setHitSound('rbxassetid://8679627751')
    elseif selected == "Minecraft" then
        setHitSound('rbxassetid://8766809464')
    elseif selected == "MinecraftHit2" then
        setHitSound('rbxassetid://8458185621')
    elseif selected == "Teamfortress Bonk" then
        setHitSound('rbxassetid://8255306220')
    elseif selected == "Teamfortress Bell" then
        setHitSound('rbxassetid://2868331684')
    end
    getgenv().hit_sound_Enabled = true
end)

Tab4:line()

Tab4:Toggle("Auto Spam AI", false, function(state)
end)

Tab4:Toggle("Anti Curve AI", false, function(state)
end)

Tab4:Toggle("Auto Curve AI", false, function(toggled)
    getgenv().auto_curve_Enabled = toggled
end)

Tab4:line()

Tab4:Dropdown("Parry Modes AI", {"Basic AI", "Basic High AI", "Medium AI", "Medium High AI", "Pro AI", "Pro High AI", "Extreme AI", "Impossible AI"}, function(selected)
end)

Tab4:Dropdown("Auto Spam Modes AI", {"Not Fast AI", "Fast AI", "Ultra Fast AI", "Mega Super Fast AI"}, function(selected)
end)

Tab5:Toggle("Auto Buy Sword Box", false, function(state)
    getgenv().ASC = state
end)

Tab5:Toggle("Auto Buy Explosion Box", false, function(state)
    getgenv().AEC = state
end)

Tab5:line()

Tab5:Button("Buy Sword Box", function()
    game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalSwordCrate)
end)

Tab5:Button("Buy Explosion Box", function()
    game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalExplosionCrate)
end)

print("Blade Ball Anti Cheat Bypass Activated.")

Tab7:Label("Anti Cheat : Disabled")

Tab7:line()

Tab7:Button("Exit " .. Title1, function()
    local gui = game:GetService("CoreGui"):FindFirstChild("woof")
    if gui then
        gui:Destroy()
    end

    local player = game.Players.LocalPlayer
    player:Kick("You have successfully exited " .. Title1 .. ".")
end)

Tab7:Toggle("Night/Day", false, function(toggled)
    getgenv().night_mode_Enabled = toggled
end)

local currentFPSPosition = UDim2.new(0, 5, 1, -100)
local currentPingPosition = UDim2.new(0, 5, 1, -130)
local isGuiActive = false
local MainContainer

local function createGui()
    if game.Players.LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("MainContainer") then
        game.Players.LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("MainContainer"):Destroy()
    end

    MainContainer = Instance.new("ScreenGui")
    local FPS = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")
    local Ping = Instance.new("Frame")
    local TextLabel_2 = Instance.new("TextLabel")

    MainContainer.Name = "MainContainer"
    MainContainer.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    FPS.Name = "FPS"
    FPS.Parent = MainContainer
    FPS.AnchorPoint = Vector2.new(0, 1)
    FPS.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    FPS.BorderColor3 = Color3.fromRGB(255, 92, 225)
    FPS.Position = currentFPSPosition
    FPS.Size = UDim2.new(0, 75, 0, 20)
    FPS.Visible = true
    FPS.Active = true
    FPS.Draggable = true

    TextLabel.Parent = FPS
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.Position = UDim2.new(0, 10, 0, 0)
    TextLabel.Size = UDim2.new(1, -10, 1, 0)
    TextLabel.Font = Enum.Font.GothamSemibold
    TextLabel.Text = "FPS: 60"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 14.000
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left

    Ping.Name = "Ping"
    Ping.Parent = MainContainer
    Ping.AnchorPoint = Vector2.new(0, 1)
    Ping.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Ping.BorderColor3 = Color3.fromRGB(255, 92, 225)
    Ping.Position = currentPingPosition
    Ping.Size = UDim2.new(0, 75, 0, 20)
    Ping.Visible = true
    Ping.Active = true
    Ping.Draggable = true

    TextLabel_2.Parent = Ping
    TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel_2.BackgroundTransparency = 1.000
    TextLabel_2.Position = UDim2.new(0, 10, 0, 0)
    TextLabel_2.Size = UDim2.new(1, -10, 1, 0)
    TextLabel_2.Font = Enum.Font.GothamSemibold
    TextLabel_2.Text = "Ping: 100"
    TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel_2.TextSize = 14.000
    TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

    local function FormatFPS(fps)
        return "FPS: " .. math.floor(fps + 0.5)
    end

    local fpsSamples = {}
    local sampleDuration = 0.1
    local lastFPS = -1

    game:GetService("RunService").RenderStepped:Connect(function()
        table.insert(fpsSamples, tick())
        if #fpsSamples > 60 then
            table.remove(fpsSamples, 1)
        end
    end)

    local function updateFPS()
        while isGuiActive do
            wait(sampleDuration)
            local now = tick()
            local count = 0
            local totalTime = 0

            for i = 1, #fpsSamples - 1 do
                if fpsSamples[i + 1] then
                    totalTime = totalTime + (fpsSamples[i + 1] - fpsSamples[i])
                    count = count + 1
                end
            end

            local fps = count / totalTime
            if fps ~= lastFPS then
                TextLabel.Text = FormatFPS(fps)

                if fps < 30 then
                    TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                else
                    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                end

                lastFPS = fps
            end
        end
    end

    spawn(updateFPS)

    local lastPing = -1
    local function updatePing()
        while isGuiActive do
            wait(0.1)
            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            local roundedPing = math.floor(ping + 0.5)
            if roundedPing ~= lastPing then
                TextLabel_2.Text = "Ping: " .. roundedPing
                if roundedPing > 250 then
                    TextLabel_2.TextColor3 = Color3.fromRGB(255, 0, 0)
                else
                    TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
                lastPing = roundedPing
            end
        end
    end

    spawn(updatePing)

    FPS:GetPropertyChangedSignal("Position"):Connect(function()
        currentFPSPosition = FPS.Position
    end)

    Ping:GetPropertyChangedSignal("Position"):Connect(function()
        currentPingPosition = Ping.Position
    end)
end

Tab7:Toggle("View Fps and Ping", false, function(toggled)
    isGuiActive = toggled
    if toggled then
        createGui()
    else
        if MainContainer then
            MainContainer:Destroy()
        end
    end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    if isGuiActive then
        createGui()
    end
end)

Tab7:line()

Tab7:Dropdown("Anti Lag", {"Disable", "Anti Lag Basic", "Anti Lag Pro", "Anti Lag Extreme"}, function(Value)
    local lighting = game:GetService("Lighting")
    local workspace = game:GetService("Workspace")

    if Value == "Disable" then
        lighting.GlobalShadows = true
        lighting.Brightness = 2
        workspace.LevelOfDetail = Enum.LevelOfDetailSetting.Automatic
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 0
            elseif v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
                v.Enabled = true
            end
        end
    elseif Value == "Anti Lag Basic" then
        lighting.GlobalShadows = false
        lighting.Brightness = 1
        workspace.LevelOfDetail = Enum.LevelOfDetailSetting.Low
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 0.5
            elseif v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
                v.Enabled = false
            end
        end
    elseif Value == "Anti Lag Pro" then
        lighting.GlobalShadows = false
        lighting.Brightness = 0.5
        workspace.LevelOfDetail = Enum.LevelOfDetailSetting.Low
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 0.7
            elseif v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
                v.Enabled = false
            end
        end
        lighting.FogEnd = 9e9
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    elseif Value == "Anti Lag Extreme" then
        lighting.GlobalShadows = false
        lighting.Brightness = 0
        workspace.LevelOfDetail = Enum.LevelOfDetailSetting.Low
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
                v.Enabled = false
            end
        end
        lighting.FogEnd = 9e9
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end
end)

Tab7:Dropdown("Anti Crash", {"Disable", "Anti Crash Basic", "Anti Crash Pro", "Anti Crash Extreme"}, function(Value)
    local lighting = game:GetService("Lighting")

    if Value == "Disable" then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        lighting.GlobalShadows = true
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
                v.Enabled = true
            elseif v:IsA("Explosion") then
                v.BlastPressure = 1
                v.BlastRadius = 1
            end
        end
    elseif Value == "Anti Crash Basic" then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level04
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
                v.Enabled = false
            elseif v:IsA("Explosion") then
                v.BlastPressure = 0.5
                v.BlastRadius = 0.5
            end
        end
    elseif Value == "Anti Crash Pro" then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level02
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
                v.Enabled = false
            elseif v:IsA("Explosion") then
                v.BlastPressure = 0.25
                v.BlastRadius = 0.25
            end
        end
    elseif Value == "Anti Crash Extreme" then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        lighting.GlobalShadows = false
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
                v.Enabled = false
            elseif v:IsA("Explosion") then
                v.BlastPressure = 0
                v.BlastRadius = 0
            end
        end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.120833337, 0, 0.0952890813, 0)
ImageButton.Size = UDim2.new(0, 50, 0, 50)
ImageButton.Draggable = true
ImageButton.Image = ""
ImageButton.ZIndex = 999

UICorner.Parent = ImageButton
UICorner.CornerRadius = UDim.new(0, 10)

ImageButton.MouseButton1Down:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, "RightControl", false, game)
end)
