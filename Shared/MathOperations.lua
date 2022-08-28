local MathOperations = {}

function MathOperations.GetDistance(position1, position2)
    return (position1 - position2).Magnitude
end

function MathOperations.GetDirection(from, to)
    return (to - from).Unit
end

function MathOperations.Round(num, decimalPlaces)
    local tenExponent = 10^decimalPlaces
    return math.floor(num * tenExponent + 0.5) / tenExponent
end

return MathOperations