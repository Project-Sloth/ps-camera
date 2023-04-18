local QBCore = exports['qb-core']:GetCoreObject()
local json = require("json")

-- Add Discord webhook here.
local webhook = "https://discord.com/api/webhooks/1092328311235018752/Wk77hKe1KXH7Ltg3DF5uC1jDOKg_3F-NolpClxHyqgS_qgHd5z5fCX-xn7qsX4THjKcM"

RegisterNetEvent("ps-camera:cheatDetect", function()
    DropPlayer(source, "Cheater Detected")
end)

RegisterNetEvent("ps-camera:grabHook", function(Key)
    local event = ("ps-camera:grabbed%s"):format(Key)
    TriggerClientEvent(event, source, webhook)
end)

RegisterNetEvent("ps-camera:CreatePhoto", function(url)
    local source = source
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return end

    local coords = GetEntityCoords(GetPlayerPed(source))
    local location = {
        x = coords.x,
        y = coords.y,
        z = coords.z
    }

    local info = {
        image = url,
        location = location
    }
    player.Functions.AddItem("photo", 1, nil, info)
end)


QBCore.Functions.CreateUseableItem("camera", function(source, item)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName(item.name) then
        TriggerClientEvent("ps-camera:useCamera", source)
    end
end)

QBCore.Functions.CreateUseableItem("photo", function(source, item)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName(item.name) then
        TriggerClientEvent("ps-camera:usePhoto", source, item.info.image, item.info.location)
    end
end)

function UseCam(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName('camera') then
        TriggerClientEvent("ps-camera:useCamera", src)
    else
        TriggerClientEvent('QBCore:Notify', src, "U don\'t have a camera", "error")
    end
end

exports("UseCam", UseCam)