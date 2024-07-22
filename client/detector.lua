----------------------- # ----------------------- # ----------------------- # -----------------------

--[[
Morte da veicolo:
[GIOCATORE] è stato ucciso da un veicolo ([MODEL]) guidato da [GIOCATORE/PED] con passeggeri [ELENCO]

Morte da giocatore:
[GIOCATORE] è stato ucciso da [GIOCATORE] utilizzando [ARMA]

Morte da ped:
[GIOCATORE] è stato ucciso da un ped ([MODEL]), utilizzando [ARMA]

Morte da object:
[GIOCATORE] è stato ucciso da un object ([MODEL])
]]

local status
local playerName = ""

----------------------- # ----------------------- # ----------------------- # -----------------------

local function calculatePed(ped)
    if IsPedAPlayer(ped) then
        TriggerServerEvent("brLogs:getPlayerName", GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped)))
        while playerName == "" do
            Wait(1)
        end
        local nameToReturn = playerName
        playerName = ""
        return nameToReturn
    else
        return GetEntityModel(ped)
    end
end

local function calculateSourceOfDeath(entity)

    if IsEntityAVehicle(entity) then

        local veh = GetEntityModel(entity)
        local vehSeats = GetVehicleModelNumberOfSeats(veh)
        local source = calculatePed(GetPedInVehicleSeat(entity, -1))
        local passengers
        for i = 0, vehSeats do
            passengers = passengers..calculatePed(GetPedInVehicleSeat(entity, i))..", "
        end
        return "da un veicolo ("..veh.."), guidato da ("..source..") con passeggeri ("..passengers..")"
    end

    if IsEntityAPed(entity) then

        if IsPedAPlayer(entity) then
            
            local source = calculatePed(entity)
            local weapon = GetEntityModel(GetPedCauseOfDeath(entity))
            return "da ("..source..") utilizzando ("..weapon..")"
        end
    end
end

local function playerDied(playerPed)
    local sourceOfDeath = calculateSourceOfDeath(GetPedSourceOfDeath(playerPed))
    --local causeOfDeath = calculateCauseOfDeath(GetPedCauseOfDeath(playerPed))
end

local function detector()
    CreateThread(function ()
        while true do
            Wait(0)

            local playerPed = PlayerPedId()
            local isDead = IsEntityDead(playerPed)

            if not isDead then -- If the player is alive then skip this cycle
                goto skip
            end

            if isDead == status then -- If the player was already dead then skip this cycle
                goto skip
            end

            playerDied(playerPed)

            ::skip::
            status = isDead
        end
    end)
end

local function event()
    RegisterNetEvent(Config.death.event)
    AddEventHandler(Config.death.event, function ()
        playerDied(PlayerPedId())
    end)
end

local function init()
    if Config.death.mode == "default" then
        detector()
    end

    if Config.death.mode == "event" then
        event()
    end
end

----------------------- # ----------------------- # ----------------------- # -----------------------

RegisterNetEvent("brLogs:recivedPlayerName")
AddEventHandler("brLogs:recivedPlayerName", function (name)
    playerName = name
end)

----------------------- # ----------------------- # ----------------------- # -----------------------

init()

----------------------- # ----------------------- # ----------------------- # -----------------------