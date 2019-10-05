local addons, ns = ...
if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
    ns.LOCALE = {
        ["Show"] = "显示",
        ["Hide"] = "隐藏",
        ["All Quests"] = "所有任务",
        ["Tracked Quests"] = "追踪的任务",
        ["Manual Selection"] = "手动选择",
        ["Hide Quests"] = "隐藏任务",
        ["Buy"] = "购买",
        ["Level"] = "等级",
        ["Required"] = "需要",
        ["Loot"] = "拾取",
        ["Vendor"] = "商贩",
        ["Quest Start"] = "任务开始",
        ["Quest End"] = "任务结束",
        ["Quest Level"] = "任务等级",
        ["Required Level"] = "需要等级",

        ["Auto-Accept Quests"] = "自动接任务",
        ["Toggle auto-accepting quests"] = "开启/关闭自动接任务",
        ["Auto-Turnin Quests"] = "自动交任务",
        ["Toggle auto-turning in quests"] = "开启/关闭自动交任务",
        ["Nameplate Quest Icon"] = "姓名板任务图标",
        ["Toggle quest icon on top of enemy nameplates"] = "在任务怪姓名板上方显示任务感叹号",
        ["All Questgivers"] = "显示所有可接任务",
        ["If selected, this will display all questgivers on the map"] = "选中后，在地图和小地图上显示可接任务的图标",
        ["Current Questgivers"] = "显示当前任务NPC",
        ["If selected, current quest-ender npcs/objects will be displayed on the map for active quests"] = "选中后，可交付当前任务的NPC或物体会显示在地图上",
        ["Show Low-level Quests"] = "显示低等级任务",
        ["If selected, low-level quests will be hidden on the map"] = "选中后，地图上的低等级任务(比玩家等级低10级)不再被隐藏",
        ["Show High-level Quests"] = "显示高等级任务",
        ["If selected, quests with a level requirement of your level + 3 will be shown on the map"] ="选中后，可接等级比玩家等级高3级的任务也会显示在地图上",
        ["Show Festival Quests"] = "显示节日任务",
        ["If selected, quests related to WoW festive seasons will be displayed on the map"] = "选中后，节日相关任务会被显示在地图上",
        ["Color By Spawn"] = "按任务怪类型标记颜色",
        ["If selected, markers' colors will be set per spawn type or per quest if not selected"] = "选中后，不同任务怪的地图标记颜色不同。如果未选中，则一个任务的所有任务怪都是同一个颜色。",
        ["Quest Marker Size"] = "任务标记大小",
        ["Spawn Marker Size"] = "怪物标记大小",
        ["Hide items with a drop probability less than (%)"] = "隐藏掉落概率低于(%)的物品",
        ["Show All Quests You Manually Hide"] = "显示所有手动隐藏的任务",
        ["Show all the quests you have hidden by shift + click.\nHide a quest by holding the shift key and clicking on the quest icon on the minimap or world map."] = "显示所有通过Shift+点击隐藏的任务\n按住Shift并点击小地图或世界地图上的任务图标可以隐藏任务",
        ['ClassicCodex: You have no manually hidden quests. You can hold the shift key and click on the quest icon on the minimap or world map to hide it.'] = 'ClassicCodex: 您没有手动隐藏过任何任务，按住Shift并点击小地图或世界地图上的任务图标可以隐藏任务',
        [' hidden quests will be able to show again.'] = '个隐藏任务已重新显示',
    }
else
    ns.LOCALE = setmetatable({  }, { __index = function(t, k) return k; end, });
end
--[[
local addons, ns = ...
local LOCALE = ns.LOCALE;
]]