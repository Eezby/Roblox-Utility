local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local ProtectedTeleport = {}
ProtectedTeleport.PlayerTeleportInfo = {}

function ProtectedTeleport.Teleport(placeId: number, players: any, teleportOptions: any)
    if typeof(players) ~= "table" then players = {players} end

    local optionObject = Instance.new("TeleportOptions")
    optionObject:SetTeleportData(teleportOptions)

    for _,player in players do
        ProtectedTeleport.PlayerTeleportInfo[player] = {
            placeId = placeId,
            originalTeleportOptions = teleportOptions
        }
    end

    local success, teleportResult = false, nil
    repeat
        success, teleportResult = pcall(function() return TeleportService:TeleportAsync(placeId, players, optionObject) end)

        if not success then
            task.wait(0.1)
        end
    until success

    for _,player in players do
        local playerTeleportInfo = ProtectedTeleport.PlayerTeleportInfo[player]
        if playerTeleportInfo then
            playerTeleportInfo.PrivateServerId = teleportResult.PrivateServerId
            playerTeleportInfo.ReservedServerAccessCode = teleportResult.ReservedServerAccessCode
        end
    end

    return teleportResult
end

TeleportService.TeleportInitFailed:Connect(function(player, teleportResult)
    if teleportResult == Enum.TeleportResult.Failure or teleportResult == Enum.TeleportResult.Flooded then
        local playerTeleportInfo = ProtectedTeleport.PlayerTeleportInfo[player]
        if ProtectedTeleport.PlayerTeleportInfo[player] then
            ProtectedTeleport.Teleport(playerTeleportInfo.placeId, player, {
                ReservedServerAccessCode = playerTeleportInfo.ReservedServerAccessCode,
                ServerInstanceId = playerTeleportInfo.originalTeleportOptions.ServerInstanceId
            })
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if ProtectedTeleport.PlayerTeleportInfo[player] then
        ProtectedTeleport.PlayerTeleportInfo[player] = nil
    end
end)

return ProtectedTeleport