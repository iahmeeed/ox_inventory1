if not lib then return end

local Items = require 'modules.items.shared' --[[@as table<string, OxClientItem>]]

local function sendDisplayMetadata(data)
    SendNUIMessage({
		action = 'displayMetadata',
		data = data
	})
end

---@param metadata string | table<string, string> | table<string, string>[]
---@param value? string
local function displayMetadata(metadata, value)
	local data = {}

	if type(metadata) == 'string' then
        if not value then return end
        data = { { metadata = metadata, value = value } }
	elseif table.type(metadata) == 'array' then
		for i = 1, #metadata do
			for k, v in pairs(metadata[i]) do
				data[i] = { metadata = k, value = v }
			end
		end
	else
		for k, v in pairs(metadata) do
			data[#data + 1] = { metadata = k, value = v }
		end
	end

    if client.uiLoaded then
        return sendDisplayMetadata(data)
    end

    CreateThread(function()
        repeat Wait(100) until client.uiLoaded
        sendDisplayMetadata(data)
    end)
end

exports('displayMetadata', displayMetadata)

local function getItem(_, name)
    if not name then return Items end
	if type(name) ~= 'string' then return end
    name = name:lower()
    if name:sub(0, 7) == 'weapon_' then name = name:upper() end
    return Items[name]
end

setmetatable(Items --[[@as table]], { __call = getItem })

local function Item(name, cb)
	local item = Items[name]
	if item then
		if not item.client?.export and not item.client?.event then
			item.effect = cb
		end
	end
end

local ox_inventory = exports[shared.resource]

-----------------------------------------------------------------------------------------------
-- Armor Sync & Slot 2 Monitoring
-----------------------------------------------------------------------------------------------
local lastArmor = 0
local lastSlot2Item = nil

CreateThread(function()
    while true do
        Wait(1000) 
        local ped = cache.ped
        local currentArmor = GetPedArmour(ped)
        
        -- 1. Damage Sync Logic
        if currentArmor < lastArmor then
            TriggerServerEvent('ox_inventory:updateArmor', currentArmor, 2)
        end
        lastArmor = currentArmor

        -- 2. Slot 2 Monitor (Equip Animation)
        local armorItem = nil
        for _, v in pairs(config.ArmorItem) do
            local items = exports.ox_inventory:Search('slots', v)
            if items then
                for _, k in pairs(items) do
                    if k.slot == 2 then armorItem = k; break end
                end
            end
            if armorItem then break end
        end

        local currentItemName = armorItem and armorItem.name or nil

        -- If a vest is placed into slot 2 (and it wasn't there last check)
        if currentItemName and currentItemName ~= lastSlot2Item then
            local label = armorItem.label or 'Body Armor'
            local duration = (currentItemName == 'military_body_armor') and 5000 or 3000

            -- The progress bar returns true if it completes successfully
            if lib.progressBar({
            duration = duration,
            label = 'Equipping ' .. label .. '...',
            useWhileDead = false,
            canCancel = true,
            disable = { move = false, car = false, combat = true },
            anim = { dict = 'clothingtie', clip = 'try_tie_positive_a', flag = 49 }
                }) then
                
            -- Apply armor to ped AFTER the bar finishes
            local armorValue = armorItem.metadata.value or 0
                SetPedArmour(cache.ped, armorValue)
                lastArmor = GetPedArmour(cache.ped)
                lib.notify({ description = 'You have equipped ' .. label, type = 'success' })
            else
                lib.notify({ description = 'Equipping cancelled.', type = 'error' })
            end
        end
        lastSlot2Item = currentItemName
    end
end)

-----------------------------------------------------------------------------------------------
-- Clientside item use functions
-----------------------------------------------------------------------------------------------

local function getVestMaxCap(vestName)
    if vestName == 'broken_body_armor' then return 20 end
    if vestName == 'military_body_armor' then return 100 end
    return 60 -- Standard armour
end

local function usePlate(data, plateType, addValue, plateMaxCap)
    local armorItem = nil
    for _, v in pairs(config.ArmorItem) do
        local items = exports.ox_inventory:Search('slots', v)
        if items then
            for _, k in pairs(items) do
                if k.slot == 2 then armorItem = k; break end
            end
        end
        if armorItem then break end
    end

    if not armorItem then
        return lib.notify({ description = 'You must have an armor vest equipped.', type = 'error' })
    end

    -- Get the maximum capacity of the vest itself
    local vestCap = getVestMaxCap(armorItem.name)
    -- The plate can only fill up to the vest's capacity
    local effectiveCap = vestCap 
    local currentArmor = GetPedArmour(cache.ped)

    if currentArmor >= effectiveCap then
        return lib.notify({ description = 'This vest is already at maximum capacity.', type = 'error' })
    end

    if lib.progressBar({
        duration = 3000,
        label = "Inserting " .. plateType .. '...',
        useWhileDead = false,
        canCancel = true,
        disable = { move = false, car = false, combat = true },
        anim = { dict = "clothingtie", clip = "try_tie_positive_a", flag = 49 },
    }) then
        ox_inventory:useItem(data, function(success)
            if success then
                local newArmor = math.min(currentArmor + addValue, effectiveCap)
                TriggerServerEvent('ox_inventory:updateArmor', newArmor, 2)
                TriggerServerEvent('ox_inventory:removeArmorPlate', data.name)
                
                SetPedArmour(cache.ped, newArmor)
                lastArmor = newArmor
                
                lib.notify({ description = plateType .. ' inserted. Armor: ' .. newArmor .. '%', type = 'success' })
            end
        end)
    end
end

-- Vests: Logic is now handled by the Slot 2 monitor, so using them is empty
Item('armour', function(data, slot) end)
Item('military_body_armor', function(data, slot) end)
Item('broken_body_armor', function(data, slot) end)

-- Plates: Now allowed in any armor, using their specific boost values
Item('broken_armor_plate', function(data, slot) usePlate(data, 'Broken Plate', 10, 20) end)
Item('armor_plate', function(data, slot) usePlate(data, 'Standard Plate', 20, 60) end)
Item('improved_armor_plate', function(data, slot) usePlate(data, 'Improved Plate', 33, 100) end)

-- Parachute and other items...
client.parachute = false
Item('parachute', function(data, slot)
	if not client.parachute then
		ox_inventory:useItem(data, function(data)
			if data then
				local chute = `GADGET_PARACHUTE`
				SetPlayerParachuteTintIndex(PlayerData.id, -1)
				GiveWeaponToPed(cache.ped, chute, 0, true, false)
				SetPedGadget(cache.ped, chute, true)
				lib.requestModel(1269906701)
				client.parachute = {CreateParachuteBagObject(cache.ped, true, true), slot?.metadata?.type or -1}
				if slot.metadata.type then
					SetPlayerParachuteTintIndex(PlayerData.id, slot.metadata.type)
				end
			end
		end)
	end
end)

Item('phone', function(data, slot)
	local success, result = pcall(function() return exports.npwd:isPhoneVisible() end)
	if success then exports.npwd:setPhoneVisible(not result) end
end)

Item('clothing', function(data, slot)
	local metadata = slot.metadata
	if not metadata.drawable or not metadata.texture then return end
	ox_inventory:useItem(data, function(data)
		if data then
			metadata = data.metadata
			if metadata.prop then
				SetPedPropIndex(cache.ped, metadata.prop, metadata.drawable, metadata.texture, false)
			elseif metadata.component then
				SetPedComponentVariation(cache.ped, metadata.component, metadata.drawable, metadata.texture, 0)
			end
		end
	end)
end)

exports('Items', function(item) return getItem(nil, item) end)
exports('ItemList', function(item) return getItem(nil, item) end)

return Items