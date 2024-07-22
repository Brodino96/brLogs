----------------------- # ----------------------- # ----------------------- # -----------------------

ESX, QB = nil, nil
ESX = exports["es_extended"]:getSharedObject()
if Config.framework == "ESX" then
end

----------------------- # ----------------------- # ----------------------- # -----------------------

local function getRpName(id)
    if Config.framework == "ESX" then
        return ESX.GetPlayerFromId(id).getName()
    end
end

----------------------- # ----------------------- # ----------------------- # -----------------------

RegisterNetEvent("brLogs:getPlayerName")
AddEventHandler("brLogs:getPlayerName", function (id)
    TriggerClientEvent("brLogs:recivedPlayerName", source, getRpName(id))
end)

----------------------- # ----------------------- # ----------------------- # -----------------------