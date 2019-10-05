local frame = CreateFrame("Frame", "ShowSlots")
local BACKPACK_FREESLOTS_FORMAT = "(%s)"

local function ShowSlots_UpdateCount()
    local totalFree = CalculateTotalNumberOfFreeBagSlots()
    if MainMenuBarBackpackButtonCount then
       MainMenuBarBackpackButtonCount:SetText(string.format(BACKPACK_FREESLOTS_FORMAT, totalFree));
    end
end

local function ShowSlots_Init()
    frame:RegisterEvent("BAG_UPDATE")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:SetScript("OnEvent", function(self, event, ...) 
        if event == "BAG_UPDATE" then
            local bag = ...
            if ( bag >= BACKPACK_CONTAINER and bag <= NUM_BAG_SLOTS ) then
              ShowSlots_UpdateCount()
            end
        elseif event == "PLAYER_ENTERING_WORLD" then
            if GetCVar("displayFreeBagSlots") == "1" then
                MainMenuBarBackpackButtonCount:Show()
            else
                MainMenuBarBackpackButtonCount:Hide()
            end
            ShowSlots_UpdateCount()
        end
    end)
end

ShowSlots_Init()