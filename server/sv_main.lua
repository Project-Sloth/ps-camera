local QBCore = exports['qb-core']:GetCoreObject()

SvConfig = {
    Inv = "qb", -- qb(=lj) or ox [Inventory system]
    webhook = "", -- Add Discord webhook
    FivemerrApiToken = '',
}
local function ConfigInvInvalid()
    print('^1[Error] Your SvConfig.Inv isnt set.. you probably had a typo\nYou have it set as= SvConfig.Inv = "'.. SvConfig.Inv .. '"')
end

RegisterNetEvent("ps-camera:cheatDetect", function()
    DropPlayer(source, "Cheater Detected")
end)

RegisterNetEvent("ps-camera:requestWebhook", function(Key)
    local source = source
    local event = ("ps-camera:grabbed%s"):format(Key)

    if SvConfig.webhook == '' then
        print("^1[Error] A webhook is missing in: SvConfig.webhook")
    else
        TriggerClientEvent(event, source, SvConfig.webhook)
    end
end)

RegisterNetEvent('ps-camera:requestFivemerrToken', function(Key)
    local source = source
    local event = ("ps-camera:grabbed%s"):format(Key)

    if Config.UseFivemerr == false then
        return print("^1[Error] Requesting Fivemerr token but Config.UseFivemerr set to false.")
    end

    if SvConfig.FivemerrApiToken == '' then
        return print("^1[Error] Your Fivemerr API Token is missing in: Config.FivemerrApiToken")
    end

    TriggerClientEvent(event, source, SvConfig.FivemerrApiToken)
end)

RegisterNetEvent("ps-camera:CreatePhoto", function(url)
    local source = source
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return end

    local coords = GetEntityCoords(GetPlayerPed(source))

    TriggerClientEvent("ps-camera:getStreetName", source, url, coords)
end)

RegisterNetEvent("ps-camera:savePhoto", function(url, streetName)
    
    local source = source
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return end

    local location = streetName

    local info = {
        ps_image = url,
        location = location
    }
    if not (SvConfig.Inv == "qb" or SvConfig.Inv == "ox") then 
        ConfigInvInvalid()
        return;
    end
    
    if SvConfig.Inv == "qb" then
        player.Functions.AddItem("photo", 1, nil, info)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['photo'], "add")
    elseif SvConfig.Inv == "ox" then
        local ox_inventory = exports.ox_inventory
        
        if not ox_inventory:CanCarryItem(source, 'photo', 1) then
			return TriggerClientEvent('QBCore:Notify', source, "Can not carry photo!", "error")
		end

        ox_inventory:AddItem(source, "photo", 1, info)
        
    end
end)


QBCore.Functions.CreateUseableItem("camera", function(source, item)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    if not (SvConfig.Inv == "qb" or SvConfig.Inv == "ox") then 
        ConfigInvInvalid()
        return;
    end

    if Config.UseFivemerr == false then
        if not SvConfig.webhook or SvConfig.webhook == nil or SvConfig.webhook == "" then 
            print("^1[Error] A webhook is missing in: SvConfig.webhook")
            return;
        end
    else
        if not SvConfig.FivemerrApiToken or SvConfig.FivemerrApiToken == '' then
            return print("^1[Error] A webhook is missing in: SvConfig.FivemerrApiToken")
        end
    end

    if SvConfig.Inv == "qb" then
        if Player.Functions.GetItemByName(item.name) then
            TriggerClientEvent("ps-camera:useCamera", source)
        end
    elseif SvConfig.Inv == "ox" then
        local ox_inventory = exports.ox_inventory
        if ox_inventory:GetItem(source, item.name, nil, true) > 0 then
            TriggerClientEvent("ps-camera:useCamera", source)
        end
    end
    
end)

QBCore.Functions.CreateUseableItem("photo", function(source, item)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    if not (SvConfig.Inv == "qb" or SvConfig.Inv == "ox") then 
        ConfigInvInvalid()
        return;
    end

    if SvConfig.Inv == "qb" then
        if Player.Functions.GetItemByName(item.name) then
            TriggerClientEvent("ps-camera:usePhoto", source, item.info.ps_image, item.info.location)
        end
    elseif SvConfig.Inv == "ox" then
        local ox_inventory = exports.ox_inventory
        if ox_inventory:GetItem(source, item.name, nil, true) > 0 then
            TriggerClientEvent("ps-camera:usePhoto", source, item.metadata.ps_image, item.metadata.location)
        end
    end
end)

function UseCam(source)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    if not (SvConfig.Inv == "qb" or SvConfig.Inv == "ox") then 
        ConfigInvInvalid()
        return;
    end

    if not SvConfig.webhook or SvConfig.webhook == nil or SvConfig.webhook == "" then 
        print("^1[Error] A webhook is missing in: SvConfig.webhook")
        return;
    end

    if SvConfig.Inv == "qb" then
        if Player.Functions.GetItemByName('dslrcamera') then
            TriggerClientEvent("ps-camera:useCamera", source)
        else
            TriggerClientEvent('QBCore:Notify', source, "U don\'t have a camera", "error")
        end
    elseif SvConfig.Inv == "ox" then
        local ox_inventory = exports.ox_inventory
        if ox_inventory:GetItem(source, 'dslrcamera', nil, true) > 0 then
            TriggerClientEvent("ps-camera:useCamera", source)
        else
            TriggerClientEvent('QBCore:Notify', source, "U don\'t have a camera", "error")
        end
    end    
end

exports("UseCam", UseCam)
