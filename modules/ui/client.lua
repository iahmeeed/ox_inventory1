-- UI Theme Client Handler
-- This file retrieves theme config from server and applies it to NUI

local uiTheme = nil
local themeApplied = false

local function ApplyUITheme(theme)
    print('[DEBUG THEME] ApplyUITheme called')
    print('[DEBUG THEME] theme exists: ' .. tostring(theme ~= nil))
    
    if not theme then
        print('[DEBUG THEME] ERROR: No theme provided')
        return
    end
    
    print('[DEBUG THEME] theme.enabled: ' .. tostring(theme.enabled))
    
    if not theme.enabled then
        print('[DEBUG THEME] Theme is disabled in config')
        return
    end
    
    print('[DEBUG THEME] Sending theme to NUI...')
    print('[DEBUG THEME] primaryColor: ' .. tostring(theme.primaryColor))
    print('[DEBUG THEME] backgroundColor: ' .. tostring(theme.backgroundColor))
    
    -- Send theme configuration to NUI
    SendNUIMessage({
        action = 'applyTheme',
        data = theme
    })
    
    print('[DEBUG THEME] Theme sent to NUI successfully')
    themeApplied = true
end

local function LoadUITheme()
    print('[DEBUG THEME] LoadUITheme called')
    print('[DEBUG THEME] themeApplied: ' .. tostring(themeApplied))
    
    if themeApplied then 
        print('[DEBUG THEME] Theme already applied, skipping')
        return 
    end
    
    print('[DEBUG THEME] Requesting theme from server...')
    local theme = lib.callback.await('ox_inventory:getUITheme', 200)
    
    print('[DEBUG THEME] Server response received: ' .. tostring(theme ~= nil))
    
    if theme then
        print('[DEBUG THEME] Theme data received from server')
        uiTheme = theme
        ApplyUITheme(theme)
    else
        print('[DEBUG THEME] ERROR: No theme data received from server')
    end
end

-- Load theme when resource starts
CreateThread(function()
    Wait(1000) -- Wait for config to be loaded
    LoadUITheme()
end)

-- Export function to get current theme
exports('getUITheme', function()
    return uiTheme
end)

-- Export function to reload theme
exports('reloadUITheme', function()
    themeApplied = false
    LoadUITheme()
end)

return {
    ApplyUITheme = ApplyUITheme,
    LoadUITheme = LoadUITheme,
    GetTheme = function() return uiTheme end
}
