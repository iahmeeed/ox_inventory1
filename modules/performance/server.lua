---@class PerformanceMonitor
local PerformanceMonitor = {}

-- Performance tracking
local performanceStats = {
    totalDropsCreated = 0,
    totalDropsRemoved = 0,
    activeDrops = 0,
    propsSpawned = 0,
    propsDeleted = 0,
    averageSpawnTime = 0,
    peakActiveDrops = 0,
    lastCleanup = 0
}

-- Configuration
local PERFORMANCE_CONFIG = {
    maxActiveDrops = 500, -- Maximum drops before cleanup
    maxPropsPerArea = 20, -- Maximum props in 10m radius
    cleanupInterval = 300000, -- 5 minutes
    alertThreshold = 400, -- Alert when drops exceed this
    enableAutoCleanup = true,
    enableLogging = true
}

---Initialize performance monitoring
function PerformanceMonitor.Initialize()
    if not config or not config.DropSystem then
        return print('[ERROR] Config not loaded')
    end
    
    -- Override config if exists
    if config.DropSystem.performance then
        for k, v in pairs(config.DropSystem.performance) do
            PERFORMANCE_CONFIG[k] = v
        end
    end
    
    -- Start cleanup thread
    if PERFORMANCE_CONFIG.enableAutoCleanup then
        PerformanceMonitor.StartCleanupThread()
    end
    
    print('[ox_inventory] Performance monitoring initialized')
end

---Track drop creation
function PerformanceMonitor.TrackDropCreated()
    performanceStats.totalDropsCreated = performanceStats.totalDropsCreated + 1
    performanceStats.activeDrops = performanceStats.activeDrops + 1
    
    -- Update peak
    if performanceStats.activeDrops > performanceStats.peakActiveDrops then
        performanceStats.peakActiveDrops = performanceStats.activeDrops
    end
    
    -- Check threshold
    if performanceStats.activeDrops >= PERFORMANCE_CONFIG.alertThreshold then
        PerformanceMonitor.AlertHighDropCount()
    end
    
    -- Auto cleanup if exceeded max
    if performanceStats.activeDrops >= PERFORMANCE_CONFIG.maxActiveDrops then
        PerformanceMonitor.EmergencyCleanup()
    end
end

---Track drop removal
function PerformanceMonitor.TrackDropRemoved()
    performanceStats.totalDropsRemoved = performanceStats.totalDropsRemoved + 1
    performanceStats.activeDrops = math.max(0, performanceStats.activeDrops - 1)
end

---Track prop spawn
---@param spawnTime number Time taken to spawn in ms
function PerformanceMonitor.TrackPropSpawned(spawnTime)
    performanceStats.propsSpawned = performanceStats.propsSpawned + 1
    
    -- Calculate average spawn time
    local totalSpawns = performanceStats.propsSpawned
    local currentAvg = performanceStats.averageSpawnTime
    performanceStats.averageSpawnTime = ((currentAvg * (totalSpawns - 1)) + spawnTime) / totalSpawns
end

---Track prop deletion
function PerformanceMonitor.TrackPropDeleted()
    performanceStats.propsDeleted = performanceStats.propsDeleted + 1
end

---Alert for high drop count
function PerformanceMonitor.AlertHighDropCount()
    local msg = ('[WARNING] High drop count: %d active drops (threshold: %d)'):format(
        performanceStats.activeDrops,
        PERFORMANCE_CONFIG.alertThreshold
    )
    
    print(msg)
    
    if PERFORMANCE_CONFIG.enableLogging then
        lib.logger('performance', 'warning', msg)
    end
end

---Emergency cleanup of old drops
function PerformanceMonitor.EmergencyCleanup()
    print('[ALERT] Emergency drop cleanup initiated!')
    
    if not Inventory or not Inventory.Drops then return end
    
    local currentTime = os.time()
    local cleanupAge = 600 -- 10 minutes
    local removedCount = 0
    
    for dropId, dropData in pairs(Inventory.Drops) do
        local dropInventory = Inventory(dropId)
        
        if dropInventory then
            -- Check if drop is old and empty/nearly empty
            local dropAge = currentTime - (dropInventory.created or currentTime)
            local isEmpty = not dropInventory.items or not next(dropInventory.items)
            local isOld = dropAge > cleanupAge
            
            if (isEmpty and dropAge > 60) or isOld then
                -- Remove drop
                TriggerClientEvent('ox_inventory:removeDrop', -1, dropId)
                Inventory.Drops[dropId] = nil
                
                if dropInventory then
                    Inventories[dropId] = nil
                end
                
                removedCount = removedCount + 1
                performanceStats.activeDrops = math.max(0, performanceStats.activeDrops - 1)
            end
        end
    end
    
    print(('[CLEANUP] Removed %d old/empty drops. Active: %d'):format(removedCount, performanceStats.activeDrops))
end

---Start automatic cleanup thread
function PerformanceMonitor.StartCleanupThread()
    CreateThread(function()
        while true do
            Wait(PERFORMANCE_CONFIG.cleanupInterval)
            
            if performanceStats.activeDrops > 100 then
                PerformanceMonitor.ScheduledCleanup()
            end
            
            performanceStats.lastCleanup = os.time()
        end
    end)
end

---Scheduled cleanup
function PerformanceMonitor.ScheduledCleanup()
    if not Inventory or not Inventory.Drops then return end
    
    local currentTime = os.time()
    local cleanupAge = 900 -- 15 minutes
    local removedCount = 0
    
    for dropId, dropData in pairs(Inventory.Drops) do
        local dropInventory = Inventory(dropId)
        
        if dropInventory then
            local dropAge = currentTime - (dropInventory.created or currentTime)
            local isEmpty = not dropInventory.items or not next(dropInventory.items)
            
            -- Remove if empty for 2 minutes or old and nearly empty
            if (isEmpty and dropAge > 120) or (dropAge > cleanupAge and dropInventory.weight < 100) then
                TriggerClientEvent('ox_inventory:removeDrop', -1, dropId)
                Inventory.Drops[dropId] = nil
                
                if Inventories[dropId] then
                    Inventories[dropId] = nil
                end
                
                removedCount = removedCount + 1
                performanceStats.activeDrops = math.max(0, performanceStats.activeDrops - 1)
            end
        end
    end
    
    if removedCount > 0 then
        print(('[CLEANUP] Scheduled cleanup removed %d drops. Active: %d'):format(removedCount, performanceStats.activeDrops))
    end
end

---Get performance statistics
---@return table stats
function PerformanceMonitor.GetStats()
    return {
        totalCreated = performanceStats.totalDropsCreated,
        totalRemoved = performanceStats.totalDropsRemoved,
        active = performanceStats.activeDrops,
        peak = performanceStats.peakActiveDrops,
        propsSpawned = performanceStats.propsSpawned,
        propsDeleted = performanceStats.propsDeleted,
        avgSpawnTime = math.floor(performanceStats.averageSpawnTime * 100) / 100,
        lastCleanup = performanceStats.lastCleanup
    }
end

---Check prop density in area
---@param coords vector3
---@param radius number
---@return boolean tooMany
function PerformanceMonitor.CheckPropDensity(coords, radius)
    if not Inventory or not Inventory.Drops then return false end
    
    local count = 0
    radius = radius or 10
    
    for dropId, dropData in pairs(Inventory.Drops) do
        if dropData.coords then
            local distance = #(coords - dropData.coords)
            if distance <= radius then
                count = count + 1
            end
        end
    end
    
    return count >= PERFORMANCE_CONFIG.maxPropsPerArea
end

---Export for server console commands
lib.callback.register('ox_inventory:getPerformanceStats', function()
    return PerformanceMonitor.GetStats()
end)

-- Console command for admins
RegisterCommand('oxinv_stats', function(source, args)
    if source > 0 then
        -- Check if player is admin (integrate with your framework)
        local hasPermission = true -- TODO: Add permission check
        if not hasPermission then return end
    end
    
    local stats = PerformanceMonitor.GetStats()
    print('========================================')
    print('OX_INVENTORY Performance Statistics')
    print('========================================')
    print(('Total Drops Created: %d'):format(stats.totalCreated))
    print(('Total Drops Removed: %d'):format(stats.totalRemoved))
    print(('Currently Active: %d'):format(stats.active))
    print(('Peak Active: %d'):format(stats.peak))
    print(('Props Spawned: %d'):format(stats.propsSpawned))
    print(('Props Deleted: %d'):format(stats.propsDeleted))
    print(('Avg Spawn Time: %.2fms'):format(stats.avgSpawnTime))
    print(('Last Cleanup: %s'):format(os.date('%H:%M:%S', stats.lastCleanup)))
    print('========================================')
end, false)

return PerformanceMonitor
