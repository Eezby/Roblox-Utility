local MemeoryStoreService = game:GetService("MemoryStoreService")
local MessagingService = game:GetService("MessagingService")

local MAX_API_RETRIES = 10
local FORTY_FIVE_DAYS = 45 * 24 * 60 * 60

local Signal = require(script.Signal)

-- Retries a function with a small wait between each try up to a max of 'triesLeft'
local function retryFunction(triesLeft, func)
	local success, result = pcall(func)

	if not success and triesLeft > 0 then
		warn(result)
		task.wait(0.1)
		return retryFunction(triesLeft-1, func)
	end

	return success, result
end

local RemoteConfig = {}
RemoteConfig.FlagMap = MemeoryStoreService:GetSortedMap("Flags")
RemoteConfig.FlagSignals = {}

function RemoteConfig.SetFlag(flag, state)
    local status = retryFunction(MAX_API_RETRIES, function()
		RemoteConfig.FlagMap:SetAsync(flag, state, FORTY_FIVE_DAYS)
	end)

    if status then
        retryFunction(MAX_API_RETRIES, function()
            MessagingService:PublishAsync("RemoteConfig", {
                action = "flag",
                flag = flag,
                state = state
            })
        end)
    end
end

function RemoteConfig.IsFlagEnabled(flag)
    return retryFunction(MAX_API_RETRIES, function()
		return (RemoteConfig.FlagMap:GetAsync(flag) ~= false) and true
	end)
end

function RemoteConfig.GetFlagChangedSignal(flag)
    if not RemoteConfig.FlagSignals[flag] then
        RemoteConfig.FlagSignals[flag] = Signal.new()
    end

    return RemoteConfig.FlagSignals[flag]
end

local status = retryFunction(MAX_API_RETRIES, function()
    return MessagingService:SubscribeAsync("RemoteConfig", function(message)
        local data = message.Data
        local action = data.action

        if action == "flag" then
            local flagSignal = RemoteConfig.GetFlagChangedSignal(data.flag)
            flagSignal:Fire(data.state)
        end
    end)
end)

if not status then warn("FATAL FAILURE: MessagingService could not subscribe to RemoteConfig") end

return RemoteConfig