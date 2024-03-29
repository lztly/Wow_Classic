--[[
	2014-10-25
	增加部分设置选项
	法力条/数值显示 修复完成，测试中
]]--
local _, i
local _G = getfenv(0)

local zTipOption = CreateFrame("Frame","zTipOption",UIParent)
zTipOption:Hide()
tinsert(UISpecialFrames, "zTipOption")

function zTipOption:Init()
	-- localize
--	self:Localize()

	-- init frame
	self:SetWidth(300); self:SetHeight(650);
	self:SetPoint("CENTER")
	self:SetFrameStrata("HIGH")
	self:SetToplevel(true)
	self:SetMovable(true)
	self:SetClampedToScreen(true)

	-- background
	self:SetBackdrop( {
	  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16,
	  insets = { left = 5, right = 5, top = 5, bottom = 5 }
	});
	self:SetBackdropColor(0,0,0)

	-- drag
	self:EnableMouse(true)
	self:RegisterForDrag("LeftButton")
	self:SetScript("OnDragStart",function(self) self:StartMoving() end)
	self:SetScript("OnDragStop",function(self) self:StopMovingOrSizing() end)

	-- title
	--self:CreateFontString("zTipOptionTitle", "ARTWORK", "SystemFont")
	self:CreateFontString("zTipOptionTitle","ARTWORK","GameFontHighlight")
	zTipOptionTitle:SetPoint("TOP",0,-10)
	zTipOptionTitle:SetTextColor(0.8,0.5,1)
	zTipOptionTitle:SetText(self.locStr["zTip Options"])

	-- buttons
	zTipOption:InitButtons()

	-- sub titles
	--self:CreateFontString("zTipOptionPositionTitle","ARTWORK","SystemFont")
	self:CreateFontString("zTipOptionPositionTitle","ARTWORK","GameFontHighlight")
	zTipOptionPositionTitle:SetPoint("BOTTOMLEFT", "zTipOptionFollowCursor","TOPLEFT",-5,0)
	zTipOptionPositionTitle:SetText(self.locStr["Positions"])

	--self:CreateFontString("zTipOptionOffsetTitle","ARTWORK","SystemFont")
	self:CreateFontString("zTipOptionOffsetTitle","ARTWORK","GameFontHighlight")
	zTipOptionOffsetTitle:SetPoint("BOTTOMLEFT", "zTipOptionOffsetX","TOPLEFT",-5,0)
	zTipOptionOffsetTitle:SetText(self.locStr["Offsets"])

	--self:CreateFontString("zTipOptionOrigPosTitle","ARTWORK","SystemFont")
	self:CreateFontString("zTipOptionOrigPosTitle","ARTWORK","GameFontHighlight")
	zTipOptionOrigPosTitle:SetPoint("BOTTOMLEFT", "zTipOptionOrigPosX","TOPLEFT",-5,0)
	zTipOptionOrigPosTitle:SetText(self.locStr["Original Position Offsets"])

	-- read options
	zTipOption:LoadOptions()

	-- done
	self.ready = 1
end

function zTipOption:InitButtons()
	local ox = 130
	self.Buttons = {
		-- Click Butons
		{name="Close",type="Button",inherits="UIPanelCloseButton",
			point="TOPRIGHT",func=function() zTipOption:Hide() end,},
		{name="Reset",type="Button",inherits="UIPanelButtonTemplate",
			width=50, height=20, text = "Reset",
			point="TOPLEFT",x=5,y=-5,func=zTipOption.Reset},

		-- Check Buttons
		{name="Target",type="CheckButton",var="TargetOfMouse",
			point="TOPLEFT",x=20,y=-35},
		{name="TTarget",type="CheckButton",var="TTargetOfMouse",
			point="LEFT",relative="Target",rpoint="RIGHT",x=ox,},
		{name="TargetedBy",type="CheckButton",var="TargetedBy",
			point="TOP",relative="Target",rpoint="BOTTOM",},
		{name="ShowRc",type="CheckButton",var="ShowRc",
			point="LEFT",relative="TargetedBy",rpoint="RIGHT",x=ox,},


		{name="PVPName",type="CheckButton",var="DisplayPvPRank",
			point="TOP",relative="TargetedBy",rpoint="BOTTOM",y=-10},
		{name="Reputation",type="CheckButton",var="DisplayFaction",
			point="LEFT",relative="PVPName",rpoint="RIGHT",x=ox,},
		{name="RealmName",type="CheckButton",var="PlayerServer",
			point="TOP",relative="PVPName",rpoint="BOTTOM",},
		{name="NPCClass",type="CheckButton",var="NPCClass",
			point="LEFT",relative="RealmName",rpoint="RIGHT",x=ox,},
		{name="IsPlayer",type="CheckButton",var="ShowIsPlayer",
			point="TOP",relative="RealmName",rpoint="BOTTOM"},
		{name="GuildInfo",type="CheckButton",var="GuildInfo",
			point="LEFT",relative="IsPlayer",rpoint="RIGHT",x=ox,},


		{name="Fade",type="CheckButton",var="Fade",
			point="TOP",relative="IsPlayer",rpoint="BOTTOM",y=-10,},
		{name="VividMask",type="CheckButton",var="VividMask",
			point="LEFT",relative="Fade",rpoint="RIGHT",x=ox,
			func = zTipOption.OnVividMaskClicked},
		{name="CombatHide",type="CheckButton",var="CombatHide",
			point="TOP",relative="Fade",rpoint="BOTTOM",},
		{name="BarTexture",type="CheckButton",var="BarTexture",
			point="LEFT",relative="CombatHide",rpoint="RIGHT",x=ox,
			func = zTipOption.OnShowBarTextureClicked},

		{name="ClassIcon",type="CheckButton",var="ClassIcon",
			point="TOP",relative="CombatHide",rpoint="BOTTOM",y=-10,},
		{name="TalentIcon",type="CheckButton",var="TalentIcon",
			point="LEFT",relative="ClassIcon",rpoint="RIGHT",x=ox,},

		{name="ItemLevel",type="CheckButton",var="ItemLevel",
			point="TOP",relative="ClassIcon",rpoint="BOTTOM",y=-10,},
		{name="ShowTalent",type="CheckButton",var="ShowTalent",
			point="LEFT",relative="ItemLevel",rpoint="RIGHT",x=ox,},

		{name="ManaBAR",type="CheckButton",var="ManaBAR",
			point="TOP",relative="ItemLevel",rpoint="BOTTOM",y=-10,
			func = zTipOption.OnManaBARClicked},
		{name="HealthBAR",type="CheckButton",var="HealthBAR",
			point="TOP",relative="ManaBAR",rpoint="BOTTOM"},
		{name="ShowBarNum",type="CheckButton",var="ShowBarNum",
			point="LEFT",relative="ManaBAR",rpoint="RIGHT",x=ox,
			func = zTipOption.OnShowBarNumClicked},
		{name="MiniNum",type="CheckButton",var="MiniNum",
			point="TOP",relative="ShowBarNum",rpoint="BOTTOM"},





		-- Sliders
		{name="Scale",type="Slider",min=0.00,max=2.00,step=0.05,width=220,
			var = "Scale", func = zTipOption.OnScaleChanged,
			point="CENTER",relative="MiniNum",rpoint="BOTTOMLEFT",x=-43,y=-20,},
		{name="ScaleBox",type="EditBox",width=32,height=20,var="Scale",
			func = zTipOption.ScaleBoxChanged,
			point="CENTER",relative="Scale",rpoint="BOTTOM",y=-15},

		-- Check Buttons for AnchorType
		{name="FollowCursor",type="CheckButton",func = zTipOption.OnAnchorChanged,
			point="TOP",relative="Scale",rpoint="BOTTOM",x=-100,y=-50, anchor = 3 },
		{name="RootOnTop",type="CheckButton",func = zTipOption.OnAnchorChanged,
			point="LEFT",relative="FollowCursor",rpoint="RIGHT",x=ox, anchor = 1 },

		{name="FollowCursorA",type="CheckButton",func = zTipOption.OnAnchorChanged,
			point="TOP",relative="FollowCursor",rpoint="BOTTOM", anchor = 0 },

		{name="OnCursorTop",type="CheckButton",func = zTipOption.OnAnchorChanged,
			point="TOP",relative="FollowCursorA",rpoint="BOTTOM", anchor = 2 },
		{name="RightBottom",type="CheckButton",func = zTipOption.OnAnchorChanged,
			point="LEFT",relative="OnCursorTop",rpoint="RIGHT",x=ox},

		-- input box
		{name="OffsetX",type="EditBox",width=32,height=20,var="OffsetX",
			point="TOPLEFT",relative="OnCursorTop",rpoint="BOTTOMLEFT",y=-25},
		{name="OffsetY",type="EditBox",width=32,height=20,var="OffsetY",
			point="LEFT",relative="OffsetX",rpoint="RIGHT",x=105,},
		{name="OrigPosX",type="EditBox",width=32,height=20,var="OrigPosX",
			point="TOP",relative="OffsetX",rpoint="BOTTOM",y=-25,},
		{name="OrigPosY",type="EditBox",width=32,height=20,var="OrigPosY",
			point="LEFT",relative="OrigPosX",rpoint="RIGHT",x=105},
	}

	local button, text, name, value
	for key, value in ipairs(zTipOption.Buttons) do
		-- pre settings
		if value.type == "CheckButton" then
			value.inherits = "OptionsCheckButtonTemplate"
		elseif value.type == "Slider" then
			value.inherits = "OptionsSliderTemplate"
		elseif value.type == "EditBox" then
			value.inherits = "InputBoxTemplate"
		end

		-- creations
		button = CreateFrame(value.type, "zTipOption"..value.name, zTipOption, value.inherits)

		if value.type == "CheckButton" then
			text = button:CreateFontString(button:GetName().."Text","ARTWORK","GameFontNormal")
			text:SetPoint("LEFT",button,"RIGHT")
			button:SetFontString(text)
		elseif value.type == "EditBox" then
			text = button:CreateFontString(button:GetName().."Text","ARTWORK","GameFontNormal")
			text:SetPoint("LEFT",button,"RIGHT",5,0)
			button.text = text
		end

		-- setup
		button:SetID(key)
		if value.width then
			button:SetWidth(value.width)
		end
		if value.height then
			button:SetHeight(value.height)
		end
		if value.point then
			if value.relative then
				value.relative = "zTipOption"..value.relative
			end
			button:SetPoint(value.point, value.relative or zTipOption, value.rpoint or value.point, value.x or 0, value.y or 0)
		end
		if value.text then
			if button.text then
				button.text:SetText(value.text)
			else
				button:SetText(value.text)
			end
		end

		-- post settings
		if value.type == "Button" then
			if value.text then button:SetText(value.text) end
			if value.func then button:SetScript("OnClick",value.func) end
		elseif value.type == "CheckButton" then
			if not value.text then button:SetText(self.locStr[value.name]) end
			if value.func then
				button:SetScript("OnClick", value.func)
			else
				button:SetScript("OnClick", zTipOption.OnCheckButtonClicked)
			end
		elseif value.type == "Slider" then
			button.text = _G["zTipOption"..value.name.."Text"]
			button.SetDisplayValue = button.SetValue;
			if value.text then
				button.title = value.text
			else
				button.title = self.locStr[value.name]
			end
			button.text:SetText(button.title)
			_G["zTipOption"..value.name.."Low"]:SetText(value.min)
			_G["zTipOption"..value.name.."High"]:SetText(value.max)
			button:SetMinMaxValues(value.min, value.max)
			button:SetValueStep(value.step)
			if value.func then button:SetScript("OnValueChanged", value.func) end
		elseif value.type == "EditBox" then
			button:SetAutoFocus(false)
			if not value.text then button.text:SetText(self.locStr[value.name]) end
			if value.func then
				button:SetScript("OnEnterPressed", value.func)
				button:SetScript("OnTabPressed", value.func)
			else
				button:SetScript("OnEnterPressed", zTipOption.OnEditBoxEnterPressed)
			end
			button:SetScript("OnEscapePressed", button.ClearFocus)
		end

		if self.locStr[value.name] and self.locStr[value.name.."Tooltip"] then
			button:SetScript("OnEnter", function(s)
				self:CheckButton_OnEnter(s,self.locStr[value.name.."Tooltip"])
			end)
		end
	end
end

--[[
	functions
--]]
local value, isChecked
function zTipOption:Reset()
	zTipSaves = zTip:GetDefault()
	zTipOption:LoadOptions()
	GameTooltip:SetScale(zTipSaves.Scale)
	if zTipSaves.VividMask then zTip:GetVividMask():Show()
	else
		if GameTooltipMask then GameTooltipMask:Hide() end
	end
	if zTipSaves.ManaBAR then
		GameTooltipManaBar:Show()
	else
		GameTooltipManaBar:Hide()
	end
	UnitFrameManaBar_Initialize("mouseover",GameTooltipManaBar)
end
function zTipOption:OnCheckButtonClicked()
	isChecked = self:GetChecked()
	if isChecked then
		-- PlaySound("igMainMenuOptionCheckBoxOn")
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	else
		-- PlaySound("igMainMenuOptionCheckBoxOff")
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
	end
	value = zTipOption.Buttons[self:GetID()]
	if value.var then
		if isChecked then
			zTipSaves[value.var] = true
		else
			zTipSaves[value.var] = false
		end
	end
end
function zTipOption:OnVividMaskClicked()
	zTipOption.OnCheckButtonClicked(self)
	if self:GetChecked() then
		zTip:GetVividMask():Show()
	else
		if GameTooltipMask then GameTooltipMask:Hide() end
	end
end
function zTipOption:OnShowBarTextureClicked()
	zTipOption.OnCheckButtonClicked(self)
	if self:GetChecked() then
		zTip:ChangeBarTexture()
	else
		zTip:ChangeBarTexture()
	end
end
function zTipOption:OnManaBARClicked()
	zTipOption.OnCheckButtonClicked(self)
	if(GameTooltipManaBar) then 
		if self:GetChecked() then
			GameTooltipManaBar.pauseUpdates = false
		else
			GameTooltipManaBar.pauseUpdates = true
		end
	end
end
function zTipOption:OnShowBarNumClicked()
	zTipOption.OnCheckButtonClicked(self)
	if(GameTooltipManaBar) then 
		GameTooltipManaBar.unit = nil 
		if self:GetChecked() then
			GameTooltipManaBar.lockShow = 1
		else
			GameTooltipManaBar.lockShow = 0
		end
	end
	if self:GetChecked() then
		GameTooltipStatusBar.lockShow = 1
	else
		GameTooltipStatusBar.lockShow = 0
	end
	TextStatusBar_OnValueChanged(GameTooltipStatusBar)
	GameTooltipStatusBar:Hide()
end

function zTipOption:OnAnchorChanged()

	local i
	for i = 0, 4 do
		local data = zTipOption.Buttons[i + zTipOptionFollowCursor:GetID()]
		local button = _G["zTipOption"..data.name]
		if button == self then
			button:SetChecked(1)
			zTipSaves.Anchor = data.anchor
		else
			button:SetChecked(nil)
		end

	end

	-- The original code was, to be franky, way too ugly that I couldn't even convince myself to leave them commented out...

end

function zTipOption:OnScaleChanged(value)
	local scale = math.floor(value*100)/100
	self:SetDisplayValue(scale)
	if scale == 0 then scale = 0.01 end
	zTipSaves.Scale = scale
	GameTooltip:SetScale(scale)
	self.text:SetText(self.title.." : "..math.floor(scale*100).."%")
	zTipOptionScaleBox:SetText(format("%.2f",scale))
end

function zTipOption:ScaleBoxChanged()
	local num = self:GetText()
	if not num then return end
	num = tonumber(num)
	if not num then return end
	value = zTipOption.Buttons[self:GetID()]
	zTipSaves[value.var] = num
	GameTooltip:SetScale(num)
	zTipOptionScale.text:SetText(zTipOptionScale.title.." : "..math.floor(num).."%")
	zTipOptionScale:SetValue(num)
	self:ClearFocus()
end

function zTipOption:CheckButton_OnEnter(button,name,message)
	GameTooltip:SetOwner(button,"ANCHOR_NONE");
	GameTooltip:SetPoint("BOTTOMLEFT",button,"TOPRIGHT")
	GameTooltip:AddLine(name);
	GameTooltip:AddLine(message,1,1,1);
	GameTooltip:Show()
end

function zTipOption:OnEditBoxEnterPressed()
	local num = self:GetText()
	if not num then return end
	num = tonumber(num)
	if not num then return end
	value = zTipOption.Buttons[self:GetID()]
	zTipSaves[value.var] = num
end
--[[
	read options
--]]
function zTipOption:SetAnchor(followcursor, rootontop, oncursortop, rightbottom)
	zTipOptionFollowCursor:SetChecked(followcursor)
	zTipOptionRootOnTop:SetChecked(rootontop)
	zTipOptionOnCursorTop:SetChecked(oncursortop)
	zTipOptionRightBottom:SetChecked(rightbottom)
end
function zTipOption:LoadOptions()
	local button
	for key, value in ipairs(zTipOption.Buttons) do
		button = _G["zTipOption"..value.name]
		if value.type == "CheckButton" then
			if value.var then
				button:SetChecked(zTipSaves[value.var])
			end
		elseif value.type == "Slider" then
			button:SetValue(zTipSaves[value.var])
		elseif value.type == "EditBox" then
			button:SetText(format("%.2f",zTipSaves[value.var]))
		end
	end
	-- for anchor
	local anchor = zTipSaves["Anchor"]
	local result = {false,false,false,false}
	if anchor then
		if anchor > 2 then
			anchor = anchor - 3
		else
			result[4] = true
		end
		result[anchor+1] = true
	end
	self:SetAnchor(unpack(result))
end
