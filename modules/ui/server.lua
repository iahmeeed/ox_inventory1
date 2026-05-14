-- UI Theme Configuration Injector
-- This file injects custom theme from config.lua to the React application

local function GetUIThemeConfig()
    -- print('[DEBUG THEME SERVER] GetUIThemeConfig called')
    -- print('[DEBUG THEME SERVER] config exists: ' .. tostring(config ~= nil))
    -- print('[DEBUG THEME SERVER] config.UITheme exists: ' .. tostring(config and config.UITheme ~= nil))
    -- print('[DEBUG THEME SERVER] config.UITheme.enabled: ' .. tostring(config and config.UITheme and config.UITheme.enabled))
    
    if not config or not config.UITheme or not config.UITheme.enabled then
        -- print('[DEBUG THEME SERVER] Theme disabled or not configured')
        return nil
    end
    
    -- print('[DEBUG THEME SERVER] Building theme object...')
    -- print('[DEBUG THEME SERVER] primaryColor: ' .. tostring(config.UITheme.primaryColor))
    -- print('[DEBUG THEME SERVER] backgroundColor: ' .. tostring(config.UITheme.backgroundColor))
    
    return {
        enabled = config.UITheme.enabled,
        primaryColor = config.UITheme.primaryColor,
        primaryHover = config.UITheme.primaryHover,
        primaryLight = config.UITheme.primaryLight,
        primaryDark = config.UITheme.primaryDark,
        backgroundColor = config.UITheme.backgroundColor,
        backgroundSecondary = config.UITheme.backgroundSecondary,
        backgroundTertiary = config.UITheme.backgroundTertiary,
        textPrimary = config.UITheme.textPrimary,
        textSecondary = config.UITheme.textSecondary,
        textMuted = config.UITheme.textMuted,
        borderColor = config.UITheme.borderColor,
        borderRadius = config.UITheme.borderRadius,
        slotBackground = config.UITheme.slotBackground,
        slotBorder = config.UITheme.slotBorder,
        slotHover = config.UITheme.slotHover,
        slotActive = config.UITheme.slotActive,
        qualityColors = config.UITheme.qualityColors,
        fontFamily = config.UITheme.fontFamily,
        fontSize = config.UITheme.fontSize,
        enableAnimations = config.UITheme.enableAnimations,
        animationSpeed = config.UITheme.animationSpeed,
        inventoryOpacity = config.UITheme.inventoryOpacity,
        enableBlur = config.UITheme.enableBlur,
        blurAmount = config.UITheme.blurAmount,
        notificationPosition = config.UITheme.notificationPosition,
        notificationDuration = config.UITheme.notificationDuration,
    }
end

-- Export for client to retrieve
lib.callback.register('ox_inventory:getUITheme', function(source)
    print('[DEBUG THEME SERVER] ox_inventory:getUITheme callback called by source: ' .. tostring(source))
    local theme = GetUIThemeConfig()
    print('[DEBUG THEME SERVER] Returning theme: ' .. tostring(theme ~= nil))
    return theme
end)

return GetUIThemeConfig
