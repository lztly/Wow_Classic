
QuestieCorrections_questExclusiveGroupFixes = {
    [463] = {276}, --greenwarden cant be completed if you have trampling paws
    [415] = {413}, --cant complete rejolds new brew if you do shimmer stout (see issue 567)
    [1339] = {1338}, -- mountaineer stormpike's task cant be done if you have finished stormpike's order
    [1943] = {1944}, -- mage robe breadcrumb
    [526] = {322,324}, -- not 100% sure on this one but it seems lightforge ingots is optional, block it after completing subsequent steps (#587)
    [3765] = {1275}, -- corruption abroad breadcrumb
    [164] = {95}, -- deliveries to sven is a breadcrumb
    -- this is a subquest
    --[403] = {311}, -- completing the unguarded barrel quest prevents to do the optional guarded barrel prequest
    [428] = {429}, -- lost deathstalkers breadcrumb
    [308] = {311}, -- distracting jarven can't be completed once you get the followup
    -- Tome of Divinity starting quests for dwarfs #703
    [1645] = {1642,1646,2997,2998,2999,3000,3681}, -- This is repeatable giving an item starting 1646
    [1646] = {1642,2997,2998,2999,3000,3681},
    [2997] = {1642,1646,2998,2999,3000,3681},
    [2999] = {1642,1646,2997,2998,3000,3681},
    [3000] = {1642,1646,2997,2998,2999,3681},
    -- Tome of Divinity starting quests for humans #703
    [1641] = {1642,1646,2997,2998,2999,3000,3861}, -- This is repeatable giving an item starting 1642
    [1642] = {1646,2997,2998,2999,3000,3861},
    [2998] = {1642,1646,2997,2998,3000,3861},
    [3861] = {1642,1646,2997,2998,2999,3000},
    -- Tome of Valor repeatable starting quests #742
    [1793] = {1649},
    [1794] = {1649},
    [431] = {411}, -- candles of beckoning
    [410] = {411}, -- the dormant shade
    -- Tome of Nobility quests #1661
    [1661] = {4485,4486},
    [4485] = {1661,4486},
    [4486] = {1661,4485},
    -- Voidwalker questline for horde
    [1473] = {1501},
    [1501] = {1473},
    [163] = {5}, -- Raven Hill breadcrumb
    [1301] = {1302}, -- breadcrumb of James Hyal #917
}

U1RegisterAddon("ClassicCodex", {
    title = "任务数据库Codex",
    desc = "在地图上标记可接、可交、正在进行的任务地点",
    tags = { TAG_MAPQUEST, },
    load = "NORMAL",
    defaultEnable = 0,
    icon = [[Interface\Icons\INV_Letter_02]],
    nopic = 1,
    --conflicts = { "Questie" },
    minimap = 'CodexBrowserIcon', 
    icon = [[Interface\Addons\ClassicCodex\img\logo]],
    runBeforeLoad = function(info, name)
    end,

    {
        text = "配置选项",
        callback = function(cfg, v, loading)
            local func = CoreIOF_OTC or InterfaceOptionsFrame_OpenToCategory
            func("ClassicCodex")
        end
    }
});
