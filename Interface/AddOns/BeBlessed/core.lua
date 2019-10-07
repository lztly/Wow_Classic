BeBlessed = {};
local eventHandler = CreateFrame("Frame");
eventHandler.events = {};
local INDEX = UnitName("player").."-"..GetRealmName();
local inCombat = false;

BeBlessed.toLocal = {};
BeBlessed.toEnglish = {};
BeBlessed.guidToIndex = {};
BeBlessed.BlessingIDs = {
    ["Blessing of Might"] =  19740,
    ["Blessing of Wisdom"] = 19742,
    ["Blessing of Salvation"] = 1038,
    ["Blessing of Kings"] = 20217,
    ["Blessing of Sanctuary"] = 20911,
    ["Blessing of Light"] = 19977,
    ["Greater Blessing of Might"] = 25782,
    ["Greater Blessing of Wisdom"] = 25894,
    ["Greater Blessing of Salvation"] = 25895,
    ["Greater Blessing of Kings"] = 25898,
    ["Greater Blessing of Sanctuary"] = 25899,
    ["Greater Blessing of Light"] = 25890,
}

local BlessingDurations = {
    ["Blessing of Might"] = 300,
    ["Blessing of Wisdom"] = 300,
    ["Blessing of Salvation"] = 300,
    ["Blessing of Kings"] = 300,
    ["Blessing of Sanctuary"] = 300,
    ["Blessing of Light"] = 300,
    ["Greater Blessing of Might"] = 900,
    ["Greater Blessing of Wisdom"] = 900,
    ["Greater Blessing of Salvation"] = 900,
    ["Greater Blessing of Kings"] = 900,
    ["Greater Blessing of Sanctuary"] = 900,
    ["Greater Blessing of Light"] = 900,
}

local function EqualAny(val, target)
    for v,_ in pairs(target) do
        if val == v then
            return true;
        end
    end
    return false;
end


function eventHandler.events:ADDON_LOADED(event, addon)
    if (addon == "BeBlessed") then

        local _, class = UnitClass("player");
        if (class ~= "PALADIN") then
            return;
        end

        if type(BeBlessedData) ~= "table" then
            BeBlessedData = {}
        end

        if (type(BeBlessedData[INDEX]) ~= "table") then
            BeBlessedData[INDEX] = {};
            BeBlessedData[INDEX].settings = {}
            BeBlessedData[INDEX].settings.modes = {[0] = 0, [1] = 0, [2] = 0, [3] = 0, [4] = 0}
            BeBlessedData[INDEX].buffStatus = {};
            BeBlessedData[INDEX].settings.selectedBlessings = {[0] = 0, [1] = 0, [2] = 0, [3] = 0, [4] = 0};
        end

        BeBlessed:CreateSpellNameLocale();
        BeBlessed:CreateBuffFrame();

        print("Be|cffF58CBABlessed|r: Loaded");
    end
end

function eventHandler.events:PLAYER_REGEN_ENABLED(event,...)
    inCombat = false;
end

function eventHandler.events:PLAYER_REGEN_DISABLED(event,...)
    inCombat = true;
end

function eventHandler.events:COMBAT_LOG_EVENT_UNFILTERED(event)

    local _, eventType, _, sourceGUID, sourceName, spellID, _, destGUID, destName, _, _, _, spellName = CombatLogGetCurrentEventInfo();

    if (sourceGUID == UnitGUID("player") and eventType == "SPELL_CAST_SUCCESS") then

        local engSpellName = BeBlessed.toEnglish[spellName];

        if EqualAny(engSpellName, BlessingDurations) then
            BeBlessedData[INDEX].buffStatus[destGUID] = {applied=GetTime(), spellName=engSpellName, spellID=spellID, duration=BlessingDurations[engSpellName]};
        end
        
    end
end

for event,_ in pairs(eventHandler.events) do
    eventHandler:RegisterEvent(event);
end
eventHandler:SetScript("OnEvent", function(self,event,...)
    eventHandler.events[event](self, event, ...);
end)


function BeBlessed:GetGUIDStatus(guid)
    if (type(BeBlessedData[INDEX].buffStatus[guid]) == "table") then
        return BeBlessedData[INDEX].buffStatus[guid]
    end
    return nil;
end

function BeBlessed:UnitHasBuff(unitID, buffName)
    for i = 1,40 do
        local name = UnitBuff(unitID, i);
        if name == buffName then
            return true;
        end
    end
    return false;
end

function BeBlessed:InCombat()
    return inCombat;
end

function BeBlessed:GetAvailableSpells()
    local avaialble = {};
    for k,v in pairs(BeBlessed.BlessingIDs) do 
        if IsSpellKnown(v) then
            avaialble[k] = true;
        end
    end
    return avaialble;
end

function BeBlessed:CreateSpellNameLocale()
    for k,v in pairs(BeBlessed.BlessingIDs) do
        local name = GetSpellInfo(v);
        BeBlessed.toLocal[k] = name;
        BeBlessed.toEnglish[name] = k;
    end
end
