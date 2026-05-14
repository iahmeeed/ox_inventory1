-- Made by Karma Developments with Love <3 

local core = 'qb_core'
local ESX, QBCore, QBX = nil, nil, nil

CreateThread(function()
    GlobalState.usebackpackItem = config.backpack.useitem
    GlobalState.staticbackpack = config.backpack.dynamic
    GlobalState.backpackSettings = {
        slot = config.backpack.slot,
        weight = config.backpack.maxWeight
    }

    Wait(5000)

    if GetResourceState('qbx_core') == 'started' then 
        core = 'qbx_core'
        QBX = exports['qb-core']:GetCoreObject()
        GlobalState.fw = 'qbx'

    elseif GetResourceState('qb_core') == 'started' then
        core = 'qb_core'
        QBCore = exports[config.CoreFolder]:GetCoreObject()
        GlobalState.fw = 'qb'

    elseif GetResourceState('es_extended') == 'started' then
        core = 'es_extended'
        ESX = exports[config.CoreFolder]:getSharedObject()
        GlobalState.fw = 'esx'
    end

    -- Cria stash da mochila se for dinâmica
    if not GlobalState.staticbackpack then 
        exports.ox_inventory:RegisterStash(
            'backpack',
            'Backpack',
            GlobalState.backpackSettings.slot,
            GlobalState.backpackSettings.weight,
            true
        )
    end
end)


-- Verifica se o jogador possui mochila em cache
lib.callback.register('ox_inventory:getbackpackitem', function(source, targetid)
    local TargetState = Player(targetid).state
    return TargetState.backpack ~= nil
end)


-- ESX: pega licença / identificador
lib.callback.register('ox_inventory:esxGetLicense', function(source)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            return xPlayer.getIdentifier()
        end
    end
    return false
end)

-- Pega dinheiro do banco corretamente com export local
function getPlayerBankBalance(source)

    -- ESX
    if core == 'es_extended' then
        local ESX = exports[config.CoreFolder]:getSharedObject()
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            return xPlayer.getAccount('bank').money
        end

    -- QBCore
    elseif core == 'qb_core' then
        local QBCore = exports[config.CoreFolder]:GetCoreObject()
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then
            return xPlayer.PlayerData.money["bank"]
        end

    -- QBX
    elseif core == 'qbx_core' then
        local QBX = exports[config.CoreFolder]:GetCoreObject()
        local player = QBX:GetPlayer(source)
        if player then
            return player.PlayerData.money.bank
        end
    end

    return 0
end


-- Remove dinheiro corretamente do banco
function RemoveMoney(source, amount)

    -- ESX
    if core == 'es_extended' then
        local ESX = exports[config.CoreFolder]:getSharedObject()
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            return xPlayer.removeAccountMoney('bank', amount)
        end

    -- QBCore
    elseif core == 'qb_core' then
        local QBCore = exports[config.CoreFolder]:GetCoreObject()
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then
            return xPlayer.Functions.RemoveMoney('bank', amount)
        end

    -- QBX
    elseif core == 'qbx_core' then
        local QBX = exports[config.CoreFolder]:GetCoreObject()
        local player = QBX:GetPlayer(source)
        if player then
            return player.Functions.RemoveMoney('bank', amount)
        end
    end

    return false
end

RegisterNetEvent('ox_inventory:removeParachute', function()
    local src = source
    exports.ox_inventory:RemoveItem(src, 'parachute', 1)
end)

RegisterNetEvent('ox_inventory:updateArmor', function(value, slot)
    local src = source
    local armor = exports.ox_inventory:GetSlot(src, slot)
    
    if armor and armor.metadata then
        local maxValue = 60 -- Standard armor max
        local maxPlates = 3
        
        -- Set limits based on the VEST type
        if armor.name == 'military_body_armor' then
            maxValue = 100
            maxPlates = 5
        elseif armor.name == 'broken_body_armor' then
            maxValue = 20
            maxPlates = 2
        end

        -- Cap the value to the vest's maximum
        if value > maxValue then value = maxValue end

        -- Calculate plates for UI (each plate = 10%)
        local plates = math.floor(value / 10)
        if plates > maxPlates then plates = maxPlates end

        armor.metadata.value = value
        armor.metadata.description = ("Plates: %d/%d"):format(plates, maxPlates)
        
        exports.ox_inventory:SetMetadata(src, armor.slot, armor.metadata)
    end
end)

-- sv_karmafunctions.lua
RegisterNetEvent('karma:server:addPlate', function(plateSlot, addValue, effectiveCap)
    local src = source
    -- Get the vest currently in Slot 2
    local armor = exports.ox_inventory:GetSlot(src, 2)
    
    if not armor or not armor.metadata then 
        return TriggerClientEvent('ox_lib:notify', src, { description = 'No armor vest detected.', type = 'error' })
    end

    -- Verify the player still has the plate in that slot and remove it
    -- This handles any of your plate item names
    local removed = exports.ox_inventory:RemoveItem(src, armor.name == 'broken_body_armor' and 'broken_armor_plate' or 'armor_plate', 1, nil, plateSlot)
    
    -- Fallback if the specific plateSlot check fails
    if not removed then
        removed = exports.ox_inventory:RemoveItem(src, 'broken_armor_plate', 1) or 
                  exports.ox_inventory:RemoveItem(src, 'armor_plate', 1) or
                  exports.ox_inventory:RemoveItem(src, 'improved_armor_plate', 1)
    end

    if removed then
        local currentArmor = armor.metadata.value or 0
        local newValue = math.min(currentArmor + addValue, effectiveCap)
        
        -- Determine max value and plates for the UI
        local maxValue = 60
        local maxPlates = 3
        if armor.name == 'military_body_armor' then
            maxValue = 100
            maxPlates = 5
        elseif armor.name == 'broken_body_armor' then
            maxValue = 20
            maxPlates = 2
        end

        -- Ensure we don't exceed the vest's maximum
        if newValue > maxValue then newValue = maxValue end

        -- Calculate plates (each plate = 10%)
        local plates = math.floor(newValue / 10)
        if plates > maxPlates then plates = maxPlates end

        -- Update metadata
        armor.metadata.value = newValue
        armor.metadata.description = ("Plates: %d/%d"):format(plates, maxPlates)
        exports.ox_inventory:SetMetadata(src, armor.slot, armor.metadata)
        
        -- Sync the actual ped armor
        TriggerClientEvent('karma:client:syncArmor', src, newValue)
        TriggerClientEvent('ox_lib:notify', src, { description = 'Plate inserted successfully.', type = 'success' })
    else
        TriggerClientEvent('ox_lib:notify', src, { description = 'Failed to use armor plate.', type = 'error' })
    end
end)