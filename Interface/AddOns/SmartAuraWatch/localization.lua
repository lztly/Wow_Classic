-------------------------------------------------------------------------------
-- English localization (Default)
-- This file must be loaded, as it fills in the gaps for partial translations
-------------------------------------------------------------------------------

SmartAuraWatchLoc = { };
local L = SmartAuraWatchLoc;

L.WhatsNew = "|cffffffffWhats new:|r\n\n"
  .."- Inital WoW classic release\n\n"
  --.."- Added Masque support\n\n"
  --.."- This release will restore basic functionality, but unfortunately it does not contain all the new aura changes, sorry.\n\n"
  .."\n- Please report any kind of issues, thanks!\n\n"
  ;


-- Default localization by WoW
L.Player = PLAYER;
L.Target = TARGET;
L.Focus = FOCUS;
L.TargetTarget = SHOW_TARGET_OF_TARGET_TEXT;
L.Pet = PET;
L.All = ALL;
L.Friendly = FRIENDLY;
L.Enemy = ENEMY;
L.Primary = PRIMARY;
L.Secondary = SECONDARY;
L.AuraTitle = AURAS;
L.Clear = DELETE;
L.Default = DEFAULT;
L.None = NONE;
L.Off = OFF;
L.SoundNone = "- "..NONE.." -";
L.Add = ADD;
L.Show = SHOW;
L.MainHand = INVTYPE_WEAPONMAINHAND;
L.OffHand = INVTYPE_WEAPONOFFHAND;
L.Ranged = INVTYPE_THROWN;
L.Hand = INVTYPE_HAND;
L.Cloak = INVTYPE_CLOAK;
L.Waist = INVTYPE_WAIST;
L.Trinket1 = TRINKET0SLOT_UNIQUE;
L.Trinket2 = TRINKET1SLOT_UNIQUE;
L.Whisper = WHISPER;
L.Say = SAY;
L.Raid = RAID;
L.Party = PARTY;
L.Guild = GUILD;
L.Officer = OFFICER;
L.Self = QUICKBUTTON_NAME_SELF;
L.Channel = CHANNEL;
L.ReportSend = SEND_LABEL;


-- Display states
L.Infinity = "∞";
L.InvRdy   = "+";
L.Missing  = "!!!";


-- Time shortcuts
L.ScDay  = "%dd"; -- DAYS_ABBR
L.ScHour = "%dh"; -- HOURS_ABBR
L.ScMin  = "%dm"; -- MINUTES_ABBR
L.ScSec  = "%ds"; -- SECONDS_ABBR

-- Target shortcuts
L.ScP   = "P";   -- Player
L.ScT   = "T";   -- Target
L.ScF   = "F";   -- Focus
L.ScTT  = "TT";  -- Target of Target
L.ScFT  = "FT";  -- Target of Focus
L.ScPet = "Pt";  -- Pet
L.ScMo  = "Mo";  -- Mouseover
L.ScA   = "A%d"  -- Arena
L.ScCd  = "Cd";  -- Cooldown

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
L.Arena = "Arena %d";
L.On = "On";
L.Bars = "Bars: %s";
L.ActiveBar = "Settings Bar: %s";
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
L.Right = "Right";
L.Left = "Left";
L.AuraHelp = "Left click: Select\nRight click: Delete\nDrag'n'Drop to order";
L.Unit = "%s";
L.Relship = "%s";
L.DurationMin = "Duration [sec] < %s";
L.DurationMax = "Duration [sec] > %s";
L.CountMin = "Charges < %s";
L.CountMax = "Charges > %s";
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
L.TimerStyle = "Blizzard Timer Style";
L.TimerStyleTT = "Displays the aura in 'Blizzard' style.";

L.OptionsGlobalTitle = "Global Options";
L.BarStyle = "Bar Style: %s";
L.FontSizeOffset = "Font Size Offset: %s";
L.SpacingOffset = "Button Spacing: %s";
L.ShowIconBorder = "Show Icon Border";
L.ShowIconBorderTT = "Displays the icon with the default border.";
L.ShowSpark = "Show Bar Spark";
L.ShowSparkTT = "Displays a spark at the actual statusbar value.";

-- FOR TESTING ONLY --------------------
--[[
L.Player = "Player";
L.Target = "Target";
L.Focus = "Focus";
L.FocusTarget = "Target of Focus";
L.All = "All";
L.Friendly = "Friendly";
L.Enemy = "Enemy";
L.Primary = "Primary";
L.Secondary = "Secondary";
L.AuraTitle = "Auras";
L.Clear = "Delete";
L.Default = "Default";
L.None = "None";
L.Off = "Off";
L.SoundNone = "- None -";
]]--
----------------------------------------
