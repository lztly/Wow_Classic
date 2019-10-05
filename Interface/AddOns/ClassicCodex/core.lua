Codex = {}
CodexHiddenQuests = {}

function Codex:strsplit(delimiter, data)
    if not data then return nil end
    local delimiter, fields = delimiter or ":", {}
    local pattern = string.format("([^%s]+)", delimiter)
    string.gsub(data, pattern, function(c) fields[table.getn(fields) + 1] = c end)
    return unpack(fields)
end

local sanitizeCache = {}
function Codex:SanitizePattern(pattern)
    if not sanitizeCache[pattern] then
        local result = pattern

        -- escape magic characters
        result = gsub(result, "([%+%-%*%(%)%?%[%]%^])", "%%%1")
        -- remove capture indexes
        result = gsub(result, "%d%$","")
        -- catch all characters
        result = gsub(result, "(%%%a)","%(%1+%)")
        -- convert all %s to .+
        result = gsub(result, "%%s%+",".+")
        -- set priority to number over strings
        result = gsub(result, "%(.%+%)%(%%d%+%)","%(.-%)%(%%d%+%)")

        sanitizeCache[pattern] = result
    end

    return sanitizeCache[pattern]
end

function Codex:tablelen(table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end


local function ALA_DEBUG()
    local data = {};
    local _, numQuests = GetNumQuestLogEntries()
    local found = 0;
    for questLogId = 1, 40 do
        local name, _, _, header, _, complete, _, questId = GetQuestLogTitle(questLogId)
        if not header then
            tinsert(data, name .. "[" .. questId .. "]");
            found = found + 1
            if found >= numQuests then
                break
            end
        end
    end
    _G.ALA_DEBUG_DATA = data;
    local cb = ChatEdit_ChooseBoxForSend();
    cb:SetText("");
    cb:Insert("/tinspect ALA_DEBUG_DATA");
    cb:GetScript("OnEnterPressed")(cb);
    _G.ALA_DEBUG_DATA = nil;
end
SLASH_ALADEBUG1 = "/alaCodexDebug";
SLASH_ALADEBUG2 = "/acd";
SlashCmdList["ALADEBUG"] = ALA_DEBUG;

