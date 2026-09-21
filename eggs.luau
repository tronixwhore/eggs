local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local vfxSource = RS:WaitForChild("Assets"):WaitForChild("Particles"):WaitForChild("EggRarityVFX"):WaitForChild("RarityNumber9+")
local modelKitsune = RS:WaitForChild("Assets"):WaitForChild("Models"):WaitForChild("Eggs"):WaitForChild("Kitsune")

local aetheronFolder = RS:WaitForChild("Assets"):WaitForChild("Models"):WaitForChild("Eggs"):WaitForChild("Aetheron")
local modelAetheron = aetheronFolder:WaitForChild("fusedegg2")

local function getNest()
	local objects = workspace:FindFirstChild("__OBJECTS")
	if objects then
		local nests = objects:FindFirstChild("Nests", true)
		if nests then
			local children = nests:GetChildren()
			return children[5] or children[1]
		end
	end
	return workspace:FindFirstChild("NestModel", true) or workspace:FindFirstChild("Nest", true)
end

local function attachVFX(eggClone, particleScale, doubleSpeed)
	if not vfxSource:FindFirstChild("FX") then return end
	
	local centerCFrame, _ = eggClone:GetBoundingBox()
	
	local centerAnchor = Instance.new("Part")
	centerAnchor.Name = "VFX_Center"
	centerAnchor.Size = Vector3.new(0.1, 0.1, 0.1)
	centerAnchor.Transparency = 1
	centerAnchor.CanCollide = false
	centerAnchor.Anchored = true
	centerAnchor.CFrame = centerCFrame
	centerAnchor.Parent = eggClone

	local fx = vfxSource.FX:Clone()
	fx.Parent = centerAnchor
	
	for _, emitter in ipairs(fx:GetChildren()) do
		if emitter:IsA("ParticleEmitter") then
			emitter.Enabled = true
			
			local currentSize = emitter.Size.Keypoints
			local newKeypoints = {}
			for i, keypoint in ipairs(currentSize) do
				table.insert(newKeypoints, NumberSequenceKeypoint.new(keypoint.Time, keypoint.Value * particleScale))
			end
			emitter.Size = NumberSequence.new(newKeypoints)
			
			if doubleSpeed then
				emitter.Speed = NumberRange.new(emitter.Speed.Min * 2, emitter.Speed.Max * 2)
			end
		end
	end
end

local function spawnKitsune()
	local eggSize = 5             
	local nestSize = eggSize * 1.35
	local eggUpOffset = eggSize * 3

	local hitPos = mouse.Hit
	if not hitPos then return end
	
	local nestSource = getNest()
	if not nestSource then return end

	local baseCFrame = CFrame.new(hitPos.Position + Vector3.new(0, 0.5, 0))

	local nestClone = nestSource:Clone()
	if nestClone:IsA("Model") then
		nestClone:ScaleTo(nestSize)
	end
	nestClone:PivotTo(baseCFrame)
	for _, part in ipairs(nestClone:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored = true
			part.CanCollide = true
		end
	end
	nestClone.Parent = workspace

	local eggClone = modelKitsune:Clone()
	eggClone:ScaleTo(eggSize)
	eggClone:PivotTo(baseCFrame * CFrame.new(0, eggUpOffset, 0))
	for _, part in ipairs(eggClone:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored = true
			part.CanCollide = true
		end
	end
	eggClone.Parent = workspace

	attachVFX(eggClone, eggSize * 0.5, true)
end

local function spawnAetheron()
	local eggSize = 0.2          
	local nestScale = 4          
	local eggInsideNestY = 15    

	local hitPos = mouse.Hit
	if not hitPos then return end
	
	local nestSource = getNest()
	if not nestSource then return end

	local baseCFrame = CFrame.new(hitPos.Position)

	local nestClone = nestSource:Clone()
	if nestClone:IsA("Model") then
		nestClone:ScaleTo(nestScale)
	end
	nestClone:PivotTo(baseCFrame)
	for _, part in ipairs(nestClone:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored = true
			part.CanCollide = true
		end
	end
	nestClone.Parent = workspace

	local eggClone = modelAetheron:Clone()
	eggClone:ScaleTo(eggSize)
	eggClone:PivotTo(baseCFrame * CFrame.new(0, eggInsideNestY, 0))
	for _, part in ipairs(eggClone:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored = true
			part.CanCollide = true
		end
	end
	eggClone.Parent = workspace

	attachVFX(eggClone, 0.7, false)
end

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	
	if input.KeyCode == Enum.KeyCode.J then
		spawnKitsune()
	elseif input.KeyCode == Enum.KeyCode.Y then
		spawnAetheron()
	end
end)
