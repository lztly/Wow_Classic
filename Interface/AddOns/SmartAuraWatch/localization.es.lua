-------------------------------------------------------------------------------
-- Spanish localization
-------------------------------------------------------------------------------

if (GetLocale() == "esES" or GetLocale() == "esMX") then
local L = SmartAuraWatchLoc;

-- Time shortcuts
L.ScDay  = "%dd"; -- Days
L.ScHour = "%dh"; -- Hours
L.ScMin  = "%dm"; -- Minutes
L.ScSec  = "%ds"; -- Seconds

-- Target shortcuts
L.ScP = "P";     -- Player
L.ScT = "T";     -- Target
L.ScF = "F";     -- Focus
L.ScTT = "TT";   -- Target of Target
L.ScFT = "FT";   -- Target of Focus
L.ScPet = "Pt";  -- Pet
L.ScMo  = "Ra";  -- Mouseover
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

L.FocusTarget = "Objetivo de foco";
L.MouseOver = "Ratón";
L.Arena = "Arena %d";
L.On = "Sí";
L.Bars = "Barras: %s";
L.ActiveBar = "Configuración Barra: %s";
L.BarAlpha = "Visibilidad: %s%%";
L.IconSize = "Tamaño de la icono: %s";
L.Orientation = "%s";
L.Growth = "%s";
L.Vertical = "Vertical";
L.Horizontal = "Horizontal";
L.HBar = "Hor. + Barras";
L.VBar = "Vert. + Barras";
L.Center = "Centrada";
L.Top = "Arriba";
L.Bottom = "Abajo";
L.Right = "Derecho";
L.Left = "Izquierdo";
L.AuraHelp = "Left click: Select\nRight click: Delete\nDrag'n'Drop to order";
L.Unit = "%s";
L.Relship = "%s";
L.DurationMin = "Duración [s] < %s";
L.DurationMax = "Duración [s] > %s";
L.CountMin = "Cargas < %s";
L.CountMax = "Cargas > %s";
L.TalentTree = "Rama de talento: %s";
L.MyAura = "Propia aura";
L.MyAuraTT = "Watches the aura only, if it is casted by yourself.";
L.OnlyInCombat = "Con tal de combate";
L.OnlyInCombatTT = "Watches the aura only during combat.";
L.NotUp = "No activo";
L.NotUpTT = "Shows the icon also, if the aura is not active on the observed target.";
L.Filter = "Filtro: %s";
L.Helpful = "Útil";
L.Harmful = "Dañina";
L.Cancelable = "Abrogable";
L.NotCancelable = "No abrogable";
L.Enchant = "Encantar";
L.Cooldown = "Descanso";
L.Sound = "Son de atención: %s";
L.SoundsTitle = "Son de atención";
L.SoundsHelp = "Left click: Select\nRight click: Demo play";
L.GlobalLoad = "Load global Profile";
L.GlobalLoadTT = "Loads the settings from the global profile.";
L.GlobalSave = "Save global Profile";
L.GlobalSaveTT = "Saves the current settings as global profile.";
L.ShowCd = "Descanso";
L.ShowCdTT = "Shows the cooldown of the aura.";
L.AuraScanTT = "Scans the auras during combat to built up the selection list.";
L.AuraScanTitle = "Aura Scan";
L.AuraScanHelp = "Left click: Apply Aura\nRight click: Delete";
L.Stat = "Est";
L.StatTitle = "Estadísticas";
L.StatHelp = "Right click: Reset";
L.StatBar = "Estadísticas barra %d";
L.StatResetAll = "Reset ALL Statistics";
L.ColoredTL = "Colorido";
L.ColoredTLTT = "Displays colored time left numbers.";
L.SecTL = "Full seconds";
L.SecTLTT = "Displays seconds as integer numbers.";
L.InCombatUptime = "In combat uptime:";
L.RunTime = "Duración: %s";
L.CombatTime = "Duración de combate (%s)";
L.AutoReset = "Auto restablecer";
L.AutoResetTT = "Auto reset the bar statistics before the combat starts.";
L.Tooltips = "Consejos";
L.TooltipsTT = "Enable aura tooltips on this bar.";
L.ReportLines = "Líneas";
L.ReportTitle = "Informe";
L.ReportMsg = "Informe barra %d";
L.ReportWhisperTo = "Susurrar a:";
L.ReportUseLinks = "Use los vínculos";
L.ReportSkipZero = "Salto 0%";

L.Loaded = "loaded";
L.SetupInfo = "/saw to display setup frame";
L.Reset = "Reset local settings to default";
L.ResetAll = "Reset ALL settings to default";

L.SpacingOffset = "Botón Espaciado: %s";

end
