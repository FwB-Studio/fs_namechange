
 

RegisterNetEvent('fs_namechange:openui')
AddEventHandler('fs_namechange:openui',function()
    ESX.TriggerServerCallback('fs_namechange:checkmoney', function(has)
        if has then
            SetNuiFocus(true, true)
            SendNUIMessage({
                display = 'true',
            })
        else
            ESX.ShowNotification("You don't have enough money")
        end    
       
    end) 

end)

 


RegisterNUICallback('fs_namechangeexit', function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        display = 'false',
    })
 
    if (#data.firstname) > 0 and (#data.lastname) > 0 then
        ESX.TriggerServerCallback('fsnamechange:removemoney', function(removed)
            if removed then
                TriggerServerEvent('fs_namechanger:savename', data.firstname, data.lastname)
            else
                ESX.ShowNotification("You don't have enough money")

            end
        
        end)
    else
        ESX.ShowNotification("Empty name not updated.")
    end
 end)



local pedspawned = false
local nameped


function registertarget(target)
  
    exports.qtarget:AddTargetEntity(target, {
        options = {
            {
                icon = "fa-solid fa-address-card",
                label = "Change Name",
                event = 'fs_namechange:openui'
            },
             
        },
        distance = 2

    })       
end
 
RegisterNUICallback('fs_namechangeclose', function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        display = 'false',
    })
end)


CreateThread(function()
    while true do
        local sleep = 1000
        local playercoords = GetEntityCoords(PlayerPedId())
        local pedcoords = Config.settings.pedlocation
        local distance = #(playercoords - vector3(pedcoords.x,pedcoords.y,pedcoords.z))
 
 
        if distance <= 10 and not pedspawned then
            local modelHash = Config.settings.pedmodel
                RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Wait(0)
            end
            nameped = CreatePed(1, Config.settings.pedmodel, pedcoords.x,pedcoords.y,pedcoords.z-1.0, pedcoords.w, false,true)
             
            pedspawned = true
            
            registertarget(nameped)
            FreezeEntityPosition(nameped, true)
            SetEntityInvincible(nameped, true)
	        SetBlockingOfNonTemporaryEvents(nameped, true)
	        TaskStartScenarioInPlace(nameped, "WORLD_HUMAN_COP_IDLES", 0, true)
        end

        if distance >= 11 and pedspawned then
            pedspawned = false
 
            FreezeEntityPosition(nameped, false)
            SetPlayerInvincible(nameped, false)
            SetPedModelIsSuppressed(nameped, false)
            DeletePed(nameped)
            SetPedAsNoLongerNeeded(nameped)
        end
        Wait(sleep)
    end
end)


CreateThread(function()
    if Config.settings.blip.enable then
        local blip = AddBlipForCoord(Config.settings.pedlocation.x, Config.settings.pedlocation.y, Config.settings.pedlocation.z)
        SetBlipAsShortRange(blip, Config.settings.blip.shortrange)
        SetBlipScale(blip, Config.settings.blip.scale)
        SetBlipSprite(blip, Config.settings.blip.sprite)
        SetBlipColour(blip, Config.settings.blip.color)
        BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(Config.settings.blip.label)
		EndTextCommandSetBlipName(blip)
    end
end)