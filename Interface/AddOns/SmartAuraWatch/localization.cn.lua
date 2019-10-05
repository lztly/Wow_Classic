-------------------------------------------------------------------------------
-- Taiwanese localization
-------------------------------------------------------------------------------

if (GetLocale() == "zhCN") then
local L = SmartAuraWatchLoc;

-- Time shortcuts
L.ScDay  = "%d天";   -- Days
L.ScHour = "%d小时"; -- Hours
L.ScMin  = "%d分钟"; -- Minutes
L.ScSec  = "%d秒";   -- Seconds

-- Target shortcuts
L.ScP   = "P";   -- Player
L.ScT   = "T";   -- Target
L.ScF   = "F";   -- Focus
L.ScTT  = "TT";  -- Target of Target
L.ScFT  = "FT";  -- Target of Focus
L.ScPet = "Pt";  -- Pet
L.ScMo  = "Mo";  -- Mouseover
L.ScA   = "A%d"  -- Arena

-- Inventory shortcuts
L.ScMH = "主手";   -- Main hand
L.ScOH = "副手";   -- Off hand
L.ScRG = "远程";    -- Ranged
L.ScT1 = "饰品1";   -- Trinket 1
L.ScT2 = "饰品2";   -- Trinket 2
L.ScHand  = "手"; -- Hand
L.ScWaist = "腰"; -- Waist
L.ScCloak = "披风"; -- Cloak

L.FocusTarget = "焦点目标";
L.MouseOver = "鼠标悬停";
L.Arena = "Arena %d";
L.On = "On";
L.Bars = "条的数量: %s";
L.ActiveBar = "设置哪个条: %s";
L.BarAlpha = "透明度: %s%%";
L.IconSize = "图标大小: %s";
L.Orientation = "%s";
L.Growth = "%s";
L.Vertical = "垂直";
L.Horizontal = "水平";
L.HBar = "水平1";
L.VBar = "垂直1";
L.Center = "居中";
L.Top = "上";
L.Bottom = "下";
L.Right = "右";
L.Left = "左";
L.AuraHelp = "左键: 选择\n右键: 删除\n边框可拖动";
L.Unit = "%s";
L.Relship = "%s";
L.DurationMin = "持续时间 [秒] < %s";
L.DurationMax = "持续时间 [秒] > %s";
L.CountMin = "计数最小值 < %s";
L.CountMax = "计数最大值 > %s";
L.TalentTree = "天赋: %s";
L.MyAura = "自己";
L.MyAuraTT = "只监视由自己施放的";
L.OnlyInCombat = "仅战斗中";
L.OnlyInCombatTT = "只在战斗中监视.";
L.NotUp = "总是显示";
L.NotUpTT = "如果目标身上没有被施放,也会显示图标";
L.Filter = "过滤: %s";
L.Helpful = "增益";
L.Harmful = "减益";
L.Cancelable = "可取消";
L.NotCancelable = "不可取消";
L.Enchant = "附魔";
L.Cooldown = "冷却计时";
L.Sound = "警报声音: %s";
L.SoundsTitle = "警报声音";
L.SoundsHelp = "左键: 选择\n右键: 演示播放";
L.GlobalLoad = "加载全局配置";
L.GlobalLoadTT = "从全局配置文件加载设置.";
L.GlobalSave = "保存全局配置";
L.GlobalSaveTT = "将当前设置保存为全局配置文件.";
L.ShowCd = "冷却CD";
L.ShowCdTT = "显示光环的冷却";
L.AuraScanTT = "在战斗中扫描光环以建立选择列表.";
L.AuraScanTitle = "光环扫描";
L.AuraScanHelp = "左键: 应用光环\n右键: 删除";
L.Stat = "统计";
L.StatTitle = "统计显示";
L.StatHelp = "右键: 重置";
L.StatBar = "统计 %d";
L.StatResetAll = "重置所有统计信息";
L.ColoredTL = "彩色";
L.ColoredTLTT = "显示彩色剩余时间数字.";
L.SecTL = "整秒显示";
L.SecTLTT = "将秒显示为整数.";
L.InCombatUptime = "战斗时间:";
L.RunTime = "运行时间: %s";
L.CombatTime = "战斗时间 (%s)";
L.AutoReset = "自动重置";
L.AutoResetTT = "战斗开始前自动重置条统计.";
L.Tooltips = "鼠标提示";
L.TooltipsTT = "在此栏上启用光环鼠标提示";
L.ReportLines = "行数";
L.ReportTitle = "报告";
L.ReportMsg = "报告 %d";
L.ReportWhisperTo = "私聊给:";
L.ReportUseLinks = "使用链接";
L.ReportSkipZero = "跳过 0%";

L.OptionsGlobalTitle = "全局设置";
L.ShowIconBorder = "显示图标边框";
L.ShowIconBorderTT = "显示图标的默认边框";
L.ShowSpark = "显示触发闪烁";
L.ShowSparkTT = "在状态栏值处显示火花闪烁";
L.TimerStyle = "暴雪计时器风格";
L.TimerStyleTT = "以“暴雪”风格展示光环.";
L.BarStyle = "风格: %s";
L.FontSizeOffset = "字体大小: %s";
L.Loaded = "已加载";
L.SetupInfo = "/saw 显示设置框架";
L.Reset = "将本地设置重置为默认值";
L.ResetAll = "将所有设置重置为默认值";

L.SpacingOffset = "按键间距: %s";

end