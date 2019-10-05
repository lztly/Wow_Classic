RAID_CLASS_COLORS["SHAMAN"].colorStr = "ff006fdc";
RAID_CLASS_COLORS["SHAMAN"].b = 0.866667;
RAID_CLASS_COLORS["SHAMAN"].g = 0.439247;
RAID_CLASS_COLORS["SHAMAN"].r = 0;
--[[
	上官晓雾
	2019年8月28日10点06分
	classic 1.0
]]--
local _G = getfenv(0)
local format = string.format
local strfind = string.find
local gsub = string.gsub
local _, i
--~ LoadAddOn("Blizzard_InspectUI")
local PRIMARY_TALENT = SPECIALIZATION.." : "
local SECONDARY_TALENT = TALENT.." : "
local lastlinenum

local print = function(...)
	if (zTip.god==1) then
		_G.print(...)
	end
end

local iLibRangeCheck;
if(LibStub and LibStub.libs["LibRangeCheck-2.0"]) then 
	iLibRangeCheck=LibStub("LibRangeCheck-2.0");
end

zTip = CreateFrame("Frame", nil, GameTooltip)
-----------------默认设置修改处:
			------生命、魔法条材质
local GameBarTexture1 = "Interface\\RAIDFRAME\\Raid-Bar-Hp-Fill.blp"
local GameBarTexture2 = "Interface\\TargetingFrame\\UI-TargetingFrame-BarFill"
function zTip:GetDefault()
	return {
		-- 以下为参数设置
		-- 提示: 取值只有两种 -- 1. 数字 2. true / false
		-- true 表示开启, false表示关闭

		Anchor = false,			-- Default: 0
			-- [false 使用系统默认位置(屏幕右下角)]
			-- [0为人物信息跟随鼠标，非人物（按钮之类）使用默认位置（屏幕右下角）]
			-- [1为屏幕上方，注意用OffsetX和OffsetY调整相对位置，非人物为默认位置（屏幕右下角）]
			-- [2为跟随鼠标，向上延展，非人物为默认位置]
			-- [3为全部跟随鼠标，非人物(按钮之类)为对象右上]
			-- [4为屏幕上方，注意用OffsetX和OffsetY调整相对位置，非人物为对象右上]
			-- [5为全部跟随鼠标，并向上延展，要正上方，将Offset调为0,0即可]

		OffsetX = 30, OffsetY = 30,		--位置偏移值（系统位置无效） Default: 30,30
		OrigPosX = 70, OrigPosY = 120,	--系统默认位置的偏移值（原版X=100, Y=160），要使用游戏默认设置为: false, false
		Scale = 1.0,					--提示缩放 Default: 1.1 取值：0~N.x		Game's Default: 1.0
		Fade = false,					--是否渐隐 Default: false       游戏默认设置为: true
		DisplayPvPRank = true,			--显示军衔[false 不显示 | true 显示] Default: false
		ShowIsPlayer = false,			--是否在等级行显示“（玩家）”字样	Default: false
		DisplayFaction = true,			--是否显示NPC声望等级。
		PlayerServer = true,			--是否显示玩家所属服务器. Default: true
		TargetOfMouse = true,			--显示对象的目标. Default: true
		TTargetOfMouse = false,			--显示对象的目标的目标
		ClassIcon = true,				--显示对象玩家/小宠物的职业/天赋图标。Default: true
		TalentIcon = false,				--显示天赋图标
		CombatHide = false,				--战斗中隐藏
		VividMask = true,				--立体化鼠标提示. Default: true
		ShowTalent = false,				--是否显示玩家天赋
		TargetedBy = false,				--是否显示关注目标
		ManaBAR = false,				--显示法力条
		HealthBAR = true,				--显示法力条
		NPCClass = true,				--显示NPC职业
		ItemLevel = false,				--显示物品等级
		ShowFaction = false,			--显示阵营字样(默认隐藏)
		ShowBarNum = false,				--显示生命法力条数字
		BarTexture = true,				--切换生命条材质
		GuildInfo = false,
		MiniNum = true,
		ShowLegend = true,		--显示7.0+橙装个数
		ShowRc = false,			--显示距离，如果有LibRangeCheck
	}
end

local function RGB(r, g, b)
	return string.format("%02x%02x%02x", r*255, g*255, b*255);	
end
local function GetRangeColorText(minRange, maxRange)
	local color, text;
	if (minRange) then
		if (minRange > 100) then
			maxRange = nil;
		end		
		
		if (maxRange) then
			local tmpText = format("%d-%d", minRange, maxRange);		
	
			if ( maxRange <= 5) then
				color = RGB(0.9, 0.9, 0.9);
			elseif (maxRange <= 20) then
				color = RGB(0.055, 0.875, 0.825);
			elseif (maxRange <= 30) then
				color = RGB(0.035, 0.865, 0.0);
			elseif (minRange >= 40) then
				color = RGB(0.9, 0.055, 0.075);
			else
				color = RGB(1.0, 0.82, 0);
			end
			
			text = format(" |cff%s%s|r",color, tmpText);
		end
	end
	
	return text;
end
-------------------------------------------------------
-- Inspect protection codes for 6.0/WOD

-- 上官晓雾    2014-10
-- 来源 : Cloudy Unit Info
-------------------------------------------------------
--[[
	Cloudy Unit Info
	Copyright (c) 2013, Cloudyfa
]]
	--- Variables ---

local ScanUnit
local inspectDB = {GearDB = {}, SpecDB = {}, NeedUpdate={},GearDBErr={}}
local artlist = {}
local currentID, currentGUID


	
--- NotifyInspect对应返回事件INSPECT_READY，但是INSPECT_READY的返回频率被服务器限制了频率
--- "观察"无法打开界面，就是因为鼠标停留在了某个目标身上，导致双方调用的NotifyInspect都被延后，并且插件因为提高了频率，就挤掉/延后了"观察"操作

--- INSPECT_READY会返回一个guid,表示当前可以使用部分api获取该guid的装备天赋信息
--- 问题1:	目前我所用的获取装备的api使用的并不是guid，而是unit，这样，目标必须处于:mouseover,target,targettarget,party之类的unit中，才能被观察(我只选择了mouseover),
---			不知道是否能直接根据guid来获取信息（如果可以，就能实现鼠标滑过目标，后台自动获取信息，而不是现在的，鼠标必须停留在目标身上）

---观察天赋/装等的流程：
---SetUnitInfo:			打印观察结果
---GetGearAndSpecID:	根据INSPECT_READY返回的目标信息，获取Gear&SpecID
---ScanUnit:			观察目标,判断目标如果正处于INSPECT_READY，直接调用GetGearAndSpecID,否则调用NotifyInspect

do

	local GameTooltipFrame = CreateFrame ("GameTooltip", "zTipGameTooltipFrame", nil, "GameTooltipTemplate")

	
	local itemLevelPattern = _G.ITEM_LEVEL:gsub("%%d", "(%%d+)")
	function RewardRealItemLevelByLink(itemLink)
		if(itemLink)then
			GameTooltipFrame:SetOwner (WorldFrame, "ANCHOR_NONE")
			GameTooltipFrame:ClearLines()
			GameTooltipFrame:SetHyperlink(itemLink)
			local itemlevel = nil
			for i = 2, 6 do
				local label, text = _G["zTipGameTooltipFrameTextLeft"..i], nil
				if label then text=label:GetText() end
				if text then
					if itemlevel==nil then itemlevel = tonumber(text:match(itemLevelPattern)) end
				end
			end
			
			return itemlevel or 1
		end
	end
	function RewardRealItemLinkByInsID(unit,index)
		GameTooltipFrame:SetOwner (WorldFrame, "ANCHOR_NONE")
		GameTooltipFrame:ClearLines()
		GameTooltipFrame:SetInventoryItem(unit,index)
		return  select(2,GameTooltipFrame:GetItem())
	end
	function RewardRealItemLevelByInsID(unit,index)
		GameTooltipFrame:SetOwner (WorldFrame, "ANCHOR_NONE")
		GameTooltipFrame:ClearLines()
		if (GameTooltipFrame:SetInventoryItem(unit,index)) then
			local itemlevel = nil
			for i = 2, 6 do
				local label, text = _G["zTipGameTooltipFrameTextLeft"..i], nil
				if label then text=label:GetText() end
				if text then
					if itemlevel==nil then itemlevel = tonumber(text:match(itemLevelPattern)) end
				end
			end
			return itemlevel or 1,select(2,GameTooltipFrame:GetItem())
		end
	end
	local artitemLeveladd = "+(%d+)".._G.ITEM_LEVEL:gsub("%%d", "")
	function RewardRealArtItemLevelAdd(itemLink)
		if(itemLink)then
			GameTooltipFrame:SetOwner (WorldFrame, "ANCHOR_NONE")
			GameTooltipFrame:ClearLines()
			GameTooltipFrame:SetHyperlink(itemLink)
			local itemlevel = nil
			for i = 2, 6 do
				local label, text = _G["zTipGameTooltipFrameTextLeft"..i], nil
				if label then text=label:GetText() end
				if text then
					if itemlevel==nil then itemlevel = tonumber(text:match(artitemLeveladd)) end
				end
			end
			
			return itemlevel or 0
		end
	end

	local UnitGearNoCheck=nil;
	local UnitSpecIDNoCheck=nil;
	local outline = CONTINUED;
	
	local HMode = false;		--特殊模式，一定程度上监控队员装备变动
	local HModeIndex = 0
	zTip_HookInsState = CreateFrame('Frame', 'zTip_HookInsState')
	-- zTip_HookInsState:RegisterEvent('UNIT_INVENTORY_CHANGED')
	-- zTip_HookInsState:RegisterEvent('INSPECT_READY')
	zTip_HookInsState:SetScript('OnEvent', function(self, event, ...)
		if (event == 'UNIT_INVENTORY_CHANGED') then
			-- if (not HMode) then return end
			local unit = ...
			local guid = UnitGUID(unit);
			local specbool = false;
			if ( guid==UnitGUID("player") ) then
				inspectDB.NeedUpdate[guid]  = false;
				specbool = true;
			else
				inspectDB.NeedUpdate[guid]  = true;
			end
			local spec,gear;
			spec = UnitSpecIDNoCheck((unit))
			if ( spec~=0 ) then
				inspectDB.SpecDB[guid] = spec
				specbool = true;
			end
			if (specbool) then
				gear = UnitGearNoCheck((unit))
				if ( gear~=0 ) then
					inspectDB.GearDB[guid] = gear
				end
			end
			HModeIndex = HModeIndex + 1;
			-- if (HModeIndex % 10 == 0) then
				-- _G.print("HModeIndex=",HModeIndex);
			-- end
			-- if (spec) then
				-- local _, specName, _, icon = GetSpecializationInfoByID(tonumber(spec))
				-- _G.print(UnitName(unit),unit,guid,spec,specName)
			-- else
				-- _G.print(UnitName(unit),unit,guid,spec,spec)
			-- end
			-- _G.print(unit,gear,spec)
		elseif (event == 'INSPECT_READY') then
			local guid = ...
			lastInsTarget = guid
			-- _G.print(GetTime(),"变动：",lastInsTarget)
			ScanMouseOverGearAndSpecID(nil,guid);
		end
	end) 
	
	--- Create Frame ---
	CUIInspect = CreateFrame('Frame', 'CloudyUnitInfo')
	CUIInspect:RegisterEvent('UNIT_INVENTORY_CHANGED')
	CUIInspect:RegisterEvent('INSPECT_READY')

	local function CheckDB(guid)
		local gear = inspectDB.GearDB[guid]  
		local spec = inspectDB.SpecDB[guid] 
		local flag = false
		if (gear and spec) then
			flag = true
		end
		return flag,gear or outline,spec or CONTINUED
	end
	
	--- Set Unit Info ---
	local function SetUnitInfo()
		local _, unit = GameTooltip:GetUnit()
		if (not unit) then return end
		local guid = UnitGUID(unit)
		if (guid ~= currentGUID) then return end
		if (not guid) then return end
		local flag, gear, spec = CheckDB(guid);
		if (not gear) and (not spec) then return end

		local gearLine, specLine
		for i = 2, GameTooltip:NumLines() do
			local line = _G['GameTooltipTextLeft' .. i]
			local text = line:GetText()

			if text and strfind(text, zTip.locStr.ItemLevel) then
				gearLine = line
			elseif text and strfind(text, PRIMARY_TALENT) then
				specLine = line
			end
		end
		if gear and zTipSaves.ItemLevel then
			gear = "|cffffff00"..zTip.locStr.ItemLevel.." : |r"..gear..(inspectDB.NeedUpdate[guid] and "*" or "")
			if gearLine then
				gearLine:SetText(gear)
			else
				if lastlinenum < GameTooltip:NumLines() then
					lastlinenum = lastlinenum + 1
					_G["GameTooltipTextLeft"..lastlinenum]:SetText(gear)
				else
					GameTooltip:AddLine(gear)
					lastlinenum = GameTooltip:NumLines()
				end
			end
		end

		if false and spec and zTipSaves.ShowTalent then
			if tonumber(spec) then	--spec已读取到
				if tonumber(spec)==0 then		--无专精
					spec = "|cffffff00"..PRIMARY_TALENT.."|r".."|cff00ff00["..NONE.."]|r"
				else							--有专精
					local _, specName, _, icon = GetSpecializationInfoByID(tonumber(spec))
					if zTipSaves.TalentIcon and icon then 			--是否使用icon
						icon = "|T"..icon..":12:12:0:0:10:10:0:10:0:10|t "
					else
						icon = ""
					end
					spec = "|cffffff00"..PRIMARY_TALENT.."|r"..icon.."|cff00ff00["..specName.."]|r"
				end
			else					--spec未读取到
				spec = "|cffffff00"..PRIMARY_TALENT.."|r".."|cff00ff00"..spec.."|r"
			end

			if specLine then
				specLine:SetText(spec)
			else
				if lastlinenum < GameTooltip:NumLines() then
					lastlinenum = lastlinenum + 1
					_G["GameTooltipTextLeft"..lastlinenum]:SetText(spec)
				else
					GameTooltip:AddLine(spec)
					lastlinenum = GameTooltip:NumLines()
				end
			end
		end
		GameTooltip:Show()
	end
	
	--- Unit Gear Info ---
	---返回值ilvl,flag
	---ilvl平均装等
	---flag=nil,表示需要稍后再次调用UnitGear,获取正确的ilvl,如果ilvl=0
	---flag=true,表示需要再次INSPECT_READY
	function UnitGearNoCheck(id)
		-- if (id == 'player') then
			-- _, ilvl = GetAverageItemLevel()
			-- if (ilvl > 0) then ilvl = string.format('%.1f', ilvl) end
			-- return ilvl;
		-- end
		
		local Visible = UnitIsVisible(id)
		local ulvl = UnitLevel(id)
		local class = select(2, UnitClass(id))

		local ilvl = 0
		local total, count, delay, hascount= 0, 16, nil, 0
		local Artlevel = 0;
		local twohandlevel;
		for i = 1, 17 do
			if( delay) then 
				break 
			end
			if (i ~= 4) then
				local itemTexture = GetInventoryItemTexture(id, i)
				-- print(itemTexture,i,id)
				if itemTexture then
					hascount = hascount + 1;
					local itemLink = GetInventoryItemLink(id, i)
					local level,quality,level,slot,texture;
					local islink = false;
					if (false and itemLink) then
						islink = true;
						_, _, quality, level, _, _, _, _, slot, texture = GetItemInfo(itemLink)
						level = RewardRealItemLevelByLink(itemLink)  
					else
						islink = false;
						level,itemLink = RewardRealItemLevelByInsID(id,i)
						quality = GetInventoryItemQuality(id,i)
					end
					-- print(i,itemLink,level,islink,Visible)
					if (not level) then
						-- print(i,"not level",itemLink)
						delay = true
					else
						if(quality==6 and level>=750) then
							if not Visible and (texture) and not artlist[texture] then	--进入游戏第一次,遇到了没缓存过的神器,直接再来一次ins
								delay = true
								artlist[texture] = true
							end
							if(not Artlevel or Artlevel==0)then
								Artlevel = level - 750;
							end
							--[[
							if(itemLink) then
								local _, _, _, jewelId1, jewelId2, jewelId3, jewelId4 = strsplit(":",itemLink)
								 jewels = {
									tonumber(jewelId1) or false,
									tonumber(jewelId2) or false,
									tonumber(jewelId3) or false
								}
								
								-- local ssss="";
								-- local index = 0;
								-- for qwe in (itemLink..":"):gmatch("(.-)"..":") do
									-- index = index + 1;
									-- if(tonumber(qwe)) then
									-- ssss = ssss.."["..index..":"..qwe.."]";
									-- end
								-- end
								-- print("物品链接:",ssss)
								-- local outstr = ""
								-- for ari = 1,3 do
									-- local _,arlink = GetItemGem(itemLink,ari);
									-- if (arlink) then
										-- local arlevel = C_ArtifactUI.GetItemLevelIncreaseProvidedByRelic(arlink)
										-- Artlevel = Artlevel + arlevel;
										-- outstr = outstr.."{"..ari..":"..arlevel.."}"
									-- else
										-- if(jewels[ari]) then	--若没有读取到圣物,再来一次ins
											-- print("圣物遗漏了")
											-- delay = true;
										-- end
									-- end
								-- end
								-- print(outstr)
							else
								-- if(not Artlevel or Artlevel==0)then
									-- Artlevel = level - 750;
								-- end
								print(id,i,"error")
							end
							--]]
							print(Artlevel,delay,"啧啧",itemLink or "无链接")
							level = 750
						end
						
						if(itemLink)then
							print(itemLink,level)
						end
						
						if (not quality) or (not level) then
							print(i,"not quality not level")
							delay = true
						else
							total = total + level
						end
						if not slot or (slot == 'INVTYPE_2HWEAPON') or (slot == 'INVTYPE_RANGED') or (slot == 'INVTYPE_RANGEDRIGHT') then
							if (i==16) then
								twohandlevel = level
							elseif(i==17) then
								twohandlevel = 0
							end
						end
					end
				end
			end
		end
		if (not delay) then
				--Artlevel标记,神器,加上神器额外等级(level-750)*2
			if (Artlevel) then
				total =  total + Artlevel * 2
			end
				--双手武器标记,若副手为空,加twohandlevel(双手武器下副手如果拿其他道具,数据会错---狂暴战)
			if (twohandlevel) then
				total = total + twohandlevel
			end
			ilvl = total / 16

			if (ilvl > 0) then ilvl = string.format('%.1f', ilvl) end
		else
			print("next",GetTime(),ilvl)
			-- _G.print("next ilvl = ", ilvl, GetTime(),Visible,ulvl,class,hascount)
			ilvl = nil
			return ilvl
		end
		if(ilvl == 0 and hascount == 0) then
			-- _G.print("ilvl & hascount = 0",Visible,ulvl,class,hascount)
			return 0
		elseif (ilvl == 0) then
			-- _G.print("next ilvl == 0",GetTime(),Visible,ulvl,class,hascount)
			return nil,true
		end
		return ilvl
	end

	local function UnitGear(id)
		if (not id) or (UnitGUID(id) ~= lastInsTarget) then return end
		return	UnitGearNoCheck(id);
	end
	--- 读取天赋ID ---
	local function IsInspectFrameOpen() return (InspectFrame and InspectFrame:IsShown()) or (Examiner and Examiner:IsShown()); end
	
	function UnitSpecIDNoCheck(id)
		return nil
		-- local specID
		-- if (id == 'player') then
			-- local specIndex = GetSpecialization()
			-- specID = specIndex and GetSpecializationInfo(specIndex) or 0
		-- else
			-- specID = GetInspectSpecialization(id)
		-- end
		-- return specID
	end
	local function UnitSpecID(id)
		return nil
		-- if (not id) or (UnitGUID(id) ~= lastInsTarget) then return end
		-- return	UnitSpecIDNoCheck(id);
	end
	
	local logindex = 0;
	function ScanMouseOverGearAndSpecID(unit, guid)
		if( unit == nil) then
			if( UnitGUID("player") == guid )then
				unit = "player";
			elseif( UnitGUID("mouseover") == guid) then
				unit = "mouseover";
			elseif( UnitGUID("target") == guid) then
				unit = "target";
			else
				for i=1,5 do
					if( UnitGUID("party"..i) == guid) then
						unit = "party"..i;
					end
				end
				for i=1,40 do
					if( UnitGUID("raid"..i) == guid) then
						unit = "raid"..i;
					end
				end
			end
		else
			guid = UnitGUID(unit);
		end
		if ( unit~=nil and guid~=nil ) then
			local cachedGear, cachedSpec	
			cachedGear = inspectDB.GearDB[guid]
			cachedSpec = inspectDB.SpecDB[guid]
			
			local CheckDBflag, gear, spec = CheckDB(guid);
			
			local flag = false;
			if (inspectDB.NeedUpdate[guid]) then
				inspectDB.NeedUpdate[guid] = nil;
				flag = true;
			end
			if (gear==0) then
				flag = true;
			end
			if(zTip.unit and IsShiftKeyDown() and UnitGUID(zTip.unit)==guid)then
				flag = true;
			end
			if (not CheckDBflag) then
				flag = true;
			end
			-- if(not IsShiftKeyDown() and CheckDBflag) then return end
			if ( not flag ) then return end
			
			logindex = logindex + 1;
			-- _G.print(logindex);
			-- _G.print(GetTime(),"执行观察",guid,CheckDBflag)
			local gear,flag = UnitGear(unit)
			inspectDB.GearDB[guid] = gear
			if (gear==0) then
				if(inspectDB.GearDBErr[guid]) then
					inspectDB.GearDBErr[guid] = inspectDB.GearDBErr[guid] + 1
				else 
					inspectDB.GearDBErr[guid] = 0
				end
			end
			
			local spec = UnitSpecID(unit)
			inspectDB.SpecDB[guid] = spec

			-- if (gear==0) then
				-- _G.print("gear=",gear,",spec=",spec,",unit=",unit,",UnitGUID(unit)=" , UnitGUID(unit),",guid=",guid)
			-- end
			-- if (gear and spec) then
			if (gear) then
				CUIInspect:Hide()
				-- _G.print("查询完成:",gear,spec)
			end
			-- if (not gear) or (not spec) then
				-- ScanUnit("mouseover")
				
			-- else
				SetUnitInfo()
			-- end
		end
	end
	
	--- Scan Current Unit ---
	function ScanUnit(id, forced)
		local cachedGear, cachedSpec
		
		if false and UnitIsUnit(id, 'player') then
			SetUnitInfo(cachedGear or outline, cachedSpec or outline)
		else
			local guid = UnitGUID(id)
			print(id,UnitGUID(id),guid,"开始观察ScanUnit")
			if (not id) or (guid ~= currentGUID) then return end
			
			
			-- if cachedGear or forced then
			-- 显示信息
			SetUnitInfo()
			-- end

			-- 某些情况下考虑重新观察
			if not (IsShiftKeyDown() or forced) then
				cachedGear = inspectDB.GearDB[guid]
				cachedSpec = inspectDB.SpecDB[guid]
				local gerr = inspectDB.GearDBErr[guid]
				-- if cachedGear and cachedSpec then 
				if cachedGear then 
					if ( cachedGear == 0 and gerr<5) then
						-- 0错误次数少于5，重新观察
					else
						return
					end
				end
 				if UnitAffectingCombat('player') then return end
			end
			
 			if (not UnitIsVisible(id) and not id:find("party")) then return end
			if UnitIsDeadOrGhost('player') or UnitOnTaxi('player') then return end
			if InspectFrame and InspectFrame:IsShown() then return end
			
			print(id,UnitGUID(id),guid,"开始ins", forced,GetTime())
			
			if( UnitGUID("target") ~= currentGUID ) then
				CUIInspect.firstUpdate = GetTime() + 0.5	--如果观察的目标不是当前目标，延迟0.5秒
			else
				CUIInspect.firstUpdate = GetTime();
			end
			CUIInspect.ShowTime = GetTime();
			CUIInspect:Show() 
		end
	end
	
	
	
	  
	local oldlastINVENTORY_CHANGED = 0;
	--- Handle Events ---
	CUIInspect:SetScript('OnEvent', function(self, event, ...)
		if (event == 'UNIT_INVENTORY_CHANGED') then
			local id = ...
			if (oldlastINVENTORY_CHANGED == GetTime()) then	--切换地图会多次触发该事件，屏蔽
				return;
			else
				oldlastINVENTORY_CHANGED = GetTime();
			end
			-- if (UnitGUID(id) == currentGUID) then
				-- ScanUnit(id, true)
			-- end
			-- _G.print("UnitGUID(id)",id)
		elseif (event == 'INSPECT_READY') then
			-- self:UnregisterEvent("INSPECT_READY");
			-- print("隐藏CUIInspect")
			-- CUIInspect:Hide()
		end
	end)
	
	CUIInspect:SetScript('OnUpdate', function(self, elapsed)
		outline = "等待.."
		if (GetTime() - self.ShowTime > 5 ) then
			CUIInspect:Hide()
		end
		if not zTip.unit then		--没有鼠标目标后，不做操作了
			CUIInspect:Hide()
		end
		if currentID and (UnitGUID(currentID) == currentGUID) then 
			if(CUIInspect.firstUpdate and GetTime() < CUIInspect.firstUpdate) then
				return
			else
				CUIInspect.firstUpdate = GetTime() + 1.5
				-- _G.print(GetTime(),"开始观察NotifyInspect",currentGUID)
				NotifyInspect(currentID,"flag") 
			end  
		end
	end)
	CUIInspect:Hide()
end
--------------------
--------------------
--------------------

-- hooksecurefunc("NotifyInspect",_G.print)

zTipSaves = zTip:GetDefault()

-- 公会名和姓名的明暗度调整 Default: 0.86 暗一点（不可超过1！）
zTip.GuildColorAlpha = 0.86
local pet_r=1
local pet_b=0
local pet_g=1

-- localized strings
zTip.locStr = {}

-- record player's factions standingId
zTip.factions = {}
---:一些函数:---
-- 颜色转换
function zTip:GetHexColor(color)
	if not color then
		return "FFFFFF"
	-- elseif not color.colorStr then
	else
		return format("%2x%2x%2x",color.r*255,color.g*255,color.b*255)
		-- return color.colorStr
	end
end

	--Hook：GameTooltip渐隐
hooksecurefunc(GameTooltip, "FadeOut", function(self)
	if (not zTipSaves.Fade) then
		GameTooltip:Hide();
	end
end)

--[[	返回职业图标	]]
function zTip:GetClassIconForText(class,size)
	if not class then return end
	local  classiconCoord = CLASS_ICON_TCOORDS[class]
	if classiconCoord then
		local a1,a2,a3,a4 = classiconCoord[1]*100,classiconCoord[2]*100,classiconCoord[3]*100,classiconCoord[4]*100
		local ed
		if size and tonumber(size) < 0 then
			ed = a2..":"..a1..":"..a3..":"..a4.."|t "
		else
			ed = a1..":"..a2..":"..a3..":"..a4.."|t "
		end
		return "|TInterface\\WorldStateFrame\\Icons-Classes:"..(size or 12)..":"..(size or 12)..":0:0:100:100:"..ed
	end
end
-- 级别上色
local lDiff,lRange, r, g, b
function zTip:GetDifficultyColor(level)
	lDiff = level - UnitLevel("player");
	lRange = GetQuestGreenRange()
	if (lDiff >= 0) then
		r = 1.00; b = 0.00;
		if lDiff < 10 then
			g = 1 - (lDiff*0.10)
		else
			g = 0.00
		end
	elseif ( -lDiff < lRange) then
		g = 1.00; b = 0.00;
		r = 1 - (-1.0*lDiff)/lRange
	elseif ( -lDiff == lRange ) then
		r = 0.50; g = 1.00; b = 0.50;
	else
		r = 0.75; g = 0.75; b = 0.75;
	end
	return format("%2x%2x%2x",r*255,g*255,b*255);
end

---:遮罩:---
function zTip:GetVividMask()
	local mask = _G["GameTooltipMask"]
	if mask then return mask end

	mask = GameTooltip:CreateTexture("GameTooltipMask")
	mask:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
	mask:SetPoint("TOPLEFT", GameTooltip, "TOPLEFT", 4, -4)
	mask:SetPoint("BOTTOMRIGHT", GameTooltip, "TOPRIGHT", -4, -30)
	mask:SetBlendMode("ADD")
	mask:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 1, 1, 1, 0.66)
	mask:Hide()

	return mask
end

local updateTooltip = 2
----
	--Events
----
function zTip:OnUpdate(elapsed)
	-- offset to mouse
	if self.AnchorType then
		x,y = GetCursorPosition()
		uiscale = UIParent:GetScale()
		tipscale = GameTooltip:GetScale()
		x = (x + zTipSaves.OffsetX) / tipscale / uiscale
		GameTooltip:ClearAllPoints()
		if zTip.AnchorType == 2 then
			y = (y + zTipSaves.OffsetY) / tipscale / uiscale
			GameTooltip:SetPoint("BOTTOM", UIParent, "BOTTOMLEFT", x, y)
		else
			y = (y - zTipSaves.OffsetY) / tipscale / uiscale
			GameTooltip:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT", x, y)
		end
	end

	if UnitExists("mouseover") then
		-- refresh target of mouseover
		self:RefreshMouseOverTarget(elapsed)
	elseif self.unit and not zTipSaves.Fade and GameTooltip:IsOwned(UIParent) then
		GameTooltip:Hide()
	elseif not GameTooltipTextLeft1:GetText() and not GameTooltipTextRight1:GetText() then
		GameTooltip:Hide()
	end
	-- GameTooltipStatusBar.unit = self.unit
	-- if not self.unit  then GameTooltipStatusBar:Hide() end
	-- print(self.unit)
	-- if ( IsModifiedClick("COMPAREITEMS")  and not GameTooltip:IsEquippedItem() ) then
		-- GameTooltip_ShowCompareItem(GameTooltip);
	-- end
end

function zTip:OnEvent(event, ...)
	if event == "PLAYER_LOGIN" then
		self:Init()
	elseif event == "PLAYER_LEAVING_WORLD" then
			-- _G.print(time()..event)
	elseif event == "PLAYER_ENTERING_WORLD" then
			-- _G.print(time()..event)
		GameTooltip:SetScale(zTipSaves.Scale)
	elseif event == "UPDATE_FACTION" then
		self:UpdatePlayerFaction()
	end
end
zTip:RegisterEvent("PLAYER_LOGIN")
zTip:SetScript("OnEvent",zTip.OnEvent)

--[[Initialize]]--
function zTip:Init()
	--加载一些额外功能
	
		---血量条动态变色（暴雪默认方案）
	-- local t=HealthBar_OnValueChanged
	-- HealthBar_OnValueChanged=function(self,value,smooth)
		-- t(self,value,true)
	-- end
		---修改系统函数，用途：改为美式/中式(简中)
	if zTipSaves.MiniNum then
		local ttAbbreviateLargeNumbers=AbbreviateLargeNumbers
		function AbbreviateLargeNumbers(...)
			local value = ...
				local strLen = strlen(value);
				local retString = value;
				if ( strLen > 8 ) then
					retString = string.sub(value, 1, -7).."M";
				elseif ( strLen > 5 ) then
					retString = string.sub(value, 1, -4).."K";
				elseif (strLen > 3 ) then
					retString = BreakUpLargeNumbers(value);
				end
				return retString;
		end
	end


	self:RegisterEvent("UPDATE_FACTION")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_LEAVING_WORLD")
	self:SetScript("OnUpdate", self.OnUpdate)

	-- mask
		if zTipSaves.VividMask then
			zTip:GetVividMask():Show()
		end
		
	-- 加载蓝条
		-- :一个manabar的标准套路↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
		if (zTipSaves.ManaBAR) then
			GameTooltip.manabar = CreateFrame("StatusBar","GameTooltipManaBar",GameTooltip)
			GameTooltipManaBar:SetPoint("TOPLEFT",GameTooltipStatusBar,"BOTTOMLEFT",0,-5)
			GameTooltipManaBar:SetPoint("TOPRIGHT",GameTooltipStatusBar,"BOTTOMRIGHT",0,-5)
			GameTooltipManaBar:SetHeight(GameTooltipStatusBar:GetHeight())
			TextStatusBar_Initialize(GameTooltip.manabar)
			local textString=GameTooltipManaBar:CreateFontString(nil,"OVERLAY","GameFontHighlightSmallOutline")
			textString:SetPoint("CENTER")
			textString:SetTextHeight(14)
			textString:SetTextColor(1,1,1)
			GameTooltipManaBar.textLockable = 1;
			GameTooltipManaBar.disconnected=true
			GameTooltipManaBar:GetParent().noTextPrefix = true
			SetTextStatusBarText(GameTooltipManaBar,textString)
			UnitFrameManaBar_Initialize(nil,GameTooltipManaBar,textString,true)
			GameTooltipManaBar:Hide()
			GameTooltipManaBar:HookScript("OnUpdate",function(self)
				if not self.unit then
					GameTooltipManaBar:Hide()
					GameTooltipManaBar.pauseUpdates = true
				end
			end)


			if zTipSaves.ManaBAR then
				GameTooltipManaBar.pauseUpdates = false
			else
				GameTooltipManaBar.pauseUpdates = true
			end

			if zTipSaves.ShowBarNum then
				GameTooltipManaBar.lockShow = 1
			else
				GameTooltipManaBar.lockShow = 0
			end
		end

		if zTipSaves.ShowBarNum then
			-- 生命条文字
			local textString=GameTooltipStatusBar:CreateFontString(nil,"OVERLAY","GameFontHighlightSmallOutline")
			textString:SetPoint("CENTER")
			textString:SetTextHeight(14)
			textString:SetTextColor(1,1,1)
			GameTooltipStatusBar.zeroText = ""
			GameTooltipStatusBar.frequentUpdates = 1
			GameTooltipStatusBar.capNumericDisplay = true
			SetTextStatusBarText(GameTooltipStatusBar,textString)
			GameTooltipStatusBar:HookScript("OnValueChanged",function(self,value)
				if zTipSaves.HealthBAR and value then
					TextStatusBar_OnValueChanged(self, value);
				end
			end)
		end
		
		
		if zTipSaves.HealthBAR then
			GameTooltipStatusBar.pauseUpdates = false
		else
			GameTooltipStatusBar.pauseUpdates = true
		end
		if zTipSaves.ShowBarNum then
			GameTooltipStatusBar.lockShow = 1
		else
			GameTooltipStatusBar.lockShow = 0
		end


		function zTip:ChangeBarTexture()
			local GameBarTexture
			if zTipSaves.BarTexture then
				GameBarTexture = "Interface\\RAIDFRAME\\Raid-Bar-Hp-Fill.blp"
			else
				GameBarTexture = "Interface\\TargetingFrame\\UI-TargetingFrame-BarFill.blp"
			end
			if (GameTooltipManaBar) then
				GameTooltipManaBar:SetStatusBarTexture(GameBarTexture)
			end
			GameTooltipStatusBar:SetStatusBarTexture(GameBarTexture)
		end
		zTip:ChangeBarTexture()

	GameTooltip:SetScale(1.2)		--不知名原因，需要调整一次大小，不然血条上的字体会异常难看
	-- Scripts

	GameTooltip:HookScript("OnTooltipSetUnit", function(self,...)
		if (showTooltip) then
			showTooltip()
		end
		zTip:OnTooltipSetUnit()
	end)

	GameTooltip:HookScript("OnTooltipCleared", function(self)
		GameTooltip_ClearMoney(self)
		GameTooltip_ClearStatusBars(self)
		zTip:OnGameTooltipHide()
	end)


	-- HOOKs
	hooksecurefunc("GameTooltip_SetDefaultAnchor", zTip.SetDefaultAnchor)
	--GameTooltip_SetDefaultAnchor = zTip.SetDefaultAnchor
	--GameTooltip_UnitColor = function(unit)
	--	return zTip:UnitColor(unit)
	--end

	-- Slash
	SLASH_ZTIPSLASH1 = "/ztip"
	SlashCmdList["ZTIPSLASH"] = function(msg)
		zTip:Slash(msg)
	end
end

--factions
local name, standingId, isHeader, isCollapsed
function zTip:UpdatePlayerFaction()
	for i = 1, GetNumFactions() do
		name,_,standingId,_,_,_,_,_,isHeader,isCollapsed,_ = GetFactionInfo(i)
		if name and not isHeader then
			self.factions[name] = standingId
		end
	end
end



local reaction	-- self var used in several functions
local gender = UnitSex("player")

-- get the formated faction name
local label, str
function zTip:GetUnitFaction(unit, reaction)
	reaction = reaction or UnitReaction(unit, "player")
	if not reaction then return "" end

	if reaction == 7 then
		for i = GameTooltip:NumLines(),3,-1 do
			label = _G["GameTooltipTextLeft"..i]:GetText()
			if label and label ~= PVP and self.factions[label] then
				reaction = self.factions[label]
				break
			end
		end
	end
	str = GetText("FACTION_STANDING_LABEL"..reaction, gender)
	if reaction == 5 then str = format("|cff33CC33%s|r", str)
	elseif reaction == 6 then str = format("|cff33CCCC%s|r", str)
	elseif reaction == 7 then str = format("|cffFF6633%s|r", str)
	elseif reaction == 8 then str = format("|cffDD33DD%s|r", str)
--Add 4 lines. By YYSS
	elseif reaction == 1 then str = format("|cffFF4444%s|r", str)
	elseif reaction == 2 then str = format("|cffFF0000%s|r", str)
	elseif reaction == 3 then str = format("|cffFF7744%s|r", str)
	elseif reaction == 4 then str = format("|cffFFCC00%s|r", str)
	end

	return str
end

--[[	Positions		]]
local x,y,uiscale,tipscale
function zTip:SetDefaultAnchor(parent)
	self:SetOwner(parent, "ANCHOR_NONE");
	if zTipSaves.OrigPosX and zTipSaves.OrigPosY then
		self:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -zTipSaves.OrigPosX - 13, zTipSaves.OrigPosY);
	else
		self:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -CONTAINER_OFFSET_X - 13, CONTAINER_OFFSET_Y);
	end
	--self.default = 1;

	if zTipSaves.Anchor then
		if parent == UIParent then
			-- posiont will be set in update function
			if zTipSaves.Anchor == 0 or zTipSaves.Anchor == 3 then
				GameTooltip:ClearAllPoints()
				zTip.AnchorType = 1
			elseif zTipSaves.Anchor == 2 or zTipSaves.Anchor == 5 then
				GameTooltip:ClearAllPoints()
				zTip.AnchorType = 2
			end	
			if UnitExists("mouseover") then
				if zTipSaves.Anchor == 1 or zTipSaves.Anchor == 4 then -- on top
					zTip.AnchorType = nil
					uiscale = UIParent:GetScale()
					tipscale = self:GetScale()
					x = zTipSaves.OffsetX / tipscale / uiscale
					y = zTipSaves.OffsetY / tipscale / uiscale
					self:ClearAllPoints()
					self:SetPoint("TOP",UIParent,"TOP", x, -y)
				else -- follow cursor [0,2,3,5]
				end
				--如果目标是unit,刷新一次
				zTip:OnUpdate(0.01)
			else -- not unit 像是熔炉，信箱
				self:SetOwner(parent, "ANCHOR_CURSOR")
				zTip.AnchorType = nil
			end
		else -- not a unit tip, buttons or other
			if zTipSaves.Anchor > 2 or parent.unit and zTipSaves.Anchor~=0 then
				self:SetOwner(parent,"ANCHOR_RIGHT")
			else -- use default anchor (BottomRight to Screen)
			end
			if zTipSaves.Anchor == 2 then zTip.AnchorType = 2 end
		end
	else -- use deault
	end
end



local unit, guid
local bplayer, bdead, tapped
local text, levelline, tmp, tmp2
local unitrace, unitCreatureType
local guild, guildrank, guildid
local bbattlepet
local targetlinenum
local found, trueNum
--[[ MouseOver Target 目标]]
local mouseTarget,mouseTTarget
local function GetTarget(unit,tname,ic)
	local tip,name
	local unittarget = unit.."target"
	name = UnitName(unittarget)
	if name ~= tname then
		tname = name or UNKNOWNOBJECT
		local tmp, tmp2 = nil, nil
--~ 		local punit = gsub(unit,"target","")
--~ 		if not (punit~="target" and UnitExists(punit)) then punit = nil end

		tip = format("|cffFFFF00%s [|r", ic and "-->" or zTip.locStr.Targeting) -- '['
		-->>>
		-- 指向我自己
		if UnitIsUnit(unittarget, "player") then
			tip = format("%s |c00FF0000%s|r", tip, zTip.locStr.YOU)
		-- 指向他自己
		elseif unit and UnitIsUnit(unittarget,unit) then
			tip = format("%s |cffFFFFFF%s|r", tip, zTip.locStr.Self)
		-- 指向其它玩家
		elseif UnitIsPlayer(unittarget) then
			tmp, tmp2 = UnitClass(unittarget)
			if UnitIsEnemy(unittarget,"player") then
				-- red enemy player
				tip = format("%s |cffFF0000%s|r |cff%s(%s)|r", tip,tname,
					zTip:GetHexColor(RAID_CLASS_COLORS[(tmp2 or "")]), zTip:GetClassIconForText(tmp2,-1) or nil)
			else
				-- white friend player
				tip = format("%s |cff%s%s|r |cffFFFFFF(%s)|r", tip,
					zTip:GetHexColor(RAID_CLASS_COLORS[(tmp2 or "")]),
					tname,zTip:GetClassIconForText(tmp2,-1) or nil)
			end
		else
			tip = format("%s |cffFFFFFF%s|r", tip, tname)
		end
		-->>>
		tip = format("%s |cffFFFF00]|r", tip) -- ']'
	end
	return tip,tname
end
local function SetMouseTarget(text)
	local result
	if not UnitExists(zTip.unittarget) then
		mouseTarget = nil
		result = nil
	else
		local tip
		tip, mouseTarget = GetTarget(zTip.unit,mouseTarget)

		if tip then
			result = tip
		end
	end
	return result
end
local function SetMouseTTarget(text)
	local result
	if not zTip.unittarget or not UnitExists(zTip.unittarget.."target") then
		mouseTTarget = nil
		result = nil
	else
		local tip
		tip, mouseTTarget = GetTarget(zTip.unittarget,mouseTTarget,true)
		if tip then
			result = tip
		end
	end
	return result
end
--[[	目标刷新		]]
function zTip:RefreshMouseOverTarget(elapsed)
	-- timer, refresh every 0.5s
	self.timer = (self.timer or 0.1) + elapsed
	if self.timer < 0.1 then return end
	self.timer = 0


	if not zTipSaves.TargetOfMouse then return end
	if not targetlinenum then return end

	local text
	text = _G["GameTooltipTextLeft"..targetlinenum]
	if not text then return end

	text.dtxtt = SetMouseTarget(text)


	if zTipSaves.TTargetOfMouse then
		text.dtxttt=SetMouseTTarget(text)
	else
		text.dtxttt=nil
	end

	if text.dtxtt then
		text:SetText(text.dtxtt..(text.dtxttt or ""))
		text:Show()
		GameTooltip:Show()
	end

end

--[[	设置目标		]]
function zTip:OnTooltipSetUnit()
--~ 	BOSS战中隐藏
	if zTipSaves.CombatHide and UnitExists("boss1") then GameTooltip:Hide() end

	zTip.unit = zTip:OnMouseOverUnit(GameTooltip:GetUnit())
	if zTip.unit then
		if not zTipSaves.HealthBAR then GameTooltipStatusBar:Hide() end
		zTip.unittarget = zTip.unit.."target"
		if (GameTooltipManaBar) then
			if UnitExists(zTip.unit) and zTipSaves.ManaBAR and not UnitIsDeadOrGhost(zTip.unit) then
				_, GameTooltipManaBar.unit = GameTooltip:GetUnit()
				if GameTooltipManaBar.unit then
					GameTooltipManaBar.pauseUpdates = false
					UnitFrameManaBar_Update(GameTooltipManaBar,GameTooltipManaBar.unit)
				end
			end
		end
	elseif (GameTooltipManaBar) then
		GameTooltipManaBar:Hide()
		GameTooltipManaBar.pauseUpdates = true
	end
end

--[[	清理目标目标	]]
function zTip:OnGameTooltipHide()
	targetlinenum = nil
	trueNum = nil
	mouseTarget = nil
	mouseTTarget = nil
	zTip.AnchorType = nil
	zTip.timer = nil
	zTip.unit = nil
	zTip.unittarget = nil
	if zTip.icon then zTip.icon:Hide() end
	if zTip.peticon then zTip.peticon:Hide() end
	if zTip.talenticon then zTip.talenticon:Hide() end
		if (GameTooltipManaBar) then
			GameTooltipManaBar:Hide()
			GameTooltipManaBar.pauseUpdates = true
		end
		GameTooltipStatusBar.unit = nil
		GameTooltipStatusBar:Hide()
end


--[[	第一行名字上色 	]]
local DEFCOLOR = { r = 0.5, g = 0.5, b = 1.0 }
function zTip:UnitColor(unit, bdead, tapped, reaction,bbattlepet)
	bdead = bdead or UnitHealth(unit) <= 0 and (not bplayer or UnitIsDeadOrGhost(unit))
	tapped = tapped or UnitIsTapDenied(unit)
	reaction = reaction or UnitReaction(unit, "player")
	local ISPLAYER = UnitIsPlayer(unit)
	if tapped or bdead then
		r = 0.55;g = 0.55;b = 0.55
	elseif bbattlepet then
		r,g,b = 0.8,0.5,0.8
	elseif ISPLAYER or UnitPlayerControlled(unit) then
		if ( UnitCanAttack(unit, "player") ) then
			if ( not UnitCanAttack("player", unit) ) then
				--purple, caution, only they can attack
				r = 1.0;g = 0.4;b = 1.0
			else
				-- Hostile players are red
				r = 1.0;g = 0.0;b = 0.0
			end
		elseif ( UnitCanAttack("player", unit) ) then
			-- Players we can attack but which are not hostile are yellow
			r = 1.0;g = 1.0;b = 0.0
		-- elseif (UnitIsPVP(unit) and not UnitIsPVPSanctuary(unit) and not UnitIsPVPSanctuary("player")) then
			-- -- Players we can assist but are PvP flagged are green
			-- r = 0.0;g = 1.0;b = 0.0
		else

			local color = ISPLAYER and RAID_CLASS_COLORS[select(2,UnitClass(unit))] or DEFCOLOR
			r, g, b = color.r, color.g, color.b
		end

	elseif reaction then
		-- mob/npc
		if reaction < 4 then -- harm
			r,g,b = 1,0.3,0.22
		elseif reaction > 4 then -- friendly
			r,g,b = 0,1,0
		else -- nature
			r,g,b = 1,1,0
		end
	else -- normal
		r,g,b = 1,1,1
	end
	return r,g,b
end

--[[	修改tip整体格式 ]]
local tip
function zTip:OnMouseOverUnit(name,unit)
	if not unit then return;end
	-- hack to fix problems
	if unit == "npc" then unit = "mouseover" end
--[[
	local values and initials
--]]
	bplayer = UnitIsPlayer(unit)
	name = name or UnitName(unit)
	guid = UnitGUID(unit)
	guild, guildrank, guildid = GetGuildInfo(unit)
	--~ 是否是战宠
	-- bbattlepet = (UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit))
	--~ 尸体，排除猎人假死
	bdead = UnitHealth(unit) <= 0 and (not bplayer or UnitIsDeadOrGhost(unit))
	tapped = UnitIsTapDenied(unit)

	-- 1 憎恨 2 敌对 3 冷淡 4 中立 5 友好 6 尊敬 7 崇敬/崇拜
	reaction = UnitReaction(unit, "player")

	local OldName=_G[GameTooltip:GetName().."TextLeft1"]:GetText()
--[[
	New Way
--]]
	tip, text, levelline, foundpvp, foundfact, tmp, tmp2 = nil
	local pvplinenum,factlinenum=nil
	--[[ Serch and Delete ]]
	if (guild) then
		GameTooltip:AddLine("asd");
		for i = GameTooltip:NumLines(), 2, -1 do
			_G[GameTooltip:GetName().."TextLeft"..(i)]:SetText(_G[GameTooltip:GetName().."TextLeft"..(i-1)]:GetText())
			_G[GameTooltip:GetName().."TextRight"..(i)]:SetText(_G[GameTooltip:GetName().."TextRight"..(i-1)]:GetText())
		end
		_G[GameTooltip:GetName().."TextLeft"..2]:SetText("zTip -- guild line");
	end
	trueNum = GameTooltip:NumLines()
	lastlinenum = trueNum
	for i = 2, trueNum do
		text = _G[GameTooltip:GetName().."TextLeft"..i]
		tip = text:GetText()
		if tip then
			--~ 查找等级行
			if not levelline and (strfind(tip, LEVEL) or strfind(tip,"Pet Level")) then
				levelline = i;
			-- 删除阵营字符
			elseif not zTipSaves.ShowFaction and (tip == FACTION_ALLIANCE or tip == FACTION_HORDE) then
				text:SetText()
				foundfact = true
				factlinenum = i
--~ 				_G["GameTooltipTextLeft"..i]:Hide()
				lastlinenum = lastlinenum - 1
			-- 删除PVP字符
			elseif tip == PVP then
				text:SetText()
				pvplinenum = i
				lastlinenum = lastlinenum - 1
			-- 能否驯服
			elseif tip == TAMEABLE then
				text:SetText( format("|cff00FF00%s|r", tip) )
			elseif tip == NOT_TAMEABLE then
				text:SetText( format("|cffFF6035%s|r", tip) )
			end
		end
	end
	-- insert target line
	if zTipSaves.TargetOfMouse then
		if lastlinenum >= GameTooltip:NumLines() then
			GameTooltip:AddLine("zTip -- target line")
			targetlinenum = GameTooltip:NumLines()
		else
			targetlinenum = lastlinenum + 1
		end
		lastlinenum = targetlinenum;
		text = _G["GameTooltipTextLeft"..targetlinenum]
		if text then
			text.dtxtt = SetMouseTarget(text)


			if zTipSaves.TTargetOfMouse then
				text.dtxttt=SetMouseTTarget(text)
			else
				text.dtxttt=nil
			end

			if text.dtxtt then
				text:SetText(text.dtxtt..(text.dtxttt or ""))
			else 
				text:SetText()
			end
		else
			targetlinenum = nil
		end
	end

	if false and bplayer and UnitLevel(unit) > 0 and CheckInteractDistance(unit, 1) and CanInspect(unit,true) then
		currentID, currentGUID = unit, UnitGUID(unit)
		ScanUnit(unit)
	end

	-- Add "Targeted By" line
	if zTipSaves.TargetedBy then
		local num= GetNumGroupMembers()
		if (num > 0) then
			local players, counter = "", 0
			for i = 1,num do
				local unit1 = (UnitName("raid"..i) and "raid"..i or "party"..i)
				if (UnitIsUnit(unit1.."target",unit)) and (not UnitIsUnit(unit1,"player")) then
					if (mod(counter + 3,6) == 0) then
						players = players.."\n"
					end
					local color = RAID_CLASS_COLORS[select(2,UnitClass(unit1))]
					players = ("%s|cff%.2x%.2x%.2x%s|r, "):format(players,color.r*255,color.g*255,color.b*255,UnitName(unit1))
					counter = (counter + 1)
				end
			end
			if (players ~= "") then
--~ 	--------------------------------------------
				if lastlinenum >= GameTooltip:NumLines() then
					GameTooltip:AddLine("zTip -- targetedby line")
					lastlinenum = GameTooltip:NumLines()
				else
					if false and zTipSaves.ShowTalent then
						lastlinenum = lastlinenum + 1
					end
					if false and zTipSaves.ItemLevel then
						lastlinenum = lastlinenum + 1
					end
				end
				text = _G["GameTooltipTextLeft"..lastlinenum]
				if text then
					text:SetText(zTip.locStr.TargetedBy.." (|cffffffff"..counter.."|r): "..players:sub(1,-5))

				else
--~ 					lastlinenum = nil
				end
			end
		end
	end

	--[[ 等级行涂改 ]]
	if levelline then
		-- 表示 等级,尸体(如果死亡)
		if bbattlepet then
			tmp=UnitBattlePetLevel(unit)
			tmp2=format(TOOLTIP_WILDBATTLEPET_LEVEL_CLASS,"","")
		else
			tmp=UnitLevel(unit)
			tmp2 = ""
		end

		if bdead then
			if tmp > 0 then
				tmp2 = format("|cff888888%d %s|r", tmp, CORPSE)
			else
				tmp2 = format("|cff888888?? %s|r", CORPSE)
			end
		elseif ( tmp > 0 ) then
			-- Color level number
			if UnitCanAttack("player", unit) or UnitCanAttack(unit, "player") then
				tmp2 = format("|cff%s%d|r", zTip:GetDifficultyColor(tmp), tmp)
			else
				-- normal color
				tmp2 = format("%s|cff3377CC%d|r",tmp2,tmp)
			end
		else
			-- Target is too high level to tell
			tmp2 = "|cffFF0000 ??|r"
		end

		-- 种族, 职业/ creature type/ creature family(pet)
		unitrace = UnitRace(unit)
		unitCreatureType = UnitCreatureType(unit)
		if unitrace and bplayer then
			--race, it is a player
			if UnitFactionGroup(unit) == UnitFactionGroup("player") then
				tmp = "00FF33"
			else
				tmp = "FF3300"  -- 敌对阵营种族为暗红
			end
			tmp2 = format("%s |cff%s%s|r", tmp2, tmp, unitrace)
			-- class
			_, tmp = UnitClass(unit)
			local c = RAID_CLASS_COLORS[(tmp or "")]
			-- if(c) then
				-- GameTooltip:SetBackdropBorderColor(c.r,c.g,c.b)
			-- end
			tmp = zTip:GetHexColor(c)
			tmp2 = format("%s |cff%s%s|r ", tmp2, tmp, _)
		elseif UnitPlayerControlled(unit) or bbattlepet then
			--creature family, its is a pet
			if bbattlepet then --判断是否是战斗宠物
				-- petType
				local petType=UnitBattlePetType(unit)
				if (petType) then
					tmp=_G["BATTLE_PET_NAME_"..petType]
					tmp2 = format("%s %s ",tmp2,tmp or "")
				end
			else
				tmp2 = format("%s %s ",tmp2,(UnitCreatureFamily(unit) or unitCreatureType or "") )
			end
		elseif unitCreatureType then
			--creature type, it is a mob or npc
			if unitCreatureType == zTip.locStr.NotSpecified then unitCreatureType = zTip.locStr.Specified end	--"未指定"替换为更通顺的"神秘物种"
			tmp2 = format("%s |cffFFFFFF%s|r", tmp2, unitCreatureType)
			if zTipSaves.NPCClass then
				local SYSCType,SYSCID = select(2,UnitClass(unit))
				tmp2 = format("%s |cff%s%s|r", tmp2, zTip:GetHexColor(RAID_CLASS_COLORS[SYSCType]), C_CreatureInfo.GetClassInfo(SYSCID).className)
				-- tmp2 = format("%s |cff%s%s|r", tmp2, zTip:GetHexColor(RAID_CLASS_COLORS[SYSCType]),"啊是的请问")
			end
			if zTipSaves.DisplayFaction and reaction and reaction > 0 then
				tmp2 = format("%s %s ", tmp2, zTip:GetUnitFaction(unit,reaction))
			end
		else
			tmp2 = format("%s %s ",tmp2,UKNOWNBEING)
		end
		if zTipSaves.ShowRc and not bplayer and iLibRangeCheck then		--距离
			local minRange, maxRange = iLibRangeCheck:getRange(unit);		
			local text = GetRangeColorText(minRange, maxRange);
			if (text) then
				tmp2 = tmp2 .. text
			end
		end
		tip = tmp2

		-- special info
		tmp = nil
		tmp2 = ""
		if bplayer then
			if zTipSaves.ShowIsPlayer then
				tmp2 = format("(%s)",PLAYER)
			end
		elseif not UnitPlayerControlled(unit) then
			tmp = UnitClassification(unit) -- Elite status
			--if tmp and tmp ~= "normal" and UnitHealth(unit) > 0 then
			if tmp and tmp ~= "normal" then
				if tmp == "elite" then
					tmp2 = format("|cffFFFF33(%s)|r", ELITE)
				elseif tmp == "worldboss" then
					tmp2 = format("|cffFF0000(%s)|r", BOSS)
				elseif tmp == "rare" then
					tmp2 = format("|cffFF66FF(%s)|r", zTip.locStr.Rare)
				elseif tmp == "rareelite" then
					tmp2 = format("|cffFFAAFF(%s%s)|r", zTip.locStr.Rare, ELITE)
				else
					tmp2 = format("(%s)", tmp) -- unknown type
				end
			end
		end
		_G["GameTooltipTextLeft"..levelline]:SetText( format("%s%s",tip,tmp2) )
	end

	--[[ First Line, rewrite name ]]
	if bplayer or bbattlepet then
		-- 军衔
		tip = ""
		if not zTipSaves.DisplayPvPRank then
			GameTooltipTextLeft1:SetText( format("%s%s", tip, name ) )
		else
			GameTooltipTextLeft1:SetText( format("%s%s", tip, (UnitPVPName(unit) or name) ) )
		end
	end

	--[[ Second Line, Rewrite / Insert guild and/or realm name ]]
	tip = nil
	if bplayer then
		-- 工会
		if guild then
			tip = "<"..guild.."> "..(zTipSaves.GuildInfo and (guildrank.."("..guildid..")") or "")
		end
		-- 服务器
		_, tmp = UnitName(unit)
		if zTipSaves.PlayerServer and (tmp and tmp~="" or tip) then
			if tmp and tip then
				tmp2 = " @ "
			else
				tmp2 = ""
			end
			tip = format("%s|cff00EEEE%s%s|r", tip or "", tmp2, tmp or "")
		end
		if tip then
			if guild then
				GameTooltipTextLeft2:SetText(tip)
			else
				GameTooltipTextLeft1:SetText(GameTooltipTextLeft1:GetText().." - "..tmp)
			end
		end
	end

	-- classicon
	local cicon = ""
	if zTipSaves.ClassIcon then
		if bbattlepet then
			local petType=UnitBattlePetType(unit)
			if (petType) then
				cicon = "|TInterface\\Icons\\Pet_TYPE_"..PET_TYPE_SUFFIX[petType]..":12:12:0:0:10:10:0:10:0:10|t "
			end
		elseif unitrace and bplayer then
			local cls = select(2,UnitClass(unit))
			cicon = zTip:GetClassIconForText(cls)
		end
	end


	--[[ Colors ]]

--~ 第一行名字上色，并调整第一行
	r,g,b = zTip:UnitColor(unit, bdead, tapped, reaction,bbattlepet)
	if bbattlepet then
		GameTooltipTextLeft1:SetText(cicon..OldName)
	else
		GameTooltipTextLeft1:SetText(cicon..format("|cff%2x%2x%2x",r*255,g*255,b*255)..GameTooltipTextLeft1:GetText().."|r")
	end


--~ 给第二行上色
	if tip or (levelline and levelline > 2) then
		if bdead or tapped then -- 尸体或已被攻击
			GameTooltipTextLeft2:SetTextColor(0.55,0.55,0.55)
		elseif bbattlepet then
			if levelline~=3 then
				GameTooltipTextLeft1:SetTextColor(pet_r,pet_g,pet_b)----宠物修改名颜色
				GameTooltipTextLeft2:SetTextColor(r,g,b)
			end
		else
			GameTooltipTextLeft2:SetTextColor(r*zTip.GuildColorAlpha,g*zTip.GuildColorAlpha,b*zTip.GuildColorAlpha)
		end
	end
--~ 标记本工会为亮色
--	if bplayer and guild == GetGuildInfo("player") then
--		GameTooltipTextLeft2:SetTextColor(0.9, 0.5, 0.9)
--	end
	if bplayer and guild then
		if guild == GetGuildInfo("player") then
			GameTooltipTextLeft2:SetTextColor(0.9, 0.5, 0.9)
		else
			GameTooltipTextLeft2:SetTextColor(1.0, 1.0, 1.0)
		end
	end

--[[
	done
--]]
 	for el = GameTooltip:NumLines(),1,-1 do
 		if not _G["GameTooltipTextLeft"..el]:GetText() then
 			_G["GameTooltipTextLeft"..el]:Hide()
		else
			break
 		end
 	end
	return unit
end

--[[	Slash Command	]]
function zTip:Slash(msg)
	local param1 = string.lower(msg)
	if (param1 == "cc") then		--/ztip cc清空天赋缓存
		wipe(inspectDB)
		collectgarbage("collect")
		inspectDB = {GearDB = {}, SpecDB = {},NeedUpdate = {}}
		DEFAULT_CHAT_FRAME:AddMessage("|cff00FFFFzTip:|r "..zTip.locStr.ResetCache, 1,1,0)
	elseif (param1 == "ct") then
		if (UnitIsPlayer("target")) then
			local name = UnitName("target")
			local guid = UnitGUID("target")
			if inspectDB[SpecDB][guid] then
				inspectDB[SpecDB][guid] = nil
				DEFAULT_CHAT_FRAME:AddMessage("|cff00FFFFzTip:|r |cff"..zTip:GetHexColor(RAID_CLASS_COLORS[select(2,UnitClass("target"))])..name.."|r 的天赋缓存已被清空");
			else
				DEFAULT_CHAT_FRAME:AddMessage("|cff00FFFFzTip:|r 未找到 |cff"..zTip:GetHexColor(RAID_CLASS_COLORS[select(2,UnitClass("target"))])..name.."|r 的天赋缓存");
			end
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cff00FFFFzTip:|r 没有目标或目标不是玩家");
		end
	elseif (param1 == "pp") then
		local n=0
		for k,v in pairs(inspectDB) do
			n=n+1;
		end
		DEFAULT_CHAT_FRAME:AddMessage("|cff00FFFFzTip:|r inspectDB="..n);
	else
		collectgarbage("collect")
		UpdateAddOnMemoryUsage()
		DEFAULT_CHAT_FRAME:AddMessage("|cff00FFFFzTip:|r Toggle Option Window", 1,1,0)
		DEFAULT_CHAT_FRAME:AddMessage("|cff00FFFFzTip:|r "..format("%.2f",GetAddOnMemoryUsage("zTip")).." KB", 1,1,0)
		if not zTipOption then return end
		if not zTipOption.ready then zTipOption:Init() end
		if not zTipOption:IsShown() then zTipOption:Show() end
	end
end



---- ID
local select, UnitBuff, UnitDebuff, UnitAura, tonumber, strfind, hooksecurefunc =
	select, UnitBuff, UnitDebuff, UnitAura, tonumber, strfind, hooksecurefunc

local function addLine(self,id,isItem)
	if id and IsAltKeyDown() then
		if isItem then
			self:AddDoubleLine(ITEMS.."ID:","|cffffffff"..tostring(id))
		else
			self:AddDoubleLine(SPELLS.."ID:","|cffffffff"..tostring(id))
		end
		self:Show()
	end
end

-- Spell Hooks ----------------------------------------------------------------
hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
	local id = select(10,UnitBuff(...))
	if id then addLine(self,id) end
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
	local id = select(10,UnitDebuff(...))
	if id then addLine(self,id) end
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
	local id = select(10,UnitAura(...))
	if id then addLine(self,id) end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local id = select(2,self:GetSpell())
	if id then addLine(self,id) end
end)

hooksecurefunc("SetItemRef", function(link, ...)
	local id = tonumber(link:match("spell:(%d+)"))
	if id then addLine(ItemRefTooltip,id) end
end)

-- Item Hooks -----------------------------------------------------------------

local function attachItemTooltip(self) 
	local link = select(2,self:GetItem())
	if not link then return end
	local id = tonumber(link:match("item:(%d+)"))
	if id then addLine(self,id,true) end
end

GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
