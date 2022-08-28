local FormatOperations = {}

function FormatOperations.FormatPrice(price)
    return "$"..FormatOperations.FormatNumber(price)
end

function FormatOperations.FormatNumber(num)
    num = tostring(num)
    return num:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

function FormatOperations.ToDHMS(seconds)
	return string.format("%01i:%02i:%02i:%02i", seconds/86400, seconds/60^2%24, seconds/60%60, seconds%60)
end

function FormatOperations.ToHMS(seconds)
	return string.format("%02i:%02i:%02i", seconds/60^2, seconds/60%60, seconds%60)
end

function FormatOperations.ToMS(seconds)
    return string.format("%01im %02is", seconds/60%60, seconds%60)
end

return FormatOperations