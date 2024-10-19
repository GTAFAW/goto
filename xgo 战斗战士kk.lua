
local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/GTAFAW/neilonmacedo153/refs/heads/main/xgoui.txt"))();    
local win = ui:new("goto战斗战士")

local UITab1 = win:Tab("『信息』",'6035145364')

local about = UITab1:section("『信息』",true)


about:Label("作者：goto_O")
about:Label("goto战斗战士")
about:Label("你的注入器:"..identifyexecutor())
about:Label("你的用户名:"..game.Players.LocalPlayer.Character.Name)

local UITab2 = win:Tab("『主要』",'16060333448')

local about = UITab2:section("『xxxxxxxgo』",true)   
 about:Toggle("自动寻找玩家","Toggle",false,function()
        _G.followclosest = true
	follow_unchecked.Visible = false
	follow_checked.Visible = true
    end
)
about:Toggle("自动跳","Toggle",false,function()
        _G.autojump = true
	jump_unchecked.Visible = false
	jump_checked.Visible = true
    end
)
about:Toggle("自动复活","Toggle",false,function()
    _G.autospawn = true
	spawn_unchecked.Visible = false
	spawn_checked.Visible = true
    end
)

about:Toggle("杀死光环","Toggle",false,function()
     _G.killsay = true
	killsay_unchecked.Visible = false
	killsay_checked.Visible = true
end)
about:Toggle("自动击中","Toggle",false,function()
        _G.autohit = true
	autohit_unchecked.Visible = false
	autohit_checked.Visible = true
    end
)
about:Toggle("无限招架","Toggle",false,function(val)
        for i,v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "PARRY_COOLDOWN_IN_SECONDS") and rawget(v, "PARRY_COOLDOWN_IN_SECONDS_AFTER_SUCCESSFUL_PARRY") then
                if val then
                    v.PARRY_COOLDOWN_IN_SECONDS = 0
                    v.PARRY_COOLDOWN_IN_SECONDS_AFTER_SUCCESSFUL_PARRY = 0
                else
                    v.PARRY_COOLDOWN_IN_SECONDS = 3
                    v.PARRY_COOLDOWN_IN_SECONDS_AFTER_SUCCESSFUL_PARRY = 0.33
                end
            end
        end
    end
)

about:Toggle("无限耐力","Toggle",false,function(val)
        for i,v in pairs(getgc(true)) do
            if typeof(v) == "table" and rawget(v, "_setStamina") then
                local old = v._setStamina
                v._setStamina = function(among, us)
                    if val then
                        among._stamina = math.huge
                        among._staminaChangedSignal:Fire(150)
                    else
                        return old(among, us)
                    end
                end
            end
         end
    end
)

about:Toggle("启用","Toggle",false,function()
    _G.enabled = true
	killaura_unchecked.Visible = false
	killaura_checked.Visible = true
end)

about:Toggle("反招架","Toggle",false,function()
        _G.antiparry = true
	antiparry_unchecked.Visible = false
	antiparry_checked.Visible = true
    end)
about:Toggle("没有破折号冷却","Toggle",false,function(val)
        for i,v2 in pairs(getgc(true)) do
            if typeof(v2) == "table" and rawget(v2, "DASH_COOLDOWN") then
                if val then
                    v2.DASH_COOLDOWN = 0
                else
                    v2.DASH_COOLDOWN = 3

                end
            end
        end
    end
)
about:Toggle("斯托拉光环","Toggle",false,function()
        _G.stompaura = true
	stompaura_unchecked.Visible = false
	stompaura_checked.Visible = true
    end
)
about:Toggle("嘘它","Toggle",false,function()
    _G.boostws = true
	velocity_unchecked.Visible = false
	velocity_checked.Visible = true
    end
)
about:Toggle("没有布娃娃","Toggle",false,function(val)
        for i,v in pairs(getgc(true)) do
            if typeof(v) == "table" and rawget(v, "toggleRagdoll") then
                local old = v.toggleRagdoll
                v.toggleRagdoll = function(among, us, irl)
                    if val then
                        return
                    else
                        return old(among, us, irl)
                    end
                end
            end
        end
    end
)
local UITab2 = win:Tab("『玩家』",'16060333448')

local about = UITab2:section("『xxxxxxxgo』",true)
about:Button( "表情",function(v)
        for i,v in pairs(getgc(true)) do
            if typeof(v) == "table" and rawget(v, "gamepassIdRequired") then
                if v.gamepassIdRequired ==  "danceEmotes" then
                    v.gamepassIdRequired = nil
                elseif v.gamepassIdRequired == "toxicEmotes" then
                    v.gamepassIdRequired = nil
                elseif v.gamepassIdRequired == "respectEmotes" then
                    v.gamepassIdRequired = nil
                end
            end
        end
    end
)
about:Button( "自动园林",function(v)

	local lp = game.Players.LocalPlayer

local animationInfo = {}

function getInfo(id)
  local success, info = pcall(function()
      return game:GetService("MarketplaceService"):GetProductInfo(id)
  end)
  if success then
      return info
  end
  return {Name=''}
end
function block(player)
  keypress(0x46)
  wait()
  keyrelease(0x46)
end

local AnimNames = {
  'Slash',
  'Swing',
  'Sword'
}

function playerAdded(v)
    local function charadded(char)
      local humanoid = char:WaitForChild("Humanoid", 5)
      if humanoid then
          humanoid.AnimationPlayed:Connect(function(track)
              local info = animationInfo[track.Animation.AnimationId]
              if not info then
                  info = getInfo(tonumber(track.Animation.AnimationId:match("%d+")))
                  animationInfo[track.Animation.AnimationId] = info
              end
             
              if (lp.Character and lp.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Head")) then
                  local mag = (v.Character.Head.Position - lp.Character.Head.Position).Magnitude
                  if mag < 15  then
                     
                      for _, animName in pairs(AnimNames) do
                          if info.Name:match(animName) then
                              pcall(block, v)
                          end
                      end
                     
                  end
              end
          end)
      end
  end
 
  if v.Character then
      charadded(v.Character)
  end
  v.CharacterAdded:Connect(charadded)
end

for i,v in pairs(game.Players:GetPlayers()) do
   if v ~= lp then
       playerAdded(v)
   end
end

game.Players.PlayerAdded:Connect(playerAdded)
end)
about:Slider("步行速度", "WalkSpeed", game.Players.LocalPlayer.Character.Humanoid.WalkSpeed, 16, 400, false, function(Speed)
  spawn(function() while task.wait() do game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Speed end end)
end)

about:Slider("跳跃高度", "JumpPower", game.Players.LocalPlayer.Character.Humanoid.JumpPower, 50, 400, false, function(Jump)
  spawn(function() while task.wait() do game.Players.LocalPlayer.Character.Humanoid.JumpPower = Jump end end)
end)

about:Toggle("飞行? 飞你大爷","Toggle",false,function(val)
        flying = not flying
        if val then
            sFLY(true)
        else
            NOFLY()
        end
    end
)

about:Button( "飞钥匙",function(val)
        flying = not flying

        if flying then
            sFLY(true)
        else
            NOFLY()
        end
    end
)
about:Toggle("耶稣","Toggle",false,function(val)
        for i,v2 in pairs(game.Workspace.Map:GetDescendants()) do
            if v2.Name == "WaterArea" then
                if val then
                    v2.CanCollide = true
                else
                    v2.CanCollide = false
                end
            end
        end
    end
)
local UITab2 = win:Tab("『战斗』",'16060333448')

local about = UITab2:section("『xxxxxxxgo』",true)
about:Toggle("自动装备","Toggle",false,function()
        _G.autoequip = true
	equip_unchecked.Visible = false
	equip_checked.Visible = true
end
)

-- reach here
about:Toggle("到达（破碎）不知道哪一个可能会导致卡屏","Toggle",false,function(val)
        Reaching = val
        if val == false then return end
        local character = game.Players.LocalPlayer.Character
        local torso = character.Torso
        local rightarm = character["Right Arm"]
        local rightshoulder = torso["Right Shoulder"]
        if rightshoulder and rightshoulder.Enabled == true then
            local rightshoulderclone = rightshoulder:Clone()
            rightshoulderclone.Enabled = false
            rightshoulder:Destroy()
            rightshoulderclone.Parent = torso
        end
    
        for i,v in pairs(game.Players.LocalPlayer.Backpack:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Massless = true
            end
        end
        if rightarm:FindFirstChild("RagdollBallSocket") then
            rightarm.RagdollBallSocket.Enabled = false
        end
        while Reaching do
            sethiddenproperty(rightarm,"AssemblyLinearVelocity",Vector3.new(100,100,100))
            rightarm.Velocity = Vector3.new(100,100,100)
            if torso:FindFirstChild("Right Shoulder") then
                local rightarm = character["Right Arm"]
                local rightshoulder = torso["Right Shoulder"]
    
                local rightshoulderclone = rightshoulder:Clone()
                rightshoulderclone.Enabled = false
                rightshoulder:Destroy()
                rightshoulderclone.Parent = torso
            end
    
            local target = getClosest()

            -- if reachchoice == "closest to player" then
            --     target = getClosest()
            -- elseif reachchoice == "closest to mouse" then
            --     target = getClosestToMouse()
            --     bruh.Adornee = target.Character
            -- else
            --     target = getClosest()
            -- end
            if target.Character:FindFirstChild("Head") and (character.Head.Position - target.Character.Head.Position).magnitude < 100 then
                rightarm.CFrame = target.Character.Head.CFrame * CFrame.new(math.random(-0,0),0,0)
            elseif character:FindFirstChild("Head") then
                rightarm.CFrame = character.Head.CFrame * CFrame.new(math.random(-0,0),0,0)
            end
            game:GetService("RunService").Heartbeat:wait()
        end
    end
)

about:Toggle("墙爆","Toggle",false,function(val)
        if val then
            game.CollectionService:AddTag(game:GetService("Workspace").Map,'RANGED_CASTER_IGNORE_LIST')
        else
            game.CollectionService:RemoveTag(game:GetService("Workspace").Map,'RANGED_CASTER_IGNORE_LIST')
        end
    end
)

about:Toggle("没有反冲","Toggle",false,function(val)
        for i,v2 in pairs(getgc(true)) do
            if typeof(v2) == "table" and rawget(v2, "recoilAmount") then
                if val then
                    v2.recoilAmount = 0
                    v2.recoilXMin = 0
                    v2.recoilXMax = 0
                    v2.recoilYMin = 0
                    v2.recoilYMax = 0
                    v2.recoilZMin = 0
                    v2.recoilZMax = 0
                else
                    v2.recoilAmount = 35
                    v2.recoilXMin = 1.25
                    v2.recoilXMax = 1.75
                    v2.recoilYMin = -1.5
                    v2.recoilYMax = 1.5
                    v2.recoilZMin = -1.5
                    v2.recoilZMax = 1.5
                end
            end
        end
    end
)
about:Toggle("垃圾跳跃","Toggle",false,function(val)
        for i,v in pairs(getgc(true)) do
            if typeof(v) == "table" and rawget(v, "getCanJump") then
                local old = v.getCanJump
                if val then
                    v.getCanJump = function()
                        return true
                    end
                else
                    return old()
                end
            end
        end
    end
)
about:Toggle("没有重力","Toggle",false,function(val)
        for i,v2 in pairs(getgc(true)) do
            if typeof(v2) == "table" and rawget(v2, "recoilAmount") then
                if val then
                    v2.gravity = Vector3.new(0,0,0)
                else
                    v2.gravity = Vector3.new(0, -10, 0)
                end
            end
        end
    end
)
about:Toggle("自动拍摄（破碎）","Toggle",false,function(val)
        for i,v in pairs(getgc(true)) do
            if typeof(v) == 'table' and rawget(v,'startShootingAfterCharge') then
                if val then
                    v.startShootingAfterCharge = true
                else
                    v.startShootingAfterCharge = false
                end
            end
        end
    end
)
local UITab2 = win:Tab("『其他』",'16060333448')

local about = UITab2:section("『xxxxxxxgo』",true)
about:Toggle("Fling","Toggle",false,function()
        local plr = game.Players.LocalPlayer
        local oldHumanoid = plr.Character.Humanoid
        local torso = game.Players.LocalPlayer.Character.HumanoidRootPart
        local flying = true
        local deb = true
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = 50
        local speed = 50
        
        workspace.CurrentCamera.CameraSubject = torso
         
        local function Fly()
             local bambam = Instance.new("BodyThrust")
             bambam.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
             bambam.Force = Vector3.new(99999,0,99999)
             bambam.Location = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
             Instance.new("SelectionBox",game.Players.LocalPlayer.Character.HumanoidRootPart).Adornee = game.Players.LocalPlayer.Character.HumanoidRootPart
             local bg = Instance.new("BodyGyro", torso)
             bg.P = 9e4
             bg.maxTorque = Vector3.new(0, 0, 0)
             bg.cframe = torso.CFrame
             local bv = Instance.new("BodyVelocity", torso)
             bv.velocity = Vector3.new(0,0,0)
             bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
             repeat wait()
                 if oldHumanoid:FindFirstChildOfClass'RemoteEvent' ~= nil then
                     oldHumanoid.RagdollRemoteEvent:FireServer(true)
                 end
                 getRemote("UpdateIsCrouching"):FireServer(true)
         
                 if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                     speed = speed+.2
                     if speed > maxspeed then
                         speed = maxspeed
                     end
                 elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                     speed = speed-1
                     if speed < 0 then
                         speed = 0
                     end
                 end
                 if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                     bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                     lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                 elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                     bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                 else
                     bv.velocity = Vector3.new(0,0.1,0)
                 end
         
             until not flying
             ctrl = {f = 0, b = 0, l = 0, r = 0}
             lastctrl = {f = 0, b = 0, l = 0, r = 0}
             speed = 0
             bg:Destroy()
             bv:Destroy()
         
         end
         mouse.KeyDown:connect(function(key)
             if key:lower() == "w" then
                 ctrl.f = 1
             elseif key:lower() == "s" then
                 ctrl.b = -1
             elseif key:lower() == "a" then
                 ctrl.l = -1
             elseif key:lower() == "d" then
                 ctrl.r = 1
             end
         end)
         mouse.KeyUp:connect(function(key)
             if key:lower() == "w" then
                 ctrl.f = 0
             elseif key:lower() == "s" then
                 ctrl.b = 0
             elseif key:lower() == "a" then
                 ctrl.l = 0
             elseif key:lower() == "d" then
                 ctrl.r = 0
             elseif key:lower() == "r" then
         
             end
         end)
         for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
             v:Destroy()
         end -- doesnt need tools anyways
         -- hides all of ur body parts expect torso (there is a chance it doesnt work)
         wait(.1)
         oldHumanoid.RagdollRemoteEvent:FireServer(true)
         wait(.5)
         coroutine.wrap(Fly)()
         wait(.5)
         game.Players.LocalPlayer.Character.HumanoidRootPart.RootJoint.Part0 = nil
    end
)
about:Toggle("启用","Toggle",false,function(val)
        game:GetService("ReplicatedStorage").Shared.Assets.Sounds.KillSound.SoundId = "rbxassetid://"..val
    end

)
about:Toggle("击中声音","Toggle",false,function(val)
        game:GetService("ReplicatedStorage").Shared.Assets.Sounds.HitmarkerSound.SoundId = "rbxassetid://"..val
     end

)

local UITab2 = win:Tab("『ESP』",'16060333448')

local about = UITab2:section("『xxxxxxxgo』",true)
about:Toggle("画线","Toggle",false,function()
        _G.drawlines = true
	drawline_unchecked.Visible = false
	drawline_checked.Visible = true
  end
  )
about:Button("人物射线",function()   
loadstring(game:HttpGet("https://raw.githubusercontent.com/xgomn/eeeeeeeeeeeppppppppppppssassssssssss/refs/heads/main/%E9%80%8F%E8%A7%86%E3%80%82%E6%A1%86%E6%9E%B6"))()ExunysDeveloperESP()     end)

about:Toggle("透视玩家",function()    local Outlines = true         local OutlineColoring = Color3.fromRGB(255, 255, 255)         local OutlineFill = false         local FillOpacity = 1         local FillColoring = Color3.fromRGB(255, 255, 255)        local NameTags = true       local TextFont = Enum.Font.RobotoMono       local NameColor = Color3.fromRGB(255, 255, 255)       local NamePositioning = false              local Folder = Instance.new("Folder", game:GetService("CoreGui"))      Folder.Name = ""            AddOutline = function(Character)   local Highlight = Instance.new("Highlight", Folder)      Highlight.OutlineColor = OutlineColoring   Highlight.Adornee = Character   if OutlineFill == true then       Highlight.FillColor = FillColoring      Highlight.FillTransparency = FillOpacity   else       Highlight.FillTransparency = 1   end         end           AddNameTag = function(Character)   local BGui = Instance.new("BillboardGui", Folder)   local Frame = Instance.new("Frame", BGui)   local TextLabel = Instance.new("TextLabel", Frame)      BGui.Adornee = Character:WaitForChild("Head")   BGui.StudsOffset = Vector3.new(0, 3, 0)   BGui.AlwaysOnTop = true      BGui.Size = UDim2.new(4, 0, 0.5, 0)   Frame.Size = UDim2.new(1, 0, 1, 0)   TextLabel.Size = UDim2.new(1, 0, 1, 0)      Frame.BackgroundTransparency = 1   TextLabel.BackgroundTransparency = 1      TextLabel.Text = Character.Name   TextLabel.Font = TextFont   TextLabel.TextColor3 = NameColor   TextLabel.TextScaled = NamePositioning     end             for i, v in ipairs(game:GetService("Players"):GetPlayers()) do   if v ~= game:GetService("Players").LocalPlayer then       v.CharacterAdded:Connect(function(Character)           if Outlines == true then               AddOutline(Character)           end          if NameTags == true then              AddNameTag(Character)          end       end)              if v.Character then           if Outlines == true then               AddOutline(v.Character)           end           if NameTags == true then               AddNameTag(v.Character)           end       end   end     end          game:GetService("Players").PlayerAdded:Connect(function(Player)   Player.CharacterAdded:Connect(function(Character)       if Outlines == true then           AddOutline(Character)       end       if NameTags == true then           AddNameTag(Character)      end   end) end)	end    )
about:Toggle("透视玩家名字","Toggle",false,function()
        _G.esp = true
	esp_unchecked.Visible = false
	esp_checked.Visible = true
end
)
-- 不要分享这个。 执行将被记录，并且您的钥匙将获得黑名单！
_G.key = "key not needed" -- 把你的钥匙放在引号内.“我的-关键这里”
-- Killaura方法，方法2可能不那么滞后，但也没有那么有效！
_G.usemethod2 = false

-- 正确转移到肘节！
_G.enabled = false
_G.antiparry = false
_G.stompaura = false
_G.drawlines = false
_G.range = 15
_G.autohit = false
_G.autospawn = false
_G.followclosest = false
_G.autoequip = false
_G.autojump = false
_G.boostws = false
_G.killsay = false
_G.usehitbox = 10
_G.esp = false
_G.usecustomaudio = true
_G.tpOverHead = false -- 这仅适用于杀死法方法2 !!! 
 --如果脚本落后于您，请尝试将其放到3或更高版本。 较低的值=更常见的杀戮地区击中但更多的滞后。
_G.loopspeed = 2

function addLine(myHrp, theirHrp)
	if not theirHrp.Parent.Torso:FindFirstChild("Beam") then
		if _G.drawlines == true then
			local beam = Instance.new("Beam", theirHrp.Parent.Torso)
			local att0 = Instance.new("Attachment", theirHrp.Parent.Torso)
			local att1 = Instance.new("Attachment", myHrp)

			beam.Attachment0 = att0
			beam.Attachment1 = att1

			beam.Width0 = 0.2
			beam.Width1 = 0.2

			beam.LightEmission = 1
			beam.LightInfluence = 0

			beam.FaceCamera = true

			if theirHrp.Parent.Humanoid.Health <= 15 then
				beam.Color = ColorSequence.new(Color3.fromRGB(255,0,0),Color3.fromRGB(255,0,0))
			else if theirHrp.Parent.Humanoid.Health >= 16 and theirHrp.Parent.Humanoid.Health <= 50 then
					beam.Color = ColorSequence.new(Color3.fromRGB(255, 170, 0),Color3.fromRGB(255, 170, 0))
				else
					beam.Color = ColorSequence.new(Color3.fromRGB(59, 255, 0),Color3.fromRGB(59, 255, 0))
				end
			end
		end
	end
end

-- shit ass esp cause im bad with drawing and math
function addEsp()
	for i,v in pairs(game.Workspace.PlayerCharacters:GetChildren()) do
		if v.Name ~= game.Players.LocalPlayer.Name then
			if not v.HumanoidRootPart:FindFirstChild("eyeesspee") then
				local billboard = Instance.new("BillboardGui", v:WaitForChild("Head"))
				billboard.LightInfluence = 0
				billboard.Size = UDim2.new(40, 40, 1, 1)
				billboard.StudsOffset = Vector3.new(0, 3, 0)
				billboard.ZIndexBehavior = "Global"
				billboard.ClipsDescendants = false
				billboard.AlwaysOnTop = true
				billboard.Name = "Head"

				local billboard2 = Instance.new("BillboardGui", v:WaitForChild("HumanoidRootPart"))
				billboard2.LightInfluence = 0
				billboard2.Size = UDim2.new(3, 3, 5, 5)
				billboard2.StudsOffset = Vector3.new(0, 0, 0)
				billboard2.ZIndexBehavior = "Global"
				billboard2.ClipsDescendants = false
				billboard2.AlwaysOnTop = true
				billboard2.Name = "eyeesspee"

				local textBox = Instance.new("TextBox", billboard)
				textBox.BackgroundTransparency = 1
				textBox.ClearTextOnFocus = false
				textBox.MultiLine = true
				textBox.Size = UDim2.new(1, 1, 1, 1)
				textBox.Font = "GothamBold"
				textBox.Text = v.Name
				textBox.TextScaled = true
				textBox.TextYAlignment = "Top"
				textBox.TextColor3 = Color3.fromRGB(255, 55, 55)

				local textBox2 = Instance.new("TextBox", billboard2)
				textBox2.BackgroundTransparency = 1
				textBox2.ClearTextOnFocus = false
				textBox2.MultiLine = true
				textBox2.Size = UDim2.new(1, 1, 1, 1)
				textBox2.Font = "GothamBold"
				textBox2.Text = " "
				textBox2.BackgroundTransparency = 0.85
				textBox2.TextScaled = true
				textBox2.TextYAlignment = "Top"
				textBox2.BackgroundColor3 = Color3.fromRGB(126, 0, 0)
			end
		end
	end
end

function removeEsp()
	for i,v in pairs(game.Workspace.PlayerCharacters:GetChildren()) do
		if v.Name ~= game.Players.LocalPlayer.Name then
			if v.HumanoidRootPart:FindFirstChild("eyeesspee") then
				v.HumanoidRootPart:FindFirstChild("eyeesspee"):Destroy()
				v.Head.Head:Destroy()
			end
		end
	end
end

function randomPlayer()
	math.randomseed(os.time())
	local RandomPlayer = game.Players:GetPlayers()[math.random(1,#game.Players:GetPlayers())]
	return RandomPlayer.DisplayName
end

local tableOfShit = {"why am i writing these messages when i can continue making the script better?! 🤣🤣😂🤣😂🤣🤣","do you ever have problems with light users parrying your ds??? get warriorhook! it has a great anti parry that works! (sometimes..)","get warriorhook!!!","oh im sorry, did i killaura you? i can whitelist you if you want boo 🥺🥺🥺🥺","🤣🤣😂🤣🤣","hey ".. randomPlayer() ..", is your dad spiderman? cause he far from home.","EZ EZ EZ EZ EZ","are you even trying?? lulululul","damn bro you got the whole squad cringing","omg ".. randomPlayer() .. " im your biggest fan!!!","how are you that bad??🤣🤣😂🤣🤣","dont even bother insulting me 🤣🤣😂 im not even touching my keyboard!!","oh god... not ".. randomPlayer() .." again...","OMG!! IS THAT THE FAMOUS ".. randomPlayer() .. "???","vex really thinks this is gonna work...", "haha got you!!!", "who the hell is vex? oh the creator of this crap script?", "get reck't noobie", "warriorhook on top!!! (not really)", "project hook has some pretty cool features","Y1K is daddy 😋😋😋", "samuel you bozo your script is patched!!!","pls pls give vouch copy!!!", "😭 oh no! 😭😭 did i 😭😭 kill your mans?? 😭😭😭😭", "you: 😭😭 noooo i got murdered by a lvl ".. game.Players.LocalPlayer.leaderstats.Level.Value.."!!!", "oh my god im so sorry for killing you 😭😭😭😭😭😭😭", "oh 😭😭 did i hurt your 😭😭 feelings???", "get good with project hoo- i mean with warriorhook!!!", "samuel no one cares about criminality!!!😭😭", "who even wrote this crappy code??😭", "this script was brought to you by raid shadow legends!!", "do you like cheese?", "😭😭 imagine 😭😭 dying 😭😭", "get killaura'd!!!", "oh no 😭😭 did i kill your 😭😭 girl?? 😭😭😭"}

local function RandomString(t)
	return t[math.random(1, #t)]
end

game.Players.LocalPlayer.leaderstats.Score.Changed:connect(function()
	if _G.killsay == true then
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(RandomString(tableOfShit),"All")
	end
end)

function remLine(theirHrp)
	if theirHrp.Parent.Torso:FindFirstChild("Beam") then
		theirHrp.Parent.Torso:FindFirstChild("Beam"):Destroy()
	end
end

function walkToClosest()
	local closestCurrent = nil
	local currentMagnitude = 999999

	local myHrp = game.Workspace.PlayerCharacters[game.Players.LocalPlayer.Name]:FindFirstChild("HumanoidRootPart")

	for i, v in pairs(game:GetService("Workspace").PlayerCharacters:GetChildren()) do
		if v.Name ~= game.Players.LocalPlayer.Name then
			if v.Humanoid.Health ~= 0 then
				local theirHrp = v:FindFirstChild("HumanoidRootPart")
				if (myHrp.Position - theirHrp.Position).Magnitude < currentMagnitude then
					if theirHrp.Parent.Humanoid.Health ~= 0 then
						currentMagnitude = (myHrp.Position - theirHrp.Position).Magnitude
						closestCurrent = theirHrp
					end
				end
			end
		end
	end

	if _G.autojump == true then
		keypress(0x20)
	end
	game.Workspace.PlayerCharacters[game.Players.LocalPlayer.Name]:FindFirstChild("Humanoid").WalkToPoint = closestCurrent.Position
end

function getClosestHrp()
	local closestCurrent = nil
	local currentMagnitude = 999999

	local myHrp = game.Workspace.PlayerCharacters[game.Players.LocalPlayer.Name]:FindFirstChild("HumanoidRootPart")

	for i, v in pairs(game:GetService("Workspace").PlayerCharacters:GetChildren()) do
		if v.Name ~= game.Players.LocalPlayer.Name then
			if v.Humanoid.Health ~= 0 then
				local theirHrp = v:FindFirstChild("HumanoidRootPart")
				if (myHrp.Position - theirHrp.Position).Magnitude < currentMagnitude then
					if (myHrp.Position - theirHrp.Position).Magnitude <= _G.range and theirHrp.Parent.Humanoid.Health ~= 0 then
						currentMagnitude = (myHrp.Position - theirHrp.Position).Magnitude
						closestCurrent = theirHrp
						addLine(myHrp, theirHrp)
					else
						remLine(theirHrp)
					end
				end
			end
		end
	end

	return closestCurrent
end

function setAttachmentWorldCFrame(attachment, cf)
	attachment.CFrame = attachment.Parent.CFrame:toObjectSpace(cf)
end

local hittable = 0
local walktocount = 0
local espCount = 0
local canLoop = 0
local boostingws = false
local canStomp = 0

game:GetService("RunService").RenderStepped:connect(function()
	if game.Players.LocalPlayer.PlayerGui.RoactUI:FindFirstChild("MainMenu") and _G.autospawn == true then
		keypress(0x20)
		keyrelease(0x20)
	end

	if _G.autoequip == true then
		if not game.Workspace.PlayerCharacters[game.Players.LocalPlayer.Name]:FindFirstChildOfClass("Tool") and not game.Players.LocalPlayer.PlayerGui.RoactUI:FindFirstChild("MainMenu") then
			keypress(0x31)
			keyrelease(0x31)
		end
	end

	if espCount == 60 then
		if _G.esp == true then
			addEsp()
		else
			removeEsp()
		end

		espCount = 0
	end

	espCount = espCount + 1
	canLoop = canLoop + 1
	canStomp = canStomp + 1

	if walktocount == 10 then
		if _G.followclosest == true then
			walkToClosest()
		end
		if _G.boostws == true then
			if boostingws == true then
				boostingws = false
				game.Workspace.PlayerCharacters[game.Players.LocalPlayer.Name]:FindFirstChild("HumanoidRootPart").Velocity = game.Workspace.PlayerCharacters[game.Players.LocalPlayer.Name]:FindFirstChild("HumanoidRootPart").CFrame.lookVector * (65) + Vector3.new(math.random(-40,40),0,math.random(-40,40))
			else
				boostingws = true
			end
		end
		walktocount = 0
	end

	walktocount = walktocount + 1

	if game.Workspace.PlayerCharacters[game.Players.LocalPlayer.Name]:FindFirstChildOfClass("Tool").Hitboxes:FindFirstChild("Hitbox2") then
		game.Workspace.PlayerCharacters[game.Players.LocalPlayer.Name]:FindFirstChildOfClass("Tool").Hitboxes:FindFirstChild("Hitbox2"):Destroy()
	end

	local enabled = game.Workspace.PlayerCharacters[game.Players.LocalPlayer.Name]:FindFirstChildOfClass("Tool"):FindFirstChild("ClientEquipProgress")

	local theirHrp = getClosestHrp()

	if _G.usemethod2 == false then
		if canLoop == _G.loopspeed or canLoop > _G.loopspeed then
			canLoop = 0
			for i,v in pairs(game.Workspace.PlayerCharacters[game.Players.LocalPlayer.Name]:FindFirstChildOfClass("Tool").Hitboxes.Hitbox:GetChildren()) do
				if i <= _G.usehitbox then
					if v.Name == "DmgPoint" then

						if _G.antiparry == true then
							if theirHrp.Parent.SemiTransparentShield.Transparency == 1 then
								enabled.Value = 1
								if _G.enabled == true then
									setAttachmentWorldCFrame(v, CFrame.new(theirHrp.Position + Vector3.new(math.random(-1,1),math.random(-1,1),math.random(-1,1))))
								end
							else
								setAttachmentWorldCFrame(v, CFrame.new(theirHrp.Position + Vector3.new(123,123,123)))
								enabled.Value = 0
							end
						else
							if _G.enabled == true then
								setAttachmentWorldCFrame(v, CFrame.new(theirHrp.Position + Vector3.new(math.random(-1,1),math.random(-1,1),math.random(-1,1))))
							end

						end
					end
				else
					setAttachmentWorldCFrame(v, CFrame.new(game.Workspace.PlayerCharacters[game.Players.LocalPlayer.Name]:FindFirstChild("Head").Position + Vector3.new(0, 10, 0)))
				end
			end
		end


		if _G.stompaura == true then
			for i,s in pairs(game.Workspace.PlayerCharacters[game.Players.LocalPlayer.Name].Stomp.Hitboxes.RightLegHitbox:GetChildren()) do
				if s.Name == "DmgPoint" then
					s.Visible = true
					if i <= _G.usehitbox then
						if theirHrp.Parent.Humanoid.Health <= 15 then
							setAttachmentWorldCFrame(s, CFrame.new(theirHrp.Position + Vector3.new(math.random(-1,1),math.random(-1,1),math.random(-1,1))))
							if canStomp >= 30 then
								keypress(0x51)
								keyrelease(0x51)
								canStomp = 0
							end
						end
					end
				end
			end
		end
	else


		local me = game:GetService("Workspace").PlayerCharacters:FindFirstChild(game:GetService("Players").LocalPlayer.Name)
		local hitbox = me:FindFirstChildOfClass("Tool").Hitboxes.Hitbox
		local hitboxes = me:FindFirstChildOfClass("Tool").Hitboxes
		local tool = me:FindFirstChildOfClass("Tool")
		local enabled = tool:FindFirstChild("ClientEquipProgress")

		if hitboxes:FindFirstChild("Hitbox2") then
			hitboxes:FindFirstChild("Hitbox2"):Destroy()
		end

		if _G.killaura == true then
			for i,v in pairs(game:GetService("Workspace").PlayerCharacters:GetChildren()) do
				if v.Name ~= game.Players.LocalPlayer.Name then
					if v:FindFirstChild("Right Arm") then
						for i,s in pairs(v:FindFirstChild("Torso"):GetChildren()) do
							if s.Name == "Right Shoulder" then
								s:Destroy()
							end
						end
						for i,s in pairs(v:FindFirstChild("Right Arm"):GetChildren()) do
							s:Destroy()
						end
						if (me.HumanoidRootPart.Position - v:FindFirstChild("Torso").Position).Magnitude <= 20 then
							if _G.tpOverHead == true then
								me.HumanoidRootPart.Anchored = true
								me.HumanoidRootPart.CFrame = CFrame.new(v:FindFirstChild("Head").Position + Vector3.new(0, 5, 0))
							end

							local vectorDec = math.random(9999)
							local vectorWhole = 0
							local vector = tostring(vectorWhole .. "." .. vectorDec)
							local vectorComplete = tonumber(vector)

							if v:FindFirstChild("SemiTransparentShield").Transparency == 1 then
								v:FindFirstChild("Right Arm").CFrame = hitbox.CFrame + Vector3.new(0, vectorComplete, 0)
								v:FindFirstChild("Right Arm").CanCollide = false
								enabled.Value = 1
							else
								enabled.Value = 0
							end
						else
							if _G.tpOverHead == true then
								me.HumanoidRootPart.Anchored = false
							end
						end
					end
				end
			end
		end

		if _G.stompaura == true then
			for i,s in pairs(game.Workspace.PlayerCharacters[game.Players.LocalPlayer.Name].Stomp.Hitboxes.RightLegHitbox:GetChildren()) do
				if s.Name == "DmgPoint" then
					s.Visible = true
					if i <= _G.usehitbox then
						if theirHrp.Parent.Humanoid.Health <= 15 then
							setAttachmentWorldCFrame(s, CFrame.new(theirHrp.Position + Vector3.new(math.random(-1,1),math.random(-1,1),math.random(-1,1))))
							if canStomp >= 30 then
								keypress(0x51)
								keyrelease(0x51)
								canStomp = 0
							end
						end
					end
				end
			end
		end

	end
end)

if _G.usecustomaudio == true then
	game:GetService("ReplicatedStorage").Shared.Assets.Sounds.HitmarkerSound.SoundId = "rbxassetid://5148302439"
	game:GetService("ReplicatedStorage").Shared.Assets.Sounds.AirdropOpen.SoundId = "rbxassetid://904663967"
	game:GetService("ReplicatedStorage").Shared.Assets.Sounds.UIClickSound.SoundId = "rbxassetid://2483029612"
	game:GetService("ReplicatedStorage").Shared.Assets.Sounds.KillSound.SoundId = "rbxassetid://165013277"
end
Combat.Selectable = true
Combat.Active = true
Combat.Draggable = true

Farming.Selectable = true
Farming.Active = true
Farming.Draggable = true

Misc.Selectable = true
Misc.Active = true
Misc.Draggable = true

Visual.Selectable = true
Visual.Active = true
Visual.Draggable = true

local UserInputService = game:GetService("UserInputService")

local function IsShiftKeyDown()
	return UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
end

local function IsCtrlKeyDown()
	return UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
end

local function IsAltKeyDown()
	return UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)
end

local function IsJKeyDown()
	return UserInputService:IsKeyDown(Enum.KeyCode.J)
end

local function IsKKeyDown()
	return UserInputService:IsKeyDown(Enum.KeyCode.K)
end

local function IsDelKeyDown()
	return UserInputService:IsKeyDown(Enum.KeyCode.Delete)
end

local function IsPgdKeyDown()
	return UserInputService:IsKeyDown(Enum.KeyCode.PageDown)
end

local function Input(input, gameProcessedEvent)
	if IsShiftKeyDown() then
		if Combat.Visible == true then
			Combat.Visible = false
			Farming.Visible = false
			Misc.Visible = false
			Visual.Visible = false
		else
			Combat.Visible = true
			Farming.Visible = true
			Misc.Visible = true
			Visual.Visible = true
		end
	end
end

UserInputService.InputBegan:Connect(Input)