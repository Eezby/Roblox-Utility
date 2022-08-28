local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Utility = ReplicatedStorage:WaitForChild("Utility")
local TweenService = require(Utility:WaitForChild("TweenService"))

local function createBasicPart()
	local rayPart = Instance.new("Part")
	rayPart.Anchored = true
	rayPart.CanCollide = false
	rayPart.Material = "Neon"
	
	return rayPart
end

local Robug = {}

function Robug.Ray(origin, direction, results, color)
	local hitLocation = origin + direction
	
	if results then
		if results.Position then
			hitLocation = results.Position
		end
	end
	
	local rayPart = createBasicPart()
	rayPart.Color = color or Color3.fromRGB(255,255,255)
	rayPart.Transparency = 1
	rayPart.Size = Vector3.new(0.1, 0.1, (origin - hitLocation).Magnitude)
	rayPart.CFrame = CFrame.new((origin + hitLocation)/2, hitLocation + direction*1000)
	rayPart.Parent = workspace
	
	local goal = {Transparency = 0}
	local properties = {Time = 0.05}
	local tween = TweenService.tween(rayPart, goal, properties)
	
	coroutine.wrap(function()
		tween.Completed:Wait()

		local goal = {Transparency = 1}
		local properties = {Time = 1}
		local tween = TweenService.tween(rayPart, goal, properties)
		
		tween.Completed:Wait()
		
		rayPart:Destroy()
	end)()
end

function Robug.Radius(origin, radius, color)
    local sphere = Instance.new("Part")
    sphere.Transparency = 1
    sphere.Material = "ForceField"
    sphere.Shape = "Ball"
    sphere.Size = Vector3.new(radius*2, radius*2, radius*2)
    sphere.Anchored = true
    sphere.CanCollide = false
    sphere.Color = color
    sphere.CFrame = CFrame.new(origin)
    sphere.Parent = workspace

    local goal = {Transparency = 0}
    local properties = {Time = 0.5}
    local tween = TweenService.tween(sphere, goal, properties)

    coroutine.wrap(function()
        tween.Completed:Wait()

        local goal = {Transparency = 1, Size = Vector3.new(0.1,0.1,0.1)}
		local properties = {Time = 1}
		local tween = TweenService.tween(sphere, goal, properties)
		
		tween.Completed:Wait()
		
		sphere:Destroy()
    end)()
end

function Robug.UiPosition(position, color)
	local screenGui = Instance.new("ScreenGui")
	screenGui.DisplayOrder = 999
	screenGui.Parent = game.Players.LocalPlayer.PlayerGui

	local newUi = Instance.new("Frame")
	newUi.AnchorPoint = Vector2.new(0.5,0.5)
	newUi.Size = UDim2.fromOffset(15,15)
	newUi.BackgroundColor3 = color or Color3.fromRGB(255,255,255)
	newUi.BorderSizePixel = 0
	newUi.Position = position --+ UDim2.fromOffset(newUi.AbsoluteSize.X/2, newUi.AbsoluteSize.Y/2)
	newUi.Parent = screenGui

	game.Debris:AddItem(screenGui, 1)
end

return Robug
