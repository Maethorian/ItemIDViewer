-- Addon Name
ItemIDViewer = {}
ItemIDViewer.name = "ItemIDViewer"


-- Function to print item name and ID to the custom tooltip
local function ShowTooltip(itemName, itemId, mouseX, mouseY)
    d("Item Name: " .. itemName .. " | Item ID: " .. itemId)
end

-- Function to print item name and ID to chat
local function PrintItemInfo(bagId, slotId)
    -- Get the item name and item ID from the item link
    local itemLink = GetItemLink(bagId, slotId)
    local itemName = GetItemLinkName(itemLink)
    local itemId = GetItemLinkItemId(itemLink) -- Use this method to get the item ID from the item link

    -- Show the custom tooltip at the mouse position
    local mouseX, mouseY = GetUIMousePosition()
    ShowTooltip(itemName, itemId, mouseX, mouseY)
end

local function OnTradingHouseTooltipSet(tooltipControl, tradingHouseIndex)
    local itemLink = GetTradingHouseSearchResultItemLink(tradingHouseIndex)
    if itemLink then
        local itemName = GetItemLinkName(itemLink)
        local itemId = GetItemLinkItemId(itemLink) -- Correct method to get item ID in Guild Store
        -- Print the item name and item ID to chat
        d("Item Name: " .. itemName .. " | Item ID: " .. itemId)
    else
        d("Item link not found in Guild Store.")
    end
end

-- Hook function for when the tooltip is set
local function OnTooltipSetItem(tooltipControl, bagId, slotId)
    PrintItemInfo(bagId, slotId)
end
 
-- Hook into the tooltip functions
local function HookBagTips()
    -- Inventory bags
    ZO_PreHook(ItemTooltip, "SetBagItem", OnTooltipSetItem)
    
    -- Bank and Guild Bank
    ZO_PreHook(ItemTooltip, "SetGuildBankItem", OnTooltipSetItem)
    ZO_PreHook(ItemTooltip, "SetBankItem", OnTooltipSetItem)
    
    -- Store and Guild Store
    ZO_PreHook(ItemTooltip, "SetStoreItem", OnTooltipSetItem)
    ZO_PreHook(ItemTooltip, "SetTradingHouseItem", OnTradingHouseTooltipSet)
    ZO_PreHook(ItemTooltip, "SetTradingHouseListing", OnTooltipSetItem)
    
    -- Loot
    ZO_PreHook(ItemTooltip, "SetLootItem", OnTooltipSetItem)
end
 
-- Function that runs when the addon is loaded
local function OnAddOnLoaded(event, name)
    if name ~= ItemIDViewer.name then return end -- If it's not our addon loaded, don't run this. Would get errors.

	-- Create the tooltip control

    HookBagTips()
    EVENT_MANAGER:UnregisterForEvent(ItemIDViewer.name, event) -- We no longer want this to run as the game loads addons. It only needs to run once.
end
 
-- Register for the event when the addon is loaded
EVENT_MANAGER:RegisterForEvent(ItemIDViewer.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded) -- As the game loads, the event manager registers our addon for an event.