local QBCore = exports['qb-core']:GetCoreObject()

local webhook = "https://discord.com/api/webhooks/1094729185777430599/FYATRwu3-dFNn5bIpu-8IWKpzpKL_sru5lrmFHO1d3gT7hQpzcmKNzt0bf3mXKBPJbbM"

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
    local info = {
        image = url
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
        TriggerClientEvent("ps-camera:usePhoto", source, item.info.image)
    end
end)