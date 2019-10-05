local _, i
local _G = getfenv(0)

if GetLocale() == "zhCN" then
	zTip.locStr = {
		Rare			= "稀有",
		Targeting	= TARGET,
		YOU			= ">> 你 <<",
		Self			= "自己",
		NotSpecified	= "未指定",
		Specified	= "神秘物种",
		TargetedBy		= "关注",
		LocalClassName= {
			["DRUID"]		= 	"德鲁伊";
			["HUNTER"]		= 	"猎人";
			["MAGE"]		= 	"法师";
			["PRIEST"]		= 	"牧师";
			["ROGUE"]		= 	"潜行者";
			["WARLOCK"]		= 	"术士";
			["WARRIOR"]		= 	"战士";
			["SHAMAN"]		= 	"萨满祭司";
			["PALADIN"]		= 	"圣骑士";
			["DEATHKNIGHT"]	= 	"死亡骑士";
			},
		Loading				= "读取中...",
		TooFar				= "距离过远",
		DisableReadTalent	= "观察时停止读取",
		ResetCache			= "天赋缓存已清空",
		ItemLevel 			= "物等",
	}
	if zTipOption then
		zTipOption.locStr = {
			["zTip Options"] = "zTip Options",
			["Positions"] = "锚点位置",
			["Offsets"] = "偏移值（按Enter键生效）",
			["Original Position Offsets"] = "原始位置偏移",
			["Target"] = TARGET,
			["Fade"] = "渐隐",
			["PVPName"] = "头衔",
			["Reputation"] = "声望",
			["RealmName"] = "服务器名",
			["IsPlayer"] = "标识(玩家)",
			["ClassIcon"] = "职业图标",
			["VividMask"] = "立体化",
			["ShowTalent"] = "天赋",
			["TargetedBy"] = "关注目标",
			["HealthBAR"] = "生命条",
			["ManaBAR"] = "法力条",
			["NPCClass"] = "NPC职业",
			["Scale"] = "缩放",
			["FollowCursor"] = "鼠标右下",
			["FollowCursorA"] = "鼠标右下/右下角",
			["RootOnTop"] = "屏幕上方",
			["OnCursorTop"] = "鼠标上方",
			["RightBottom"] = "右下角",
			["OffsetX"] = "水平偏移",
			["OffsetY"] = "垂直偏移",
			["OrigPosX"] = "默认水平偏移",
			["OrigPosY"] = "默认垂直偏移",
			["TalentIcon"] = "天赋图标",
			["CombatHide"] = "BOSS战斗中隐藏",
			["ItemLevel"] = "物品等级",
			["FactionName"] = "隐藏阵营标志",
			["ShowBarNum"] = "显示数值",
			["TTarget"] = "目标的目标",
			["BarTexture"] = "切换材质",
			["GuildInfo"] = "公会会阶",
			["ShowLegend"] = "橙装数量",
			["MiniNum"] = "切换数值",
			["MiniNumTooltip"] = "|cff00ffff会造成其他类似数值都被改变!|r",
			["ShowRc"] = "显示距离",
			["ShowRcTooltip"] = "如果开启了LibRangeCheck",
		}
	end
elseif GetLocale() == "zhTW" then
	zTip.locStr = {
		PetLevel	="寵物等級",
		Rare			= "稀有",
		Targeting	= TARGET,
		YOU			= ">> 你 <<",
		Self			= "自己",
		NotSpecified	= "未指定", -- 也許不正確？
		Specified	= "神秘物種",
		Talent			= "天賦: ",
		inactiveTalent	= "備用: ",
		TargetedBy		= "關註",
		LocalClassName= {
			["DRUID"]		= 	"德魯伊";
			["HUNTER"]		= 	"獵人";
			["MAGE"]		= 	"法師";
			["PRIEST"]		= 	"牧師";
			["ROGUE"]		= 	"盜賊";
			["WARLOCK"]		= 	"術士";
			["WARRIOR"]		= 	"戰士";
			["SHAMAN"]		= 	"薩滿";
			["PALADIN"]		= 	"聖騎士";
			["DEATHKNIGHT"]	= 	"死亡騎士";
			},
		Loading				= "讀取中...",
		TooFar				= "距離過遠",
		DisableReadTalent	= "觀察時停止讀取",
		ResetCache			= "天賦緩存已清空",
		ItemLevel 			= "物等",
	}
	if zTipOption then
		zTipOption.locStr = {
			["zTip Options"] = "zTip Options",
			["Positions"] = "錨點設定",
			["Offsets"] = "偏移設定（按Enter鍵生效）",
			["Original Position Offsets"] = "原始偏移設定",
			["Target"] = TARGET,
			["Fade"] = "淡出",
			["PVPName"] = "頭銜",
			["Reputation"] = "聲望",
			["RealmName"] = "伺服器名",
			["IsPlayer"] = "標示(玩家)",
			["ClassIcon"] = "職業圖示",
			["VividMask"] = "立體化",
			["ShowTalent"] = "天賦",
			["TargetedBy"] = "關註目標",
			["HealthBAR"] = "生命條",
			["ManaBAR"] = "法力條",
			["NPCClass"] = "NPC職業",
			["Scale"] = "縮放",
			["FollowCursor"] = "游標右下",
			["FollowCursorA"] = "游標右下/右下角",
			["RootOnTop"] = "屏幕上方",
			["OnCursorTop"] = "游標正上",
			["RightBottom"] = "右下角",
			["OffsetX"] = "水平偏移",
			["OffsetY"] = "垂直偏移",
			["OrigPosX"] = "原始水平偏移",
			["OrigPosY"] = "原始垂直偏移",
			["TalentIcon"] = "天賦圖標",
			["CombatHide"] = "BOSS戰鬥中隱藏",
			["ItemLevel"] = "物品等級",
			["FactionName"] = "隱藏陣營標誌",
			["ShowBarNum"] = "顯示數值",
			["TTarget"] = "目标的目标",
			["BarTexture"] = "切換材質",
			["GuildInfo"] = "公会会阶",
			["ShowLegend"] = "橙裝數量",
			["MiniNum"] = "切換數值",
			["MiniNumTooltip"] = "|cff00ffff會導致其他類似數值都被改變!|r",
			["ShowRc"] = "显示距离",
			["ShowRcTooltip"] = "如果开启了LibRangeCheck",
		}
	end
else
	zTip.locStr = {
		PetLevel	="Petlevel",
		Rare			= "Rare",
		Targeting	= "Targeting",
		YOU			= ">> U <<",
		Self			= "Self",
		NotSpecified	= "Not specified", -- maybe not correct
		Specified	= "Mystery",
		Talent			= "Talent: ",
		inactiveTalent	= "Inactive: ",
		TargetedBy		= "TargetedBy",
		ItemLevel		 = "Item Level",
		LocalClassName= {
			["DRUID"]		= 	"Druid";
			["HUNTER"]		= 	"Hunter";
			["MAGE"]		= 	"Mage";
			["PRIEST"]		= 	"Priest";
			["ROGUE"]		= 	"Rogue";
			["WARLOCK"]		= 	"Warlock";
			["WARRIOR"]		= 	"Warrior";
			["SHAMAN"]		= 	"Shaman";
			["PALADIN"]		= 	"Paladin";
			["DEATHKNIGHT"]	= 	"DeathKnight";
			},
		Loading				= "Loading...",
		TooFar				= "Too far",
		DisableReadTalent	= "Disable loading while inspecting",
		ResetCache			= "Reset talent cache",
	}
	if zTipOption then
		zTipOption.locStr = {
			["zTip Options"] = "zTip Options",
			["Positions"] = "Positions",
			["Offsets"] = "Offsets(ENTER to apply)",
			["Original Position Offsets"] = "Original Position Offsets",
			["Target"] = "Target",
			["Fade"] = "Fade",
			["PVPName"] = "PVPName",
			["Reputation"] = "Reputation",
			["RealmName"] = "RealmName",
			["IsPlayer"] = "Mark(Player)",
			["ClassIcon"] = "ClassIcon",
			["VividMask"] = "VividMask",
			["ShowTalent"] = "ShowTalent",
			["TargetedBy"] = "TargetedBy",
			["ManaBAR"] = "Mana Bar",
			["NPCClass"] = "NPC Class",
			["Scale"] = "Scale",
			["FollowCursor"] = "FollowCursor",
			["RootOnTop"] = "RootOnTop",
			["OnCursorTop"] = "OnCursorTop",
			["RightBottom"] = "RightBottom",
			["OffsetX"] = "OffsetX",
			["OffsetY"] = "OffsetY",
			["OrigPosX"] = "OrigPosX",
			["OrigPosY"] = "OrigPosY",
			["ShowLegend"] = "Legend Num",
			["ShowRc"] = "Show Range",
			["ShowRcTooltip"] = "if has LibRangeCheck",
		}
	end
end
local Imp = {"ManaBAR","MiniNum","ShowBarNum"}
local id,value;
for id,value in pairs(Imp) do
	if (zTipOption.locStr[value]) then 
		zTipOption.locStr[value] = "|cffFF0000"..zTipOption.locStr[value].."|r"
		if not (zTipOption.locStr[value.."Tooltip"]) then
			zTipOption.locStr[value.."Tooltip"] = "|cffFF0000需要重载插件\r\n输入/reload|r";
		else
			zTipOption.locStr[value.."Tooltip"] = zTipOption.locStr[value.."Tooltip"].."\r\n".."|cffFF0000需要重载插件\r\n输入/reload|r";
		end
	end
end