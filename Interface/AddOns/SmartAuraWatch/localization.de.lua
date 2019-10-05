-------------------------------------------------------------------------------
-- German localization
-------------------------------------------------------------------------------

if (GetLocale() == "deDE") then
local L = SmartAuraWatchLoc;

-- Time shortcuts
L.ScDay  = "%dt";   -- Days
L.ScHour = "%dstd"; -- Hours
L.ScMin  = "%dm";   -- Minutes
L.ScSec  = "%ds";   -- Seconds

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
L.ScMH = "Wh";   -- Main hand
L.ScOH = "Sh";   -- Off hand
L.ScRG = "D";    -- Ranged
L.ScT1 = "S1";   -- Trinket 1
L.ScT2 = "S2";   -- Trinket 2
L.ScHand  = "H"; -- Hand
L.ScWaist = "Ta"; -- Waist
L.ScCloak = "R"; -- Cloak

L.FocusTarget = "Ziel des Fokus";
L.MouseOver = "Mouseover";
L.Arena = "Arena %d";
L.On = "An";
L.Bars = "Leisten: %s";
L.ActiveBar = "Einstellungen Leiste: %s";
L.BarAlpha = "Sichtbarkeit: %s%%";
L.IconSize = "Symbol-Grösse: %s";
L.Orientation = "%s";
L.Growth = "%s";
L.Vertical = "Vertikal";
L.Horizontal = "Horizontal";
L.HBar = "Hor. + Leisten";
L.VBar = "Vert. + Leisten";
L.Center = "Mittig";
L.Top = "Oben";
L.Bottom = "Unten";
L.Right = "Rechts";
L.Left = "Links";
L.AuraHelp = "Links-Klick: Auswählen\nRechts-Klick: Löschen\nDrag'n'Drop zum Ordnen";
L.Unit = "%s";
L.Relship = "%s";
L.DurationMin = "Dauer [sek] < %s";
L.DurationMax = "Dauer [sek] > %s";
L.CountMin = "Aufladungen".." < %s";
L.CountMax = "Aufladungen".." > %s";
L.TalentTree = "Talentbaum: %s";
L.MyAura = "Eigene Aura";
L.MyAuraTT = "Überwacht nur die eigene Aura.";
L.OnlyInCombat = "Nur im Kampf";
L.OnlyInCombatTT = "Überwacht die Aura nur im Kampf.";
L.NotUp = "Nicht Aktiv";
L.NotUpTT = "Zeigt das Symbol auch an, wenn die Aura auf dem überwachten Ziel nicht aktiv ist.";
L.Filter = "Filter: %s";
L.Helpful = "Hilfreich";
L.Harmful = "Schädlich";
L.Cancelable = "Aufhebbar";
L.NotCancelable = "Nicht aufhebbar";
L.Enchant = "Verzauberung";
L.Cooldown = "Abklingzeit";
L.Sound = "Warnton: %s";
L.SoundsTitle = "Warntöne";
L.SoundsHelp = "Links-Klick: Auswählen\nRechts-Klick: Abspielen";
L.GlobalLoad = "Laden";
L.GlobalLoadTT = "Lädt die Einstellung aus der globalen Vorlage.";
L.GlobalSave = "Speichern";
L.GlobalSaveTT = "Speichert die aktuellen Einstellungen als globale Vorlage.";
L.ShowCd = "Abklingzeit";
L.ShowCdTT = "Zeigt die Abklingzeit der Aura an.";
L.AuraScanTT = "Zeichnet die Auren während des Kampfes auf und speichert diese in der Auswahlliste.";
L.AuraScanTitle = "Aura-Aufzeichnung";
L.AuraScanHelp = "Links-Klick: Aura übernehmen\nRechts-Klick: Löschen";
L.Stat = "Stat";
L.StatTitle = "Statistik";
L.StatHelp = "Rechts-Klick: Zurücksetzen";
L.StatBar = "Statistik Leiste %d";
L.StatResetAll = "Statistiken zurücksetzen";
L.ColoredTL = "Farbig";
L.ColoredTLTT = "Stellt die Dauer in farbigen Zahlen dar.";
L.SecTL = "Volle Sekunden";
L.SecTLTT = "Stellt die Sekunden als Ganzzahl dar.";
L.InCombatUptime = "Aktiv-Zeit im Kampf:";
L.RunTime = "Laufzeit: %s";
L.CombatTime = "Kampfdauer (%s)";
L.AutoReset = "Auto. zurücksetzen";
L.AutoResetTT = "Setzt automatisch die Statistik bei Kampfbeginn zurück.";
L.Tooltips = "Tooltips";
L.TooltipsTT = "Aktiviert die Aura-Tooltips auf dieser Leiste.";
L.ReportLines = "Zeilen";
L.ReportTitle = "Bericht";
L.ReportMsg = "Bericht Leiste %d";
L.ReportWhisperTo = "Flüstern an:";
L.ReportUseLinks = "Verwende Links";
L.ReportSkipZero = "0% überspringen";
L.Loaded = "geladen";
L.SetupInfo = "/saw um die Optionen zu öffnen";
L.Reset = "Setzt die lokalen Einstellungen zurück";
L.ResetAll = "Setzt ALLE Einstellungen zurück";

L.OptionsGlobalTitle = "Globale Optionen";
L.BarStyle = "Leistenstil: %s";
L.FontSizeOffset = "Schriftgrössen-Offset: %s";
L.SpacingOffset = "Button-Abstand: %s";
L.ShowIconBorder = "Zeige Symbolrahmen";
L.ShowIconBorderTT = "Stellt das Symbol mit dem Standardrahmen dar.";
L.ShowSpark = "Zeige Leisten-Funke";
L.ShowSparkTT = "Stellt einen Funken beim aktuellen Wert auf der Statusleiste dar.";
L.TimerStyle = "Blizzard Timer Stil";
L.TimerStyleTT = "Stellt den Aura-Timer im 'Blizzard'-Stil dar.";

end
