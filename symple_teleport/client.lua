local QBCore = exports['qb-core']:GetCoreObject()
local isPolice = false
local teleportPoints = {
    start = vector4(1515.13, 779.3, 77.44, 326.99),
    destination = vector4(184.17, 6634.78, 31.54, 188.72)
}


-- Function to create blips
local function CreateBlips()
    -- Create blip for start location
    local startBlip = AddBlipForCoord(teleportPoints.start.x, teleportPoints.start.y, teleportPoints.start.z)
    SetBlipSprite(startBlip, 1)
    SetBlipDisplay(startBlip, 4)
    SetBlipScale(startBlip, 0.5)
    SetBlipColour(startBlip, 38)
    SetBlipAsShortRange(startBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Police Teleport Start")
    EndTextCommandSetBlipName(startBlip)

    -- Create blip for destination
    local destBlip = AddBlipForCoord(teleportPoints.destination.x, teleportPoints.destination.y, teleportPoints.destination.z)
    SetBlipSprite(destBlip, 1)
    SetBlipDisplay(destBlip, 4)
    SetBlipScale(destBlip, 0.5)
    SetBlipColour(destBlip, 38)
    SetBlipAsShortRange(destBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Police Teleport End")
    EndTextCommandSetBlipName(destBlip)
    
    return {startBlip, destBlip}
end

-- Function to remove blips
local function RemoveBlips()
    for _, blip in ipairs(blips or {}) do
        if DoesBlipExist(blip) then RemoveBlip(blip) end
    end
end

-- Function to check if player is in a vehicle
local function IsPlayerInVehicle()
    local ped = PlayerPedId()
    return IsPedInAnyVehicle(ped, false)
end

-- Function to teleport player and vehicle
local function TeleportPlayerAndVehicle(coords)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle ~= 0 then
        SetEntityCoords(vehicle, coords.x, coords.y, coords.z)
        SetEntityHeading(vehicle, coords.w)
        SetVehicleOnGroundProperly(vehicle)
    end
end

-- Function to check if player is near a point
local function IsNearPoint(point, distance)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local pointCoords = vector3(point.x, point.y, point.z)
    return #(playerCoords - pointCoords) < distance
end

-- Central function to manage police status and associated UI
local function SetPoliceStatus(isCopOnDuty)
    if isPolice == isCopOnDuty then return end -- No change, do nothing

    isPolice = isCopOnDuty
    if isPolice then
        blips = CreateBlips()
        QBCore.Functions.Notify('Police teleport system activated', 'success')
    else
        RemoveBlips()
        QBCore.Functions.Notify('Police teleport system deactivated', 'error')
    end
end

-- Set initial status when player loads in
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    local playerData = QBCore.Functions.GetPlayerData()
    local isCopOnDuty = playerData.job and playerData.job.name == "police" and playerData.job.onduty
    SetPoliceStatus(isCopOnDuty)
end)

-- Listen for job updates and set police status accordingly
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    local isCopOnDuty = job and job.name == "police" and job.onduty
    SetPoliceStatus(isCopOnDuty)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        -- Check if player is near the teleport points
        if IsNearPoint(teleportPoints.start, 2.0) then
            if isPolice then
                DrawText3D(teleportPoints.start.x, teleportPoints.start.y, teleportPoints.start.z, "Press ~g~E~w~ to teleport to destination")
                if IsControlJustPressed(0, 38) and IsPlayerInVehicle() then -- 38 is E key
                    TeleportPlayerAndVehicle(teleportPoints.destination)
                end
            else
                DrawText3D(teleportPoints.start.x, teleportPoints.start.y, teleportPoints.start.z, "~r~Police Only")
            end
        elseif IsNearPoint(teleportPoints.destination, 2.0) then
            if isPolice then
                DrawText3D(teleportPoints.destination.x, teleportPoints.destination.y, teleportPoints.destination.z, "Press ~g~E~w~ to teleport back")
                if IsControlJustPressed(0, 38) and IsPlayerInVehicle() then
                    TeleportPlayerAndVehicle(teleportPoints.start)
                end
            else
                DrawText3D(teleportPoints.destination.x, teleportPoints.destination.y, teleportPoints.destination.z, "~r~Police Only")
            end
        end
    end
end)

-- Function to draw 3D text
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end