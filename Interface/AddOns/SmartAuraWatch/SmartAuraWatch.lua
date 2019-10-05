-------------------------------------------------------------------------------
-- SmartAuraWatch
-- Created by Aeldra (EU-Proudmoore)
--
-- The addon will notify you with an icon, time left, charges and target 
-- of the aura that has procced.
-------------------------------------------------------------------------------

local AddonVersion         = "1.13.2a";
local AddonTitle           = "SmartAuraWatch";
local AddonTitleVersion    = AddonTitle.." "..AddonVersion;
local EventOnUpdate        = "SAWONUPDATE";
local L                    = SmartAuraWatchLoc;

local M_A  = "AURA";
local M_TE = "ENCHANT";
local M_TO = "TOTEM";
local M_CD = "COOLDOWN";

SmartAuraWatch_ActiveBar    = 1;
SmartAuraWatch_MaxBars      = 9;
SmartAuraWatch_MaxButtons   = 9;
SmartAuraWatch_SldScale     = 0.92;
SmartAuraWatch_MaxBarStyles = 7;


local LCD = LibStub and LibStub("LibClassicDurations")
if LCD then LCD:Register(AddonTitle) end

local UnitAuraFull = UnitAura
if LCD and LCD.UnitAura then UnitAuraFull = function(a, b, c) return LCD:UnitAura(a, b, c) end end


SmartAuraWatch_UnitList = {
  {"player",       L.Player,       L.ScP},
  {"target",       L.Target,       L.ScT},
  {"focus",        L.Focus,        L.ScF},
  {"targettarget", L.TargetTarget, L.ScTT},
  {"focustarget",  L.FocusTarget,  L.ScFT},
  {"pet",          L.Pet,          L.ScPet},
  {"mouseover",    L.MouseOver,    L.ScMo},
  {"arena1",       format(L.Arena, 1), format(L.ScA, 1)},
  {"arena2",       format(L.Arena, 2), format(L.ScA, 2)},
  {"arena3",       format(L.Arena, 3), format(L.ScA, 3)},
  {"arena4",       format(L.Arena, 4), format(L.ScA, 4)},
  {"arena5",       format(L.Arena, 5), format(L.ScA, 5)},
}

SmartAuraWatch_FilterList = {
  {"",               L.None},
  {"HELPFUL",        L.Helpful},
  {"HARMFUL",        L.Harmful},
  {"RAID",           L.Raid},
  {"CANCELABLE",     L.Cancelable},
  {"NOT_CANCELABLE", L.NotCancelable},
  {M_TE,             L.Enchant},
  {M_CD,             L.Cooldown},
}

SmartAuraWatch_RelationshipList = {
  {"ALL",    L.All},
  {"FRIEND", L.Friendly},
  {"ENEMY",  L.Enemy},
}

SmartAuraWatch_TalentGroupList = {
  [0] = {"ALL",       L.All},
  [1] = {"PRIMARY",   L.Primary},
  [2] = {"SECONDARY", L.Secondary},
}

SmartAuraWatch_InventoryList = {
  {INVSLOT_MAINHAND, L.MainHand, L.ScMH},
  {INVSLOT_OFFHAND, L.OffHand, L.ScOH},
  {INVSLOT_TRINKET1, L.Trinket1, L.ScT1},
  {INVSLOT_TRINKET2, L.Trinket2, L.ScT2},
  {INVSLOT_HAND, L.Hand, L.ScHand},
  {INVSLOT_WAIST, L.Waist, L.ScWaist},
  {INVSLOT_BACK, L.Cloak, L.ScCloak},
}

local _;
local O;
local OG;
local fMain;
local fOptions;
local fSounds;
local fAuraScanList;
local fStatList;
local fReport;
local fOG;
local isInit = false;
local isCombat = false;
local isLayoutDone = false;
local isEnabled = true;

local sRealmName = nil;
local sPlayerName = nil;
local sPlayerClass = nil;
local PlayerGUID = nil;
local sID = nil;
local iTalentGroup = 0;

local tUpdate = 0.1;
local tBarUpdate = 0.01;
local tLast;

local DefMin = -1;
local DefMax = 101;
local DefSize = 32;
local BtnMax = SmartAuraWatch_MaxButtons;
local BarMax = SmartAuraWatch_MaxBars;
local BtnName = "SmartAuraWatch_AuraBtn";
local BarName = "SmartAuraWatch_AuraBar";

local icoQuestionMark = "Interface\\Icons\\INV_Misc_QuestionMark";
local icoRun = "Interface\\Icons\\ability_rogue_sprint";
local icoCombat = "Interface\\Icons\\ability_parry";
local statusbarH = "Interface\\Addons\\SmartAuraWatch\\statusbar\\bar%dh";
local statusbarV = "Interface\\Addons\\SmartAuraWatch\\statusbar\\bar%dv";

local UnitList = SmartAuraWatch_UnitList;
local FilterList = SmartAuraWatch_FilterList;
local RelshipList = SmartAuraWatch_RelationshipList;
local TGList = SmartAuraWatch_TalentGroupList;
local InvList = SmartAuraWatch_InventoryList;
local ActiveAura;
local cPlayed = { };
local cAuraScanList = { };
local cBtnBars = { };

local AuraList = { };
local AuraListDefault = {
  -- id, Class, target, caster, filter, < timeleft, > timeleft, < count, > count
  -- combat only, when off, relationship, talent group, form/stance, use sound, sound file, show cd

  -- FOR TESTING ONLY --
  {774,   "DRUID", 1, true, 2, 8, nil, nil, nil, nil, nil, nil, 1}, -- Verjüngung
  {467,   "DRUID", 1, true, 2, nil, 0, nil, nil, nil, nil},  -- Dornen
  {8921,  "DRUID", 2, true, 3, nil, 0, nil, nil, nil, true}, -- Mondfeuer
  ----------------------
  
  --[[
  
  {53386, "DEATHKNIGHT", 1, true, 2, nil, 0, nil, nil, true}, -- Cinderglacier
  {51124, "DEATHKNIGHT", 1, true, 2, nil, 0, nil, nil, true}, -- Killing Machine
  {59052, "DEATHKNIGHT", 1, true, 2, nil, 0, nil, nil, true}, -- Rime
  {81340, "DEATHKNIGHT", 1, true, 2, nil, 0, nil, nil, true}, -- Sudden Doom
  {63560, "DEATHKNIGHT", 1, true, 2, nil, 0, nil, nil, true}, -- Dark Transformation
  
  {48517, "DRUID", 1, true, 2, nil, 0, nil, nil, true}, -- Eclipse (Solar)
  {48518, "DRUID", 1, true, 2, nil, 0, nil, nil, true}, -- Eclipse (Lunar)
  {16886, "DRUID", 1, true, 2, nil, 0, nil, nil, true}, -- Nature's Grace
  {69369, "DRUID", 1, true, 2, nil, 0, nil, nil, true}, -- Predator's Swiftness
  {16870, "DRUID", 1, true, 2, nil, 0, nil, nil, true}, -- Clearcasting
  {48391, "DRUID", 1, true, 2, nil, 0, nil, nil, true}, -- Owlkin Frenzy
  {93400, "DRUID", 1, true, 2, nil, 0, nil, nil, true}, -- Shooting Stars
  {52610, "DRUID", 1, true, 2, nil, 0, nil, nil, true}, -- Savage Roar
  
  {3045,  "HUNTER", 1, true, 2, nil, 0, nil, nil, true}, -- Rapid Fire
  {35098, "HUNTER", 1, true, 2, nil, 0, nil, nil, true}, -- Rapid Killing
  
  {12536, "MAGE", 1, true, 2, nil, 0, nil, nil, true}, -- Clearcasting
  {79683, "MAGE", 1, true, 2, nil, 0, nil, nil, true}, -- Arcane Missiles!
  {31643, "MAGE", 1, true, 2, nil, 0, nil, nil, true}, -- Blazing Speed
  {57761, "MAGE", 1, true, 2, nil, 0, nil, nil, true}, -- Brain Freeze
  {54741, "MAGE", 1, true, 2, nil, 0, nil, nil, true}, -- Firestarter
  {48108, "MAGE", 1, true, 2, nil, 0, nil, nil, true}, -- Hot Streak
  {64343, "MAGE", 1, true, 2, nil, 0, nil, nil, true}, -- Impact
  {36032, "MAGE", 1, true, 2, nil, 0, nil, nil, true}, -- Arcane Blast
  {44544, "MAGE", 1, true, 2, nil, 0, nil, nil, true}, -- Fingers of Frost
  
  {59578, "PALADIN", 1, true, 2, nil, 0, nil, nil, true}, -- The Art of War
  {88819, "PALADIN", 1, true, 2, nil, 0, nil, nil, true}, -- Daybreak
  {85509, "PALADIN", 1, true, 2, nil, 0, nil, nil, true}, -- Denounce
  {90174, "PALADIN", 1, true, 2, nil, 0, nil, nil, true}, -- Hand of Light
  {53672, "PALADIN", 1, true, 2, nil, 0, nil, nil, true}, -- Infusion of Light
  {85433, "PALADIN", 1, true, 2, nil, 0, nil, nil, true}, -- Sacred Duty
  {88688, "PALADIN", 1, true, 2, nil, 0, nil, nil, true}, -- Surge of Light

  {34914, "PRIEST", 2, true, 3, nil, 0, nil, nil, true}, -- Vampiric Touch
  {2944,  "PRIEST", 2, true, 3, nil, 0, nil, nil, true}, -- Devouring Plague
  {589,   "PRIEST", 2, true, 3, nil, 0, nil, nil, true}, -- Shadow Word: Pain
  {59887, "PRIEST", 1, true, 2, nil, 0, nil, nil, true}, -- Borrowed Time
  {88688, "PRIEST", 1, true, 2, nil, 0, nil, nil, true}, -- Surge of Light
  {81661, "PRIEST", 1, true, 2, nil, 0, nil, nil, true}, -- Evangelism
  {87118, "PRIEST", 1, true, 2, nil, 0, nil, nil, true}, -- Dark Evangelism
  {63731, "PRIEST", 1, true, 2, nil, 0, nil, nil, true}, -- Serendipity
  {77487, "PRIEST", 1, true, 2, nil, nil, nil, 0, true}, -- Shadow Orb

  {5171,  "ROGUE", 1, true, 2, 9, nil, nil, nil, true}, -- Slice and Dice
  {84617, "ROGUE", 2, true, 3, nil, 0, nil, nil, true}, -- Revealing Strike
  {1943,  "ROGUE", 2, true, 3, 9, nil, nil, nil, true}, -- Rupture
  {-1,    "ROGUE", 1, true, 7, nil, 0, nil, nil, true}, -- Mainhand
  {-2,    "ROGUE", 1, true, 7, nil, 0, nil, nil, true}, -- Offhand
    
  {8050,  "SHAMAN", 2, true, 3, 9, nil, nil, nil, true}, -- Flame Shock
  {324,   "SHAMAN", 1, true, 2, nil, nil, nil, 7, true}, -- Lightning Shield
  {16246, "SHAMAN", 1, true, 2, nil, 0, nil, nil, true}, -- Clearcasting
  {53817, "SHAMAN", 1, true, 2, nil, nil, nil, 4, true}, -- Maelstrom Weapon
  {53390, "SHAMAN", 1, true, 2, nil, 0, nil, nil, true}, -- Tidal Waves
  {79206, "SHAMAN", 1, true, 2, nil, 0, nil, nil, true}, -- Spiritwalker's Grace
  
  {54274, "WARLOCK", 1, true, 2, nil, 0, nil, nil, true}, -- Backdraft
  {34936, "WARLOCK", 1, true, 2, nil, 0, nil, nil, true}, -- Backlash
  {63165, "WARLOCK", 1, true, 2, nil, 0, nil, nil, true}, -- Decimation
  {47283, "WARLOCK", 1, true, 2, nil, 0, nil, nil, true}, -- Empowered Imp
  {64368, "WARLOCK", 1, true, 2, nil, 0, nil, nil, true}, -- Eradication
  {47383, "WARLOCK", 1, true, 2, nil, 0, nil, nil, true}, -- Molten Core
  {17941, "WARLOCK", 1, true, 2, nil, 0, nil, nil, true}, -- Shadow Trance
  
  {58567, "WARRIOR", 2, true, 3, nil, 0, nil, nil, true}, -- Sunder Armor
  {12964, "WARRIOR", 1, true, 2, nil, 0, nil, nil, true}, -- Battle Trance
  {46916, "WARRIOR", 1, true, 2, nil, 0, nil, nil, true}, -- Bloodsurge
  {86627, "WARRIOR", 1, true, 2, nil, 0, nil, nil, true}, -- Incite
  {84584, "WARRIOR", 1, true, 2, nil, 0, nil, nil, true}, -- Slaughter
  {52437, "WARRIOR", 1, true, 2, nil, 0, nil, nil, true}, -- Sudden Death
  {50227, "WARRIOR", 1, true, 2, nil, 0, nil, nil, true}, -- Sword and Board
  {60503, "WARRIOR", 1, true, 2, nil, 0, nil, nil, true}, -- Taste for Blood
  {34428, "WARRIOR", 1, true, 2, nil, 0, nil, nil, true}, -- Victory Rush
  {87095, "WARRIOR", 1, true, 2, nil, 0, nil, nil, true}, -- Thunderstruck
  
  --{2825,  "ALL", 1, false, 2, nil, 0}, -- Kampfrausch
  --{32182, "ALL", 1, false, 2, nil, 0}, -- Heldentum
  --{80353, "ALL", 1, false, 2, nil, 0}, -- Zeitkrümmung
  --{-4, "ALL", 1, true, 8, nil, 0, nil, nil, true}, -- Trinket 1
  --{-5, "ALL", 1, true, 8, nil, 0, nil, nil, true}, -- Trinket 2
  
  ]]--
  
  --{xxxxx, "xxxxx", 1, true, 2, nil, 0, nil, nil, true}, -- xxxxx
}

local SoundList = {
  {L.SoundNone, ""},
  {"Alarm Clock 1", "Sound\\Interface\\AlarmClockWarning1.ogg"},
  {"Alarm Clock 2", "Sound\\Interface\\AlarmClockWarning2.ogg"},
  {"Alarm Clock 3", "Sound\\Interface\\AlarmClockWarning3.ogg"},
  {"Anti Holy", "Sound\\Spells\\AntiHoly.ogg"},
  {"Auction House", "Sound\\interface\\AuctionWindowOpen.ogg"},
  {"Bell Alliance", "Sound\\Doodad\\BellTollAlliance.ogg"},
  {"Bell Horde", "Sound\\Doodad\\BellTollHorde.ogg"},
  {"Bell Karazhan", "Sound\\Doodad\\KharazahnBellToll.ogg"},
  {"Bell Mellow", "Sound\\Spells\\ShaysBell.ogg"},
  {"Bell Night Elf", "Sound\\Doodad\\BellTollNightElf.ogg"},
  {"Bell Tribal", "Sound\\Doodad\\BellTollTribal.ogg"},
  {"Cartoon FX", "Sound\\Doodad\\Goblin_Lottery_Open03.ogg"},
  {"Cheer", "Sound\\Event Sounds\\OgreEventCheerUnique.ogg"},
  {"Explosion", "Sound\\Doodad\\Hellfire_Raid_FX_Explosion05.ogg"},
  {"Fel Nova", "Sound\\Spells\\SeepingGaseous_Fel_Nova.ogg"},
  {"Fel Portal", "Sound\\Spells\\Sunwell_Fel_PortalStand.ogg"},
  {"Friend Join", "Sound\\interface\\FriendJoin.ogg"},
  {"Gong Troll", "Sound\\Doodad\\G_GongTroll01.ogg"},
  {"Humm", "Sound\\Spells\\SimonGame_Visual_GameStart.ogg"},
  {"Level Up", "Sound\\interface\\levelup.ogg"},
  {"Loot Chime", "Sound\\interface\\igLootCreature.ogg"},
  {"Magic Click", "Sound\\interface\\MagicClick.ogg"},
  {"Murloc", "Sound\\Creature\\Murloc\\mMurlocAggroOld.ogg"},
  {"Ready Check", "Sound\\interface\\levelup2.ogg"},
  {"Rubber Ducky", "Sound\\Doodad\\Goblin_Lottery_Open01.ogg"},
  {"Shing", "Sound\\Doodad\\PortcullisActive_Closed.ogg"},
  {"Short Circuit", "Sound\\Spells\\SimonGame_Visual_BadPress.ogg"},
  {"Simon Chime", "Sound\\Doodad\\SimonGame_LargeBlueTree.ogg"},
  {"War Drums", "Sound\\Event Sounds\\Event_wardrum_ogre.ogg"},
  {"Wham", "Sound\\Doodad\\PVP_Lordaeron_Door_Open.ogg"},
  {"Whisper Ping", "Sound\\interface\\iTellMessage.ogg"},
};
for i = 1, 10 do tinsert(SoundList, { "Custom Sound "..i, "Interface\\Addons\\SmartAuraWatch\\sound\\sound"..i..".mp3" }) end

local ChatTypeList = {
  {"SELF", "self", L.Self},
  {"WHISPER", "WHISPER", L.Whisper},
  {"SAY", nil, L.Say},
  {"RAID", nil, L.Raid},
  {"PARTY", nil, L.Party},
  {"GUILD", nil, L.Guild},
  {"OFFICER", nil, L.Officer},
  {"CHANNEL", "name", L.Channel},
};

local Masque;
local MasqueGroup;

-----------------------------------------------------------------------------------------------------------------
-- Local helper functions ---------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

-- Reorders values in the table
local function treorder(t, i, n)
  if (t and t[i]) then
    local s = t[i];
    tremove(t, i);
    if (i + n < 1) then
      tinsert(t, 1, s);
    elseif (i + n > #t) then
      tinsert(t, s);
    else
      tinsert(t, i + n, s);
    end
  end
end

-- Table copy
local function tcopy(t)
  local u = { };
  for k, v in pairs(t) do u[k] = v end
  return setmetatable(u, getmetatable(t));
end

-- Table count, counts members even if they are not indexed by numbers
local function tcount(t)
  if (not t or type(t) ~= "table") then return -1 end
  local n = #t
  if (not n or n == 0) then
    n = 0;
    for _ in pairs(t) do n = n + 1 end
  end
  return n;
end

-- Rounds a number to the given number of decimal places. 
local r_mult;
local function Round(num, idp)
  r_mult = 10^(idp or 0);
  return math.floor(num * r_mult + 0.5) / r_mult;
end

-- Returns a chat color code string
local function BCC(r, g, b)
  return format("|cff%02x%02x%02x", (r*255), (g*255), (b*255));
end

local BL  = BCC(0.2, 0.3, 1.0);
local BLD = BCC(0.0, 0.0, 0.8);
local BLL = BCC(0.5, 0.8, 1.0);
local GR  = BCC(0.1, 1.0, 0.1);
local GRD = BCC(0.0, 0.7, 0.0);
local GRL = BCC(0.4, 1.0, 0.4);
local RD  = BCC(1.0, 0.1, 0.1);
local RDD = BCC(0.7, 0.0, 0.0);
local RDL = BCC(1.0, 0.3, 0.3);
local YL  = BCC(1.0, 1.0, 0.0);
local YLD = BCC(0.7, 0.7, 0.0);
local YLL = BCC(1.0, 1.0, 0.5);
local OR  = BCC(1.0, 0.5, 0.25);
local ORD = BCC(0.7, 0.5, 0.0);
local ORL = BCC(1.0, 0.6, 0.3);
local WH  = BCC(1.0, 1.0, 1.0);
local WHD = BCC(0.75, 0.75, 0.75);
local WHB = BCC(0.7, 0.98, 1.0);
local CY  = BCC(0.5, 1.0, 1.0);
local GY  = BCC(0.5, 0.5, 0.5);
local GYD = BCC(0.35, 0.35, 0.35);
local GYL = BCC(0.65, 0.65, 0.65);
local GFN = BCC(1.0, 0.82, 0.0);
local GFH = BCC(1.0, 1.0, 1.0);

-- Returns "" instead of nil
local function ChkS(s)
  if (s == nil) then
    s = "";
  end
  return s;
end

-- Converts a string to number
local function StrToNum(s, nDef, nMin, nMax)
  local n = nDef;
  if (s ~= nil) then
    n = tonumber(s);
    if (n == nil) then
      n = nDef;
    elseif (nMin ~= nil and n < nMin) then
      n = nMin;
    elseif (nMax ~= nil and n > nMax) then
      n = nMax;
    end
  end
  return n;
end

local function BToStr(b)
  if (b) then
    return GR..L.On"|r";
  else
    return RD..L.Off.."|r";
  end
end

local function DurationStr(d)
  if (not d) then return "" end
  d = Round(d);
  local n = d%60;
  local s = format(L.ScSec, n);
  if (d >= 60) then
    d = (d - n) / 60; -- minutes
    n = d%60;
    s = format(L.ScMin, n).." "..s;
    if (d >= 60) then
      d = (d - n) / 60; -- hours
      n = d%24;
      s = format(L.ScHour, n).." "..s;
      if (d >= 24) then
        d = (d - n) / 24; -- days
        s = format(L.ScDay, d).." "..s;
      end
    end
  end
  return s
end

-- Splits a string
local function Split(msg, char)
  local arr = { };
  while (string.find(msg, char)) do
    local iStart, iEnd = string.find(msg, char);
    tinsert(arr, strsub(msg, 1, iStart - 1));
    msg = strsub(msg, iEnd + 1, strlen(msg));
  end
  if (strlen(msg) > 0) then
    tinsert(arr, msg);
  end
  return arr;
end

-- Will dump the value of msg to the default chat window
local function AddMsg(msg)
  if (DEFAULT_CHAT_FRAME) then
    DEFAULT_CHAT_FRAME:AddMessage(YLL..msg.."|r");
  end
end

local function AddMsgErr(msg)
  if (DEFAULT_CHAT_FRAME) then
    DEFAULT_CHAT_FRAME:AddMessage(RDL..AddonTitle..": "..msg.."|r");
  end
end

local function AddMsgWarn(msg)
  if (DEFAULT_CHAT_FRAME) then
    DEFAULT_CHAT_FRAME:AddMessage(CY..msg.."|r");
  end
end

local function AddMsgD(msg, r, g, b)
  if (r == nil) then r = 0.5; end
  if (g == nil) then g = 0.8; end
  if (b == nil) then b = 1; end
  if (DEFAULT_CHAT_FRAME and O and O.Debug) then
    DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b);
  end
end

local function BToggle(b, msg)
  if (not b or b == nil) then
    b = true;
    AddMsg(AddonTitle..": "..msg..GR..L.On);
  else
    b = false
    AddMsg(AddonTitle..": "..msg..RD..L.Off);
  end
  return b;
end

local function BState(b, msg)
  if (b) then
    AddMsg(AddonTitle..": "..msg..GR..L.On);
  else
    AddMsg(AddonTitle..": "..msg..RD..L.Off);
  end
end


-----------------------------------------------------------------------------------------------------------------
-- END Local helper functions -----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

-- If Masque is in use
local function isMasque()
  if (Masque) then return true end
  return false;
end


-- Set aura icon
local function SetIcon(ctrl, tx)
  if (not tx or tx == "" or tx == "?") then
    if (ctrl.SetTexture) then ctrl:SetTexture(icoQuestionMark) end
    if (ctrl.SetNormalTexture) then ctrl:SetNormalTexture(icoQuestionMark) end
  else
    if (ctrl.SetTexture) then ctrl:SetTexture(tx) end
    if (ctrl.SetNormalTexture) then ctrl:SetNormalTexture(tx) end
  end
  if (not isMasque() and ctrl.ShowIconBorder ~= OG.ShowIconBorder) then
    ctrl.ShowIconBorder = OG.ShowIconBorder;
    if (OG.ShowIconBorder) then
      if (ctrl.SetTexture) then ctrl:SetTexCoord(0.0, 1.0, 0.0, 1.0) end
      if (ctrl.SetNormalTexture) then ctrl:GetNormalTexture():SetTexCoord(0.0, 1.0, 0.0, 1.0) end
    else
      if (ctrl.SetTexture) then ctrl:SetTexCoord(0.07, 0.93, 0.07, 0.93) end
      if (ctrl.SetNormalTexture) then ctrl:GetNormalTexture():SetTexCoord(0.07, 0.93, 0.07, 0.93) end
    end
  end
end


-- Update button status bar
local function UpdateButtonBar(btn, du, et, t) -- button, duration, expiration time, current time
  local tl;
  if (du and et and t) then tl = et-t end
  if (tl and tl > 0.0) then
    local v = tl/du;
    btn.bar:SetValue(tl);
    btn.bar:SetStatusBarColor(1.0-v^5, v*1.33, v-v*v);
    btn.bar:SetBackdropColor(1.0-v^5, v*1.33, v-v*v, 0.4);
    if (OG.ShowSpark) then
      local sp;
      btn.bar.spark:ClearAllPoints();
      if (btn.bar:GetOrientation() == "HORIZONTAL") then
        sp = v * btn.bar:GetWidth();
        btn.bar.spark:SetPoint("CENTER", btn.bar, "LEFT", sp, 0);
      else
        sp = v * btn.bar:GetHeight();
        btn.bar.spark:SetPoint("CENTER", btn.bar, "BOTTOM", 0, sp);
      end
      btn.bar.spark:Show();
    else
      btn.bar.spark:Hide();
    end
    btn.bar:Show();
    return;
  end
  if (cBtnBars[btn]) then wipe(cBtnBars[btn]) end
  btn.bar:Hide();
end

local function UpdateButtonBars()
  local t = GetTime();
  for k, v in pairs(cBtnBars) do
    if (v and v[1]) then
      UpdateButtonBar(k, v[1], v[2], t)
    end
  end
end


local function AuraScan(b)
  if (not fMain or not OG) then return end
  if (b) then  
    if (not fMain.ScanCombatLog) then
      fMain:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
      fMain:RegisterEvent("PLAYER_REGEN_ENABLED");
    end
    fMain.ScanCombatLog = true;
  else
    if (fMain.ScanCombatLog) then
      fMain:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
      fMain:UnregisterEvent("PLAYER_REGEN_ENABLED");
    end
    fMain.ScanCombatLog = false;
  end
end

local lockPASL;
local function ProcessAuraScanList()
  if (not OG or not OG.AuraScanList or lockPASL) then return end
  lockPASL = true;
  local o = OG.AuraScanList;
  local b;
  for k, v in pairs(cAuraScanList) do
    if (k and v) then
      b = false;
      for i = 1, #o do
        if (o[i][1] == k) then
          b = true;
          break;
        end
      end
      if (not b) then
        local name, _, icon = GetSpellInfo(k);
        if (name and icon) then
          local f;
          if (v == "DEBUFF") then
            f = 3; -- HARMFUL
          else
            f = 2; -- HELPFUL
          end
          tinsert(o, {k, name, icon, f});
          --print(format("Insert: %s %s, %s (%s)", k, name, v, f));
        end
      end
    end
  end
  lockPASL = false;
end


local function CreateButtons(f, n)
  local btn, s;
  local w, h = DefSize, DefSize;
  for i = 1, BtnMax do
    s = BtnName..n..i;
    btn = _G[s];
    if (btn == nil) then
      btn = CreateFrame("Button", s, f, "SmartAuraWatchButtonTemplate");
      btn:SetSize(w, h);
      -- Init cooldown element
      btn.cd:ClearAllPoints();
      btn.cd:SetPoint("CENTER", btn, "CENTER");
      btn.cd:SetSize(w-2, h-2);
      btn.cd:SetAlpha(0.7);
      -- Init icon element
      btn.icon:ClearAllPoints();
      btn.icon:SetPoint("CENTER", btn, "CENTER");
      btn.icon:SetSize(w, h);
      btn.icon:SetTexture(icoQuestionMark);
      -- Init font elements
      btn.text:ClearAllPoints();
      btn.target:ClearAllPoints();
      btn.count:ClearAllPoints();
      btn.text:SetPoint("BOTTOM", btn, "BOTTOM", 0, 0);
      btn.target:SetPoint("TOPLEFT", btn, "TOPLEFT", 3, -3);
      btn.count:SetPoint("TOPRIGHT", btn, "TOPRIGHT", -1, -3);
      btn:Hide();
      
      -- Masque
      if (MasqueGroup) then
        MasqueGroup:AddButton(btn, { Icon = btn.icon });
      end
      
    end
    btn:SetMovable(false);
    btn:EnableMouse(false);
  end
end

local function CreateBar(j)
  local s = BarName..j;
  local bar = _G[s];
  if (bar == nil) then
    bar = CreateFrame("Frame", s, UIParent, "SmartAuraWatchBarTemplate");
    bar.BarId = j;
    bar:Hide();
  end
  bar:ClearAllPoints();
  bar:SetSize(DefSize+12, DefSize+12);
  bar:SetMovable(true);
  bar:EnableMouse(false);
  bar:EnableKeyboard(false);
  bar:EnableMouseWheel(false);
  bar:SetClampedToScreen(true);
  bar:RegisterForDrag("LeftButton");
  
  if (O[s] == nil) then O[s] = { } end
  local o = O[s];
  if (o.P == nil or o.P == nil or o.P == nil) then
    o.P, o.X, o.Y = "LEFT", 200+(j-1)*(OG.IconSize+8), 0;    
  end
  bar:SetPoint(o.P, o.X, o.Y);
  
  bar.backdrop:SetTexture(1.0, 1.0, 0.2, 0.8);
  bar.backdrop:SetAllPoints(bar);
  bar.backdrop:SetBlendMode("BLEND");

  CreateButtons(bar, j);
  return bar;
end


local function UpdateBackdrop(mode)
  mode = mode or 2;
  local f;
  for j = 1, O.Bars do
    f = _G[BarName..j];
    if (f) then
      f:Show();      
      if (mode == 1 or (mode == 2 and not f:IsMouseEnabled())) then
        f.backdrop:SetAlpha(1);
        f:EnableMouse(true);
        --print("Enable backdrop: "..BarName..j);
      else
        f.backdrop:SetAlpha(0);
        f:EnableMouse(false);
      end
    end
  end
end


local function ToggleOptions(force)  
  if(force or not fOptions:IsVisible()) then
    fOptions:Show();
  else
    fOptions:Hide();
  end  
end


local function ResetAuraList(n)
  if (n == nil) then return end
  local bn = BarName..n;
  local bo = O[bn];
  if (bo == nil) then return end
  if (bo.AuraList == nil) then 
    bo.AuraList = { };
  else
    wipe(bo.AuraList);
  end
  local name, icon, loc;
  for _, v in pairs(AuraListDefault) do
    name, icon, loc = nil, nil, nil;
    if (v and v[1] and (v[2] == "ALL" or v[2] == sPlayerClass)) then
      if (v[1] > 0) then
        name, _, icon = GetSpellInfo(v[1]);
      else
        loc = InvList[-v[1]];
        if (loc) then
          name, icon = loc[2], GetInventoryItemTexture("player", loc[1]);
        end
      end
      if (name) then
        tinsert(bo.AuraList, { v[1], name, icon, v[3], v[4], v[5], v[6], v[7], v[8], v[9], v[10], v[11], v[12], v[13], v[14], v[15], v[16], v[17], v[18] } );
        --print("Aura added: "..name);
      end
    end
  end  
end


function CheckFontSize(h)
  h = math.floor(h + OG.FontSizeOffset);
  if (h > 0) then return h end
  return 1;
end

function SmartAuraWatch_UpdateBars()
  isLayoutDone = false;
  local bar, btn, n, v, bn, bo, w, h, sc, tx, fs, tso;
  local s = OG.SpacingOffset;
  
  for j = 1, BarMax do
    if (j <= O.Bars) then
      bar = CreateBar(j);
    else
      bar = _G[BarName..j];
    end
    
    if (bar) then      
      if (j <= O.Bars) then
        bn = bar:GetName();
        if (O[bn] == nil) then O[bn] = { } end
        bo = O[bn];
        
        if (bo.Orientation == nil) then bo.Orientation = OG.Orientation end
        if (bo.Tooltips == nil) then bo.Tooltips = false end
        if (bo.StatAutoReset == nil) then bo.StatAutoReset = false end
        if (bo.RunTime == nil) then bo.RunTime = 0.00001 end
        if (bo.CombatTime == nil) then bo.CombatTime = 0.0 end
        if (bo.Alpha == nil) then bo.Alpha = OG.Alpha end
        if (bo.Growth == nil) then bo.Growth = OG.Growth end
        if (bo.IconSize == nil) then bo.IconSize = OG.IconSize end
        
        if (OG.TimerStyle and bo.Orientation < 2) then tso = 14 else tso = 0 end
        
        w, h, sc, fs = DefSize, DefSize, bo.IconSize/DefSize, 8;
        bar:ClearAllPoints();
        bar:SetPoint(bo.P, bo.X/sc, bo.Y/sc);
        bar:SetScale(sc);
        bar:SetAlpha(bo.Alpha);
        
        n = 0;               
        for i = 1, BtnMax do
          btn = _G[BtnName..j..i];
          
          if (bo.Growth == 0) then
            -- Left/Top
            v = 1;
            if (i > 1) then n = n+1 end
          elseif (bo.Growth == 2) then
            -- Right/Bottom
            v = -1;
            if (i > 1) then n = n+1 end
          else
            -- Center
            if (math.fmod(i-1, 2) == 0) then
              v = -1;
            else
              v = 1;
              if (i > 1) then n = n+1 end
            end
          end
          btn:ClearAllPoints();
          if (bo.Orientation == 1 or bo.Orientation == 3) then
            btn:SetPoint("CENTER", n*v*(w+s), 0);
          else
            btn:SetPoint("CENTER", 0, n*v*(h+s+tso));
          end
          
          -- Set status bar
          if (bo.Orientation >= 2) then
            tx, fs = statusbarH, h-2;
            btn.bar:ClearAllPoints();
            btn.bar.target:ClearAllPoints();
            btn.bar.count:ClearAllPoints();
            btn.bar.text:ClearAllPoints();
            btn.bar.text:SetPoint("CENTER", btn.bar, "CENTER", 1, -2);
            if (bo.Orientation == 3) then
              tx, fs = statusbarV, w-6-w/4;
              btn.bar:SetPoint("BOTTOM", btn, "TOP", 0, 1);
              btn.bar:SetSize(w, math.floor(h+h/sc));
              btn.bar.spark:SetRotation(math.rad(90.0));
              btn.bar.spark:SetSize(math.floor(w*1.68), 12);
              btn.bar.target:SetPoint("BOTTOM", btn.bar, "BOTTOM", 1, 1);
              btn.bar.count:SetPoint("TOP", btn.bar, "TOP", 1, -2);
            else
              btn.bar:SetPoint("LEFT", btn, "RIGHT", 1, 0);
              btn.bar:SetSize(math.floor(w*1.4+w*2/sc), h);
              btn.bar.spark:SetRotation(0.0);
              btn.bar.spark:SetSize(12, math.floor(h*1.68));
              btn.bar.target:SetPoint("LEFT", btn.bar, "LEFT", 2, -2);
              btn.bar.count:SetPoint("RIGHT", btn.bar, "RIGHT", -1, -2);
            end
            tx = format(tx, OG.BarStyle);
            if (btn.bar:GetStatusBarTexture():GetTexture() ~= tx) then
              btn.bar:SetStatusBarTexture(tx);
              btn.bar:SetBackdrop( { 
                bgFile = tx, 
                edgeFile = nil, tile = false, tileSize = 0, edgeSize = 0, 
                insets = { left = 0, right = 0, top = 0, bottom = 0 }
              });
            end
          else
            btn.bar:Hide();
          end
          
          -- Check and set font, size, style
          btn.bar.target:SetFont(OG.Font, CheckFontSize(fs), "OUTLINE");
          if (not btn.bar.target:GetFont()) then
            OG.Font = STANDARD_TEXT_FONT;
            btn.bar.target:SetFont(OG.Font, CheckFontSize(fs), "OUTLINE");
          end          
          btn.bar.target:SetFont(OG.Font, CheckFontSize(fs), "OUTLINE");
          btn.bar.count:SetFont(OG.Font, CheckFontSize(fs), "OUTLINE");
          btn.bar.text:SetFont(OG.Font, CheckFontSize(fs), "OUTLINE");

          btn.target:SetFont(OG.Font, CheckFontSize(w/2.7), "OUTLINE");
          btn.text:SetFont(OG.Font, CheckFontSize(w-6-w/4), "OUTLINE");
          -- THICKOUTLINE / OUTLINE / MONOCHROME
          
          if (OG.TimerStyle and bo.Orientation < 2) then
            btn.count:ClearAllPoints();
            btn.count:SetPoint("TOP", btn, "BOTTOM", 0, -1);
            btn.count:SetFont(OG.Font, 12, "OUTLINE");
          else
            btn.count:ClearAllPoints();
            btn.count:SetPoint("TOPRIGHT", btn, "TOPRIGHT", -1, -3);
            btn.count:SetFont(OG.Font, CheckFontSize(w/2.7), "OUTLINE");
          end          
          
          -- Enable tooltips
          if (bo.Tooltips and not fOptions:IsVisible()) then
            btn:EnableMouse(true);
            btn:SetScript("OnEnter", function(self, b)
              if (self and self.AuraId) then
                SmartAuraWatch_AuraInfoTooltip(self, self.AuraId, nil, "ANCHOR_LEFT"); -- ANCHOR_LEFT, ANCHOR_CURSOR
              end
              end
            );    
            btn:SetScript("OnLeave", function(self, b)
              GameTooltip:Hide();
              end
            );      
          else
            btn:EnableMouse(false);
          end          
          
        end
        bar:Show();
      else
        bar:Hide();
      end
    end
  end
  
  if (fOptions:IsVisible()) then
    UpdateBackdrop(1);
  end
  isLayoutDone = true;
end


local function CheckInventory(a, v)
  if (not a) then return end
  
  local s = v or a[2] or "";
  if (s == "" or (a[1] and a[1] > 0 and GetSpellInfo(a[1]))) then return end
  
  local id, slot, name, loc;
  for i = 1, 18 do
    id = GetInventoryItemID("player", i);
    if (id) then
      name, _, _, _, _, _, _, _, loc = GetItemInfo(id);
      --loc = _G[loc];
      --print(format("Item: %d. %s (%s)", i, name, loc));
      if (name and s and (name == s or strlower(name) == strlower(s))) then
        slot = i;
        break;
      end
    end
  end
  for i = 1, #InvList do
    loc = InvList[i];
    -- 1:slot, 2:slot name, 3:shortcut
    if (loc and (s == loc[2] or (slot and slot == loc[1]))) then
      a[1] = -i;
      a[2] = loc[2];
      a[3] = GetInventoryItemTexture("player", loc[1]);
      -- Update default filter
      if (not a[6] or a[6] < 7) then
        if (loc[1] == INVSLOT_MAINHAND or loc[1] == INVSLOT_OFFHAND) then
          a[6] = 7; -- enchant
        else
          a[6] = 8; -- cooldown
        end
      end
      --print(format("Inv slot: %d. %s, %s", loc[1], loc[2], FilterList[a[6]][2]));
    end
  end
end


local function CheckAura(a, noInv)
  if (a == nil) then return end
  
  if (a[1] == nil and a[2]) then               -- aura id
    _, a[1] = GetSpellBookItemInfo(a[2], BOOKTYPE_SPELL);
  end
  
  if (a[2] == nil) then a[2] = "" end          -- aura name
  if (not noInv) then CheckInventory(a) end
  
  if (a[3] == nil) then                        -- aura icon
    local icon;
    if (a[1]) then _, _, icon = GetSpellInfo(a[1]) end
    if (icon) then a[3] = icon
    else a[3] = "?" end
  end    
  if (a[4] == nil)  then a[4]  = 1 end         -- unit (player)
  if (a[5] == nil)  then a[5]  = true end      -- caster (yourself)
  if (a[6] == nil)  then a[6]  = 2 end         -- filter (helpful)
  if (a[7] == nil)  then a[7]  = DefMin end    -- < timeleft (-1)
  if (a[8] == nil)  then a[8]  = 0 end         -- > timeleft
  if (a[9] == nil)  then a[9]  = DefMin end    -- < count (-1)
  if (a[10] == nil) then a[10] = 0 end         -- > count
  if (a[11] == nil) then a[11] = false end     -- combat only
  if (a[12] == nil) then a[12] = false end     -- when off
  if (a[13] == nil) then a[13] = 1 end         -- relationship (all)
  if (a[14] == nil) then a[14] = 0 end         -- talent group (all)
  if (a[15] == nil) then a[15] = "" end        -- form/stance (not used yet)
  if (a[16] == nil) then a[16] = false end     -- use sound
  if (a[17] == nil) then a[17] = 1 end         -- sound file (none)
  if (a[18] == nil) then a[18] = false end     -- show cd (false)
  
  if (a[30] == nil) then a[30] = 0.00001 end   -- total combat time
  if (a[31] == nil) then a[31] = 0.0 end       -- active combat time

  -- Make sure to have integers
  a[7] = Round(tonumber(a[7]));
  a[8] = Round(tonumber(a[8]));
  a[9] = Round(tonumber(a[9]));
  a[10] = Round(tonumber(a[10]));
end

local function CheckAuras()
  local bn;
  for j = 1, BarMax do
    bn = BarName..j;
    if (O[bn] and O[bn].AuraList) then
      for _, a in pairs(O[bn].AuraList) do
        CheckAura(a);
      end
    end
  end
end


-- Set status bar value
local function SetBarValue(btn, du, et, t)
  if (btn.ori and btn.ori >= 2 and du) then
    -- full blue bar
    if (du == -1) then
      if (cBtnBars[btn]) then wipe(cBtnBars[btn]) end
      btn.bar.spark:Hide();
      btn.bar:SetMinMaxValues(0, 1);
      btn.bar:SetValue(1);
      btn.bar:SetStatusBarColor(0, 0, 1);
      btn.bar:Show();
      return;
    end
    -- colored time left bar
    if (du > 0.0 and et and et > 0.0 and t and t > 0.0) then
      if (et-t > 0.0) then
        if (not cBtnBars[btn]) then cBtnBars[btn] = { } end
        cBtnBars[btn][1] = du;
        cBtnBars[btn][2] = et;
        btn.bar:SetMinMaxValues(0.0, du);
        if (btn.ori == 3) then
          btn.bar:SetOrientation("VERTICAL");
        else
          btn.bar:SetOrientation("HORIZONTAL");
        end
        return;
      end
    end
  end
  UpdateButtonBar(btn);
end


-- Map text fields
local function MapBtn(btn, o, bm)
  wipe(bm);
  btn.ori = o;
  if (o >= 2) then
    btn.text:Hide();
    btn.count:Hide();
    btn.target:Hide();
    --bm.text = btn.text;
    bm.text = btn.bar.text;
    bm.count = btn.bar.count;
    bm.target = btn.bar.target;
  else
    bm.target = btn.target;
    if (OG.TimerStyle) then
      bm.text = btn.count;
      bm.count = btn.text;
    else
      bm.text = btn.text;
      bm.count = btn.count;
    end
  end
end


local function IsInPetBattle()
  if (C_PetBattles) then
    return C_PetBattles.IsInBattle();
  end
  return false;
end


local bm = { };
local to = { };
local lock;
function SmartAuraWatch_AuraUpdate()
  if (lock or not isLayoutDone or IsInPetBattle()) then return end
  lock = true;

  iTalentGroup = 0; --GetActiveSpecGroup() or 0;
  isCombat = UnitAffectingCombat("player") or false;
    
  local t = GetTime();
  if (not tLast) then tLast = t end
  local tDiff = t - tLast;
  O.RunTimeTotal = O.RunTimeTotal + tDiff;
  if (isCombat) then O.CombatTimeTotal = O.CombatTimeTotal + tDiff end
  
  local btn, bar, bn, b, n, f, u, c, tl, sc, name, icon, count, duration, expirationTime, spellId, start, isOn, cr, cg, cb, ori, bTo, sSec;
  
  if (OG.SecTL) then
    sSec = "%.0f";
  else
    sSec = "%.1f";
  end

  local iv = InvList;
  iv[1][4], iv[1][5], iv[1][6], iv[2][4], iv[2][5], iv[2][6], iv[3][4], iv[3][5], iv[3][6] = GetWeaponEnchantInfo();
  
  bTo = false;
  if (sPlayerClass == "SHAMAN") then
    for i = 1, MAX_TOTEMS do
      if (not to[i]) then to[i] = { } end
      c = to[i];
      -- haveTotem, totemName, startTime, duration, icon
      _, name, start, duration, icon = GetTotemInfo(i);
      if (name and name ~= "") then
        bTo = true;
        c[1], c[2], c[3], c[4] = name, duration, start+duration, icon;
      else
        c[1], c[2], c[3], c[4] = nil, -1, -1, nil;
      end
    end
  end 
  
  for j = 1, O.Bars do
    bn = BarName..j;
    bar = _G[bn];
    if (not bar) then break end
    ori = O[bn].Orientation or 0;
    if (O[bn]) then
      O[bn].RunTime = O[bn].RunTime + tDiff;
      if (isCombat) then O[bn].CombatTime = O[bn].CombatTime + tDiff end
    end
    
    b = bar:IsMouseEnabled();
    for i = 1, BtnMax do
      btn = _G[BtnName..j..i];
      if (btn) then
        btn.AuraId = nil;
        btn.icon:SetAlpha(0.9);
        if (b) then
          tBarUpdate = tUpdate;
          btn.isUsed = true;
          SetIcon(btn.icon);
          MapBtn(btn, ori, bm);
          --SetBarValue(btn, -1);
          SetBarValue(btn, 10, 11-i+t, t);
          bm.target:SetText(GFN..j);
          bm.target:Show();
          bm.count:SetText(BLL..j);
          bm.count:Show();
          bm.text:SetFormattedText(sSec, i);
          bm.text:Show();
        else
          tBarUpdate = 0.01;
          btn.isUsed = false;
        end
      end
    end
    
    if (isEnabled and not b and O[bn] and O[bn].AuraList) then      
      n = 1;
      for k, v in pairs(O[bn].AuraList) do
        b = false;
        -- 1:aura id, 2:aura name, 3:aura icon
        -- 4:target, 5:caster, 6:filter
        -- 7:<timeleft, 8:>timeleft, 9:<count, 10:>count
        -- 11:combat only, 12:when off, 13:relationship
        -- 14:talent group, 15:form/stance
        -- 16:use sound, 17:sound file, 18:show cd
        if (v and v[2] and v[2] ~= "") then
          spellId, name, icon, sc, duration, expirationTime, count, isOn, tl = nil, nil, nil, nil, -1, -1, -1, 0, -1;
          f = FilterList[v[6]][1];
          u = UnitList[v[4]][1];
          if ((v[14] == 0 or v[14] == iTalentGroup) and UnitExists(u) and not UnitIsDeadOrGhost(u)) then
            if (v[13] == 1 or (v[13] == 2 and UnitIsFriend("player", u)) or (v[13] == 3 and not UnitIsFriend("player", u))) then
              if (not v[11] or (v[11] and isCombat)) then
                
                -- Check for inventory/temporary enchants
                if (v[1] and v[1] < 0) then
                  c = iv[-v[1]];
                  if (c) then
                    -- 1:slot, 2:slot name, 3:shortcut, 4:has enchant, 5:expiration, 6:charges
                    icon, sc = GetInventoryItemTexture("player", c[1]), c[3];
                    if (icon) then
                      if (f == M_CD) then
                        -- inventory cd
                        start, duration, isOn = GetInventoryItemCooldown("player", c[1]);
                        if (isOn == 1) then -- if the item has use/cooldown
                          name, expirationTime = c[2], start+duration;
                        else
                          name, duration, icon = nil, -9, "?";
                        end
                      else
                        -- temporary enchant
                        if (c[4]) then
                          name, duration, expirationTime, count = c[2], 1, t+c[5]/1000, c[6];
                        end
                      end
                    end
                  end
                
                else
                  -- Check for totems
                  if (bTo) then
                    for i = 1, MAX_TOTEMS do
                      -- 1:name, 2:duration, 3:expirationTime, 4:icon
                      c = to[i];
                      if (c and c[1] and c[1] == v[2]) then
                        name, duration, expirationTime, icon = v[2], c[2], c[3], c[4];
                        if (u) then sc = UnitList[v[4]][3] end
                      end
                    end
                  end
                  
                  -- Check for auras
                  if (not name) then
                    if (f == M_CD) then
                      if (v[1]) then
                        start, duration = GetSpellCooldown(v[1]);
                        name, icon, expirationTime = v[2], v[3], start + duration;
                        if (not v[12] and expirationTime == 0) then duration = -99 end
                        --sc = L.ScCd;
                      end
                    else
                      if (f ~= "" and v[5]) then f = "|"..f end
                      if (v[5]) then f = "PLAYER"..f end
                      --name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff
                      for ia = 1, 40 do
                        
                        name, icon, count, _, duration, expirationTime, _, _, _, spellId = UnitAuraFull(u, ia, f);
                        if (name == nil or name == v[2]) then
                          break;
                        else
                          name = nil;
                        end
                      end
                      
                      if (name == nil) then 
                        spellId, name, icon, sc, duration, expirationTime, count, isOn, tl = nil, nil, nil, nil, -1, -1, -1, 0, -1;
                      else
                        if (u) then sc = UnitList[v[4]][3] end
                        -- Update aura
                        if (icon) then v[3] = icon end
                        if (spellId) then v[1] = spellId end
                      end 
                    end
                  end
                end
                
                -- Update statistic
                if (isCombat) then
                  v[30] = v[30] + tDiff;
                  if (name and (f ~= M_CD or (f == M_CD and start and start > 0))) then v[31] = v[31] + tDiff end
                end

                -- Not active check
                if (name == nil and v[12] and v[3] ~= "?") then name = v[2] end
              end
            end
          end
          
          if (name) then
            btn = _G[BtnName..j..n];
            if (btn == nil) then break end
            
            -- Button mapping
            MapBtn(btn, ori, bm);
                        
            -- Complete missing info
            if (icon == nil) then
              icon = v[3];
              duration = -1;
              count = -1;          
            end
            if (icon == "?" and v[3] == "?") then
              local _, _, si = GetSpellInfo(name);
              if (si) then
                v[3], icon = si, si;
              end
            end            
            
            -- Aura is not active
            if (duration == -1) then
              btn.icon:SetAlpha(0.7);
              bm.text:SetText(L.Missing);
              bm.text:Show();
              SetBarValue(btn, -1);
              b = true;
            end            
            
            -- Set icon
            SetIcon(btn.icon, icon);
            
            -- Set target shortcut
            if (sc) then
              bm.target:SetText(GFN..sc);
              bm.target:Show();
            else
              bm.target:Hide();
            end
            
            -- Set time left
            if (duration and duration > 0 and duration ~= 1.5 and expirationTime) then
            --if (duration and duration > 0 and expirationTime) then
              tl = expirationTime - t;
              if (tl > 0.0 and (tl < v[7] or (tl > v[8] and v[8] ~= DefMax))) then
                if (tl < 9.94) then
                  if (OG.ColoredTL) then
                    cg, cb = tl*0.1, tl*0.05;
                    if (cg > 1.0) then cg = 1.0 end
                    if (cb > 1.0) then cb = 1.0 end
                    bm.text:SetFormattedText("%s"..sSec, BCC(1.0, cg, cb), tl);
                  else
                    bm.text:SetFormattedText(sSec, tl);
                  end
                elseif (tl < 99.4) then
                  if (f == M_CD) then
                    bm.text:SetFormattedText("%s%.0f", BL, tl);
                  else
                    bm.text:SetFormattedText("%.0f", tl);
                  end
                else
                  if (f == M_CD) then
                    bm.text:SetFormattedText("%s%.0f", BLD, Round(tl/60));
                  else
                    bm.text:SetFormattedText("%s%.0f", GRL, Round(tl/60));
                  end
                end
                SetBarValue(btn, duration, expirationTime, t);
                bm.text:Show();
                b = true;
              else
                SetBarValue(btn);
                bm.text:Hide();
              end
            end
            
            -- Set aura without duration and expiration time
            if (not b and duration and duration == 0 and expirationTime and expirationTime == 0 and (v[7] ~= DefMin or v[8] ~= DefMax)) then
              --print(format("D: %s, E: %s", duration, expirationTime));
              if (f == M_CD) then
                SetBarValue(btn, -1);
                bm.text:SetText(L.InvRdy);
                bm.text:Show();
              else
                SetBarValue(btn);
                --bm.text:SetText(WHD..L.Infinity);
                --bm.text:Show();
                bm.text:Hide();
              end
              b = true;
            end

            -- Set the number of applications of an aura
            if (count > 0 and (count < v[9] or (count > v[10] and v[10] ~= DefMax))) then
              if (b or OG.TimerStyle) then
                bm.count:SetText(BLL..count);
                bm.count:Show();
              else
                if (expirationTime) then SetBarValue(btn, duration, expirationTime, t) end
                bm.text:SetText(WHB..count);
                bm.text:Show();
                bm.count:Hide();
              end
              b = true;
            else
              bm.count:Hide();
            end
            
            if (b) then
              -- Set cooldown
              if (v[18] and v[1]) then
                start, duration, isOn = GetSpellCooldown(v[1]);
                if (start and start > 0 and duration > 1.6 and isOn > 0) then
                  btn.cd.noCooldownCount = ori < 2; -- disables OmniCC timer
                  btn.cd:SetCooldown(start, duration);
                  btn.cd:Show();
                else
                  btn.cd.noCooldownCount = true;
                  btn.cd:Hide();
                end
              else
                btn.cd.noCooldownCount = true;
                btn.cd:Hide();
              end
              btn.AuraId = v[1];
              btn.isUsed = true;
              n = n + 1;
            end
          end -- name
          
          -- Play alert sound
          if (v[16] and v[17]) then
            if (b) then
              if (not cPlayed[v]) then
                cPlayed[v] = true;
                PlaySoundFile(SoundList[v[17]][2], "Master");
                --print(SoundList[v[17]][1]);
              end
            else
              cPlayed[v] = nil;
            end            
          end
          
        end -- aura
      end -- aura list
    end -- bar

    for i = 1, BtnMax do
      btn = _G[BtnName..j..i];
      if (btn) then
        if (btn.isUsed) then
          btn:Show();
        else
          SetBarValue(btn);
          btn.cd:Hide();
          btn:Hide();
        end
      end
    end    
  
  end -- Bars
  tLast = t;
  lock = false;
end



function SmartAuraWatch_UpdateBarPos(self)
  if (self == nil) then return end
  local s = self:GetName();
  local x, y, w, h = self:GetRect();
  local sc = self:GetScale();
  if (O[s] == nil) then O[s] = { } end
  O[s].P = "BOTTOMLEFT";
  O[s].X = x*sc;
  O[s].Y = y*sc;
  --print(s..": "..O[s].X..", "..O[s].Y);
end


function SmartAuraWatch_UpdateBarCount(v)
  if (not O) then return end
  local f = fOptions.bars;
  if (v) then
    if (v == O.Bars) then return end
    O.Bars = v;
  else
    v = O.Bars;
    f:SetValue(v);
  end
  _G[f:GetName().."Text"]:SetFormattedText(L.Bars, GFN..v.."|r");
  --SmartAuraWatch_UpdateBars();
  SmartAuraWatch_UpdateActiveBar();
end


function SmartAuraWatch_UpdateActiveBar(v)
  if (not O) then return end
  local f = fOptions.bar;
  if (v) then
    if (SmartAuraWatch_ActiveBar == v) then return end
    f:SetValue(v);
  else
    v = 1;
    f:SetValue(v);
  end
  if (ActiveAura) then
    local c = tcopy(ActiveAura);
    c[1], c[3] = nil, nil;
    CheckAura(c);
    ActiveAura = c;
  end
  SmartAuraWatch_ActiveBar = v;
  f:SetMinMaxValues(1, O.Bars);
  _G[f:GetName().."Text"]:SetFormattedText(L.ActiveBar, GFN..v.."|r");

  --local bn = BarName..SmartAuraWatch_ActiveBar;
  --local bo = O[bn];
  --fOptions.iconsize:SetValue(bo.IconSize);
  
  SmartAuraWatch_UpdateBarAlpha(nil, true);
  SmartAuraWatch_UpdateIconSize(nil, true);
  SmartAuraWatch_UpdateOrientation(nil, true);
  SmartAuraWatch_UpdateTooltips(nil, true);
  SmartAuraWatch_UpdateBars();
  SmartAuraWatch_AuraListOnScroll();
end


function SmartAuraWatch_UpdateBarAlpha(v, noUd)
  if (not O) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local bo = O[bn];
  local f = fOptions.baralpha;
  
  if (v) then
    if (v == bo.Alpha) then return end
    bo.Alpha = v;
  else
    v = bo.Alpha;
    f:SetValue(v);
  end
  local s
  s = format("%.0f", v*100);  
  _G[f:GetName().."Text"]:SetFormattedText(L.BarAlpha, GFN..s.."|r");
  if (not noUd) then SmartAuraWatch_UpdateBars() end
end


function SmartAuraWatch_UpdateIconSize(v, noUd)
  if (not O) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local bo = O[bn];
  local f = fOptions.iconsize;
  
  if (v) then
    if (v == bo.IconSize) then return end
    bo.IconSize = v;
  else
    v = bo.IconSize;
    f:SetValue(v);
  end
  
  _G[f:GetName().."Text"]:SetFormattedText(L.IconSize, GFN..v.."|r");
  if (not noUd) then SmartAuraWatch_UpdateBars() end
end


function SmartAuraWatch_UpdateOrientation(v, noUd)
  if (not O) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local bo = O[bn];
  local f = fOptions.orientation;
  
  if (v) then
    if (v == bo.Orientation) then return end
    bo.Orientation = v;
  else
    v = bo.Orientation;
    f:SetValue(v);
  end  
  
  local s;
  if (v == 1) then
    s = L.Horizontal;
  elseif (v == 2) then
    s = L.VBar;
  elseif (v == 3) then
    s = L.HBar;
  else
    s = L.Vertical;
  end
  _G[f:GetName().."Text"]:SetFormattedText(L.Orientation, GFN..s.."|r");
  SmartAuraWatch_UpdateGrowth(nil, noUd);
end


function SmartAuraWatch_UpdateGrowth(v, noUd)
  if (not O) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local bo = O[bn];
  local f = fOptions.growth;
  
  if (v) then
    if (v == bo.Growth) then return end
    bo.Growth = v;
  else
    v = bo.Growth;
    f:SetValue(v);
  end  
  
  local s;
  if (v == 0) then
    if (bo.Orientation == 1 or bo.Orientation == 3) then
      s = L.Left;
    else
      s = L.Bottom;
    end
  elseif (v == 2) then
    if (bo.Orientation == 1 or bo.Orientation == 3) then
      s = L.Right;
    else
      s = L.Top;
    end
  else
    s = L.Center;
  end
  _G[f:GetName().."Text"]:SetFormattedText(L.Growth, GFN..s.."|r");
  if (not noUd) then SmartAuraWatch_UpdateBars() end
end


function SmartAuraWatch_UpdateTooltips(v, noUd)
  if (not O) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local bo = O[bn];
  local f = fOptions.tooltips;
  
  if (v ~= nil) then
    bo.Tooltips = v;
  else
    v = bo.Tooltips;
    f:SetChecked(v);
  end
  _G[f:GetName().."Text"]:SetText(WH..L.Tooltips);
  if (not noUd) then SmartAuraWatch_UpdateBars() end
end


function SmartAuraWatch_UpdateActiveAura()
  if (ActiveAura == nil) then
    ActiveAura = { };
  end
  local a = ActiveAura;
  CheckAura(a, true);
  SmartAuraWatch_UpdateAura(a[2]);
  SmartAuraWatch_UpdateUnit();
  SmartAuraWatch_UpdateRelship();
  SmartAuraWatch_UpdateDurationMin();
  SmartAuraWatch_UpdateDurationMax();
  SmartAuraWatch_UpdateCountMin();
  SmartAuraWatch_UpdateCountMax();
  SmartAuraWatch_UpdateTalentGroup();
  SmartAuraWatch_UpdateMyAura();
  SmartAuraWatch_UpdateCombatOnly();
  SmartAuraWatch_UpdateNotUp();
  SmartAuraWatch_UpdateShowCd();
  SmartAuraWatch_UpdateSound();
  SmartAuraWatch_SoundListOnScroll();
end


function SmartAuraWatch_UpdateAura(v)
  if (not O or not ActiveAura) then return end
  local a = ActiveAura;
  local f = fOptions.aura;
  
  if (not v) then
    v = f:GetText() or "";  
    v = strtrim(v);  
  end
  if (v ~= "") then
    if (a[2] and a[2] ~= v) then      -- if name has changed, clear id and icon
      a[1] = nil;
      a[3] = "?";
    end
    a[2] = v;                         -- update name
    local name, icon;
    local n = tonumber(v);            -- check if it is a spell id
    if (n) then v = n end
    --name, rank, icon, castTime, minRange, maxRange, spellId
    name, _, icon, _, _, _, a[1] = GetSpellInfo(v);  -- get spell info
    if (icon) then a[3] = icon end    -- update icon
    if (name) then 
      a[2], v = name, name;           -- update name
    else
      CheckInventory(a, v);
      v = a[2];
    end
  end
  SetIcon(fOptions.icon, a[3]);
  f:SetText(v);
  f:ClearFocus();
  SmartAuraWatch_AuraListOnScroll();  -- update aura list
  SmartAuraWatch_UpdateFilter();      -- update filter (inventory change)
end


function SmartAuraWatch_UpdateUnit(v)
  if (not O or not ActiveAura) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local a = ActiveAura;
  local f = fOptions.unit;
  
  if (v) then
    if (v == a[4]) then return end
    a[4] = v;
  else
    v = a[4];
    f:SetValue(v);
  end
  v = UnitList[v][2];
  _G[f:GetName().."Text"]:SetFormattedText(L.Unit, GFN..v.."|r");
end


function SmartAuraWatch_UpdateFilter(v)
  if (not O or not ActiveAura) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local a = ActiveAura;
  local f = fOptions.filter;
  
  if (v) then
    if (v == a[6]) then return end
    a[6] = v;
  else
    v = a[6];
    f:SetValue(v);
  end
  local s;
  if (v == 1) then
    s = GYL..FilterList[v][2];
  else
    s = GFN..FilterList[v][2];
  end
  _G[f:GetName().."Text"]:SetFormattedText(L.Filter, s.."|r");
end


function SmartAuraWatch_UpdateRelship(v)
  if (not O or not ActiveAura) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local a = ActiveAura;
  local f = fOptions.relship;
  
  if (v) then
    if (v == a[13]) then return end
    a[13] = v;
  else
    v = a[13];
    f:SetValue(v);
  end
  local s;
  if (v == 1) then
    s = GYL..RelshipList[v][2];
  else
    s = GFN..RelshipList[v][2];
  end
  _G[f:GetName().."Text"]:SetFormattedText(L.Relship, s.."|r");
end


function SmartAuraWatch_UpdateDurationMin(v)
  if (not O or not ActiveAura) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local a = ActiveAura;
  local f = fOptions.durationmin;
  
  if (v) then
    if (v == a[7]) then return end
    a[7] = v;
  else
    v = a[7];
    f:SetValue(v);
  end
  local s;
  if (v < 0) then 
    s = GYL..L.Off;
  else
    s = GFN..v;
  end
  _G[f:GetName().."Text"]:SetFormattedText(L.DurationMin, s.."|r");
end


function SmartAuraWatch_UpdateDurationMax(v)
  if (not O or not ActiveAura) then return end
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local a = ActiveAura;
  local f = fOptions.durationmax;
  
  if (v) then
    if (v == a[8]) then return end
    a[8] = v;
  else
    v = a[8];
    f:SetValue(v);
  end
  local s;
  if (v > 100) then 
    s = GYL..L.Off
  else
    s = GFN..v;
  end
  _G[f:GetName().."Text"]:SetFormattedText(L.DurationMax, s.."|r");
end


function SmartAuraWatch_UpdateCountMin(v)
  if (not O or not ActiveAura) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local a = ActiveAura;
  local f = fOptions.countmin;
  
  if (v) then
    if (v == a[9]) then return end
    a[9] = v;
  else
    v = a[9];
    f:SetValue(v);
  end
  local s;
  if (v < 0) then 
    s = GYL..L.Off;
  else
    s = GFN..v;
  end
  _G[f:GetName().."Text"]:SetFormattedText(L.CountMin, s.."|r");
end


function SmartAuraWatch_UpdateCountMax(v)
  if (not O or not ActiveAura) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local a = ActiveAura;
  local f = fOptions.countmax;
  
  if (v) then
    if (v == a[10]) then return end
    a[10] = v;
  else
    v = a[10];
    f:SetValue(v);
  end
  local s;
  if (v > 100) then 
    s = GYL..L.Off
  else
    s = GFN..v;
  end
  _G[f:GetName().."Text"]:SetFormattedText(L.CountMax, s.."|r");
end


function SmartAuraWatch_UpdateTalentGroup(v)
  if (not O or not ActiveAura) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local a = ActiveAura;
  local f = fOptions.talentgroup;
  
  if (v) then
    if (v == a[14]) then return end
    a[14] = v;
  else
    v = a[14];
    f:SetValue(v);
  end
  local s;
  if (v == 0) then
    s = GYL..TGList[v][2];
  else
    s = GFN..TGList[v][2];
  end
  _G[f:GetName().."Text"]:SetFormattedText(L.TalentTree, s.."|r");
end


function SmartAuraWatch_UpdateMyAura(v)
  if (not O or not ActiveAura) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local a = ActiveAura;
  local f = fOptions.myaura;
  
  if (v ~= nil) then
    a[5] = v;
  else
    v = a[5];
    f:SetChecked(v);
  end
  _G[f:GetName().."Text"]:SetText(WH..L.MyAura);
end


function SmartAuraWatch_UpdateCombatOnly(v)
  if (not O or not ActiveAura) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local a = ActiveAura;
  local f = fOptions.combatonly;
  
  if (v ~= nil) then
    a[11] = v;
  else
    v = a[11];
    f:SetChecked(v);
  end
  _G[f:GetName().."Text"]:SetText(WH..L.OnlyInCombat);
end


function SmartAuraWatch_UpdateNotUp(v)
  if (not O or not ActiveAura) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local a = ActiveAura;
  local f = fOptions.notup;
  
  if (v ~= nil) then
    a[12] = v;
  else
    v = a[12];
    f:SetChecked(v);
  end
  _G[f:GetName().."Text"]:SetText(WH..L.NotUp);
end


function SmartAuraWatch_UpdateShowCd(v)
  if (not O or not ActiveAura) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local a = ActiveAura;
  local f = fOptions.showcd;
  
  if (v ~= nil) then
    a[18] = v;
  else
    v = a[18];
    f:SetChecked(v);
  end
  _G[f:GetName().."Text"]:SetText(WH..L.ShowCd);
end


function SmartAuraWatch_UpdateSound(v)
  if (not O or not ActiveAura) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local a = ActiveAura;
  local f = fOptions.sound;
  
  if (v ~= nil) then
    a[16] = v;
  else
    v = a[16];
    f:SetChecked(v);
  end
  if (v) then
    fSounds:Show();
  else
    fSounds:Hide();
  end
  _G[f:GetName().."Text"]:SetText(WH..format(L.Sound, GFN..SoundList[a[17]][1].."|r"));
end


function SmartAuraWatch_UpdateAutoReset(v)
  if (not O) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local bo = O[bn];
  local f = fStatList.autoreset;
  
  if (v ~= nil) then
    bo.StatAutoReset = v;
  else
    v = bo.StatAutoReset;
    f:SetChecked(v);
  end
  _G[f:GetName().."Text"]:SetText(WH..L.AutoReset);
end


function SmartAuraWatch_ClearAuraList()
  if (not O) then return end
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local bo = O[bn];
  if (bo.AuraList) then wipe(bo.AuraList) end
  SmartAuraWatch_ClearActiveAura();
  SmartAuraWatch_AuraListOnScroll();
end


function SmartAuraWatch_DefaultAuraList()
  if (not O) then return end
  ResetAuraList(SmartAuraWatch_ActiveBar);
  SmartAuraWatch_ClearActiveAura();
  SmartAuraWatch_AuraListOnScroll();
end


function SmartAuraWatch_AddAura()
  if (not O or not ActiveAura) then return end  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local bo = O[bn];
  local f = fOptions.aura;
  local a = ActiveAura;
  if (bo.AuraList == nil) then bo.AuraList = { } end
  
  local v = f:GetText() or "";  
  v = strtrim(v);
  f:SetText(v);
  if (v ~= "") then
    if (tContains(bo.AuraList, a)) then
      local c = tcopy(a);
      c[1], c[3] = nil, nil;
      CheckAura(c);
      tinsert(bo.AuraList, c);
      ActiveAura = c;
    else
      a[2] = v;
      tinsert(bo.AuraList, a);
    end
    SmartAuraWatch_AuraListOnScroll();
  end
  f:ClearFocus();
end


function SmartAuraWatch_ShowAuraScanList()
  if (not OG) then return end
  local f = fAuraScanList;
  if (f:IsVisible()) then
    f:Hide();
  else
    ProcessAuraScanList();
    sort(OG.AuraScanList, function(a,b) return a[2]<b[2] end);
    --print("Sort aura scan list");
    f:EnableMouse(true);
    f.list:EnableMouse(true);
    f:Show();
  end
end

function SmartAuraWatch_ClearAuraScanList()
  if (not OG) then return end
  wipe(OG.AuraScanList);
  SmartAuraWatch_AuraScanListOnScroll();
end


function SmartAuraWatch_ShowStatList(nBar)
  local f = fStatList;
  f:SetMovable(false);
  if (not nBar and f:IsVisible()) then
    f:Hide();
  else
    if (nBar) then
      SmartAuraWatch_ActiveBar = nBar
      f:SetMovable(true);
      SmartAuraWatch_StatListOnScroll();
    end
    if (fOptions:IsVisible()) then
      f:ClearAllPoints();
      f:SetPoint("TOPLEFT", fOptions, "TOPRIGHT", 1, 0);
    end
    f:EnableMouse(true);
    f.list:EnableMouse(true);
    f:Show();
  end
end

function SmartAuraWatch_ClearStatList(name)
  local bn = name or BarName..SmartAuraWatch_ActiveBar;
  local bo = O[bn];
  if (bo) then
    bo.RunTime = 0.00001;
    bo.CombatTime = 0.0;
    if (bo.AuraList) then
      for k, a in pairs(bo.AuraList) do
        if (a) then
          a[30] = 0.00001;
          a[31] = 0.0;
          --print("Clear: "..a[2]);
        end
      end
    end
  end
  SmartAuraWatch_StatListOnScroll();
end


function SmartAuraWatch_Tooltip(self, title, text, anchor)
  if (not anchor) then anchor = "ANCHOR_LEFT" end
  GameTooltip:ClearLines();
  GameTooltip:SetOwner(self, anchor);
  GameTooltip:SetText(WH..title, 1, 1, 1, 1, 1);
  if (text and text ~= "") then GameTooltip:AddLine(GFN..text, 1, 1, 1, 1, 1) end
  GameTooltip:Show();
end

function SmartAuraWatch_AuraInfoTooltip(self, spellId, text, anchor)
  if (not O) then return end
  if (not anchor) then anchor = "ANCHOR_LEFT" end
  local id;
  local a = ActiveAura;
  if (a and a[1]) then id = a[1] end
  if (spellId) then id = spellId end
  if (id) then
    GameTooltip:ClearLines();
    GameTooltip:SetOwner(self, anchor);
    if (id < 0) then
      local c = InvList[-id];
      if (c) then
        GameTooltip:SetInventoryItem("player", c[1]);
      end
    else
      GameTooltip:SetSpellByID(id);
    end
    if (text and text ~= "" and GameTooltip:NumLines() > 0) then GameTooltip:AddLine(GR..text, 1, 1, 1, 1, 1) end
    GameTooltip:Show();
  end
end


-- Options Global frame functions ---------------------------------------------------------------------------------------

function SmartAuraWatch_ShowOptionsGlobal()
  if (not OG) then return end
  local f = fOG;
  if (f:IsVisible()) then
    f:Hide();
  else
    f:EnableMouse(true);
    f:Show();
  end
end


function SmartAuraWatch_UpdateAuraScan(v)
  if (not OG) then return end
  local f = fOG.aurascan;
  if (v ~= nil) then
    OG.AuraScan = v;
    AuraScan(v);
  else
    f:SetChecked(OG.AuraScan);
  end
  _G[f:GetName().."Text"]:SetText(WH..L.AuraScanTitle);
end


function SmartAuraWatch_UpdateColoredTL(v)
  if (not OG) then return end
  local f = fOG.coloredtl;
  if (v ~= nil) then
    OG.ColoredTL = v;
  else
    f:SetChecked(OG.ColoredTL);
  end
  _G[f:GetName().."Text"]:SetText(WH..L.ColoredTL);
end


function SmartAuraWatch_UpdateSecTL(v)
  if (not OG) then return end
  local f = fOG.sectl;
  if (v ~= nil) then
    OG.SecTL = v;
  else
    f:SetChecked(OG.SecTL);
  end
  _G[f:GetName().."Text"]:SetText(WH..L.SecTL);
end


function SmartAuraWatch_UpdateShowIconBorder(v)
  if (not OG) then return end
  local f = fOG.showiconborder;
  if (v ~= nil) then
    OG.ShowIconBorder = v;
  else
    f:SetChecked(OG.ShowIconBorder);
  end
  _G[f:GetName().."Text"]:SetText(WH..L.ShowIconBorder);
end


function SmartAuraWatch_UpdateShowSpark(v)
  if (not OG) then return end
  local f = fOG.showspark;
  if (v ~= nil) then
    OG.ShowSpark = v;
  else
    f:SetChecked(OG.ShowSpark);
  end
  _G[f:GetName().."Text"]:SetText(WH..L.ShowSpark);
end


function SmartAuraWatch_UpdateTimerStyle(v, noUd)
  if (not OG) then return end
  local f = fOG.timerstyle;
  if (v ~= nil) then
    OG.TimerStyle = v;
  else
    f:SetChecked(OG.TimerStyle);
  end
  _G[f:GetName().."Text"]:SetText(WH..L.TimerStyle);
  if (not noUd) then SmartAuraWatch_UpdateBars() end
end

--[[
OG.Font
]]--

function SmartAuraWatch_UpdateBarStyle(v)
  if (not OG) then return end
  local f = fOG.barstyle;
  if (v) then
    if (v == OG.BarStyle) then return end
    OG.BarStyle = v;
  else
    v = OG.BarStyle;
    f:SetValue(v);
  end
  _G[f:GetName().."Text"]:SetFormattedText(L.BarStyle, GFN..Round(v).."|r");
  SmartAuraWatch_UpdateBars();
end


function SmartAuraWatch_UpdateFontSizeOffset(v)
  if (not OG) then return end
  local f = fOG.fontsizeoffset;
  if (v) then
    if (v == OG.FontSizeOffset) then return end
    OG.FontSizeOffset = v;
  else
    v = OG.FontSizeOffset;
    f:SetValue(v);
  end
  _G[f:GetName().."Text"]:SetFormattedText(L.FontSizeOffset, GFN..Round(v).."|r");
  SmartAuraWatch_UpdateBars();
end

function SmartAuraWatch_UpdateSpacingOffset(v)
  if (not OG) then return end
  local f = fOG.spacingoffset;
  if (v) then
    if (v == OG.SpacingOffset) then return end
    OG.SpacingOffset = v;
  else
    v = OG.SpacingOffset;
    f:SetValue(v);
  end
  _G[f:GetName().."Text"]:SetFormattedText(L.SpacingOffset, GFN..Round(v).."|r");
  SmartAuraWatch_UpdateBars();
end


function SmartAuraWatch_OptionsFrameOnShow()
  SmartAuraWatch_HideAllButThis(SmartAuraWatchWNF);
  CheckAuras();
  SmartAuraWatch_UpdateActiveBar();
  SmartAuraWatch_UpdateActiveAura();
  UpdateBackdrop(1);
end


function SmartAuraWatch_OptionsFrameOnHide()
  CheckAuras();
  wipe(cPlayed);
  ActiveAura = nil;  
  SmartAuraWatchWNF:Hide();
  fStatList:Hide();
  UpdateBackdrop(0);
  SmartAuraWatch_UpdateBars();
end


function SmartAuraWatch_HideAllButThis(self)
  if (self ~= SmartAuraWatchWNF) then SmartAuraWatchWNF:Hide() end
  if (self ~= fStatList) then fStatList:Hide() end
  if (self ~= fAuraScanList) then fAuraScanList:Hide() end
  if (self ~= fSounds) then fSounds:Hide() end
  if (self ~= fOG) then fOG:Hide() end
end


-- Scroll frame functions ---------------------------------------------------------------------------------------

local function SetPosScrollButtons(parent)
  local btn;
  local name;
  for i = 1, #parent.BtnList do
    btn = parent.BtnList[i];
    btn:ClearAllPoints();
    btn:SetPoint("TOPLEFT", parent, "TOPLEFT", 2, -2 - parent.BtnHeight*(i-1));
  end
end


local function CreateScrollButton(type, name, parent, onClick, onDragStop, onEnter)
  local btn = CreateFrame("Button", name, parent, type);
  btn:SetWidth(parent:GetWidth());
  btn:SetHeight(parent.BtnHeight);
  btn:RegisterForClicks("LeftButtonUp", "RightButtonUp");
  btn:SetScript("OnClick", onClick);
  
  --print("Create: "..name..", "..parent.BtnHeight);
  if (onDragStop) then
    btn:SetMovable(true);
    btn:RegisterForDrag("LeftButton");
    btn:SetScript("OnDragStart", function(self, b)    
      parent.StartY = self:GetTop();
      self:StartMoving();
      end
    );
    btn:SetScript("OnDragStop", function(self, b)
      parent.EndY = self:GetTop();
      local os = FauxScrollFrame_GetOffset(self:GetParent()) or 0;
      local i = tonumber(self:GetID()) + os;
      local n = math.floor((parent.StartY - parent.EndY) / parent.BtnHeight);
      --print(format("%.0f: %.0f->%.0f = %.0f", i, parent.StartY, parent.EndY, n));
      self:StopMovingOrSizing();
      SetPosScrollButtons(parent);
      onDragStop(self, i, n);
      end
    );
  end
  
  if (onEnter) then
    btn:SetScript("OnEnter", function(self, b)
      local os = FauxScrollFrame_GetOffset(self:GetParent()) or 0;
      local i = tonumber(self:GetID()) + os;
      onEnter(self, i);
      end
    );    
    btn:SetScript("OnLeave", function(self, b)
      GameTooltip:Hide();
      end
    );
  end  

  local text = btn:CreateFontString(nil, nil, "GameFontNormal");
  text:SetJustifyH("LEFT");
  text:SetAllPoints(btn);
  btn:SetFontString(text);
  btn:SetHighlightFontObject("GameFontHighlight");

  local highlight = btn:CreateTexture();
  highlight:SetAllPoints(btn);
  highlight:SetTexture("Interface/QuestFrame/UI-QuestTitleHighlight");
  btn:SetHighlightTexture(highlight);

  return btn;
end


local function CreateScrollButtons(type, self, sBtnName, onClick, onDragStop, onEnter)
  local btn, i;
  self.BtnList = { };
  self.BtnMax = math.floor(self:GetHeight()/self.BtnHeight);
  --print("BtnMax = "..self.BtnMax);
  for i = 1, self.BtnMax do
    btn = CreateScrollButton(type, sBtnName..i, self, onClick, onDragStop, onEnter);
    btn:SetID(i);    
    self.BtnList[i] = btn;
  end
  SetPosScrollButtons(self);
end


local function ButtonsUnlockHighlight(self)  
  if (self == nil) then return end  
  for i = 1, #self.BtnList do
    self.BtnList[i]:UnlockHighlight();
  end
end


function SmartAuraWatch_AddTextToTable(self, tbl)
  if (self) then
    local text = self:GetText();
    if (text and string.len(text) > 1) then
      table.insert(tbl, text);
      self:SetText("");
    end
    self:ClearFocus();
  end
end


-- Aura list scroll frame functions ---------------------------------------------------------------------------------------

local function OnScroll(self, cData, sBtnName)
  local a;
  local num = #cData;
  local n, numToDisplay;
  
  if (num <= self.BtnMax) then
    numToDisplay = num-1;
  else
    numToDisplay = self.BtnMax;
  end
  
  --print("OnScroll: "..self:GetName()..", "..num..", "..numToDisplay..", "..self.BtnHeight)
  
  FauxScrollFrame_Update(self, num, numToDisplay, self.BtnHeight);
  local os = FauxScrollFrame_GetOffset(self) or 0;
  for i = 1, self.BtnMax do
    n = i + os;
    btn = _G[sBtnName..i];
    if (btn) then
      if (n <= num) then
        btn:SetNormalFontObject("GameFontNormalSmall");
        btn:SetHighlightFontObject("GameFontHighlightSmall");
        a = cData[n];
        btn:SetText(a[2]);
        if (ActiveAura and ActiveAura == a) then
          btn:LockHighlight();
        end
        btn:Show();
      else
        btn:Hide();
      end
    end
  end
end


function SmartAuraWatch_AuraListOnScroll(self, arg1)
  if (not self) then self = fOptions.auralist end
  if (not self:IsVisible()) then return end

  local name = "SmartAuraWatchOptionsFrame_ScrBtnAL";
  if (self and not self.BtnList) then
    CreateScrollButtons(nil, self, name, SmartAuraWatch_AuraListBtnOnClick, SmartAuraWatch_AuraListBtnOnDragStop);    
  end
  ButtonsUnlockHighlight(self);
  local bn = BarName..SmartAuraWatch_ActiveBar;
  if (O[bn].AuraList == nil) then O[bn].AuraList = { } end
  OnScroll(self, O[bn].AuraList, name);
  SmartAuraWatch_StatListOnScroll();
end


function SmartAuraWatch_AuraListBtnOnClick(self, button)
  ButtonsUnlockHighlight(fOptions.auralist);
  self:LockHighlight();  
  
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local os = FauxScrollFrame_GetOffset(self:GetParent()) or 0;
  local n = self:GetID() + os;
  if (O[bn].AuraList[n]) then
    if (button == "LeftButton") then      
      ActiveAura = O[bn].AuraList[n];      
      SmartAuraWatch_UpdateActiveAura();
    else
      --print("Remove: "..n);
      table.remove(O[bn].AuraList, n);
      ActiveAura = nil;
      SmartAuraWatch_UpdateActiveAura();
      SmartAuraWatch_AuraListOnScroll();
    end
  end
  fOptions.aura:ClearFocus();
end


function SmartAuraWatch_AuraListBtnOnDragStop(self, i, n)
  --print(format("i = %.0f, n = %.0f", i, n));
  local bn = BarName..SmartAuraWatch_ActiveBar;
  treorder(O[bn].AuraList, i, n);
  SmartAuraWatch_AuraListOnScroll();
end


function SmartAuraWatch_ClearActiveAura()
  ButtonsUnlockHighlight(fOptions.auralist);
  ActiveAura = nil;
  SmartAuraWatch_UpdateActiveAura();
end


-- Sound list scroll frame functions ---------------------------------------------------------------------------------------

local function OnScrollSounds(self, cData, sBtnName)
  local num = #cData;
  local n, numToDisplay;
  
  if (num <= self.BtnMax) then
    numToDisplay = num-1;
  else
    numToDisplay = self.BtnMax;
  end
  
  --print("OnScroll: "..self:GetName()..", "..num..", "..numToDisplay..", "..self.BtnHeight)
  
  FauxScrollFrame_Update(self, num, numToDisplay, self.BtnHeight);
  local os = FauxScrollFrame_GetOffset(self) or 0;
  local a = ActiveAura;
  for i = 1, self.BtnMax do
    n = i + os;
    btn = _G[sBtnName..i];
    if (btn) then
      if (n <= num) then
        btn:SetNormalFontObject("GameFontNormalSmall");
        btn:SetHighlightFontObject("GameFontHighlightSmall");      
        btn:SetText(cData[n][1]);
        if (a and a[17] and a[17] == n) then
          btn:LockHighlight();
        end
        btn:Show();
      else
        btn:Hide();
      end
    end
  end
end


function SmartAuraWatch_SoundListOnScroll(self, arg1)
  if (not self) then self = fSounds.soundlist end
  if (not self:IsVisible()) then return end

  local name = "SmartAuraWatchSounds_ScrBtnSnd";
  if (self and not self.BtnList) then
    CreateScrollButtons(nil, self, name, SmartAuraWatch_SoundListBtnOnClick, SmartAuraWatch_SoundListBtnOnDragStop);
  end
  ButtonsUnlockHighlight(self);
  OnScrollSounds(self, SoundList, name);
end


function SmartAuraWatch_SoundListBtnOnClick(self, button)
  ButtonsUnlockHighlight(fSounds.soundlist);
  self:LockHighlight();  
  
  local os = FauxScrollFrame_GetOffset(self:GetParent()) or 0;
  local n = self:GetID() + os;
  if (SoundList[n]) then
    if (button == "LeftButton") then
      local a = ActiveAura;
      if (a) then
        a[17] = n;
      end
      SmartAuraWatch_UpdateSound();
    end
    PlaySoundFile(SoundList[n][2], "Master");
  end
end

-- Aura scan list scroll frame functions ---------------------------------------------------------------------------------------

local function OnScrollAuraScanList(self, cData, sBtnName)
  local num = #cData;
  local n, numToDisplay;
  
  if (num <= self.BtnMax) then
    numToDisplay = num-1;
  else
    numToDisplay = self.BtnMax;
  end
  
  --print("OnScroll: "..self:GetName()..", "..num..", "..numToDisplay..", "..self.BtnHeight)
  
  FauxScrollFrame_Update(self, num, numToDisplay, self.BtnHeight);
  local os = FauxScrollFrame_GetOffset(self) or 0;
  for i = 1, self.BtnMax do
    n = i + os;
    btn = _G[sBtnName..i];
    if (btn) then
      if (n <= num) then
        btn:SetNormalFontObject("GameFontNormalSmall");
        btn:SetHighlightFontObject("GameFontHighlightSmall");
        btn:SetText(cData[n][2]);
        btn:Show();
      else
        btn:Hide();
      end
    end
  end
end


function SmartAuraWatch_AuraScanListOnScroll(self, arg1)
  if (not self) then self = fAuraScanList.list end
  if (not self:IsVisible()) then return end

  local name = "SmartAuraWatchAuraScan_ScrBtnAS";
  if (self and not self.BtnList) then
    CreateScrollButtons(nil, self, name, SmartAuraWatch_AuraScanListBtnOnClick, nil, SmartAuraWatch_AuraScanListBtnOnEnter);
  end
  ButtonsUnlockHighlight(self);
  OnScrollAuraScanList(self, OG.AuraScanList, name);
end


function SmartAuraWatch_AuraScanListBtnOnEnter(self, n)
  local o = OG.AuraScanList[n];
  if (self and o and o[1]) then
    SmartAuraWatch_AuraInfoTooltip(self, o[1]);
  end
end


function SmartAuraWatch_AuraScanListBtnOnClick(self, button)
  ButtonsUnlockHighlight(fAuraScanList.list);
  self:LockHighlight();  
  
  local os = FauxScrollFrame_GetOffset(self:GetParent()) or 0;
  local n = self:GetID() + os;
  local o = OG.AuraScanList;
  if (o[n]) then
    if (button == "LeftButton") then
      ActiveAura = { };
      local a = ActiveAura;
      a[1] = o[n][1]; -- id
      a[2] = o[n][2]; -- name
      a[3] = o[n][3]; -- icon
      a[6] = o[n][4]; -- filter
      SmartAuraWatch_UpdateActiveAura();
    else
      table.remove(o, n);
      SmartAuraWatch_AuraScanListOnScroll();
    end
  end
end

-- Statistics list scroll frame functions ---------------------------------------------------------------------------------------

local function OnScrollStatList(self, cData, sBtnName)
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local bo = O[bn];
  local num = #cData+2;
  local n, numToDisplay;
  
  if (num <= self.BtnMax) then
    numToDisplay = num-1;
  else
    numToDisplay = self.BtnMax;
  end
  
  --print("OnScroll: "..self:GetName()..", "..num..", "..numToDisplay..", "..self.BtnHeight)
  local a, v, s, t;
  local h = self.BtnHeight;
  FauxScrollFrame_Update(self, num, numToDisplay, h);
  local os = FauxScrollFrame_GetOffset(self) or 0;
  for i = 1, self.BtnMax do
    n = i + os;
    btn = _G[sBtnName..i];
    if (btn) then
      if (n <= num) then
        s = nil;
        if (bo and n == 1) then
          v = 9.9;
          s = format(L.RunTime, DurationStr(bo.RunTime));
          t = icoRun;
        elseif (bo and n == 2) then
          v = bo.CombatTime/bo.RunTime;
          s = format(L.CombatTime, DurationStr(bo.CombatTime));
          t = icoCombat;
        else
          a = cData[n-2];
          if (a) then
            if (not a[30]) then a[30] = 0.00001 end
            if (not a[31]) then a[31] = 0.0 end
            v = a[31]/a[30];
            s = a[2];
            t = a[3];
          end
        end
        if (s) then
          SetIcon(btn.icon, t);
          btn.icon:SetSize(h, h);
          btn.bar:SetStatusBarTexture(format(statusbarH, OG.BarStyle));
          btn.bar:SetStatusBarColor(1.0-v^5, v*1.33, v-v*v);
          btn.bar:SetSize(btn:GetWidth()-h, h);
          btn.bar:SetMinMaxValues(0, 100);
          v = math.abs(v * 100);
          if (v > 100.0) then
            btn.bar:SetStatusBarColor(0, 0, 1);
            btn.bar:SetValue(100);
            btn.bar.text:SetText(s);
          else
            btn.bar:SetValue(v);
            btn.bar.text:SetFormattedText("%.1f%% %s", v, s);
          end
          btn:Show();
        else
          btn:Hide();
        end
      else
        btn:Hide();
      end
    end
  end
end


function SmartAuraWatch_StatListOnScroll(self, arg1)
  if (not self) then self = fStatList.list end
  if (not self:IsVisible()) then return end
  
  local name = "SmartAuraWatchStat_ScrBtnST";
  if (self and not self.BtnList) then
    CreateScrollButtons("SmartAuraWatchStatisticsButtonTemplate", self, name, SmartAuraWatch_StatListBtnOnClick, nil, SmartAuraWatch_StatListBtnOnEnter);
  end
  self.title:SetFormattedText("%s %d", SmartAuraWatchLoc.StatTitle, SmartAuraWatch_ActiveBar);
  local bn = BarName..SmartAuraWatch_ActiveBar;
  OnScrollStatList(self, O[bn].AuraList, name);
  SmartAuraWatch_UpdateAutoReset();
end


function SmartAuraWatch_StatListBtnOnEnter(self, n)
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local a = O[bn].AuraList[n-2];
  if (self and a and a[1]) then
    local v = math.abs(a[31]/a[30]*100);
    local s = format("%s (%s)\n%s\n%.1f%%\n%s", UnitList[a[4]][2], FilterList[a[6]][2], L.InCombatUptime, v, DurationStr(a[31]));
    SmartAuraWatch_AuraInfoTooltip(self, a[1], s);
  end
end


function SmartAuraWatch_StatListBtnOnClick(self, button)
  local bn = BarName..SmartAuraWatch_ActiveBar;
  local os = FauxScrollFrame_GetOffset(self:GetParent()) or 0;
  local n = self:GetID() + os;
  local bo = O[bn];
  if (not bo) then return end  
  if (button == "LeftButton") then
    -- Do nothing yet :)
  else
    if (n <= 2) then
      SmartAuraWatch_ClearStatList();
    else
      local a = bo.AuraList[n-2];
      if (a) then
        a[30] = 0.00001; -- total combat time
        a[31] = 0.0;     -- active combat time
      end
    end
    SmartAuraWatch_StatListOnScroll();
  end
end


function SmartAuraWatch_ProcessStatAutoReset(force)
  local bn;
  for j = 1, BarMax do
    bn = BarName..j;
    if (O[bn] and (force or O[bn].StatAutoReset)) then
      SmartAuraWatch_ClearStatList(bn);
    end
  end
end


-- Report functions ---------------------------------------------------------------------------------------

local function SendMsg(msg, chattype, channel)
  if (chattype == "SELF") then
    print(YLL..msg);
  else
    --print(format("%s, %s, %s", msg, chattype, channel or ""));
    SendChatMessage(msg, chattype, nil, channel);
  end
end

function SmartAuraWatch_Report(nBar, chattype, channel, nLines, bSkip, bLinks)
  if (not O or not nBar or not chattype) then return end
  local bn = BarName..nBar;
  local bo = O[bn];
  if (not bo or not bo.AuraList) then return end
  local max = nLines or 10;
  local id, cid, v, s, n, c;
  if(chattype == "CHANNEL") then
    c = {GetChannelList()};
    for i = 1, #c/2 do
      if (channel == c[i*2]) then
        channel = c[i*2-1];
        break;
      end
    end
  end
  
  -- Title
  SendMsg(AddonTitle.." "..format(L.ReportMsg, nBar), chattype, channel);
  SendMsg(format(L.RunTime, DurationStr(bo.RunTime)), chattype, channel);
  SendMsg(format("%.1f%%  "..L.CombatTime, math.abs(bo.CombatTime/bo.RunTime*100), DurationStr(bo.CombatTime)), chattype, channel);
  
  -- Auras
  n = 1;
  for i, a in pairs(bo.AuraList) do
    if (a and a[2]) then
      v, id, s = math.abs(a[31]/a[30]*100), a[1], nil;
      if (not bSkip or v >= 0.1 ) then
        if (bLinks and id) then
          if (id < 0) then
            c = InvList[-id];
            if (c) then s = GetInventoryItemLink("player", c[1]) end
          else
            s = GetSpellLink(id);
          end
        end
        if (not s) then s = a[2] end
        SendMsg(format("%.1f%%  %s (%s) %s", v, s, DurationStr(a[31]), UnitList[a[4]][3]), chattype, channel);
        n = n + 1;
      end
    end
    if (n > max) then break end
  end
end


function SmartAuraWatch_ReportMenu()
  if (not fMain.ReportMenu) then
    fMain.ReportMenu = CreateFrame("Frame", "SmartAuraWatch_ReportMenu");
  end
  local menu = fMain.ReportMenu;
  menu.displayMode = "MENU";
  
  local info = { };
  menu.initialize = function(self, level)
    if (not O or not level) then return end
    wipe(info);
    if (level == 1) then
      -- Create the title of the menu
      info.isTitle = true;
      info.text = L.ReportTitle;
      info.notCheckable = true;
      UIDropDownMenu_AddButton(info, level);

      wipe(info);
      info.text = L.ReportUseLinks;
      info.isNotRadio = true;
      info.checked = O.ReportUseLinks;
      info.func = function(self) O.ReportUseLinks = not O.ReportUseLinks end
      UIDropDownMenu_AddButton(info, level);
      
      wipe(info);
      info.text = L.ReportSkipZero;
      info.isNotRadio = true;
      info.checked = O.ReportSkipZero;
      info.func = function(self) O.ReportSkipZero = not O.ReportSkipZero end
      UIDropDownMenu_AddButton(info, level);      

      wipe(info);
      info.text = L.Channel;
      info.hasArrow = true;
      info.value = "channels"
      info.notCheckable = true;
      UIDropDownMenu_AddButton(info, level);
      
      wipe(info);
      info.text = L.ReportLines;
      info.hasArrow = true;
      info.value = "lines";
      info.notCheckable = true;
      UIDropDownMenu_AddButton(info, level);
      
      wipe(info);
      info.text = L.ReportSend;
      info.func = function()
        if (not O) then return end
        if (O.ReportChatType == "WHISPER") then
          StaticPopupDialogs["SmartAuraWatchReportDialog"] = {
            text = L.ReportWhisperTo, 
            button1 = ACCEPT, 
            button2 = CANCEL,
            hasEditBox = true,
            timeout = 30, 
            hideOnEscape = true, 
            OnAccept =   function(self)
              local v = self.editBox:GetText();
              if (not v or v == "") then return end
              O.ReportChannel = v;
              SmartAuraWatch_Report(SmartAuraWatch_ActiveBar, O.ReportChatType, O.ReportChannel, O.ReportLines, O.ReportSkipZero, O.ReportUseLinks);
            end,
          }
          StaticPopup_Show("SmartAuraWatchReportDialog");
        else
          SmartAuraWatch_Report(SmartAuraWatch_ActiveBar, O.ReportChatType, O.ReportChannel, O.ReportLines, O.ReportSkipZero, O.ReportUseLinks);
        end
      end
      info.notCheckable = true;      
      UIDropDownMenu_AddButton(info, level);
      
      -- Blank separator
      wipe(info);
      info.disabled = true;
      info.notCheckable = true;
      UIDropDownMenu_AddButton(info, level);
      
      -- Close menu item
      wipe(info);
      info.text = CLOSE;
      info.func = function() CloseDropDownMenus() end
      info.checked = nil;
      info.notCheckable = true;
      UIDropDownMenu_AddButton(info, level);
      
    elseif (level == 2) then
      if (UIDROPDOWNMENU_MENU_VALUE == "channels") then
        for _, v in pairs(ChatTypeList) do
          if (v and v[1] and v[1] ~= "CHANNEL") then
            wipe(info);
            info.text = v[3];
            info.checked = (O.ReportChatType == v[1]);
            info.func = function() O.ReportChatType = v[1]; O.ReportChannel = v[2] end
            UIDropDownMenu_AddButton(info, level);
          end
        end
        
        local c = {GetChannelList()};
        for i = 1, #c/2 do
          info.text = c[i*2];
          info.checked = (O.ReportChannel == c[i*2]);
          info.func = function() O.ReportChatType = "CHANNEL"; O.ReportChannel = c[i*2] end
          UIDropDownMenu_AddButton(info, level);
        end
        
      elseif (UIDROPDOWNMENU_MENU_VALUE == "lines") then
        for i = 1, 25 do
          wipe(info);
          info.text = i;
          info.checked = (O.ReportLines == i);
          info.func = function() O.ReportLines = i end
          UIDropDownMenu_AddButton(info, level);
        end
      end
    end
  end
  
  local x, y = GetCursorPosition(UIParent);
  local sc = UIParent:GetEffectiveScale();
  ToggleDropDownMenu(1, nil, menu, "UIParent", x/sc, y/sc);
end



-----------------------------------------------------------------------------------------------------------------
-- Init ---------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

local function LoadSettings(resetL, resetG)
  if (resetL) then wipe(O) end
  if (resetG) then wipe(OG) end
  if (cPlayed) then wipe(cPlayed) end
  
  if (OG.FirstStart == nil) then OG.FirstStart = AddonVersion end
  if (OG.Orientation == nil) then OG.Orientation = 2 end
  if (OG.Growth == nil) then OG.Growth = 1 end
  if (OG.IconSize == nil) then OG.IconSize = 32 end
  if (OG.Alpha == nil) then OG.Alpha = 1.0 end
  --if (OG.Font == nil) then OG.Font = STANDARD_TEXT_FONT end -- NumberFont_Outline_Med
  if (OG.Font == nil) then OG.Font = STANDARD_TEXT_FONT end
  if (OG.FontSizeOffset == nil) then OG.FontSizeOffset = 0 end
  if (OG.SpacingOffset == nil) then OG.SpacingOffset = 2 end
  if (OG.AuraScan == nil) then OG.AuraScan = true end
  if (OG.AuraScanList == nil) then OG.AuraScanList = { } end
  if (OG.ShowSpark == nil) then OG.ShowSpark = true end
  if (OG.ShowIconBorder == nil) then OG.ShowIconBorder = true end
  if (OG.BF == nil) then OG.BF = { skin = "Blizzard", gloss = false, backdrop = false, colors = {} } end
  if (OG.ColoredTL == nil) then OG.ColoredTL = O.ColoredTL or false end
  if (OG.SecTL == nil) then OG.SecTL = false end
  if (OG.BarStyle == nil) then OG.BarStyle = 2 end
  if (OG.TimerStyle == nil) then OG.TimerStyle = false end
    
  if (O.FirstStart == nil) then O.FirstStart = AddonVersion end
  if (O.Bars == nil) then O.Bars = 1 end
  if (O.RunTimeTotal == nil) then O.RunTimeTotal = 0.00001 end
  if (O.CombatTimeTotal == nil) then O.CombatTimeTotal = 0.0 end
  if (O.ReportUseLinks == nil) then O.ReportUseLinks = true end
  if (O.ReportLines == nil) then O.ReportLines = 20 end
  if (O.ReportChatType == nil) then O.ReportChatType = "SELF" end
  if (O.ReportSkipZero == nil) then O.ReportSkipZero = true end
  if (O.Debug == nil) then O.Debug = false end
  
  -- Init default for bar 1
  local bn = BarName.."1";
  if (O[bn] == nil) then O[bn] = { } end
  if (O[bn].AuraList == nil) then
    ResetAuraList(1);
  end
  
  -- Masque support
  if (isMasque()) then MasqueGroup = Masque:Group(AddonTitle) end
end


local function Init(self)
  -- Set player info
  _, sPlayerClass = UnitClass("player");
  sPlayerName = UnitName("player");
  sRealmName = GetRealmName();
  PlayerGUID = UnitGUID("player");
  sID = sPlayerName.."-"..sRealmName;
  iTalentGroup = 0; --GetActiveSpecGroup();
  --print("ActiveTalentGroup: "..iTalentGroup..", "..sID);
  
  -- Load Masque library
  if (_G["LibStub"]) then Masque = LibStub("Masque", true) end

  local show = false;
  if (SmartAuraWatch_OptionsGlobal == nil) then
    SmartAuraWatch_OptionsGlobal = { };
  end  
  if (SmartAuraWatch_Options == nil) then 
    SmartAuraWatch_Options = { };
    show = true;
  end
  OG = SmartAuraWatch_OptionsGlobal;
  O = SmartAuraWatch_Options;
  
  if (O.FirstStart == nil) then O.FirstStart = "v0" end
  if (O.FirstStart ~= AddonVersion) then
    O.FirstStart = AddonVersion;
    --SmartAuraWatch_ProcessStatAutoReset(true);
  end
  if (OG.FirstStart == nil) then OG.FirstStart = "v0" end
  if (OG.FirstStart ~= AddonVersion) then
    OG.FirstStart = AddonVersion;
    SmartAuraWatchWNF.text:SetText(L.WhatsNew);
    SmartAuraWatchWNF:Show();
    show = true;
  end
  
  LoadSettings();
  CheckAuras();
  SmartAuraWatch_UpdateBars();
  if (show) then
    ToggleOptions(show);
  else
    UpdateBackdrop(0);
  end
  AuraScan(OG.AuraScan);
  
  AddMsg(AddonTitleVersion.." "..L.Loaded);
  AddMsg(L.SetupInfo);
  
  --AddMsg(format("Total run time: %s", DurationStr(O.RunTimeTotal)));
  --AddMsg(format("Total combat time: %s (%.1f%%)", DurationStr(O.CombatTimeTotal), (O.CombatTimeTotal/O.RunTimeTotal*100)));
  --AddMsg(format("Test time: %s", DurationStr(281543))); -- 3d 6h 12m 23s
  
  isInit = true;
end


local function GlobalLoadSave(s, t)
  local bn, o, og;
  t.Bars = s.Bars or 1;
  t.ColoredTL = s.ColoredTL or false;
  for j = 1, BarMax do
    bn = BarName..j;
    og = s[bn];
    if (og) then
      if (t[bn] == nil) then t[bn] = { } end
      o = t[bn];
      for k, v in pairs(og) do
        if (k and v and type(v) ~= "table") then
          o[k] = v;
        end
      end
    end
  end
end

function SmartAuraWatch_GlobalLoad()
  GlobalLoadSave(OG, O);
  SmartAuraWatch_ProcessStatAutoReset(true);
  SmartAuraWatch_UpdateBarCount();
end

function SmartAuraWatch_GlobalSave()
  GlobalLoadSave(O, OG);
end

function SmartAuraWatch_ResetOptionsGlobal()
  LoadSettings(false, true); -- reset local, global settings
  fOG:Hide();
  fOG:Show();
  SmartAuraWatch_UpdateBars();
end

-----------------------------------------------------------------------------------------------------------------
-- Command line menu --------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function SmartAuraWatch_command(msgIn)
  if (not isInit) then return end
  
  local msgs = Split(msgIn, " ");
  local msg = msgs[1];
  
  if (msg == nil or msg == "") then
    ToggleOptions();
  elseif (msg == "t" or msg == "toggle") then
    isEnabled = BToggle(isEnabled, "Enabled = ");
  elseif (msg == "o") then
    local s;
    if (OG.Orientation == 1) then
      OG.Orientation = 0;
      s = L.Vertical
    else
      OG.Orientation = 1;
      s = L.Horizontal
    end
    AddMsg(AddonTitle..": Default Orientation = "..WH..s);
  elseif (msg == "is") then
    OG.IconSize = StrToNum(msgs[2], 40, 20, 80);
    AddMsg(AddonTitle..": Default Icon size = "..WH..OG.IconSize);
  elseif (msg == "g") then
    OG.Growth = StrToNum(msgs[2], 1, 0, 2);
    AddMsg(AddonTitle..": Default Growth = "..WH..OG.Growth);    
  elseif (msg == "a") then
    OG.Alpha = StrToNum(msgs[2], 1.0, 0.0, 1.0);
    AddMsg(AddonTitle..": Default Visibility = "..WH..OG.Alpha);
  elseif (msg == "f") then
    if (msgs[2]) then
      OG.Font = msgs[2];
    end
    SmartAuraWatch_UpdateBars();
    AddMsg(AddonTitle..": Default Font = "..WH..OG.Font);
  elseif (msg == "fso") then
    OG.FontSizeOffset = StrToNum(msgs[2], 0, -20, 20);
    SmartAuraWatch_UpdateBars();
    AddMsg(AddonTitle..": Font Size Offset = "..WH..OG.FontSizeOffset);
  elseif (msg == "frs") then
    OG.Font = STANDARD_TEXT_FONT;
    OG.FontSizeOffset = 0;
    SmartAuraWatch_UpdateBars();
    AddMsg(AddonTitle..": Reset to default Font");
  elseif (msg == "as") then
    OG.AuraScan = BToggle(OG.AuraScan, "Aura scan = ");
    AuraScan(OG.AuraScan);
  elseif (msg == "srs") then
    SmartAuraWatch_ProcessStatAutoReset(true);
    AddMsg(AddonTitle..": All Statistics reset");
  elseif (msg == "debug") then
    O.Debug = BToggle(O.Debug, "Debug = ");
  elseif (msg == "reset") then
    fOptions:Hide();
    LoadSettings(true);
    SmartAuraWatch_UpdateBars();
    ToggleOptions(true);
    AddMsg(AddonTitle..": Set local settings to default");
  elseif (msg == "resetall") then
    fOptions:Hide();
    LoadSettings(true, true);
    SmartAuraWatch_UpdateBars();
    ToggleOptions(true);
    AddMsg(AddonTitle..": Set all settings to default");    
  elseif (msg == "?" or msg == "help") then
    AddMsg(AddonTitleVersion, true);
    AddMsg("Syntax: /saw [command] or /smartaurawatch [command]");
    AddMsg("t           - Toggles temporary SAW on/off");
    AddMsg("o           - Default Orientation");
    AddMsg("is #       - Default Icon size #value (20-80)");
    AddMsg("g #        - Default Growth #value (0-2)");
    AddMsg("v #        - Default Visibility #value (0.0-1.0)");
    AddMsg("f <>       - Default Font <font path>");
    AddMsg("fso #     - Font size offset #value (-20-20)");
    AddMsg("frs         - Reset to default Font");
    AddMsg("srs        - "..L.StatResetAll);
    AddMsg("reset     - "..L.Reset);
    AddMsg("resetall - "..L.ResetAll);
  end
end
-- END SmartAuraWatch_command


-----------------------------------------------------------------------------------------------------------------
-- OnLoad -------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function SmartAuraWatch_OnLoad(self)
  fMain = self;
  self:RegisterEvent("ADDON_LOADED");
  self:RegisterEvent("PLAYER_REGEN_DISABLED");
  SlashCmdList["SmartAuraWatch"] = SmartAuraWatch_command;
  SLASH_SmartAuraWatch1 = "/saw";
  SLASH_SmartAuraWatch2 = "/swatch";
  SLASH_SmartAuraWatch3 = "/smartaurawatch";

  SlashCmdList["SmartReloadUI"] = function(msg) ReloadUI(); end;
  SLASH_SmartReloadUI1 = "/rui";
end


function SmartAuraWatch_OptionsFrameOnLoad(self)
  fOptions = self;
  
  self.texture = self:CreateTexture(nil, "BACKGROUND");
  self.texture:SetTexture(0.0, 0.0, 0.0, 0.7);      
  self.texture:SetPoint("TOPLEFT", self , "TOPLEFT", 1, -1);
  self.texture:SetPoint("TOPRIGHT", self , "TOPRIGHT", -1, -1);
  self.texture:SetPoint("BOTTOMLEFT", self , "BOTTOMLEFT", 1, 1);
  self.texture:SetPoint("BOTTOMRIGHT", self , "BOTTOMRIGHT", -2, 1);        
  self.texture:SetBlendMode("BLEND");
  
  self.text = self:CreateFontString(nil, nil, "GameFontHighlight");
  self.text:SetJustifyH("CENTER");
  self.text:SetJustifyV("TOP");
  self.text:SetPoint("TOP", 0, -4);
  self.text:SetText(AddonTitleVersion);

  self:SetMovable(true);
  self:SetClampedToScreen(true);
  self:SetResizable(false);
  self:RegisterForDrag("LeftButton");
  self:ClearAllPoints();
  self:SetPoint("CENTER", UIParent, "CENTER");
  
  -- Allows SmartAuraWatch to be closed with the Escape key
  tinsert(UISpecialFrames, "SmartAuraWatchOptionsFrame");
  UIPanelWindows["SmartAuraWatchOptionsFrame"] = nil;
end


function SmartAuraWatch_SoundsOnLoad(self)
  fSounds = self;
end

function SmartAuraWatch_AuraScanListOnLoad(self)
  fAuraScanList = self;
end

function SmartAuraWatch_StatListOnLoad(self)
  fStatList = self;
  self:RegisterForDrag("LeftButton");
end

function SmartAuraWatch_OptionsGlobalOnLoad(self)
  fOG = self;
end


function SmartAuraWatch_SliderOnLoad(self, low, high, step)
  _G[self:GetName().."Low"]:SetText("");
  _G[self:GetName().."High"]:SetText("");
  self:SetMinMaxValues(low, high);
  self:SetValueStep(step);
  self:SetStepsPerPage(step);
  
  if (step < 1) then return; end
  
  self.GetValueBase = self.GetValue;
  self.GetValue = function()
    local n = self:GetValueBase();
    if (n) then
      local r = Round(n);
      if (r ~= n) then
        self:SetValue(n);
      end
      return r;
    end
    return low;
  end;
  
end


-----------------------------------------------------------------------------------------------------------------
-- Events -------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

local isLoaded = false;
function SmartAuraWatch_OnEvent(self, event, ...)
  local arg1 = select(1, ...);
  
  --print("Event = "..tostring(event));  
  if(event == "ADDON_LOADED" and arg1 == AddonTitle and not isInit) then
    self:UnregisterEvent("ADDON_LOADED");
    isLoaded = true;
  end
  
  if (event == EventOnUpdate and isLoaded and not isInit) then
    Init(self);
  end
  
  if (not isInit or not isEnabled) then return end
  
  if (event == "PLAYER_REGEN_DISABLED") then
    SmartAuraWatch_ProcessStatAutoReset();
  end
  
  if (not OG.AuraScan) then return end
  
  if (event == "PLAYER_REGEN_ENABLED") then
    ProcessAuraScanList();
  end

--4.1: timestamp, event, hideCaster, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags
--4.2: timestamp, event, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2

  if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
  
    local timestamp, eventType, hideCaster,
    srcGUID, srcName, srcFlags, srcFlags2,
    dstGUID, dstName, dstFlags, dstFlags2,
    spellId, spellName, spellSchool, auraType, amount = CombatLogGetCurrentEventInfo();
  
    if (eventType == "SPELL_AURA_APPLIED" and (srcGUID == PlayerGUID or dstGUID == PlayerGUID)) then
      
      --print(spellId, spellName, spellSchool, auraType, srcName, dstName);
      
      if (spellName and spellId == 0) then
        -- name, rank, icon, castTime, minRange, maxRange, spellId
        name, _, _, _, _, _, spellId = GetSpellInfo(spellName);
        if (spellName ~= name) then return end
      else
        return;
      end
      
      if (spellId and spellId > 0) then
        if (not cAuraScanList[spellId]) then
          cAuraScanList[spellId] = auraType;
          --print(spellName..", "..spellId..", "..auraType);
        end
      end
    end
  end
  
end


local diffA = 0.0;
local diffB = 0.0;
local isTTreeLoaded = false;
function SmartAuraWatch_OnUpdate(self, elapsed)
  if (not isInit) then    
    diffA = diffA + elapsed;
    --print("Update ("..diffA.."sec)");
    if (diffA > 0.5) then
      if (not isTTreeLoaded) then
        local _, tName = GetTalentInfo(1, 1, 1);
        if (tName) then
          --print(string.format("Talent tree ready (%s %.2fsec) -> Init SAW", tName, diffA));
          isTTreeLoaded = true;        
        end
      end
      if (isTTreeLoaded) then
        SmartAuraWatch_OnEvent(self, EventOnUpdate);
      end      
      diffA = 0.0;
    end
  else 
    diffA = diffA + elapsed;
    diffB = diffB + elapsed;
    if (diffA > tUpdate) then
      diffA = 0.0;
      SmartAuraWatch_AuraUpdate();
    end
    if (diffB > tBarUpdate) then
      diffB = 0.0;
      UpdateButtonBars();
    end
  end
end
