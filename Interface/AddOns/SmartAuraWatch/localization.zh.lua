-------------------------------------------------------------------------------
-- Taiwanese localization
-------------------------------------------------------------------------------

if (GetLocale() == "zhTW") then
local L = SmartAuraWatchLoc;

-- Time shortcuts
L.ScDay  = "%d天";   -- Days
L.ScHour = "%d小時"; -- Hours
L.ScMin  = "%d分鐘"; -- Minutes
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
L.ScRG = "遠程";    -- Ranged
L.ScT1 = "飾品1";   -- Trinket 1
L.ScT2 = "飾品2";   -- Trinket 2
L.ScHand  = "手"; -- Hand
L.ScWaist = "腰"; -- Waist
L.ScCloak = "披風"; -- Cloak

L.FocusTarget = "焦點目標";
L.MouseOver = "滑鼠懸停";
L.Arena = "Arena %d";
L.On = "On";
L.Bars = "條的數量: %s";
L.ActiveBar = "設定哪個條: %s";
L.BarAlpha = "透明度: %s%%";
L.IconSize = "圖示大小: %s";
L.Orientation = "%s";
L.Growth = "%s";
L.Vertical = "垂直";
L.Horizontal = "水平";
L.HBar = "水平1";
L.VBar = "垂直1";
L.Center = "齊中";
L.Top = "上";
L.Bottom = "下";
L.Right = "右";
L.Left = "左";
L.AuraHelp = "左鍵: 選擇\n右鍵: 刪除\n邊框可拖動";
L.Unit = "%s";
L.Relship = "%s";
L.DurationMin = "持續時間 [秒] < %s";
L.DurationMax = "持續時間 [秒] > %s";
L.CountMin = "計數最小值 < %s";
L.CountMax = "計數最大值 > %s";
L.TalentTree = "天賦: %s";
L.MyAura = "自己";
L.MyAuraTT = "只監視由自己施放的";
L.OnlyInCombat = "僅戰鬥中";
L.OnlyInCombatTT = "只在戰鬥中監視.";
L.NotUp = "總是顯示";
L.NotUpTT = "如果目標身上沒有被施放,也會顯示圖示";
L.Filter = "過濾: %s";
L.Helpful = "增益";
L.Harmful = "減益";
L.Cancelable = "可取消";
L.NotCancelable = "不可取消";
L.Enchant = "附魔";
L.Cooldown = "冷卻計時";
L.Sound = "警報聲音: %s";
L.SoundsTitle = "警報聲音";
L.SoundsHelp = "左鍵: 選擇\n右鍵: 演示播放";
L.GlobalLoad = "載入全局配置";
L.GlobalLoadTT = "從全局設定檔載入設定.";
L.GlobalSave = "保存全局配置";
L.GlobalSaveTT = "將當前設定保存為全局設定檔.";
L.ShowCd = "冷卻CD";
L.ShowCdTT = "顯示光環的冷卻";
L.AuraScanTT = "在戰鬥中掃瞄光環以建立選擇列表.";
L.AuraScanTitle = "光環掃瞄";
L.AuraScanHelp = "左鍵: 應用光環\n右鍵: 刪除";
L.Stat = "統計";
L.StatTitle = "統計顯示";
L.StatHelp = "右鍵: 重置";
L.StatBar = "統計 %d";
L.StatResetAll = "重置所有統計訊息";
L.ColoredTL = "彩色";
L.ColoredTLTT = "顯示彩色剩餘時間數字.";
L.SecTL = "整秒顯示";
L.SecTLTT = "將秒顯示為整數.";
L.InCombatUptime = "戰鬥時間:";
L.RunTime = "執行時間: %s";
L.CombatTime = "戰鬥時間 (%s)";
L.AutoReset = "自動重置";
L.AutoResetTT = "戰鬥開始前自動重置條統計.";
L.Tooltips = "滑鼠提示";
L.TooltipsTT = "在此欄上啟用光環滑鼠提示";
L.ReportLines = "行數";
L.ReportTitle = "報告";
L.ReportMsg = "報告 %d";
L.ReportWhisperTo = "私聊給:";
L.ReportUseLinks = "使用連結";
L.ReportSkipZero = "跳過 0%";

L.OptionsGlobalTitle = "全局設定";
L.ShowIconBorder = "顯示圖示邊框";
L.ShowIconBorderTT = "顯示圖示的預設邊框";
L.ShowSpark = "顯示觸發閃爍";
L.ShowSparkTT = "在狀態列值處顯示火花閃爍";
L.TimerStyle = "暴雪計時器風格";
L.TimerStyleTT = "以「暴雪」風格展示光環.";
L.BarStyle = "風格: %s";
L.FontSizeOffset = "字型大小: %s";
L.Loaded = "已載入";
L.SetupInfo = "/saw 顯示設定框架";
L.Reset = "將本地設定重置為預設值";
L.ResetAll = "將所有設定重置為預設值";

L.SpacingOffset = "按鍵間距: %s";

end