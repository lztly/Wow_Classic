--[[ ---------------------------------------------------------------------------
Name:	SimpleUnitFrames
Author:	Pneumatus
About:	An extension to the default WoW Unit Frames. Rather than a complete
		unitframe replacement, this addon adds further information and features
		to the existing frames and allows a greater degree of customization to
		enhance their usability.
----------------------------------------------------------------------------- ]]

local SUF = LibStub("AceAddon-3.0"):GetAddon("SimpleUnitFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("SimpleUnitFrames")
local TO = SUF:NewModule("TextOverlay", "AceEvent-3.0", "AceHook-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local LCMH1 = LibStub("LibClassicMobHealth-1.0")
local RMH = RealMobHealth

local function abbrev(value)
	if abs(value) >= 10000000000 then
		return ("%.1fb"):format(value / 1000000000)
	elseif abs(value) >= 1000000000 then
		return ("%.2fb"):format(value / 1000000000)
	elseif value >= 10000000 or value <= -10000000 then
		return ("%.1fm"):format(value / 1000000)
	elseif value >= 1000000 or value <= -1000000 then
		return ("%.2fm"):format(value / 1000000)
	elseif value >= 100000 or value <= -100000 then
		return ("%.0fk"):format(value / 1000)
	elseif value >= 10000 or value <= -10000 then
		return ("%.1fk"):format(value / 1000)
	else
		return math.floor(value + 0.5) .. ''
	end
end

local function SUFGetUnitHealth(unit)
	if RMH and RMH.IsUnitMob(unit) then
		return RMH.GetUnitHealth(unit)
	end
	return LCMH1:GetUnitHealth(unit)
end

-- Static FontString display styles
local STATIC_STYLES = {
	-- Health Styles
	["HPcurrent"] = {
		type = "HP",
		desc = L["Current HP"],
		fn = function(unit)
			return SUFGetUnitHealth(unit)
		end,
	},
	["HPdeficit"] = {
		type = "HP",
		desc = L["HP Defecit"],
		fn = function(unit)
			local curr, max = SUFGetUnitHealth(unit)
			return curr - max
		end,
	},
	["HPpercent"] = {
		type = "HP",
		desc = L["Percent HP"],
		fn = function(unit)
			local curr, max = UnitHealth(unit), UnitHealthMax(unit)
			return ("%d%%"):format(curr * 100 / (max > 0 and max or 1))
		end,
	},
	["HPcurrmax"] = {
		type = "HP",
		desc = L["Fractional HP"],
		fn = function(unit)
			local curr, max = SUFGetUnitHealth(unit)
			return ("%s/%s"):format(abbrev(curr), abbrev(max))
		end,
	},
	["HPcomplete"] = {
		type = "HP",
		desc = L["Complete HP"],
		fn = function(unit)
			local curr, max = SUFGetUnitHealth(unit)
			local percent = curr * 100 / (max > 0 and max or 1)
			if max == 100 then -- Only return % when the exact HP is not known.
				return ("(%d%%)"):format(percent)
			else
				return ("%s/%s (%d%%)"):format(abbrev(curr), abbrev(max), percent)
			end
		end,
	},
	["HPnone"] = {
		type = "HP",
		desc = L["Blank"],
		fn = function() return "" end,
	},
	-- Mana Styles
	["MPcurrent"] = {
		type = "MP",
		desc = L["Current MP"],
		fn = function(unit)
			local curr, max = UnitPower(unit), UnitPowerMax(unit)
			return max > 0 and curr or "-"
		end,
	},
	["MPdeficit"] = {
		type = "MP",
		desc = L["MP Defecit"],
		fn = function(unit)
			local curr, max = UnitPower(unit), UnitPowerMax(unit)
			return max > 0 and curr - max or ""
		end
	},
	["MPpercent"] = {
		type = "MP",
		desc = L["Percent MP"],
		fn = function(unit)
			local curr, max = UnitPower(unit), UnitPowerMax(unit)
			return max > 0 and ("%d%%"):format(curr * 100 / max) or "-"
		end,
	},
	["MPcurrmax"] = {
		type = "MP",
		desc = L["Fractional MP"],
		fn = function(unit)
			local curr, max = UnitPower(unit), UnitPowerMax(unit)
			return max > 0 and ("%s/%s"):format(abbrev(curr), abbrev(max)) or "-"
		end,
	},
	["MPcomplete"] = {
		type = "MP",
		desc = L["Complete MP"],
		fn = function(unit)
			local curr, max = UnitPower(unit), UnitPowerMax(unit)
			return max > 0 and ("%s/%s (%d%%)"):format(abbrev(curr), abbrev(max), curr * 100 / max) or "-"
		end,
	},
	["MPnone"] = {
		type = "MP",
		desc = L["Blank"],
		fn = function() return "" end,
	},
}

SUF.defaults.global.overlayfont = {
	fontface = "Friz Quadrata TT",
	fontsize = 10,
}

SUF.options.args.general.args.fontface = {
	type = "select",
	name = L["Overlay Font"],
	desc = L["Text Overlay Font"],
	get = function(info) return info.handler.db.global.overlayfont.fontface end,
	set = function(info, val)
		info.handler.db.global.overlayfont.fontface = val
		TO:RefreshFontStrings()
	end,
	dialogControl = "LSM30_Font",
	values = AceGUIWidgetLSMlists.font,
	order = 100,
}
SUF.options.args.general.args.fontsize = {
	type = "range",
	name = L["Overlay Font Size"],
	desc = L["Text Overlay Font Size"],
	get = function(info) return info.handler.db.global.overlayfont.fontsize end,
	set = function(info, value)
		info.handler.db.global.overlayfont.fontsize = value
		TO:RefreshFontStrings()
	end,
	min = 7,
	max = 14,
	step = 1,
	order = 110,
}

local frames = {}
local inVehicle = {}

TO.frameSettings = {}
TO.activeStyles = {}
TO.formatList = { HP = {}, MP = {} }

function TO:OnInitialize()
	-- Copy STATIC_STYLES into self.formatList and self.activeStyles
	for name, style in pairs(STATIC_STYLES) do
		self.formatList[style.type][name] = style.desc
		self.activeStyles[name] = style.fn
	end
	
	for unit, args in pairs(self.frameSettings) do
		self:CreateNewFrame(unit, args)
	end
	
	SUF.db.RegisterCallback(self, "OnProfileChanged", function() self:RefreshFontStrings() end)
	SUF.db.RegisterCallback(self, "OnProfileCopied", function() self:RefreshFontStrings() end)
	SUF.db.RegisterCallback(self, "OnProfileReset", function() self:RefreshFontStrings() end)
	
	LSM.RegisterCallback(self, "LibSharedMedia_Registered", function(event, type, key)
		if type == "font" and key == SUF.db.global.overlayfont.fontface then self:RefreshFontStrings() end
	end)
	LSM.RegisterCallback(self, "LibSharedMedia_SetGlobal", function(event, type)
		if type == "font" then self:RefreshFontStrings() end
	end)
end

function TO:OnEnable()
	self:RegisterEvent("UNIT_HEALTH", "Update")
	self:RegisterEvent("UNIT_MAXHEALTH", "Update")
	self:RegisterEvent("UNIT_POWER_FREQUENT", "Update")
	self:RegisterEvent("UNIT_DISPLAYPOWER", "Update")
	self:RefreshFontStrings()
end

function TO:OnDisable()
end

function TO:CreateNewFrame(unit, args)
	local parent = args.parent
	
	local frame = CreateFrame("Frame", nil, parent)
	frames[unit] = frame
	frame:SetFrameLevel(parent:GetFrameLevel()+3)
	frame.fontStrings = {}
	
	for text, points in pairs(args.text) do
		local fontString = frame:CreateFontString(nil, "OVERLAY")
		frame.fontStrings[text] = fontString
		fontString:SetPoint(unpack(points))
		fontString:SetShadowOffset(1, -1)
		fontString.parent = points[2]
	end
end

function TO:RefreshFontStrings(unit)
	if unit then
		local mappedUnit = SUF.unitMap[unit] or unit
		if mappedUnit and frames[unit] then
			for text, fontString in pairs(frames[unit].fontStrings) do
				fontString:SetFont(LSM:Fetch("font", SUF.db.global.overlayfont.fontface), SUF.db.global.overlayfont.fontsize)
				local style = SUF.db.profile[mappedUnit][text]
				local activeFn = self.activeStyles[style] or function() return "ERROR" end
				fontString:SetText(activeFn(unit))
			end
		end
	else
		for unit, _ in pairs(frames) do
			self:RefreshFontStrings(unit)
		end
	end
end

function TO:Update(event, unit, powerType)
	if powerType and "HAPPINESS" == powerType then return end
	self:RefreshFontStrings(unit)
end

function TO:ToggleOverlay(unit, fs)
	-- Sanity that the FontString exists
	if not frames[unit].fontStrings[fs] then return end
	
	-- Toggle depending on the parent frame"s visibility
	if frames[unit].fontStrings[fs].parent:IsShown() then
		frames[unit].fontStrings[fs]:Show()
	else
		frames[unit].fontStrings[fs]:Hide()
	end
end
