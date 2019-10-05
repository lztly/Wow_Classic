-------------------------------------------------------------------------------
-- Korean localization by Nfrog
-------------------------------------------------------------------------------

if (GetLocale() == "koKR") then
local L = SmartAuraWatchLoc;

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
L.ScMH = "주";   -- Main hand
L.ScOH = "보";   -- Off hand
L.ScRG = "원";   -- Ranged
L.ScT1 = "T1";   -- Trinket 1
L.ScT2 = "T2";   -- Trinket 2
L.ScHand  = "H"; -- Hand
L.ScWaist = "W"; -- Waist
L.ScCloak = "C"; -- Cloak

L.FocusTarget = "주시의 대상";
L.MouseOver = "마우스오버";
L.Arena = "투기장 %d";
L.On = "On";
L.Bars = "바: %s";
L.ActiveBar = "%s번 바 설정";
L.BarAlpha = "투명도: %s%%";
L.IconSize = "아이콘 크기: %s";
L.Orientation = "%s";
L.Growth = "%s";
L.Vertical = "수직(아이콘)";
L.Horizontal = "수평(아이콘)";
L.HBar = "수평(바)";
L.VBar = "수직(바)";
L.Center = "중앙";
L.Top = "상단";
L.Bottom = "하단";
L.Right = "오른쪽";
L.Left = "왼쪽";
L.AuraHelp = "클릭: 선택\n오른마우스: 삭제\n드래그 : 순서변경";
L.Unit = "%s";
L.Relship = "%s";
L.DurationMin = "지속 시간이 %s초 보다 작을 때 표시";
L.DurationMax = "지속 시간이 %s초 보다 높을 때 표시";
L.CountMin = "중첩이 %s 보다 작을 때 표시";
L.CountMax = "중첩이 %s 보다 높을 때 표시";
L.TalentTree = "특성: %s";
L.MyAura = "자신의 효과";
L.MyAuraTT = "자신에 의해 시전된 효과만 표시합니다.";
L.OnlyInCombat = "전투중에만";
L.OnlyInCombatTT = "전투중에만 보여줍니다.";
L.NotUp = "비활성화시";
L.NotUpTT = "해당 효과가 비활성화 중이더라도 아이콘을 표시합니다.";
L.Filter = "필터: %s";
L.Helpful = "버프";
L.Harmful = "디버프";
L.Cancelable = "해제 가능";
L.NotCancelable = "해제 불가";
L.Enchant = "마법부여";
L.Cooldown = "쿨다운";
L.Sound = "알림 소리: %s";
L.SoundsTitle = "알림 소리";
L.SoundsHelp = "클릭: 선택\n오른 클릭: 미리듣기";
L.GlobalLoad = "글로벌 프로필 불러오기";
L.GlobalLoadTT = "글로벌 프로필의 설정 불러오기";
L.GlobalSave = "글로벌 프로필 저장";
L.GlobalSaveTT = "글로벌 프로필로 현재 설정 저장";
L.ShowCd = "쿨다운";
L.ShowCdTT = "오라의 쿨다운 보기";
L.AuraScanTT = "전투 중 오라를 선택가능한 목록으로 수집";
L.AuraScanTitle = "오라 스캔";
L.AuraScanHelp = "좌클릭: 오라 적용\n우클릭: 삭제";
L.Stat = "통계";
L.StatTitle = "통계";
L.StatHelp = "우클릭: 초기화";
L.StatBar = "통계바 %d";
L.StatResetAll = "모든 통계 초기화";
L.ColoredTL = "시간 색상";
L.ColoredTLTT = "남은 시간에 따른 색상 표시";
L.SecTL = "초단위표시";
L.SecTLTT = "정수 단위 초";
L.InCombatUptime = "전투 시간중:";
L.RunTime = "실행 시간: %s";
L.CombatTime = "전투 시간 (%s)";
L.AutoReset = "자동 초기화";
L.AutoResetTT = "전투가 시작되기 전 바 통계를 자동으로 초기화 합니다";
L.Tooltips = "툴팁";
L.TooltipsTT = "이 바의 오라 툴팁 활성화";
L.ReportLines = "보고 갯수";
L.ReportTitle = "보고";
L.ReportMsg = "보고 바 %d";
L.ReportWhisperTo = "귓속말 대상:";
L.ReportUseLinks = "링크 사용";
L.ReportSkipZero = "0% 스킵";
L.Loaded = "loaded";
L.SetupInfo = "설정창을 보려면 /saw";
L.Reset = "캐릭별 설정을 기본값으로 되돌림";
L.ResetAll = "모든 설정을 기본값으로 되돌림";

L.OptionsGlobalTitle = "전체 옵션";
L.BarStyle = "바 스타일: %s";
L.FontSizeOffset = "글꼴 크기 오프셋: %s";
L.SpacingOffset = "버튼 간격: %s";
L.ShowIconBorder = "아이콘 테두리 표시";
L.ShowIconBorderTT = "아이콘에 기본테두리를 사용합니다.";
L.ShowSpark = "표시막대에 반짝임 표시";
L.ShowSparkTT = "활성화된 상태바에 반짝임 표시";

-- FOR TESTING ONLY --------------------
--[[
L.Player = "Player";
L.Target = "Target";
L.Focus = "Focus";
L.FocusTarget = "Target of Focus";
L.All = "All";
L.Friendly = "Friendly";
L.Enemy = "Enemy";
L.Primary = "1 특성";
L.Secondary = "2 특성";
L.AuraTitle = "Auras";
L.Clear = "Delete";
L.Default = "Default";
L.None = "None";
L.Off = "Off";
L.SoundNone = "- None -";
]]--
----------------------------------------

end
