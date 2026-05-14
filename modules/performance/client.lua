---@class ClientPerformanceMonitor
local ClientPerformance = {}

-- Client performance tracking
local clientStats = {
    propsRendered = 0,
    propsInView = 0,
    averageFPS = 60,
    fpsSamples = {},
    lastFPSCheck = 0,
    propLoadTime = {},
    streamingIssues = 0
}

-- Configuration
local CLIENT_CONFIG = {
    maxVisibleProps = 50, -- Maximum props to render
    checkInterval = 5000, -- Check every 5 seconds
    fpsThreshold = 30, -- Alert if FPS drops below this
    enableFPSMonitoring = true,
    enablePropCulling = true, -- Hide props beyond distance
    cullingDistance = 100, -- Distance for culling
    lodDistance = 50, -- Level of detail distance
}

---Initialize client performance monitoring
function ClientPerformance.Initialize()
    if config and config.DropSystem and config.DropSystem.clientPerformance then
        for k, v in pairs(config.DropSystem.clientPerformance) do
            CLIENT_CONFIG[k] = v
        end
    end
    
    if CLIENT_CONFIG.enableFPSMonitoring then
        ClientPerformance.StartFPSMonitoring()
    end
    
    if CLIENT_CONFIG.enablePropCulling then
        ClientPerformance.StartPropCulling()
    end
    
    print('[ox_inventory] Client performance monitoring initialized')
end

---Monitor FPS
function ClientPerformance.StartFPSMonitoring()
    CreateThread(function()
        while true do
            Wait(CLIENT_CONFIG.checkInterval)
            
            local fps = GetFrameCount() / GetFrameTime()
            table.insert(clientStats.fpsSamples, fps)
            
            -- Keep only last 10 samples
            if #clientStats.fpsSamples > 10 then
                table.remove(clientStats.fpsSamples, 1)
            end
            
            -- Calculate average
            local sum = 0
            for _, v in ipairs(clientStats.fpsSamples) do
                sum = sum + v
            end
            clientStats.averageFPS = sum / #clientStats.fpsSamples
            
            -- Alert if low FPS
            if clientStats.averageFPS < CLIENT_CONFIG.fpsThreshold then
                ClientPerformance.HandleLowFPS()
            end
            
            clientStats.lastFPSCheck = GetGameTimer()
        end
    end)
end

---Handle low FPS situation
function ClientPerformance.HandleLowFPS()
    if clientStats.propsInView > 20 then
        print(('[PERFORMANCE] Low FPS detected (%.1f). Props in view: %d'):format(
            clientStats.averageFPS, 
            clientStats.propsInView
        ))
        
        -- Suggest reducing props
        if clientStats.propsInView > CLIENT_CONFIG.maxVisibleProps then
            print('[SUGGESTION] Too many props visible. Consider reducing drop radius.')
        end
    end
end

---Start prop culling system
function ClientPerformance.StartPropCulling()
    CreateThread(function()
        while true do
            Wait(1000) -- Check every second
            
            if client.drops then
                local playerCoords = GetEntityCoords(cache.ped)
                local visibleCount = 0
                
                for dropId, point in pairs(client.drops) do
                    local distance = #(playerCoords - point.coords)
                    
                    -- Handle multiple entities (new system)
                    if point.entities then
                        for _, entity in ipairs(point.entities) do
                            if DoesEntityExist(entity) then
                                -- Culling logic
                                if distance > CLIENT_CONFIG.cullingDistance then
                                    SetEntityVisible(entity, false, false)
                                elseif distance > CLIENT_CONFIG.lodDistance then
                                    SetEntityVisible(entity, true, false)
                                    SetEntityLodDist(entity, 50)
                                else
                                    SetEntityVisible(entity, true, false)
                                    SetEntityLodDist(entity, 200)
                                    visibleCount = visibleCount + 1
                                end
                            end
                        end
                    -- Handle single entity (old system fallback)
                    elseif point.entity then
                        if DoesEntityExist(point.entity) then
                            if distance > CLIENT_CONFIG.cullingDistance then
                                SetEntityVisible(point.entity, false, false)
                            elseif distance > CLIENT_CONFIG.lodDistance then
                                SetEntityVisible(point.entity, true, false)
                                SetEntityLodDist(point.entity, 50)
                            else
                                SetEntityVisible(point.entity, true, false)
                                SetEntityLodDist(point.entity, 200)
                                visibleCount = visibleCount + 1
                            end
                        end
                    end
                end
                
                clientStats.propsInView = visibleCount
            end
        end
    end)
end

---Track prop render
---@param loadTime number Time taken to load/spawn
function ClientPerformance.TrackPropRendered(loadTime)
    clientStats.propsRendered = clientStats.propsRendered + 1
    table.insert(clientStats.propLoadTime, loadTime)
    
    -- Keep only last 100 samples
    if #clientStats.propLoadTime > 100 then
        table.remove(clientStats.propLoadTime, 1)
    end
end

---Check if can spawn more props
---@param count number Number of props to spawn (default 1)
---@return boolean canSpawn
function ClientPerformance.CanSpawnProp(count)
    count = count or 1
    return (clientStats.propsInView + count) <= CLIENT_CONFIG.maxVisibleProps
end

---Get client performance stats
---@return table stats
function ClientPerformance.GetStats()
    local avgLoadTime = 0
    if #clientStats.propLoadTime > 0 then
        local sum = 0
        for _, v in ipairs(clientStats.propLoadTime) do
            sum = sum + v
        end
        avgLoadTime = sum / #clientStats.propLoadTime
    end
    
    return {
        propsRendered = clientStats.propsRendered,
        propsInView = clientStats.propsInView,
        averageFPS = math.floor(clientStats.averageFPS * 10) / 10,
        avgPropLoadTime = math.floor(avgLoadTime * 100) / 100,
        streamingIssues = clientStats.streamingIssues
    }
end

-- Export for client
exports('getClientPerformanceStats', function()
    return ClientPerformance.GetStats()
end)

-- Console command
RegisterCommand('oxinv_client_stats', function()
    local stats = ClientPerformance.GetStats()
    print('========================================')
    print('OX_INVENTORY Client Performance')
    print('========================================')
    print(('Props Rendered: %d'):format(stats.propsRendered))
    print(('Props In View: %d'):format(stats.propsInView))
    print(('Average FPS: %.1f'):format(stats.averageFPS))
    print(('Avg Prop Load: %.2fms'):format(stats.avgPropLoadTime))
    print(('Streaming Issues: %d'):format(stats.streamingIssues))
    print('========================================')
end, false)

return ClientPerformance
