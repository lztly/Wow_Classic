-------------------------------------------------------------------------------
-- Russian localization
-------------------------------------------------------------------------------

if (GetLocale() == "ruRU") then
local L = SmartAuraWatchLoc;

-- Time shortcuts
L.ScDay  = "%dд"; -- Days
L.ScHour = "%dч"; -- Hours
L.ScMin  = "%dм"; -- Minutes
L.ScSec  = "%dс"; -- Seconds

-- Target shortcuts
L.ScP = "P";     -- Player
L.ScT = "T";     -- Target
L.ScF = "F";     -- Focus
L.ScTT = "TT";   -- Target of Target
L.ScFT = "FT";   -- Target of Focus
L.ScPet = "Pt";  -- Pet
L.ScMo  = "Mo";  -- Mouseover
L.ScA   = "A%d"  -- Arena

-- Inventory shortcuts
L.ScMH = "Mh";   -- Main hand
L.ScOH = "Oh";   -- Off hand
L.ScRG = "R";    -- Ranged
L.ScT1 = "T1";   -- Trinket 1
L.ScT2 = "T2";   -- Trinket 2
L.ScHand  = "H"; -- Hand
L.ScWaist = "W"; -- Waist
L.ScCloak = "C"; -- Cloak

L.FocusTarget = "Target of Focus";
L.MouseOver = "Mouseover";
L.Arena = "Арена %d";
L.On = "On";
L.Bars = "Bars: %s";
L.ActiveBar = "Setup панель: %s";
L.BarAlpha = "Visibility: %s%%";
L.IconSize = "Icon Size: %s";
L.Orientation = "%s";
L.Growth = "%s";
L.Vertical = "Vertical";
L.Horizontal = "Horizontal";
L.HBar = "Hor. + Bars";
L.VBar = "Vert. + Bars";
L.Center = "Center";
L.Top = "Top";
L.Bottom = "Bottom";
L.Right = "вправо";
L.Left = "влево";
L.AuraHelp = "Left click: Select\nRight click: Delete\nDrag'n'Drop to order";
L.Unit = "%s";
L.Relship = "%s";
L.DurationMin = "Срок действия [сек] < %s";
L.DurationMax = "Срок действия [сек] > %s";
L.CountMin = "зарядов < %s";
L.CountMax = "зарядов > %s";
L.TalentTree = "Talent Tree: %s";
L.MyAura = "Own Aura";
L.MyAuraTT = "Watches the aura only, if it is casted by yourself.";
L.OnlyInCombat = "Only in Combat";
L.OnlyInCombatTT = "Watches the aura only during combat.";
L.NotUp = "Not Active";
L.NotUpTT = "Shows the icon also, if the aura is not active on the observed target.";
L.Filter = "Filter: %s";
L.Helpful = "Helpful";
L.Harmful = "Harmful";
L.Cancelable = "Cancelable";
L.NotCancelable = "Not Cancelable";
L.Enchant = "Enchant";
L.Cooldown = "Cooldown";
L.Sound = "Alert Sound: %s";
L.SoundsTitle = "Alert Sounds";
L.SoundsHelp = "Left click: Select\nRight click: Demo play";
L.GlobalLoad = "Load global Profile";
L.GlobalLoadTT = "Loads the settings from the global profile.";
L.GlobalSave = "Save global Profile";
L.GlobalSaveTT = "Saves the current settings as global profile.";
L.ShowCd = "Cooldown";
L.ShowCdTT = "Shows the cooldown of the aura.";
L.AuraScanTT = "Scans the auras during combat to built up the selection list.";
L.AuraScanTitle = "Aura Scan";
L.AuraScanHelp = "Left click: Apply Aura\nRight click: Delete";
L.Stat = "Stat";
L.StatTitle = "Statistics";
L.StatHelp = "Right click: Reset";
L.StatBar = "Statistics Bar %d";
L.StatResetAll = "Reset ALL Statistics";
L.ColoredTL = "Colored";
L.ColoredTLTT = "Displays colored time left numbers.";
L.SecTL = "Full seconds";
L.SecTLTT = "Displays seconds as integer numbers.";
L.InCombatUptime = "In combat uptime:";
L.RunTime = "Run time: %s";
L.CombatTime = "Combat time (%s)";
L.AutoReset = "Auto Reset";
L.AutoResetTT = "Auto reset the bar statistics before the combat starts.";
L.Tooltips = "Tooltips";
L.TooltipsTT = "Enable aura tooltips on this bar.";
L.ReportLines = "Lines";
L.ReportTitle = "Report";
L.ReportMsg = "Report Bar %d";
L.ReportWhisperTo = "Whisper to:";
L.ReportUseLinks = "Use Links";
L.ReportSkipZero = "Skip 0%";

L.Loaded = "loaded";
L.SetupInfo = "/saw to display setup frame";
L.Reset = "Reset local settings to default";
L.ResetAll = "Reset ALL settings to default";

L.SpacingOffset = "Кнопка Расстояние: %s";

end
