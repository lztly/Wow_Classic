pont= 0.000
pofft= 0.000
ont = 0.000
offt= 0.000
ons = 0.000
offs= 0.000
offh = 0
onh  = 0
epont=0.000
epofft= 0.000
eont = 0.000
eofft= 0.000
eons = 0.000
eoffs= 0.000
eoffh = 0
eonh  = 0
testvar = 0

function Abar_chat(msg)
	msg = strlower(msg)
	if msg == "fix" then
		Abar_reset()
	elseif msg=="lock" then
		Abar_Frame:Hide()
		ebar_Frame:Hide()
	elseif msg=="unlock" then
		Abar_Frame:Show()
		ebar_Frame:Show()
	elseif msg=="range" then
		abar.range= not(abar.range)
		print('range is'.. Abar_Boo(abar.range));
	elseif msg=="h2h" then
		abar.h2h = not(abar.h2h)
		print('H2H is'.. Abar_Boo(abar.h2h));
	elseif msg=="timer" then
		abar.timer = not(abar.timer)
		print('timer is'.. Abar_Boo(abar.timer));
	elseif msg=="pvp" then
		abar.pvp = not(abar.pvp)
		print('pvp is'.. Abar_Boo(abar.pvp));
	elseif msg=="mob" then
		abar.mob = not(abar.mob)
		print('mobs are'.. Abar_Boo(abar.mob));
	else
		print('用以下命令来控制攻击条:');
		print('Lock- 锁定攻击条');
		print('unlock- 解锁和显示攻击条');
		print('fix- 重置攻击条');
		print('h2h- 近战攻击条开关');
		print('range- 远程攻击条开关');
		print('pvp- pvp攻击条开关');
		print('mob- 怪物攻击条开关');
	end
end

function Abar_loaded()
	SlashCmdList["ATKBAR"] = Abar_chat;
	SLASH_ATKBAR1 = "/abar";
	SLASH_ATKBAR2 = "/atkbar";
	if not(abar) then abar={} end
	if abar.range == nil then
		abar.range=true
	end
	if abar.h2h == nil then
		abar.h2h=true
	end
	if abar.timer == nil then
		abar.timer=true
	end


	Abar_Mhr:SetPoint("LEFT",Abar_Frame,"TOPLEFT",6,-13)
	Abar_Oh:SetPoint("LEFT",Abar_Frame,"TOPLEFT",6,-35)
	Abar_MhrText:SetJustifyH("Left")
	Abar_OhText:SetJustifyH("Left")
	ebar_VL()
end

function Abar_OnEvent(event, ...)
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		local subevent = select(2, ...)
		local sourceGUID = select(4, ...)
		local destGUID = select(8, ...)
		if (sourceGUID == UnitGUID("player")) then
			if (string.find(subevent, "SWING.*") ~= nil) and abar.h2h then
				Abar_selfhit()
			elseif (string.find(subevent, "SPELL.*") ~= nil) and abar.h2h then
				spell = select(13, ...)
				Abar_spellhit(spell, true)
			end
		elseif (destGUID == UnitGUID("player") and sourceGUID == UnitGUID("target")) then
			if (UnitIsPlayer("target")) then
				if (abar.pvp) then
					if (string.find(subevent, "SWING.*") ~= nil) and abar.h2h then
						ebar_set()
					elseif (string.find(subevent, "SPELL.*") ~= nil) and abar.h2h then
						spell = select(13, ...)
						Abar_spellhit(spell, false)
					end
				end
			else
				if (abar.mob) then
						if (string.find(subevent, "SWING.*") ~= nil) and abar.h2h then
							ebar_set()
						end
				end
			end
		end
	end
	if event=="PLAYER_LEAVE_COMBAT" then Abar_reset() end
	if event == "VARIABLES_LOADED" then Abar_loaded() end
	if event == "VARIABLES_LOADED" then Abar_loaded() end
end

function Abar_spellhit(spell, player)
	if (spell == "猛禽一击" or spell == "英勇打击" or
	spell == "槌击" or spell == "顺劈斩") and abar.h2h then
		hd,ld,ohd,lhd = UnitDamage("player")
		hd,ld= hd-math.fmod(hd,1),ld-math.fmod(ld,1)
		if pofft == 0 then pofft=offt end
		pont = ont
		tons = ons
		ons = ons - math.fmod(ons,0.01)
		if (player) then
			--Abar_Mhrs(tons,"主["..ons.."s]("..hd.."-"..ld..")",0,0,1)
			Abar_Mhrs(tons,"主手",0,0,1)
		else
			ebar_set()
		end
	end
end

function Abar_selfhit()
ons,offs=UnitAttackSpeed("player");
hd,ld,ohd,old = UnitDamage("player")
hd,ld= hd-math.fmod(hd,1),ld-math.fmod(ld,1)
if old then
	ohd,old = ohd-math.fmod(ohd,1),old-math.fmod(old,1)
end	
if offs then
	ont,offt=GetTime(),GetTime()
	if ((math.abs((ont-pont)-ons) <= math.abs((offt-pofft)-offs))and not(onh <= offs/ons)) or offh >= ons/offs then
		if pofft == 0 then pofft=offt end
		pont = ont
		tons = ons
		offh = 0
		onh = onh +1
		ons = ons - math.fmod(ons,0.01)
		--Abar_Mhrs(tons,"主["..ons.."s]("..hd.."-"..ld..")",0,0,1)
		Abar_Mhrs(tons,"主手",0,0,1)
	else
		pofft = offt
		offh = offh+1
		onh = 0
		ohd,old = ohd-math.fmod(ohd,1),old-math.fmod(old,1)
		offs = offs - math.fmod(offs,0.01)
		--Abar_Ohs(offs,"副["..offs.."s]("..ohd.."-"..old..")",0,0,1)
		Abar_Ohs(offs,"副手",0,0,1)
	end
else
	ont=GetTime()
	tons = ons
	ons = ons - math.fmod(ons,0.01)
	--Abar_Mhrs(tons,"主["..ons.."s]("..hd.."-"..ld..")",0,0,1)
	Abar_Mhrs(tons,"主手",0,0,1)
end
end

function Abar_reset()
	pont=0.000
	pofft= 0.000
	ont=0.000
	offt= 0.000
	onid=0
	offid=0
end

function Abar_Update(self)
	local ttime = GetTime()
	local left = 0.0
	tSpark=getglobal(self:GetName().. "Spark")
	tText=getglobal(self:GetName().. "Tmr")
	if abar.timer==true then
		left = (self.et-GetTime()) - (math.fmod((self.et-GetTime()),.1))
	--	tText:SetText(this.txt.. "{"..left.."}")
	--	tText:SetText("{"..left.."}")
		tText:SetText(left)
		tText:Show()
	else
	        tText:Hide()
	end
	self:SetValue(ttime)
	tSpark:SetPoint("CENTER", self, "LEFT", (ttime-self.st)/(self.et-self.st)*195, 2);
	if ttime>=self.et then 
		self:Hide() 
		tSpark:SetPoint("CENTER", self, "LEFT",195, 2);
	end
end

function Abar_Mhrs(bartime,text,r,g,b)
	Abar_Mhr:Hide()
	Abar_Mhr.txt = text
	Abar_Mhr.st = GetTime()
	Abar_Mhr.et = GetTime() + bartime
	Abar_Mhr:SetStatusBarColor(r,g,b)
	Abar_MhrText:SetText(text)
	Abar_Mhr:SetMinMaxValues(Abar_Mhr.st,Abar_Mhr.et)
	Abar_Mhr:SetValue(Abar_Mhr.st)
	Abar_Mhr:Show()
end

function Abar_Ohs(bartime,text,r,g,b)
	Abar_Oh:Hide()
	Abar_Oh.txt = text
	Abar_Oh.st = GetTime()
	Abar_Oh.et = GetTime() + bartime
	Abar_Oh:SetStatusBarColor(r,g,b)
	Abar_OhText:SetText(text)
	Abar_Oh:SetMinMaxValues(Abar_Oh.st,Abar_Oh.et)
	Abar_Oh:SetValue(Abar_Oh.st)
	Abar_Oh:Show()
end

function Abar_Boo(inpt)
	if inpt == true then return " ON" else return " OFF" end
end

-----------------------------------------------------------------------------------------------------------------------
-- ENEMY BAR CODE --
-----------------------------------------------------------------------------------------------------------------------

function ebar_VL()
	if not abar.pvp then abar.pvp = true end
	if not abar.mob then abar.mob = false end
	ebar_mh:SetPoint("LEFT",ebar_Frame,"TOPLEFT",6,-13)
	ebar_oh:SetPoint("LEFT",ebar_Frame,"TOPLEFT",6,-35)
	ebar_mhText:SetJustifyH("Left")
	ebar_ohText:SetJustifyH("Left")
end

function ebar_set()
	eons,eoffs = UnitAttackSpeed("target")
	eons = eons - math.fmod(eons,0.01)
	--ebar_mhs(eons,"目标".."["..eons.."s]",1,.1,.1)
	ebar_mhs(eons,"目标".."",1,.1,.1)
end

function ebar_mhs(bartime,text,r,g,b)
	ebar_mh:Hide()
	ebar_mh.txt = text
	ebar_mh.st = GetTime()
	ebar_mh.et = GetTime() + bartime
	ebar_mh:SetStatusBarColor(r,g,b)
	ebar_mhText:SetText(text)
	ebar_mh:SetMinMaxValues(ebar_mh.st,ebar_mh.et)
	ebar_mh:SetValue(ebar_mh.st)
	ebar_mh:Show()
end 