local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local camera = false
local photo = false
local fov_max = 80.0
local fov_min = 5.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 10.0 -- camera zoom speed
local speed_lr = 8.0 -- speed by which the camera pans left-right
local speed_ud = 8.0 -- speed by which the camera pans up-down
local fov = (fov_max+fov_min)*0.5

local cameraprop = nil
local photoprop = nil

local Functions = exports[GetCurrentResourceName()]

local function grabWebhook()
    local newEvent = nil
    local p = promise.new()
    local Key = Functions.Key()
    local event = ("ps-camera:grabbed%s"):format(Key)
    RegisterNetEvent(event)
    newEvent = AddEventHandler(event, function(hook)
        newEvent = RemoveEventHandler(newEvent)
        p:resolve(hook)
    end)
    TriggerServerEvent("ps-camera:requestWebhook", Key)
    return Citizen.Await(p)
end

RegisterNetEvent("ps-debug", function()
    print("Player Cheating")
end)

local function HideHUDThisFrame()
    HideHelpTextThisFrame()
    HideHudAndRadarThisFrame()
    HideHudComponentThisFrame(1)
    HideHudComponentThisFrame(2)
    HideHudComponentThisFrame(3) 
    HideHudComponentThisFrame(4)
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(8)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(13)
    HideHudComponentThisFrame(11)
    HideHudComponentThisFrame(12)
    HideHudComponentThisFrame(15)
    HideHudComponentThisFrame(18)
    HideHudComponentThisFrame(19)
end

local function CheckInputRotation(cam, zoomvalue)
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    local rotation = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        local new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
        local new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
        SetCamRot(cam, new_x, 0.0, new_z, 2)
        -- Moves the entities body if they are not in a vehicle (else the whole vehicle will rotate as they look around :P)
        if not IsPedSittingInAnyVehicle(PlayerPedId()) then
            SetEntityHeading(PlayerPedId(), new_z)
        end
    end
end

local function HandleZoom(cam)
    local lPed = PlayerPedId()
    if not IsPedSittingInAnyVehicle(lPed) then
        if IsControlJustPressed(0,241) then
            fov = math.max(fov - zoomspeed, fov_min)
        end
        if IsControlJustPressed(0,242) then
            fov = math.min(fov + zoomspeed, fov_max)
        end
        local current_fov = GetCamFov(cam)
        if math.abs(fov-current_fov) < 0.1 then
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
    else
        if IsControlJustPressed(0,17) then
            fov = math.max(fov - zoomspeed, fov_min)
        end
        if IsControlJustPressed(0,16) then
            fov = math.min(fov + zoomspeed, fov_max)
        end
        local current_fov = GetCamFov(cam)
        if math.abs(fov-current_fov) < 0.1 then
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
    end
end

local function SharedRequestAnimDict(animDict, cb)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
	end
	if cb ~= nil then
		cb()
	end
end

local function LoadPropDict(model)
    while not HasModelLoaded(GetHashKey(model)) do
        RequestModel(GetHashKey(model))
        Wait(10)
    end
end

local function GetStreetNames()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local streetName, crossingRoad = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    local streetNameText = GetStreetNameFromHashKey(streetName)
    local crossingRoadText = ""

    if crossingRoad ~= 0 then
        crossingRoadText = GetStreetNameFromHashKey(crossingRoad)
    end

    return streetNameText, crossingRoadText
end

function SetLocation()
    local streetName, crossingRoad = GetStreetNames()

    if crossingRoad ~= "" then
        SendNUIMessage({action = "SetLocation", location = streetName .. " & " .. crossingRoad})
    else
        SendNUIMessage({action = "SetLocation", location = streetName})
    end
end

function CameraLoop()
    local ped = PlayerPedId()

    SharedRequestAnimDict("amb@world_human_paparazzi@male@base", function()
        TaskPlayAnim(ped, "amb@world_human_paparazzi@male@base", "base", 2.0, 2.0, -1, 1, 0, false, false, false)
    end)

    local x, y, z = table.unpack(GetEntityCoords(ped))

    if not HasModelLoaded("ps_camera") then
        LoadPropDict("ps_camera")
    end

    cameraprop = CreateObject(GetHashKey("ps_camera"), x, y, z + 0.2, true, true, true)
    AttachEntityToEntity(cameraprop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded("ps_camera")

    CreateThread(function()
        local lPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(lPed)
        local hook = grabWebhook()
        Wait(500)

        SetTimecycleModifier("default")
        SetTimecycleModifierStrength(0.3)

        local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
        AttachCamToEntity(cam, lPed, 0.0, 1.0, 0.8, true)
        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(lPed), 2)
        SetCamFov(cam, fov)
        RenderScriptCams(true, false, 0, true, false)

        while camera and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == vehicle) do
            if IsControlJustPressed(0, 177) then
                camera = false
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                ClearPedTasks(lPed)
                if cameraprop then DeleteEntity(cameraprop) end
            elseif IsControlJustPressed(1, 176) then
                PlaySoundFrontend(-1, "Camera_Shoot", "Phone_Soundset_Franklin", false)
                exports['screenshot-basic']:requestScreenshotUpload(tostring(hook), "files[]", function(data)
                    local image = json.decode(data)
                    camera = false
                    if cameraprop then DeleteEntity(cameraprop) end
                    ClearPedTasks(lPed)
                    TriggerServerEvent("ps-camera:CreatePhoto", json.encode(image.attachments[1].proxy_url))
					SendNUIMessage({action = "SavePic", pic = json.encode(image.attachments[1].proxy_url)})
                    SendNUIMessage({action = "hideOverlay"})
                end)
            end

            local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
            CheckInputRotation(cam, zoomvalue)
            HandleZoom(cam)
            HideHUDThisFrame()
            Wait(0)
        end

        camera = false
        ClearTimecycleModifier()
        fov = (fov_max + fov_min) * 0.5
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(cam, false)
        SetNightvision(false)
        SetSeethrough(false)
        SendNUIMessage({action = "hideOverlay"})
    end)
end

RegisterNetEvent("ps-camera:getStreetName", function(url, coords)
    local streetHash, crossingHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetName = GetStreetNameFromHashKey(streetHash)

    TriggerServerEvent("ps-camera:savePhoto", url, streetName)
end)


RegisterNetEvent("ps-camera:usePhoto", function(url, location)
    photo = not photo

    if photo then
        SetNuiFocus(true, true);
        SendNUIMessage({action = "openPhoto", image = url, location = location})

        local ped = PlayerPedId()
        SharedRequestAnimDict("amb@world_human_tourist_map@male@base", function()
            TaskPlayAnim(ped, "amb@world_human_tourist_map@male@base", "base", 2.0, 2.0, -1, 1, 0, false, false, false)
        end)

        local coords = GetEntityCoords(ped)
        
        if not HasModelLoaded("prop_cs_planning_photo") then
            LoadPropDict("prop_cs_planning_photo")
        end

        photoprop = CreateObject(`prop_cs_planning_photo`, coords.x, coords.y, coords.z+0.2,  true,  true, true)
        AttachEntityToEntity(photoprop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        SetModelAsNoLongerNeeded("prop_cs_planning_photo")
    end
end)


RegisterNUICallback("close", function()
    SetNuiFocus(false, false)
    photo = false

    if photoprop then
        DeleteEntity(photoprop)
    end

    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('ps-camera:useCamera', function()
    camera = not camera

    if camera then
        SendNUIMessage({action = "showOverlay"})

        CameraLoop()
    else
        local playerPed = PlayerPedId()
        ClearPedTasks(playerPed)
        if cameraprop then
            DeleteEntity(cameraprop)
        end
        SendNUIMessage({action = "hideOverlay"})
    end
end)
