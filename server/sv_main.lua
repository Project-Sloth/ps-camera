local ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- Add Discord webhook here.
local webhook = ""

RegisterNetEvent("ps-camera:cheatDetect", function()
    DropPlayer(source, "Cheater Detected")
end)

RegisterNetEvent("ps-camera:requestWebhook", function(Key)
    local source = source
    local event = ("ps-camera:grabbed%s"):format(Key)
    TriggerClientEvent(event, source, webhook)
end)

RegisterNetEvent("ps-camera:CreatePhoto", function(url, streetName)
    local source = source
    local player = ESX.GetPlayerFromId(source)
    if not player then return end

    local info = {
        metaimage = url,
        metalocation = streetName,
        type = streetName,
        description = " Taken on " .. os.date("%Y-%m-%d") .. '  \n  Time - ' ..os.date("%I : %M")
    }
    exports.ox_inventory:AddItem(source, 'photo', 1, info)
end)