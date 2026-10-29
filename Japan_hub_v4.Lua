local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local service = setmetatable({}, {__index=function(self,k) local s=game:GetService(k) rawset(self,k,s) return s end})
local Players = service.Players
local RunService = service.RunService
local ReplicatedStorage = service.ReplicatedStorage
local Workspace = service.Workspace
local LocalPlayer = Players.LocalPlayer
local TweenService = service.TweenService
local CharacterEvents = ReplicatedStorage:WaitForChild("CharacterEvents")
local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local PlayerEvents = ReplicatedStorage:WaitForChild("PlayerEvents")
local MenuToys = ReplicatedStorage:WaitForChild("MenuToys")
local Struggle = CharacterEvents:WaitForChild("Struggle")
local RagdollRemote = CharacterEvents:WaitForChild("RagdollRemote")
local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")
local CreateGrabLine = GrabEvents:WaitForChild("CreateGrabLine")
local DestroyGrabLine = GrabEvents:WaitForChild("DestroyGrabLine")
local StickyPartEvent = PlayerEvents:WaitForChild("StickyPartEvent")
local SpawnToyRemoteFunction = MenuToys:WaitForChild("SpawnToyRemoteFunction")
local BuyToyRemoteFunction = MenuToys:WaitForChild("BuyToyRemoteFunction")
local DestroyToy = MenuToys:WaitForChild("DestroyToy")
local SpawnedInToys = Workspace:WaitForChild(LocalPlayer.Name .. "SpawnedInToys")

local Config = {PlayerList = {}, aa6 = false, aa9 = 25, aa13 = false, aa17 = false, aa73 = nil, running = false}

local function JapanNotify(Message) Rayfield:Notify({ Title = "Japan HUB", Content = Message, Duration = 4, Image = 4483362458 }) end
local function spawntoy(name, cframe, vector3) SpawnToyRemoteFunction:InvokeServer(name, cframe, vector3 or Vector3.zero) return SpawnedInToys and SpawnedInToys[name] end
local function GetCharacter() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end

local TextureConfig = {Enabled = false, Size = 45, MouthFrames = {"rbxassetid://75252859666942", "rbxassetid://110474979527548", "rbxassetid://88413342916949", "rbxassetid://102189053362318", "rbxassetid://72775664942814"}, Connections = {}}
local function ProcessMouth(p2)
    if not p2 or not p2.Parent or p2:FindFirstChild("ProcessedMouth") then return end
    local hole = p2:FindFirstChild("Hole") or p2:FindFirstChildWhichIsA("BasePart")
    if not hole then return end
    local processedMouth = Instance.new("BoolValue") processedMouth.Name = "ProcessedMouth" processedMouth.Parent = p2
    for _, v in ipairs(hole:GetChildren()) do v:Destroy() end
    for _, v in ipairs(p2:GetChildren()) do if v ~= hole and (v:IsA("BasePart") or v:IsA("Attachment") or v:IsA("ParticleEmitter")) then v:Destroy() end end
    hole.Transparency = 1
    local monsterMouthGui = Instance.new("BillboardGui") monsterMouthGui.Name = "MonsterMouthGui" monsterMouthGui.AlwaysOnTop = true monsterMouthGui.Size = UDim2.new(TextureConfig.Size, 0, TextureConfig.Size, 0) monsterMouthGui.Parent = hole
    local mouthAnim = Instance.new("ImageLabel") mouthAnim.Name = "MouthAnim" mouthAnim.Size = UDim2.new(1, 0, 1, 0) mouthAnim.BackgroundTransparency = 1 mouthAnim.Image = TextureConfig.MouthFrames[1] mouthAnim.Parent = monsterMouthGui
    task.spawn(function()
        monsterMouthGui.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(monsterMouthGui, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(TextureConfig.Size, 0, TextureConfig.Size, 0)}):Play()
        task.wait(0.3)
        for i = 1, #TextureConfig.MouthFrames do mouthAnim.Image = TextureConfig.MouthFrames[i] task.wait(0.08) end
        local part = Instance.new("Part") part.Shape = Enum.PartType.Ball part.Size = Vector3.new(4, 4, 4) part.CFrame = hole.CFrame part.Color = Color3.fromRGB(220, 10, 10) part.Material = Enum.Material.Neon part.Anchored = true part.CanCollide = false part.Parent = workspace
        local create = TweenService:Create(part, TweenInfo.new(0.25), {Size = Vector3.new(45, 45, 45), Transparency = 1})
        create:Play() create.Completed:Connect(function() part:Destroy() end) task.wait(0.05) p2:Destroy()
    end)
end
local function StartTextureSystem()
    if #TextureConfig.Connections > 0 then return end
    for _, v in ipairs(workspace:GetChildren()) do if v.Name:find("BlackHole") or v.Name:find("BlackHoleKick") then ProcessMouth(v) end end
    table.insert(TextureConfig.Connections, workspace.ChildAdded:Connect(function(child) if TextureConfig.Enabled and (child.Name:find("BlackHole") or child.Name:find("BlackHoleKick")) then task.wait(0.05) ProcessMouth(child) end end))
end
local function StopTextureSystem() for _, conn in ipairs(TextureConfig.Connections) do conn:Disconnect() end table.clear(TextureConfig.Connections) end

local CosmicBlackhole = { Enabled = false, Active = {}, Connection = nil, Options = {["EternityHole"] = {Id = "rbxassetid://99340233207059", Scale = 1.0, Type = "model"}} }
local function WipeOriginal(bh)
    if not bh then return end
    for _, desc in ipairs(bh:GetDescendants()) do
        if desc:IsA("BasePart") or desc:IsA("MeshPart") or desc:IsA("UnionOperation") then desc.Transparency = 1 desc.CastShadow = false
        elseif desc:IsA("ParticleEmitter") or desc:IsA("Trail") or desc:IsA("Beam") or desc:IsA("Smoke") or desc:IsA("Fire") or desc:IsA("Sparkles") then desc.Enabled = false
        elseif desc:IsA("PointLight") or desc:IsA("SpotLight") or desc:IsA("SurfaceLight") then desc.Enabled = false
        elseif desc:IsA("Decal") or desc:IsA("Texture") then desc.Transparency = 1
        elseif desc:IsA("BillboardGui") or desc:IsA("SurfaceGui") then desc.Enabled = false end
    end
    if bh:IsA("BasePart") then bh.Transparency = 1 end
    if bh:IsA("Model") and bh.PrimaryPart then bh.PrimaryPart.Transparency = 1 end
end
local function RestoreOriginal(bh)
    if not bh then return end
    for _, desc in ipairs(bh:GetDescendants()) do
        if desc:IsA("BasePart") or desc:IsA("MeshPart") or desc:IsA("UnionOperation") then desc.Transparency = 0
        elseif desc:IsA("ParticleEmitter") or desc:IsA("Trail") or desc:IsA("Beam") or desc:IsA("Smoke") or desc:IsA("Fire") or desc:IsA("Sparkles") then desc.Enabled = true
        elseif desc:IsA("PointLight") or desc:IsA("SpotLight") or desc:IsA("SurfaceLight") then desc.Enabled = true
        elseif desc:IsA("Decal") or desc:IsA("Texture") then desc.Transparency = 0
        elseif desc:IsA("BillboardGui") or desc:IsA("SurfaceGui") then desc.Enabled = true end
    end
    if bh:IsA("BasePart") then bh.Transparency = 0 end
    if bh:IsA("Model") and bh.PrimaryPart then bh.PrimaryPart.Transparency = 0 end
end
local function CleanupCosmic(bh)
    if not bh then return end
    local data = CosmicBlackhole.Active[bh] if not data then return end
    if data.Anim then pcall(function() data.Anim:Disconnect() end) end
    if data.Model then pcall(function() data.Model:Destroy() end) end
    RestoreOriginal(bh) CosmicBlackhole.Active[bh] = nil
end
local function BuildCosmic(bh)
    if not bh or not bh.Parent or CosmicBlackhole.Active[bh] then return end
    local hole = bh:FindFirstChild("Hole") or bh:FindFirstChildWhichIsA("BasePart") if not hole then return end
    WipeOriginal(bh) local pos = hole.Position local option = CosmicBlackhole.Options["EternityHole"]
    local data = {Time = 0, Hole = hole, Anim = nil, Model = nil, SpinSpeed = 0, TargetSpin = 0.8, Scale = 0, TargetScale = option.Scale, StartTime = tick()}
    local assetId = option.Id local model = nil
    local success, result = pcall(function() return game:GetObjects(assetId)[1] end)
    if success and result then model = result end
    if not model then
        local cleanId = tonumber((assetId:gsub("rbxassetid://", "")))
        success, result = pcall(function() return game:GetService("InsertService"):LoadAsset(cleanId) end)
        if success and result then model = result:GetChildren()[1] end
    end
    if not model then RestoreOriginal(bh) return end
    model.Parent = bh model.Name = "CosmicMesh"
    for _, desc in ipairs(model:GetDescendants()) do if desc:IsA("AnimationController") or desc:IsA("Animator") or desc:IsA("Animation") then desc:Destroy() end end
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("MeshPart") then part.Anchored = true part.CanCollide = false part.CastShadow = false part.Size = part.Size * 0.01 end
        if part:IsA("Smoke") or part:IsA("ParticleEmitter") then if part.Name:lower():find("smog") or part.Name:lower():find("fog") or part.Name:lower():find("mist") or part.Name:lower():find("haze") or part.Name:lower():find("cloud") then part:Destroy() end end
    end
    if model.PrimaryPart then local offset = pos - model.PrimaryPart.Position model:SetPrimaryPartCFrame(model.PrimaryPart.CFrame + offset)
    else
        local firstPart = nil for _, part in ipairs(model:GetDescendants()) do if part:IsA("BasePart") then firstPart = part break end end
        if firstPart then local offset = pos - firstPart.Position for _, part in ipairs(model:GetDescendants()) do if part:IsA("BasePart") then part.CFrame = part.CFrame + offset end end end
    end
    data.Model = model
    data.Anim = RunService.Heartbeat:Connect(function(dt)
        if not bh or not bh.Parent then CleanupCosmic(bh) return end
        local currentPos = hole.Position data.Time = data.Time + dt * data.SpinSpeed
        if data.Model then
            if data.Model:IsA("Model") then
                if data.Model.PrimaryPart then local cf = CFrame.new(currentPos) * CFrame.Angles(0, data.Time, 0) data.Model:SetPrimaryPartCFrame(cf) end
                for _, part in ipairs(data.Model:GetDescendants()) do if part:IsA("BasePart") or part:IsA("MeshPart") then if not part:GetAttribute("BaseSize") then part:SetAttribute("BaseSize", part.Size / 0.01) end local baseSize = part:GetAttribute("BaseSize") part.Size = baseSize * data.Scale end end
            elseif data.Model:IsA("BasePart") then data.Model.CFrame = CFrame.new(currentPos) * CFrame.Angles(0, data.Time, 0) if not data.Model:GetAttribute("BaseSize") then data.Model:SetAttribute("BaseSize", data.Model.Size / 0.01) end data.Model.Size = data.Model:GetAttribute("BaseSize") * data.Scale end
        end
    end)
    bh.AncestryChanged:Connect(function() if not bh.Parent then CleanupCosmic(bh) end end) CosmicBlackhole.Active[bh] = data
end
local function StartCosmicSystem()
    if CosmicBlackhole.Connection then return end
    CosmicBlackhole.Connection = Workspace.ChildAdded:Connect(function(obj) if not CosmicBlackhole.Enabled then return end if obj.Name:lower():find("blackhole") then task.wait(0.2) BuildCosmic(obj) end end)
end
local function StopCosmicSystem()
    if CosmicBlackhole.Connection then CosmicBlackhole.Connection:Disconnect() CosmicBlackhole.Connection = nil end
    for bh, _ in pairs(CosmicBlackhole.Active) do CleanupCosmic(bh) end
end

local Defense = {
    AntiGrab = false, AntiBurn = false, AntiExplosion = false, AntiBananaSit = false, AntiSticky = false, AntiPaint = false, AntiAFK = false, AntiVoid = false, AntiRagdoll = false, AntiWater = false, AntiInputLag = false, AntiKickGrab = false, AntiKickV2 = false, AutoRespawn = false, SelectedSpawn = "Spawn", AutoAttacker = false, AttackerMode = "Death",
    ragdollCount = 0, antiGrabProce = false, paintPartsBackup = {}, paintConnections = {}, antiKickCoroutine = nil, notifiedNoCoins = false, originalVoidHeight = nil, ragdollConnections = {},
    SpawnLocations = {["Spawn"] = CFrame.new(4, -7, -3), ["Green Safe-House"] = CFrame.new(-584, -6, 93), ["Chinese Safe-House"] = CFrame.new(579, 124, -94), ["Blue Safe-House"] = CFrame.new(538, 96, -372), ["Witch Safe-House"] = CFrame.new(296, -4, 494), ["Red Safe-House"] = CFrame.new(-516, -6, -162)}
}

function ToggleAntiGrab(enabled)
    Defense.AntiGrab = enabled
    if enabled then
        task.spawn(function() while Defense.AntiGrab do pcall(function() Struggle:FireServer(LocalPlayer) end) Defense.ragdollCount = 0 task.wait(0.1) end end)
        local function AntiGrabHandler(character)
            local hrp = character:WaitForChild("HumanoidRootPart", 10) local hum = character:WaitForChild("Humanoid", 10) local head = character:WaitForChild("Head", 10)
            if not (hrp and hum and head) then return end
            head.ChildAdded:Connect(function(child)
                if child.Name ~= "PartOwner" or not Defense.AntiGrab then return end
                hum.Sit = false
                if Defense.ragdollCount < 100 then RagdollRemote:FireServer(hrp, 0) Defense.ragdollCount = Defense.ragdollCount + 1 end
                if not Defense.antiGrabProce then
                    Defense.antiGrabProce = true hrp.Anchored = true
                    local isHeld = LocalPlayer:WaitForChild("IsHeld", 5) while Defense.AntiGrab and (not isHeld or not isHeld.Value) do task.wait() end
                    local renderConnection = service.RunService.RenderStepped:Connect(function() hrp.CFrame = hrp.CFrame + hum.MoveDirection * 0.3 end)
                    while Defense.AntiGrab and isHeld and isHeld.Value do task.wait() end
                    renderConnection:Disconnect() hrp.Anchored = false Defense.antiGrabProce = false
                end
            end)
        end
        if LocalPlayer.Character then task.spawn(AntiGrabHandler, LocalPlayer.Character) end
        LocalPlayer.CharacterAdded:Connect(AntiGrabHandler)
    end
end
function ToggleAntiBurn(enabled)
    Defense.AntiBurn = enabled
    if enabled then
        if not Defense.burnConnection then
            Defense.burnConnection = service.RunService.Heartbeat:Connect(function()
                local char = GetCharacter() local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local fireLight = hrp:FindFirstChild("FireLight") local fireEmitter = hrp:FindFirstChild("FireParticleEmitter")
                    local mapHole = service.Workspace:FindFirstChild("Map") and service.Workspace.Map:FindFirstChild("Hole") and service.Workspace.Map.Hole:FindFirstChild("PoisonBigHole")
                    local extPart = mapHole and mapHole:FindFirstChild("ExtinguishPart") local originalPos = extPart and extPart.Position or Vector3.new()
                    if extPart then if fireLight or fireEmitter then extPart.CFrame = hrp.CFrame else extPart.CFrame = CFrame.new(originalPos) end end
                end
            end)
        end
    else if Defense.burnConnection then Defense.burnConnection:Disconnect() Defense.burnConnection = nil end end
end
function ToggleAntiExplosion(enabled)
    Defense.AntiExplosion = enabled
    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
    if PlayerScripts then local handler = PlayerScripts:FindFirstChild("ClientExoplosionHandler") if handler then handler.Enabled = not enabled end end
end
function ToggleAntiBananaSit(enabled)
    Defense.AntiBananaSit = enabled
    if enabled then
        task.spawn(function()
            while Defense.AntiBananaSit do
                task.wait() local char = GetCharacter() local hum = char:FindFirstChildOfClass("Humanoid") local hrp = char:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then hum.Sit = true hum:ChangeState(Enum.HumanoidStateType.Running) local vec = Workspace.CurrentCamera.CFrame.LookVector hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(vec.X, 0, vec.Z)) task.wait() hum:ChangeState(Enum.HumanoidStateType.Running) end
            end
        end)
    end
end
function ToggleAntiSticky(enabled)
    Defense.AntiSticky = enabled local stickyScript = LocalPlayer.PlayerScripts:FindFirstChild("StickyPartsTouchDetection") if stickyScript then stickyScript.Disabled = enabled end
end
function ToggleAntiPaint(enabled)
    Defense.AntiPaint = enabled
    local function setTouchQuery(state) local char = GetCharacter() if char then for _, v in ipairs(char:GetChildren()) do if v:IsA("BasePart") then v.CanTouch = state v.CanQuery = state end end end end
    if enabled then
        for _, obj in ipairs(service.Workspace:GetDescendants()) do if obj:IsA("BasePart") and obj.Name == "PaintPlayerPart" then local clone = obj:Clone() clone.Archivable = true Defense.paintPartsBackup[obj:GetDebugId()] = { clone = clone, parent = obj.Parent } obj:Destroy() end end
        local conn = service.Workspace.DescendantAdded:Connect(function(obj) if obj:IsA("BasePart") and obj.Name == "PaintPlayerPart" then task.defer(function() if obj and obj.Parent then local clone = obj:Clone() clone.Archivable = true Defense.paintPartsBackup[obj:GetDebugId()] = { clone = clone, parent = obj.Parent } obj:Destroy() end end) end end) table.insert(Defense.paintConnections, conn) setTouchQuery(false)
    else
        for _, conn in ipairs(Defense.paintConnections) do if conn.Connected then conn:Disconnect() end end Defense.paintConnections = {}
        for id, data in pairs(Defense.paintPartsBackup) do if data.clone and data.parent then data.clone.Parent = data.parent end end Defense.paintPartsBackup = {} setTouchQuery(true)
    end
end
function ToggleAntiAFK(enabled)
    Defense.AntiAFK = enabled if not enabled then return end
    LocalPlayer.Idled:Connect(function() if Defense.AntiAFK then service.VirtualUser:CaptureController() service.VirtualUser:ClickButton2(Vector2.new()) end end)
    task.spawn(function() while Defense.AntiAFK do service.VirtualUser:CaptureController() service.VirtualUser:Button1Down(Vector2.new(0,0)) task.wait(0.1) service.VirtualUser:Button1Up(Vector2.new(0,0)) task.wait(600) end end)
end
function ToggleAntiVoid(enabled)
    Defense.AntiVoid = enabled
    if enabled then if not Defense.originalVoidHeight then Defense.originalVoidHeight = service.Workspace.FallenPartsDestroyHeight end service.Workspace.FallenPartsDestroyHeight = -1e95
    else service.Workspace.FallenPartsDestroyHeight = Defense.originalVoidHeight or -500 end
end
function ToggleAntiRagdoll(enabled)
    Defense.AntiRagdoll = enabled
    local function clearConnections() for _, conn in ipairs(Defense.ragdollConnections) do if conn then conn:Disconnect() end end Defense.ragdollConnections = {} end
    local function protectHumanoid(humanoid)
        humanoid.BreakJointsOnDeath = false humanoid.AutoRotate = true humanoid.PlatformStand = false
        table.insert(Defense.ragdollConnections, humanoid.HealthChanged:Connect(function(health) if Defense.AntiRagdoll and health <= 0 then humanoid.Health = 1 end end))
        table.insert(Defense.ragdollConnections, humanoid:GetPropertyChangedSignal("AutoRotate"):Connect(function() if Defense.AntiRagdoll and humanoid.AutoRotate == false then humanoid.AutoRotate = true end end))
        table.insert(Defense.ragdollConnections, humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function() if Defense.AntiRagdoll and humanoid.PlatformStand == true then humanoid.PlatformStand = false end end))
        table.insert(Defense.ragdollConnections, service.RunService.RenderStepped:Connect(function() if Defense.AntiRagdoll and humanoid.Sit and humanoid.SeatPart == nil then humanoid.Sit = false end end))
    end
    local function onCharacter(char) local humanoid = char:WaitForChild("Humanoid", 5) if humanoid and Defense.AntiRagdoll then protectHumanoid(humanoid) end end
    if enabled then if GetCharacter() then onCharacter(GetCharacter()) end Defense.ragdollCharAddedConn = LocalPlayer.CharacterAdded:Connect(onCharacter)
    else clearConnections() if Defense.ragdollCharAddedConn then Defense.ragdollCharAddedConn:Disconnect() Defense.ragdollCharAddedConn = nil end end
end
function ToggleAntiWater(enabled)
    Defense.AntiWater = enabled
    local oceanPath = service.Workspace:FindFirstChild("Map") and service.Workspace.Map:FindFirstChild("AlwaysHereTweenedObjects") and service.Workspace.Map.AlwaysHereTweenedObjects:FindFirstChild("Ocean") and service.Workspace.Map.AlwaysHereTweenedObjects.Ocean:FindFirstChild("Object") and service.Workspace.Map.AlwaysHereTweenedObjects.Ocean.Object:FindFirstChild("ObjectModel")
    if oceanPath then for _, part in pairs(oceanPath:GetChildren()) do if part:IsA("BasePart") and part.Name == "Ocean" then part.CanCollide = enabled end end end
end
function ToggleAntiInputLag(enabled)
    Defense.AntiInputLag = enabled
    if enabled then
        task.spawn(function()
            local ToyName = "FoodHamburger"
            while Defense.AntiInputLag do
                local char = GetCharacter() local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then service.RunService.Heartbeat:Wait() continue end
                local burger = SpawnedInToys and SpawnedInToys:FindFirstChild(ToyName)
                if not burger and Defense.AntiInputLag then pcall(function() SpawnToyRemoteFunction:InvokeServer(ToyName, hrp.CFrame * CFrame.new(0, 5, 0), Vector3.new(0, 0, 0)) end) continue end
                if burger and Defense.AntiInputLag then
                    local holdPart = burger:FindFirstChild("HoldPart", true)
                    if holdPart then
                        local hRemote = holdPart:FindFirstChild("HoldItemRemoteFunction") local dRemote = holdPart:FindFirstChild("DropItemRemoteFunction") local hPlayer = holdPart:FindFirstChild("HoldingPlayer")
                        if hPlayer and hPlayer.Value and hPlayer.Value ~= LocalPlayer then if dRemote then pcall(function() dRemote:InvokeServer(burger, hrp.CFrame * CFrame.new(0, 2000, 0), Vector3.new(0, 0, 0)) end) end burger:Destroy()
                        elseif hRemote and dRemote then pcall(function() hRemote:InvokeServer(burger, char) dRemote:InvokeServer(burger, hrp.CFrame * CFrame.new(0, 2000, 0), Vector3.new(0, 0, 0)) end) end
                    end
                end
                task.wait()
            end
        end)
    end
end
function ToggleAntiKickGrab(enabled)
    Defense.AntiKickGrab = enabled
    if Defense.antiKickCoroutine then Defense.antiKickCoroutine:Disconnect() Defense.antiKickCoroutine = nil end
    if enabled then
        Defense.antiKickCoroutine = service.RunService.Heartbeat:Connect(function()
            local character = GetCharacter()
            if character and character:FindFirstChild("HumanoidRootPart") then
                local fp = character.HumanoidRootPart:FindFirstChild("FirePlayerPart")
                if fp then local partOwner = fp:FindFirstChild("PartOwner") if partOwner and partOwner.Value ~= LocalPlayer.Name then pcall(function() RagdollRemote:FireServer(character.HumanoidRootPart, 0) task.wait(0.1) Struggle:FireServer() end) end end
            end
        end)
    end
end
function ToggleAntiKickV2(enabled)
    Defense.AntiKickV2 = enabled if enabled then Defense.notifiedNoCoins = false end
    local function getCharPart(name) local char = GetCharacter() return char and char:FindFirstChild(name) end
    local function inner_toyspn(toyName, cf) SpawnToyRemoteFunction:InvokeServer(toyName, cf, Vector3.new(0, 0, 0)) end
    local function inner_toyspn2(toyName) local hrp = getCharPart("HumanoidRootPart") if hrp then local cf = hrp.CFrame inner_toyspn(toyName, cf - Vector3.new(cf.LookVector.X * 20, -15, cf.LookVector.Z * 20)) end end
    local function kickLoop()
        local character = GetCharacter() if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart") local hum = character:FindFirstChildOfClass("Humanoid") local leg = character:FindFirstChild("Right Leg")
        if not hrp or not hum or not leg or hum.Health <= 0 then return end
        if LocalPlayer.InPlot and LocalPlayer.InPlot.Value then return end
        local ToyContents = LocalPlayer.PlayerGui:WaitForChild("MenuGui"):WaitForChild("Menu"):WaitForChild("TabContents"):WaitForChild("Toys"):WaitForChild("Contents")
        if not ToyContents:FindFirstChild("NinjaKunai") then
            local success = BuyToyRemoteFunction:InvokeServer("NinjaKunai")
            if not success then if not Defense.notifiedNoCoins then JapanNotify("コイン不足でNinjaKunaiを買えません。") Defense.notifiedNoCoins = true end return end
        end
        local kunai = SpawnedInToys:FindFirstChild("NinjaKunai")
        if kunai then
            local sticky = kunai:WaitForChild("StickyPart", 1)
            if sticky then local weld = sticky:FindFirstChild("StickyWeld") local attachedPart = weld and weld.Part1 if not weld or attachedPart ~= leg then DestroyToy:FireServer(kunai) task.wait(0.1) end else DestroyToy:FireServer(kunai) task.wait(0.1) end
        elseif LocalPlayer.CanSpawnToy and LocalPlayer.CanSpawnToy.Value then
            task.spawn(inner_toyspn2, "NinjaKunai")
            local newKunai = SpawnedInToys:WaitForChild("NinjaKunai", 3)
            if newKunai then local sticky = newKunai:WaitForChild("StickyPart", 2) if sticky then local weld = sticky:WaitForChild("StickyWeld", 2) SetNetworkOwner:FireServer(sticky, sticky.CFrame) local retry = 0 while Defense.AntiKickV2 and weld.Part1 == nil and retry < 20 do StickyPartEvent:FireServer(sticky, leg, CFrame.new(0.0490287527, 0.5, 0, 0, 0.00739139877, -0.999561906, -0.998452604, -0.0478846952, 0.0282763243, -0.0476547107, 0.99882561, 0) * CFrame.Angles(0, 0, 0)) task.wait(0.1) retry = retry + 1 end end end
        end
    end
    if enabled then task.spawn(function() while Defense.AntiKickV2 do pcall(kickLoop) task.wait() end end) end
end
local respawnConnection = nil
function ToggleAutoRespawn(enabled, spawnLocation)
    Defense.AutoRespawn = enabled if spawnLocation then Defense.SelectedSpawn = spawnLocation end
    if respawnConnection then respawnConnection:Disconnect() respawnConnection = nil end
    if enabled then
        respawnConnection = LocalPlayer.CharacterAdded:Connect(function(char)
            local hrp = char:WaitForChild("HumanoidRootPart", 5) if hrp then local targetCFrame = Defense.SpawnLocations[Defense.SelectedSpawn] if targetCFrame then task.wait() hrp.CFrame = targetCFrame end end
        end)
    end
end
local attackerCoroutine = nil
function ToggleAutoAttacker(enabled, mode)
    Defense.AutoAttacker = enabled if mode then Defense.AttackerMode = mode end
    if attackerCoroutine then coroutine.close(attackerCoroutine) attackerCoroutine = nil end
    if not enabled then return end
    attackerCoroutine = coroutine.create(function()
        while Defense.AutoAttacker do
            task.wait(0.02) local character = GetCharacter() local head = character and character:FindFirstChild("Head") local localHRP = character and character:FindFirstChild("HumanoidRootPart")
            if not (character and head and localHRP) then continue end
            local partOwner = head:FindFirstChild("PartOwner") if not partOwner then continue end
            local attacker = service.Players:FindFirstChild(partOwner.Value) if not (attacker and attacker.Character) then continue end
            local targetChar = attacker.Character local hrp = targetChar:FindFirstChild("HumanoidRootPart") local hum = targetChar:FindFirstChildOfClass("Humanoid") local torso = targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso")
            if not hrp or not hum then continue end
            Struggle:FireServer()
            if Defense.AttackerMode == "Death" then pcall(function() SetNetworkOwner:FireServer(hrp, hrp.CFrame) task.wait(0.05) for _, bp in ipairs(targetChar:GetChildren()) do if bp:IsA("BasePart") then bp.CFrame = CFrame.new(0, -1e9, 0) bp.CanCollide = false end end hum.Health = 0 hum:ChangeState(Enum.HumanoidStateType.Dead) if GrabEvents:FindFirstChild("DestroyGrabLine") then DestroyGrabLine:FireServer(hrp) end end)
            elseif Defense.AttackerMode == "Knockback" then local knockback = Instance.new("BodyVelocity") knockback.MaxForce = Vector3.new(1e6, 1e6, 1e6) knockback.Velocity = (localHRP.CFrame.LookVector * 200) + Vector3.new(0, 50, 0) knockback.Parent = hrp service.Debris:AddItem(knockback, 1)
            elseif Defense.AttackerMode == "airSuspend" and torso then local velocity = torso:FindFirstChild("l") or Instance.new("BodyVelocity") velocity.Name = "l" velocity.Velocity = Vector3.new(0, 5000, 0) velocity.MaxForce = Vector3.new(0, math.huge, 0) velocity.Parent = torso service.Debris:AddItem(velocity, 1)
            elseif Defense.AttackerMode == "Freeze" then local freezeVel = Instance.new("BodyVelocity") freezeVel.MaxForce = Vector3.new(1e6, 1e6, 1e6) freezeVel.Velocity = Vector3.new(0, 0, 0) freezeVel.Parent = hrp service.Debris:AddItem(freezeVel, 2) end
        end
    end)
    coroutine.resume(attackerCoroutine)
end
function ToggleAntiLag(enabled)
    local CharacterAndBeamMove = LocalPlayer.PlayerScripts:FindFirstChild("CharacterAndBeamMove") if CharacterAndBeamMove then CharacterAndBeamMove.Disabled = enabled end
end

local Window = Rayfield:CreateWindow({Name = "Japan HUB", LoadingTitle = "Japan HUB 起動中...", LoadingSubtitle = "多機能", Theme = "Default", ToggleUIKeybind = "K", KeySystem = false})

local KickTab = Window:CreateTab("キック", 4483362458)
local TargetOptions, TargetMap = {}, {}
local selectedActionTargetName = ""
local orbitRunning, radius, speed, heightOffset, angle, currentLoopId = false, 19, 12, 0, 0, 0
local function UpdateTargetOptions() TargetOptions = {"(なし)"} TargetMap = {} for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then local display = p.DisplayName .. " (@" .. p.Name .. ")" table.insert(TargetOptions, display) TargetMap[display] = p.Name end end end
UpdateTargetOptions()
local DriftTargetDropdown = KickTab:CreateDropdown({Name = "ターゲットを選択", Options = TargetOptions, CurrentOption = {"(なし)"}, MultipleOptions = false, Flag = "DriftTarget", Callback = function(option) selectedActionTargetName = TargetMap[option[1]] or "" end})
KickTab:CreateButton({Name = "ターゲットリストを更新", Callback = function() UpdateTargetOptions() DriftTargetDropdown:Refresh(TargetOptions) JapanNotify("リストを更新しました。") end})
KickTab:CreateToggle({
    Name = "Drift Kick (旋回キック + ラインラグ)", CurrentValue = false, Flag = "DriftKick",
    Callback = function(v)
        orbitRunning = v currentLoopId = currentLoopId + 1 local myLoopId = currentLoopId
        if not v then return end
        local target = Players:FindFirstChild(selectedActionTargetName)
        if not target or target == LocalPlayer then JapanNotify("有効なターゲットを選んでください。") orbitRunning = false return end
        
        task.spawn(function()
            while orbitRunning and myLoopId == currentLoopId do
                local t = Players:FindFirstChild(selectedActionTargetName)
                if t and t.Character then
                    local spawnLoc = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Spawn") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
                    if spawnLoc then
                        CreateGrabLine:FireServer(spawnLoc, CFrame.new(math.random(-2e9, 2e9), 0, math.random(-2e9, 2e9)))
                        CreateGrabLine:FireServer(spawnLoc, CFrame.new(math.random(-2e9, 2e9), 0, math.random(-2e9, 2e9)))
                        CreateGrabLine:FireServer(spawnLoc, CFrame.new(math.random(-2e9, 2e9), 0, math.random(-2e9, 2e9)))
                    end
                end
                task.wait(0.001)
            end
        end)

        local blobman = nil local spawned = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
        if spawned then blobman = spawned:FindFirstChild("CreatureBlobman") end
        if not blobman then local mt = ReplicatedStorage:FindFirstChild("MenuToys") local st = mt and mt:FindFirstChild("SpawnToyRemoteFunction") if st then local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") local spawnCF = myRoot and (myRoot.CFrame + Vector3.new(0, 5, 0)) or CFrame.new(0, 50, 0) st:InvokeServer("CreatureBlobman", spawnCF, Vector3.zero) task.wait(0.8) spawned = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys") if spawned then blobman = spawned:FindFirstChild("CreatureBlobman") end end end
        if not blobman then for _, obj in ipairs(Workspace:GetChildren()) do if obj.Name == "CreatureBlobman" and obj:FindFirstChild("VehicleSeat") then blobman = obj break end end end
        if blobman then
            local scriptObj = blobman:FindFirstChild("BlobmanSeatAndOwnerScript") local grabRemote = scriptObj and scriptObj:FindFirstChild("CreatureGrab") local dropRemote = scriptObj and scriptObj:FindFirstChild("CreatureDrop")
            local lDet = blobman:FindFirstChild("LeftDetector") local rDet = blobman:FindFirstChild("RightDetector") local lWeld = lDet and (lDet:FindFirstChild("LeftWeld") or lDet:FindFirstChild("RigidConstraint")) local rWeld = rDet and (rDet:FindFirstChild("RightWeld") or rDet:FindFirstChild("RigidConstraint"))
            local seat = blobman:FindFirstChild("VehicleSeat") local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if seat and hum and seat.Occupant ~= hum then LocalPlayer.Character.HumanoidRootPart.CFrame = seat.CFrame + Vector3.new(0, 2, 0) task.wait(0.2) seat:Sit(hum) task.wait(0.5) end
            local GE = ReplicatedStorage:FindFirstChild("GrabEvents")
            if GE and grabRemote and dropRemote and ((lDet and lWeld) or (rDet and rWeld)) then
                JapanNotify("drift kick を開始します")
                task.spawn(function()
                    local blobRoot = blobman:FindFirstChild("HumanoidRootPart") or blobman.PrimaryPart local Det = rDet or lDet local Weld = rWeld or lWeld
                    while orbitRunning do
                        if myLoopId ~= currentLoopId then break end if not target or not target.Parent then break end
                        local tChar = target.Character local tHum = tChar and tChar:FindFirstChild("Humanoid") local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                        if tChar and tRoot and tHum and tHum.Health > 0 then
                            local bringStart = tick()
                            while tick() - bringStart < 0.35 do
                                if myLoopId ~= currentLoopId or not orbitRunning or not blobman or not blobman.Parent then break end
                                if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                                    local currentTRoot = target.Character.HumanoidRootPart blobRoot.CFrame = currentTRoot.CFrame blobRoot.AssemblyLinearVelocity = Vector3.zero
                                    pcall(function() if Det then grabRemote:FireServer(Det, currentTRoot, Weld) end GE.CreateGrabLine:FireServer(currentTRoot, Vector3.zero, currentTRoot.Position, false) GE.SetNetworkOwner:FireServer(currentTRoot, blobRoot.CFrame) end)
                                end
                                RunService.Heartbeat:Wait()
                            end
                            if myLoopId ~= currentLoopId or not orbitRunning or not blobman or not blobman.Parent then break end
                            tChar = target.Character tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart") tHum = tChar and tChar:FindFirstChild("Humanoid")
                            if tChar and tRoot and tHum and tHum.Health > 0 then
                                local SavedPos = tRoot.CFrame local targetCenterCFrame = SavedPos + Vector3.new(0, 30, 0) local lastTime = tick() local lastDropTime = tick() local dropCount = 0
                                while orbitRunning and blobman and blobman.Parent do
                                    if myLoopId ~= currentLoopId then break end if not target or not target.Parent then break end
                                    tChar = target.Character tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart") tHum = tChar and tChar:FindFirstChild("Humanoid")
                                    if not tChar or not tRoot or not tHum or tHum.Health <= 0 then break end
                                    if dropCount < 2 and (tick() - lastDropTime) > 0.8 then
                                        dropCount = dropCount + 1
                                        pcall(function() local rightWeld = blobman:FindFirstChild("RightDetector") and blobman.RightDetector:FindFirstChild("RightWeld") if rightWeld then dropRemote:FireServer(rightWeld) end GE.DestroyGrabLine:FireServer(tRoot) end)
                                        blobRoot.CFrame = SavedPos blobRoot.AssemblyLinearVelocity = Vector3.zero RunService.Heartbeat:Wait()
                                        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then local currentTRoot = target.Character.HumanoidRootPart blobRoot.CFrame = currentTRoot.CFrame blobRoot.AssemblyLinearVelocity = Vector3.zero pcall(function() if Det then grabRemote:FireServer(Det, currentTRoot, Weld) end GE.CreateGrabLine:FireServer(currentTRoot, Vector3.zero, currentTRoot.Position, false) GE.SetNetworkOwner:FireServer(currentTRoot, blobRoot.CFrame) end) end
                                        lastTime = tick() lastDropTime = tick() continue
                                    end
                                    if tRoot and tHum and tHum.Health > 0 and blobRoot then
                                        local currentTime = tick() local dt = currentTime - lastTime lastTime = currentTime
                                        angle = angle + (speed * dt) local offsetX = math.cos(angle) * radius local offsetZ = math.sin(angle) * radius
                                        local blobPos = targetCenterCFrame.Position + Vector3.new(offsetX, heightOffset, offsetZ)
                                        blobRoot.CFrame = CFrame.new(blobPos, targetCenterCFrame.Position) blobRoot.AssemblyLinearVelocity = Vector3.zero blobRoot.AssemblyAngularVelocity = Vector3.zero
                                        tRoot.CFrame = targetCenterCFrame tRoot.AssemblyLinearVelocity = Vector3.zero tRoot.AssemblyAngularVelocity = Vector3.zero
                                        pcall(function() tHum.PlatformStand = true tHum.Sit = true GE.SetNetworkOwner:FireServer(tRoot, targetCenterCFrame) local rightWeld = blobman:FindFirstChild("RightDetector") and blobman.RightDetector:FindFirstChild("RightWeld") if rightWeld then dropRemote:FireServer(rightWeld) end GE.DestroyGrabLine:FireServer(tRoot) if Det then grabRemote:FireServer(Det, tRoot, Weld) end GE.CreateGrabLine:FireServer(tRoot, Vector3.zero, targetCenterCFrame.Position, false) end)
                                    else break end
                                    RunService.Heartbeat:Wait()
                                end
                                if not orbitRunning or myLoopId ~= currentLoopId then
                                    if blobRoot and SavedPos then pcall(function() local rightWeld = blobman:FindFirstChild("RightDetector") and blobman.RightDetector:FindFirstChild("RightWeld") if rightWeld then dropRemote:FireServer(rightWeld) end if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then GE.DestroyGrabLine:FireServer(target.Character.HumanoidRootPart) end end) blobRoot.CFrame = SavedPos blobRoot.AssemblyLinearVelocity = Vector3.zero end
                                    break
                                end
                            end
                        end
                        RunService.Heartbeat:Wait()
                    end
                end)
            else JapanNotify("必要なRemoteEventやDetectorが見つかりません") orbitRunning = false end
        else JapanNotify("Blobmanの取得・生成に失敗しました") orbitRunning = false end
    end,
})
KickTab:CreateSlider({Name = "旋回半径 (Radius)", Range = {5, 50}, Increment = 1, Suffix = "studs", CurrentValue = 19, Flag = "OrbitRadius", Callback = function(v) radius = v end})
KickTab:CreateSlider({Name = "旋回速度 (Speed)", Range = {1, 50}, Increment = 1, Suffix = "speed", CurrentValue = 12, Flag = "OrbitSpeed", Callback = function(v) speed = v end})

local MainTab = Window:CreateTab("板キック", 4483362458)
local PlankTargetOptions, PlankTargetMap = {}, {}
local function UpdatePlankTargetOptions() PlankTargetOptions = {"(なし)"} PlankTargetMap = {} for _, p in ipairs(service.Players:GetPlayers()) do if p ~= LocalPlayer then local display = p.DisplayName table.insert(PlankTargetOptions, display) PlankTargetMap[display] = p end end end
UpdatePlankTargetOptions()
local PlankDropdown = MainTab:CreateDropdown({Name = "ターゲットを選択", Options = PlankTargetOptions, CurrentOption = {"(なし)"}, MultipleOptions = false, Flag = "PlankTarget", Callback = function(option) local val = option[1] local p = PlankTargetMap[val] Config.PlayerList = p and {p.Name} or {} end})
MainTab:CreateButton({Name = "ターゲットリストを更新", Callback = function() UpdatePlankTargetOptions() PlankDropdown:Refresh(PlankTargetOptions) JapanNotify("リストを更新しました。") end})
MainTab:CreateToggle({
    Name = "キックスパム (ラグドール＆ラグ)", CurrentValue = false, Flag = "KickSpam",
    Callback = function(aa61)
        Config.aa6 = aa61 Config.aa13 = aa61
        if aa61 then if not Config.PlayerList or #Config.PlayerList == 0 then JapanNotify("先にターゲットを選んでください。") Config.aa6 = false Config.aa13 = false return end end
        local function aa31(aa32, aa33, aa34) return aa32:FindFirstChild(aa33) or aa32:WaitForChild(aa33, aa34 or 5) end
        local function aa35(aa36) if aa36 and aa36:IsA("BasePart") then SetNetworkOwner:FireServer(aa36, aa36.CFrame) task.wait() end end
        local function aa37(aa38, aa39) return aa38:FindFirstChild(aa39) ~= nil end
        local function aa40(aa41)
            local aa42 = GetCharacter() if not aa42 then return nil end local aa43 = aa42:WaitForChild("HumanoidRootPart") local waitCount = 0
            while (LocalPlayer.InPlot.Value and not LocalPlayer.InOwnedPlot.Value) and waitCount < 50 do task.wait(0.1) waitCount = waitCount + 1 end waitCount = 0
            while not LocalPlayer.CanSpawnToy.Value and waitCount < 50 do task.wait(0.1) waitCount = waitCount + 1 end
            local aa44 = aa43.CFrame * CFrame.new(0, 14, 20) local aa45 = workspace:FindFirstChild(LocalPlayer.Name.."SpawnedInToys")
            if not aa45 then aa45 = workspace:FindFirstChild("PlotItems") if aa45 then aa45 = aa45:FindFirstChild("Plot1") end end if not aa45 then aa45 = workspace end
            local aa46 = nil local aa47 = aa45.ChildAdded:Connect(function(aa48) if aa48.Name == aa41 then aa46 = aa48 end end)
            task.spawn(function() pcall(function() spawntoy(aa41, aa44, Vector3.zero) end) end)
            local aa49 = tick() repeat task.wait(0.05) until aa46 or (tick() - aa49) > 5 aa47:Disconnect() return aa46
        end
        local function aa50()
            if Config.aa17 then return nil end Config.aa17 = true local aa51 = aa40("PalletLightBrown")
            if not aa51 then Config.aa17 = false return nil end local aa52 = aa31(aa51, "SoundPart", 3) if not aa52 then aa51:Destroy() Config.aa17 = false return nil end
            local retryCount = 0 while retryCount < 10 do if not Config.aa13 then aa51:Destroy() Config.aa17 = false return nil end aa35(aa52) task.wait() if aa37(aa52, "PartOwner") then break end retryCount = retryCount + 1 end
            if not aa37(aa52, "PartOwner") then aa51:Destroy() Config.aa17 = false return nil end
            for _, aa54 in pairs(aa51:GetDescendants()) do if aa54:IsA("BasePart") then aa54.CanCollide = false aa54.Transparency = 0.8 end end
            aa51.Name = "RagdollPalete" local aa55 = Instance.new("BodyVelocity") aa55.MaxForce = Vector3.new(0, math.huge, 0) aa55.Velocity = Vector3.new(0, 900, 0) aa55.Parent = aa52 Config.aa17 = false return aa51
        end
        local function aa25(aa26, aa27)
            if not aa26.Character then return end local aa28 = aa26.Character:FindFirstChild("HumanoidRootPart") if not aa28 or not aa27 then return end
            local aa29 = aa27.CFrame aa27.CFrame = aa28.CFrame * CFrame.new(0, 0, 2) for aa30 = 1, 15 do SetNetworkOwner:FireServer(aa28, aa28.CFrame) task.wait() end aa27.CFrame = aa29
        end
        local function startLagSpam()
            if Config.running then return end if not Config.PlayerList or #Config.PlayerList == 0 then return end if not CreateGrabLine then CreateGrabLine = GrabEvents:WaitForChild("CreateGrabLine", 3) if not CreateGrabLine then return end end
            Config.running = true task.spawn(function() while Config.running do local spawnLocation = service.Workspace:FindFirstChild("SpawnLocation") or service.Workspace:FindFirstChild("Spawn") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) if spawnLocation then CreateGrabLine:FireServer(spawnLocation, CFrame.new(math.random(-2010000000, 2000000001), 0, math.random(-2008100000, 2000200000))) end task.wait(0.001) end end)
        end
        local function stopLagSpam() if not Config.running then return end Config.running = false end
        if aa61 then if not Config.PlayerList or #Config.PlayerList == 0 then return end task.wait(0.5) task.defer(function() startLagSpam() end) else stopLagSpam() end
        if Config.aa6 then
            task.spawn(function()
                while Config.aa6 do local targets = type(Config.PlayerList) == "table" and Config.PlayerList or {Config.PlayerList}
                    for _, targetName in ipairs(targets) do local aa62 = service.Players:FindFirstChild(targetName) local aa63 = LocalPlayer.Character local aa64 = aa63 and aa63:FindFirstChild("HumanoidRootPart")
                        if aa62 and aa64 then local aa65 = aa62.Character local aa66 = aa65 and aa65:FindFirstChild("HumanoidRootPart")
                            if aa66 then local aa67 = (aa64.Position - aa66.Position).Magnitude if aa67 > Config.aa9 then aa25(aa62, aa64) end
                                SetNetworkOwner:FireServer(aa66, aa66.CFrame) if DestroyGrabLine then DestroyGrabLine:FireServer(aa66) end aa66.AssemblyLinearVelocity = Vector3.zero aa66.AssemblyAngularVelocity = Vector3.zero
                                local aa68 = aa66:FindFirstChild("ControlBP") if not aa68 then aa68 = Instance.new("BodyPosition") aa68.Name = "ControlBP" aa68.MaxForce = Vector3.new(math.huge, math.huge, math.huge) aa68.P = 800000 aa68.Parent = aa66 end
                                aa68.Position = aa64.Position + Vector3.new(0, 15, 0)
                            end
                        end
                    end task.wait(0.001)
                end
                local targets = type(Config.PlayerList) == "table" and Config.PlayerList or {Config.PlayerList}
                for _, targetName in ipairs(targets) do local aa69 = service.Players:FindFirstChild(targetName) if aa69 and aa69.Character then local aa70 = aa69.Character:FindFirstChild("HumanoidRootPart") if aa70 and aa70:FindFirstChild("ControlBP") then aa70.ControlBP:Destroy() end end end
            end)
        end
        if aa61 then
            local aa71 = workspace:FindFirstChild(LocalPlayer.Name.."SpawnedInToys") local aa72 = nil
            Config.aa73 = service.RunService.RenderStepped:Connect(function()
                if not Config.aa13 then return end if not Config.PlayerList or #Config.PlayerList == 0 then return end
                local targets = type(Config.PlayerList) == "table" and Config.PlayerList or {Config.PlayerList} local targetName = targets[1] if not targetName then return end
                local aa74 = service.Players:FindFirstChild(targetName) if not aa74 or not aa74.Character then return end local aa75 = aa74.Character:FindFirstChild("HumanoidRootPart") local aa76 = aa74.Character:FindFirstChild("Humanoid") if not aa75 or not aa76 then return end
                if aa72 and aa72:IsDescendantOf(workspace) then local aa77 = aa72:FindFirstChild("SoundPart") if aa77 then if not aa37(aa77, "PartOwner") then aa72:Destroy() aa72 = nil end else aa72:Destroy() aa72 = nil end end
                if not Config.aa17 and (not aa72 or not aa72:IsDescendantOf(workspace)) then aa72 = aa71 and aa71:FindFirstChild("RagdollPalete") or aa50() end
                if aa72 and aa72:FindFirstChild("SoundPart") then local aa78 = aa76:FindFirstChild("Ragdolled") if aa78 and not aa78.Value then aa72.SoundPart.Position = aa75.Position end end
            end)
        else if Config.aa73 then Config.aa73:Disconnect() Config.aa73 = nil end end
    end,
})
MainTab:CreateSlider({Name = "パレットの距離", Range = {5, 100}, Increment = 1, Suffix = "スタッズ", CurrentValue = 25, Flag = "PalletDist", Callback = function(v) Config.aa9 = v end})

local CamTab = Window:CreateTab("三人称", 4483362458)
CamTab:CreateToggle({
    Name = "三人称視点 (Third Person)", CurrentValue = false, Flag = "ThirdPerson",
    Callback = function(Value)
        local char = LocalPlayer.Character
        if Value then LocalPlayer.CameraMode = Enum.CameraMode.Classic if char then local hum = char:FindFirstChildOfClass("Humanoid") if hum then workspace.CurrentCamera.CameraSubject = hum end end LocalPlayer.CameraMaxZoomDistance = 1000 LocalPlayer.CameraMinZoomDistance = 0.5
        else LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson if char then local hum = char:FindFirstChildOfClass("Humanoid") if hum then workspace.CurrentCamera.CameraSubject = hum end end LocalPlayer.CameraMaxZoomDistance = 0 LocalPlayer.CameraMinZoomDistance = 0 end
    end,
})

local TextureTab = Window:CreateTab("キックテクスチャ", 4483362458)
TextureTab:CreateToggle({Name = "👹 HYPER BITE KICK (口のアニメーション)", CurrentValue = false, Flag = "KickTexture", Callback = function(Value) TextureConfig.Enabled = Value if Value then StartTextureSystem() JapanNotify("HYPER BITE を有効にしました。") else StopTextureSystem() JapanNotify("HYPER BITE を無効にしました。") end end})
TextureTab:CreateToggle({Name = "🌌 Cosmic Blackhole (EternityHoleモデル)", CurrentValue = false, Flag = "CosmicTexture", Callback = function(Value) CosmicBlackhole.Enabled = Value if Value then StartCosmicSystem() for _, obj in ipairs(Workspace:GetChildren()) do if obj.Name:lower():find("blackhole") then BuildCosmic(obj) end end JapanNotify("Cosmic Blackhole を有効にしました。") else StopCosmicSystem() JapanNotify("Cosmic Blackhole を無効にしました。") end end})
TextureTab:CreateSlider({Name = "口のサイズ (HYPER BITE用)", Range = {10, 200}, Increment = 1, Suffix = "px", CurrentValue = 45, Flag = "TextureSize", Callback = function(v) TextureConfig.Size = v end})

local DefTab = Window:CreateTab("防御", 4483362458)
DefTab:CreateToggle({Name = "アンチグラブ (掴まれたら脱出)", CurrentValue = false, Flag = "AntiGrab", Callback = ToggleAntiGrab})
DefTab:CreateToggle({Name = "アンチバーン (燃焼対策)", CurrentValue = false, Flag = "AntiBurn", Callback = ToggleAntiBurn})
DefTab:CreateToggle({Name = "アンチエクスプロージョン (爆発)", CurrentValue = false, Flag = "AntiExplosion", Callback = ToggleAntiExplosion})
DefTab:CreateToggle({Name = "アンチバナナ (座り対策)", CurrentValue = false, Flag = "AntiBananaSit", Callback = ToggleAntiBananaSit})
DefTab:CreateToggle({Name = "アンチスティッキー", CurrentValue = false, Flag = "AntiSticky", Callback = ToggleAntiSticky})
DefTab:CreateToggle({Name = "アンチペイント", CurrentValue = false, Flag = "AntiPaint", Callback = ToggleAntiPaint})
DefTab:CreateToggle({Name = "アンチAFK", CurrentValue = false, Flag = "AntiAFK", Callback = ToggleAntiAFK})
DefTab:CreateToggle({Name = "アンチヴォイド (奈落)", CurrentValue = false, Flag = "AntiVoid", Callback = ToggleAntiVoid})
DefTab:CreateToggle({Name = "アンチラグドール (死亡無効)", CurrentValue = false, Flag = "AntiRagdoll", Callback = ToggleAntiRagdoll})
DefTab:CreateToggle({Name = "アンチウォーター (水上歩行)", CurrentValue = false, Flag = "AntiWater", Callback = ToggleAntiWater})
DefTab:CreateToggle({Name = "アンチインプットラグ", CurrentValue = false, Flag = "AntiInputLag", Callback = ToggleAntiInputLag})
DefTab:CreateToggle({Name = "アンチキック (グラブ)", CurrentValue = false, Flag = "AntiKickGrab", Callback = ToggleAntiKickGrab})
DefTab:CreateToggle({Name = "アンチキック (手裏剣)", CurrentValue = false, Flag = "AntiKickV2", Callback = ToggleAntiKickV2})
DefTab:CreateToggle({Name = "アンチラグ (軽量化)", CurrentValue = false, Flag = "AntiLag", Callback = ToggleAntiLag})
DefTab:CreateToggle({Name = "自動リスポーン", CurrentValue = false, Flag = "AutoRespawn", Callback = function(val) ToggleAutoRespawn(val, "Spawn") end})
DefTab:CreateToggle({Name = "オートアタッカー (自動反撃)", CurrentValue = false, Flag = "AutoAttacker", Callback = function(val) ToggleAutoAttacker(val, "Death") end})
DefTab:CreateDropdown({Name = "反撃モード", Options = {"Death", "Knockback", "airSuspend", "Freeze"}, CurrentOption = {"Death"}, Flag = "AttackerMode", Callback = function(option) Defense.AttackerMode = option[1] end})

local UITab = Window:CreateTab("設定", 4483362458)
UITab:CreateButton({Name = "UIを閉じる (アンロード)", Callback = function() StopTextureSystem() StopCosmicSystem() Rayfield:Destroy() end})

JapanNotify("Japan HUB 起動完了。")
