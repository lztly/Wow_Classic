-------------------------------------------------------------------------------
-- French localization
-------------------------------------------------------------------------------

if (GetLocale() == "frFR") then
local L = SmartAuraWatchLoc;

-- Time shortcuts
L.ScDay  = "%dj"; -- Days
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
L.ScMo  = "Ss";  -- Mouseover
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

L.FocusTarget = "Cible de la focalisation";
L.MouseOver = "Survol de la souris";
L.Arena = "Arène %d";
L.On = "On";
L.Bars = "Barres: %s";
L.ActiveBar = "Réglages Barre: %s";
L.BarAlpha = "Visibilité: %s%%";
L.IconSize = "Taille de l'icône: %s";
L.Orientation = "%s";
L.Growth = "%s";
L.Vertical = "Vertical";
L.Horizontal = "Horizontal";
L.HBar = "Hor. + Barres";
L.VBar = "Vert. + Barres";
L.Center = "Centrique";
L.Top = "En haut";
L.Bottom = "En bas";
L.Right = "Droite";
L.Left = "Gauche";
L.AuraHelp = "Left click: Select\nRight click: Delete\nDrag'n'Drop to order";
L.Unit = "%s";
L.Relship = "%s";
L.DurationMin = "Durée [sec] < %s";
L.DurationMax = "Durée [sec] > %s";
L.CountMin = "Charges < %s";
L.CountMax = "Charges > %s";
L.TalentTree = "Arbres de talents: %s";
L.MyAura = "Propre aura";
L.MyAuraTT = "Watches the aura only, if it is casted by yourself.";
L.OnlyInCombat = "Seulement en combat";
L.OnlyInCombatTT = "Watches the aura only during combat.";
L.NotUp = "Non actif";
L.NotUpTT = "Shows the icon also, if the aura is not active on the observed target.";
L.Filter = "Filtre: %s";
L.Helpful = "Secourable";
L.Harmful = "Nocive";
L.Cancelable = "Résoluble";
L.NotCancelable = "Non résoluble";
L.Enchant = "Enchanter";
L.Cooldown = "Recharge";
L.Sound = "Son d'alarme: %s";
L.SoundsTitle = "Son d'alarme";
L.SoundsHelp = "Left click: Select\nRight click: Demo play";
L.GlobalLoad = "Load global Profile";
L.GlobalLoadTT = "Loads the settings from the global profile.";
L.GlobalSave = "Save global Profile";
L.GlobalSaveTT = "Saves the current settings as global profile.";
L.ShowCd = "Recharge";
L.ShowCdTT = "Shows the cooldown of the aura.";
L.AuraScanTT = "Scans the auras during combat to built up the selection list.";
L.AuraScanTitle = "Aura Scan";
L.AuraScanHelp = "Left click: Apply Aura\nRight click: Delete";
L.Stat = "Stat";
L.StatTitle = "Statistiques";
L.StatHelp = "Right click: Reset";
L.StatBar = "Statistiques barre %d";
L.StatResetAll = "Reset ALL Statistics";
L.ColoredTL = "Coloré";
L.ColoredTLTT = "Displays colored time left numbers.";
L.SecTL = "Full seconds";
L.SecTLTT = "Displays seconds as integer numbers.";
L.InCombatUptime = "In combat uptime:";
L.RunTime = "Période d'action: %s";
L.CombatTime = "Période de combat (%s)";
L.AutoReset = "Auto réinitialiser";
L.AutoResetTT = "Auto reset the bar statistics before the combat starts.";
L.Tooltips = "Bulles d'aide";
L.TooltipsTT = "Enable aura tooltips on this bar.";
L.ReportLines = "Lignes";
L.ReportTitle = "Rapport";
L.ReportMsg = "Rapport barre %d";
L.ReportWhisperTo = "Chuchoter à:";
L.ReportUseLinks = "Utilisez les liens";
L.ReportSkipZero = "Sauter 0%";

L.Loaded = "loaded";
L.SetupInfo = "/saw to display setup frame";
L.Reset = "Reset local settings to default";
L.ResetAll = "Reset ALL settings to default";

L.SpacingOffset = "Bouton Espacement: %s";

end
