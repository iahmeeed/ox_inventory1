-- Made by Karma Developments with Love <3 

config = {}

-- Core Inventory Settings
config.CoreFolder = 'qb-core' -- Fill it with your Core Folder (es_extended, qb-core or qbx_core)
config.autousearmor = false          -- Automatically uses armor when player's armor drops below 5%
config.autouseparachute = false      -- Automatically deploys parachute when equipped in parachute slot

-- Item Restrictions & Classifications
config.blacklistitem = {'backpack'}        -- Items banned from backpack storage
config.ArmorItem = {
    'armour',
    'body_armor',
    'military_body_armor',
    'broken_body_armor'
}                       -- Items classified as protective armor
config.CustomMetadataItem = {'water','frappuccino'}        -- Items supporting custom metadata fields

-- Backpack System Configuration
config.backpack = {
    dynamic = true,                 -- Inventory size scales based on equipped backpack type
    useitem = true,                 -- Requires backpack item to access expanded inventory
    slot = 20,                      -- Default slot count when no backpack is equipped
    maxWeight = 200000,             -- Maximum carry weight in grams (500kg)
}

-- Special Item Slots
config.SpecialSlot = {
    {'backpack'},          -- Slot 1: Backpack (inventory expansion equipment)
    {'armour', 'body_armor', 'military_body_armor', 'broken_body_armor'},            -- Slot 2: Body Armor (damage protection system)
    {'phone', 'radio'},             -- Slot 3: Phone (communication and applications)
    {'hazmatkit', 'bluehazmatkit', 'ramadhazmatkit', 'hazmatkitbag' ,'parachute'},         -- Slot 4: Parachute (fall damage prevention)
}

-- Advanced Drop System
config.DropSystem = {
    enableIndividualProps = true,                   -- Unique 3D models for different item types
    defaultDropModel = 'prop_box_guncase_01a',      -- Fallback model for unidentified items
    useAreaDetection = true,                        -- Area-based inventory access for nearby drops
    detectionRadius = 2.5,                          -- Pickup range in meters
    enableCustomProps = true,                       -- Custom models from items.lua/weapons.lua

    -- Category-Specific Visuals
    categoryModels = {
        weapon = 'prop_box_guncase_02a',            -- Large weapon case for firearms
        ammo = 'prop_ld_ammo_pack_01',              -- Ammunition pack model
        food = 'prop_food_bag1',                    -- Food bag container
        drink = 'prop_food_bag1',                   -- Drink container
        tool = 'prop_tool_box_01',                  -- Toolbox for equipment
        money = 'prop_poly_bag_money',              -- Money bag for currency
        default = 'prop_box_guncase_01a'            -- Small case for general items
    },

    -- Server Performance Optimization
    performance = {
        maxActiveDrops = 500,                       -- Total drops before emergency cleanup
        maxPropsPerArea = 20,                       -- Maximum props within 10m radius
        cleanupInterval = 300000,                   -- Auto cleanup every 5 minutes (ms)
        alertThreshold = 400,                       -- Admin alert when approaching limit
        enableAutoCleanup = true,                   -- Remove old/empty drops automatically
        enableLogging = true,                       -- Log performance warnings to console
        dropExpireTime = 900,                       -- 15 minute expiration for uncollected drops
        emptyDropExpireTime = 120,                  -- 2 minute cleanup for empty containers
    },

    -- Client-Side Performance Settings
    clientPerformance = {
        maxVisibleProps = 50,                       -- Maximum rendered drop props
        checkInterval = 5000,                       -- Performance monitoring interval (ms)
        fpsThreshold = 30,                          -- FPS warning threshold
        enableFPSMonitoring = true,                 -- Real-time FPS tracking
        enablePropCulling = true,                   -- Distance-based prop hiding
        cullingDistance = 100,                      -- Maximum render distance (meters)
        lodDistance = 50,                           -- Level of detail reduction distance
    }
}

-- Inventory UI Customization
config.UITheme = {
    enabled = false,                                -- Master toggle for UI customization

    -- Primary Color Scheme
    primaryColor = '#7c8ba313',                     -- Main theme color (transparent blue)
    primaryHover = '#2563eb',                       -- Hover state color
    primaryLight = '#60a5fa',                       -- Light accent color
    primaryDark = '#1e40af',                        -- Dark accent color

    -- Background Layers
    backgroundColor = '#ff0000ff',                  -- Primary background (solid red)
    backgroundSecondary = '#374151',                -- Secondary background layer
    backgroundTertiary = '#4b5563',                 -- Tertiary background element

    -- Text Hierarchy Colors
    textPrimary = '#ff0000ff',                      -- Main text color (solid red)
    textSecondary = '#d1d5db',                      -- Secondary text information
    textMuted = '#9ca3af',                          -- Muted/disabled text

    -- Border & Container Styling
    borderColor = '#4b5563',                        -- Border and separator lines
    borderRadius = '0.5rem',                        -- Corner rounding (8px)

    -- Inventory Slot Design
    slotBackground = '#374151',                     -- Individual slot background
    slotBorder = '#4b5563',                         -- Slot border styling
    slotHover = '#4b5563',                          -- Hover state for slots
    slotActive = '#3b82f6',                         -- Active/selected slot indicator

    -- Item Rarity Color Coding
    qualityColors = {
        common = '#9ca3af',                         -- Common items (gray)
        uncommon = '#10b981',                       -- Uncommon items (green)
        rare = '#3b82f6',                           -- Rare items (blue)
        epic = '#996dffff',                         -- Epic items (purple)
        legendary = '#f59e0b',                      -- Legendary items (orange)
        unique = '#ef4444',                         -- Unique items (red)
    },

    -- Typography System
    fontFamily = 'Inter, system-ui, -apple-system, sans-serif', -- Font stack
    fontSize = {
        small = '0.75rem',                          -- 12px - labels, metadata
        normal = '0.875rem',                        -- 14px - body text
        medium = '1rem',                            -- 16px - interface text
        large = '1.125rem',                         -- 18px - headers, titles
    },

    -- Interaction Animations
    enableAnimations = true,                        -- Enable UI animations
    animationSpeed = '200ms',                       -- Animation timing

    -- Inventory Window Settings
    inventoryOpacity = 0.95,                        -- Background transparency (0-1)
    enableBlur = false,                             -- Background blur effect
    blurAmount = '8px',                             -- Blur intensity

    -- Notification System
    notificationPosition = 'top-right',             -- Screen position for alerts
    notificationDuration = 3000,                    -- Display time in milliseconds
}