---@class PropManager
local PropManager = {}

-- Track all spawned props to prevent memory leaks
local spawnedProps = {}
local propRegistry = {}

---Register a spawned prop
---@param entity number Entity handle
---@param dropId string Drop ID
---@param model string|number Prop model
function PropManager.RegisterProp(entity, dropId, model)
    if not entity or entity == 0 then return end
    
    spawnedProps[entity] = {
        dropId = dropId,
        model = model,
        spawnTime = GetGameTimer(),
        coords = GetEntityCoords(entity)
    }
    
    if not propRegistry[dropId] then
        propRegistry[dropId] = {}
    end
    
    table.insert(propRegistry[dropId], entity)
end

---Unregister and delete prop
---@param entity number Entity handle
---@param dropId string? Drop ID (optional)
function PropManager.UnregisterProp(entity, dropId)
    if not entity or entity == 0 then return end
    
    -- Remove from spawned props
    if spawnedProps[entity] then
        dropId = dropId or spawnedProps[entity].dropId
        spawnedProps[entity] = nil
    end
    
    -- Remove from registry
    if dropId and propRegistry[dropId] then
        for i, ent in ipairs(propRegistry[dropId]) do
            if ent == entity then
                table.remove(propRegistry[dropId], i)
                break
            end
        end
        
        if #propRegistry[dropId] == 0 then
            propRegistry[dropId] = nil
        end
    end
    
    -- Safely delete entity
    if DoesEntityExist(entity) then
        SetEntityAsMissionEntity(entity, true, true)
        DeleteEntity(entity)
    end
end

---Clean up all props for a drop ID
---@param dropId string Drop ID
function PropManager.CleanupDrop(dropId)
    if not propRegistry[dropId] then return end
    
    local cleaned = 0
    for _, entity in ipairs(propRegistry[dropId]) do
        if DoesEntityExist(entity) then
            PropManager.UnregisterProp(entity, dropId)
            cleaned = cleaned + 1
        end
    end
    
    propRegistry[dropId] = nil
    
    if cleaned > 0 then
        print(('[PropManager] Cleaned up %d props for drop %s'):format(cleaned, dropId))
    end
end

---Emergency cleanup of all orphaned props
function PropManager.EmergencyCleanup()
    local cleanedCount = 0
    local currentTime = GetGameTimer()
    
    for entity, data in pairs(spawnedProps) do
        if not DoesEntityExist(entity) then
            -- Entity already gone, just remove from tracking
            spawnedProps[entity] = nil
            cleanedCount = cleanedCount + 1
        elseif currentTime - data.spawnTime > 3600000 then
            -- Prop older than 1 hour, probably orphaned
            PropManager.UnregisterProp(entity, data.dropId)
            cleanedCount = cleanedCount + 1
        end
    end
    
    if cleanedCount > 0 then
        print(('[PropManager] Emergency cleanup removed %d orphaned props'):format(cleanedCount))
    end
    
    return cleanedCount
end

---Get prop count
---@return number activeProps
function PropManager.GetActivePropCount()
    local count = 0
    for _ in pairs(spawnedProps) do
        count = count + 1
    end
    return count
end

---Check if prop exists for drop
---@param dropId string Drop ID
---@return boolean exists
function PropManager.HasProp(dropId)
    return propRegistry[dropId] ~= nil and #propRegistry[dropId] > 0
end

---Get all props for drop
---@param dropId string Drop ID
---@return table entities
function PropManager.GetDropProps(dropId)
    return propRegistry[dropId] or {}
end

-- Periodic cleanup thread
CreateThread(function()
    while true do
        Wait(600000) -- Every 10 minutes
        PropManager.EmergencyCleanup()
    end
end)

-- Export for external use
exports('getPropCount', function()
    return PropManager.GetActivePropCount()
end)

exports('cleanupOrphanedProps', function()
    return PropManager.EmergencyCleanup()
end)

return PropManager
