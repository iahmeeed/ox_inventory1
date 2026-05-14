-- Made by Karma Developments with Love <3 

local function isPedFreemodeModel(ped)
    local model = GetEntityModel(ped)
    if model == `mp_m_freemode_01` then
        return 'male'
    elseif model == `mp_f_freemode_01` then
        return 'female'
    else
        return 'male'
    end
end

function SetupInventorySettings()
    local model = isPedFreemodeModel(cache.ped)
    local data = {
        gender = model,
        SpecialSlot = config.SpecialSlot,
        balcklistItem = config.blacklistitem
    }
    SendNUIMessage({
		action = 'setupInventorySettings',
		data = data
	})
end
function GetPlayerLicense()
    if GlobalState.fw == 'esx' then
        local license = lib.callback.await('ox_inventory:esxGetLicense', false)
        return license
    elseif GlobalState.fw == 'qb' then
        return QBCore.Functions.GetPlayerData().cid
    elseif GlobalState.fw == 'qbx' then
        return QBX.PlayerData.cid
    end
end
function checkBackpackInslot()
    local backpack = exports.ox_inventory:Search('slots', 'backpack')
    if backpack then
        for _, v in pairs(backpack) do
            if v.slot == 1 then 
                if LocalPlayer.state.backpack == nil then
                    LocalPlayer.state:set('backpack', {use = true, id = v.metadata.id}, true)
                end
                return true
            end
        end
        LocalPlayer.state:set('backpack', nil, true)
        return false
    else 
        LocalPlayer.state:set('backpack', nil, true)
        return false
    end
end

local function useArmor(metadata, itemName)
    local armor = metadata.value or 0
    
    local maxCap = 60 -- Standard body_armor
    if itemName == 'military_body_armor' then
        maxCap = 100 -- Military
    elseif itemName == 'broken_body_armor' then
        maxCap = 20 -- Broken
    end
    
    if armor > maxCap then armor = maxCap end
    SetPedArmour(cache.ped, armor)
end

function startArmour()
    for _, v in pairs(config.ArmorItem) do
        local item = exports.ox_inventory:Search('slots', v)
        if item then
            for i, k in pairs(item) do
                if k.slot == 2 then
                    -- Pass k.name here
                    return useArmor(k.metadata, k.name)
                else
                    SetPedArmour(cache.ped, 0)
                end
            end
        end
        Wait(100)
    end
end
function CheckArmorItem(item, lepas, to)
    if lepas then
        SetTimeout(500, function()
            local armor = GetPedArmour(cache.ped)
            TriggerServerEvent('ox_inventory:updateArmor', armor, to)
            Wait(100)
            SetPedArmour(cache.ped, 0)
        end) -- Removed 'return' here as it's inside a timeout
    else
        SetTimeout(1000, function()
            for _, v in pairs(config.ArmorItem) do
                if v == item then
                    local itemData = exports.ox_inventory:Search('slots', item)
                    if itemData then
                        for i, k in pairs(itemData) do
                            if k.slot == 2 then
                                return useArmor(k.metadata, k.name)
                            end
                        end
                    end
                end
            end
        end)
    end -- <--- This was missing
end     -- <--- This was missing

local savedSkin = nil

local function SavePlayerSkin()
    local ped = cache.ped
    savedSkin = {
        components = {},
        props = {}
    }

    for i = 0, 11 do
        savedSkin.components[i] = {
            drawable = GetPedDrawableVariation(ped, i),
            texture = GetPedTextureVariation(ped, i)
        }
    end

    for i = 0, 7 do
        savedSkin.props[i] = {
            prop = GetPedPropIndex(ped, i),
            texture = GetPedPropTextureIndex(ped, i)
        }
    end
end

local function RestorePlayerSkin()
    if not savedSkin then return end

    local ped = cache.ped

    for i = 0, 11 do
        local comp = savedSkin.components[i]
        if comp then
            SetPedComponentVariation(ped, i, comp.drawable, comp.texture, 0)
        end
    end

    for i = 0, 7 do
        local prop = savedSkin.props[i]
        if prop then
            if prop.prop == -1 then
                ClearPedProp(ped, i)
            else
                SetPedPropIndex(ped, i, prop.prop, prop.texture, true)
            end
        end
    end

    savedSkin = nil
end

RegisterNetEvent('karma:client:syncArmor', function(value)
    SetPedArmour(cache.ped, value)
    -- Update local variable in client.lua if necessary
    if lastArmor then lastArmor = value end 
end)

function CheckParachuteItem(item, lepas)
    if lepas then
if item == 'hazmatkit' or item == 'bluehazmatkit' or item == 'ramadhazmatkit' then
    lib.requestAnimDict('clothingtie')
    TaskPlayAnim(cache.ped, 'clothingtie', 'try_tie_positive_a', 8.0, 8.0, 1500, 49, 0, false, false, false)

    SetTimeout(1500, function()
        RestorePlayerSkin()
    end)
    return
end
        return removeParachute()
    else
        SetTimeout(1000, function()
            if item == 'parachute' then
                local itemData = exports.ox_inventory:Search('slots', item)
                if itemData then
                    for i, k in pairs(itemData) do
                        if k.slot == 4 then
                            local chute = `GADGET_PARACHUTE`
                            SetPlayerParachuteTintIndex(cache.playerId, -1)
                            GiveWeaponToPed(cache.ped, chute, 0, true, false)
                            SetPedGadget(cache.ped, chute, true)
                            lib.requestModel(1269906701)
                            client.parachute = {CreateParachuteBagObject(cache.ped, true, true), k?.metadata?.type or -1}
                            if k.metadata.type then
                                SetPlayerParachuteTintIndex(cache.playerId, k.metadata.type)
                            end
                        end
                    end
                end
            elseif item == 'hazmatkit' then
                local itemData = exports.ox_inventory:Search('slots', item)
                if itemData then
                    for _, k in pairs(itemData) do
                        if k.slot == 4 then


                -- Save outfit
                if not savedSkin then
                    SavePlayerSkin()
                end
                
                lib.requestAnimDict('missmic4')
                TaskPlayAnim(cache.ped, 'missmic4', 'michael_tux_fidget', 8.0, 8.0, 1500, 49, 0, false, false, false)

                SetTimeout(1500, function()
                    SetPedComponentVariation(cache.ped, 1, 46, 0, 0)
                    SetPedComponentVariation(cache.ped, 4, 40, 2, 0)
                    SetPedComponentVariation(cache.ped, 6, 25, 0, 0)
                    SetPedComponentVariation(cache.ped, 8, 62, 2, 0)
                    SetPedComponentVariation(cache.ped, 11, 67, 2, 0)
                    SetPedComponentVariation(cache.ped, 3, 33, 0, 0)
                    

                end)
            end
        end
    end
elseif item == 'bluehazmatkit' then
    local itemData = exports.ox_inventory:Search('slots', item)
    if itemData then
        for _, k in pairs(itemData) do
            if k.slot == 4 then


                -- Save outfit
                if not savedSkin then
                    SavePlayerSkin()
                end
                
                lib.requestAnimDict('missmic4')
                TaskPlayAnim(cache.ped, 'missmic4', 'michael_tux_fidget', 8.0, 8.0, 1500, 49, 0, false, false, false)

                SetTimeout(1500, function()
                    SetPedComponentVariation(cache.ped, 1, 46, 0, 0)
                    SetPedComponentVariation(cache.ped, 4, 40, 3, 0)
                    SetPedComponentVariation(cache.ped, 6, 25, 0, 0)
                    SetPedComponentVariation(cache.ped, 8, 62, 3, 0)
                    SetPedComponentVariation(cache.ped, 11, 67, 3, 0)
                    SetPedComponentVariation(cache.ped, 3, 33, 0, 0)
                end)
            end
        end
    end

elseif item == 'ramadhazmatkit' then
    local itemData = exports.ox_inventory:Search('slots', item)
    if itemData then
        for _, k in pairs(itemData) do
            if k.slot == 4 then


                -- Save outfit
                if not savedSkin then
                    SavePlayerSkin()
                end
                
                lib.requestAnimDict('missmic4')
                TaskPlayAnim(cache.ped, 'missmic4', 'michael_tux_fidget', 8.0, 8.0, 1500, 49, 0, false, false, false)

                SetTimeout(1500, function()
                    SetPedComponentVariation(cache.ped, 1, 46, 0, 0)--mask
                    SetPedComponentVariation(cache.ped, 4, 216, 2, 0)--legs
                    SetPedComponentVariation(cache.ped, 6, 27, 0, 0)--shoes
                    SetPedComponentVariation(cache.ped, 8, 15, 0, 0)--undershirt
                    SetPedComponentVariation(cache.ped, 11, 575, 2, 0)--troso
                    SetPedComponentVariation(cache.ped, 3, 33, 0, 0)--arms
                end)
            end
        end
    end
end
        end)
    end
end
function SendGiveUI(data)
	SendNUIMessage({ action = 'UpdatePlayerList', data = data })
end