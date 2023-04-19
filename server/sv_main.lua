local ESX = exports['es_extended']:getSharedObject()

-- Add Discord webhook here.
local webhook = ""

RegisterNetEvent("ps-camera:cheatDetect", function()
    DropPlayer(source, "Cheater Detected")
end)

RegisterNetEvent("ps-camera:grabHook", function(Key)
    local event = ("ps-camera:grabbed%s"):format(Key)
    TriggerClientEvent(event, source, webhook)
end)

RegisterNetEvent("ps-camera:CreatePhoto", function(url)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local coords = GetEntityCoords(GetPlayerPed(source))

    TriggerClientEvent("ps-camera:getStreetName", source, url, coords)
end)

RegisterNetEvent("ps-camera:savePhoto", function(url, streetName)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local location = streetName

    local metadata = {
        image = url,
        location = location
    }
    xPlayer.addInventoryItem("photo", 1, metadata)
end)


ESX.RegisterUsableItem("camera", function(source, name, item)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local _item = xPlayer.getInventoryItem(name)

    if _item.count > 0 then
        TriggerClientEvent("ps-camera:useCamera", source)
    end
end)

ESX.RegisterUsableItem("photo", function(source, name, item)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local _item = xPlayer.getInventoryItem(name)

    if _item.count > 0 then
        TriggerClientEvent("ps-camera:usePhoto", source, item.metadata.image, item.metadata.location)
    end
end)

function UseCam(source)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.Functions.GetItemByName('camera') then
        TriggerClientEvent("ps-camera:useCamera", src)
    else
        TriggerClientEvent('esx:showNotification', src, "U don\'t have a camera", "error")
    end
end

exports("UseCam", UseCam)