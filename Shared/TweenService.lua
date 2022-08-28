local TweenService = game:GetService("TweenService")

local TweenModule = {}

-- POST: Creates a Tween object, maps the given properties, and returns the object
function TweenModule.Tween(object, goal, properties)
	local tweenData = {
		Time = 0.5,
		Style = "Linear",
		Dir = "Out",
		Repeat = 0,
		Reverse = false,
		Delay = 0
	}

	for property, value in properties do
		tweenData[property] = value
	end

	local tweenInfo = TweenInfo.new(
		tweenData.Time,
		Enum.EasingStyle[tweenData.Style],
		Enum.EasingDirection[tweenData.Dir],
		tweenData.Repeat,
		tweenData.Reverse,
		tweenData.Delay
	)

	local tween = TweenService:Create(object, tweenInfo, goal)
	tween:Play()

	return tween
end

return TweenModule
