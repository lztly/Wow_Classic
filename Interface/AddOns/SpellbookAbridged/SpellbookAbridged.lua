SpellBookList = {};  --- Stores the Filtered Spell List
local RankFilter = true;
local SBA_SkillLines = {}; --- Stores offset and number of Spells data for the SpellTabs/SkillLines.
local SpellsChanged = true; -- Flags when SpellBookFrame_Update needs the list rebuilt.

function SpellBookAbridged_OnLoad(self)
--- Can't append to OnLoad Event.
	--- Ensure the SpellList is properly generated when starting
	self:RegisterEvent("PLAYER_LOGIN");
	
	--- These are the events SpellBookFrame watches.
	self:RegisterEvent("SPELLS_CHANGED");
	self:RegisterEvent("LEARNED_SPELL_IN_TAB");
	
	getglobal(RankFilterButton:GetName() .. "Text"):SetText("法术等级过滤");
end

function SpellBookAbridged_OnEvent()
	-- When Spells change or such, set flag so the next time SpellBookFrame_Update function is called.
	SpellsChanged = true;
end

function RankFilterButton_OnClick()
	SpellBookAbridged_CreateSpellList();
	if (SpellBookFrame:IsVisible()) then
		SpellBookFrame_Update();
	end
end

function SpellBookAbridged_CreateSpellList()
--- Generates Spell List after the Spells change
	local spellList = {};
	--- Get Skill Line info and total number of spells
	
	-- numSkillTabs = GetNumSpellTabs();
	
	SBA_numSpells = 0;
	SBA_offset = 0;
	savedName = nil;
	savedRank = nil;
	countRank = 0;
	
	--- Process SpellBook and SkillLine info
	for i = 1, MAX_SKILLLINE_TABS do
		--- For Each SkillLine, get the official data
		_, _, offset, numSpells = GetSpellTabInfo(i);
		
		--- Set offset for the Abridged version's SkillLine
		SBA_offset = SBA_numSpells;
		
		--- Go to first spell of the SkillLine and set last spell of SkillLine
		total = offset + numSpells;
		offset = offset + 1;
		
		--- For each spell in the SkillLine
		for slot = offset, total do
			--- Grab name information
			name, rank = GetSpellBookItemName(slot, "spell");
			
			--- if not a new Spell Name
			if ((name == savedName) and RankFilterButton:GetChecked()) then
				--- then count the rank
				countRank = countRank + 1;
			else
				--- else, add a spell, and set up for next spell
				SBA_numSpells = SBA_numSpells + 1;
				countRank = 1;
				savedName = name;
			end
			
			--- store real slot and number of ranks counted in current spellList slot
			spellList[SBA_numSpells] = {slot, countRank};
		end
		
		--- Store the Abridged SkillLine info
		newTotal = SBA_numSpells - SBA_offset;
		
		SBA_SkillLines[i] = {SBA_offset, newTotal};
	end

	SpellBookList = nil;
	SpellBookList = spellList;

end

function SpellBookAbridged_GetSpellTabInfo(tab)
--- Replaces GetSpellTabInfo in SpellBookFrame so it pulls the filtered SpellList's data
--- The Filtered SpellList has different number of spells and offsets, so replace this part of the SkillLine data
		
	--- Grab SpellTab's info
	local name, texture, _,_, isGuild, offSpecID, shouldHide, specID = GetSpellTabInfo(tab);
	local tabInfo = SBA_SkillLines[tab];

	return name, texture, tabInfo[1], tabInfo[2], isGuild, offSpecID, shouldHide, specID;
end

function SpellBookAbridged_GetSpellBookItemInfo(slot, bookType)
	--- Originally, the SpellBook will grab an offset calculated slot that is the actual spell in WoW API's SpellList
	--- As such, that slot was the spell's slot number.  So, SpellBookFrame doesn't generate it.
	
	--- Because the SpellBookFrame slot refers to a slot in the Filtered SpellList,
	--- we need to return the correct spell slot in addition to the rest of the info.
	realSlot = SpellBookList[slot];
	return realSlot[1], GetSpellBookItemInfo(realSlot[1],bookType);
end


--- Functions to replace SpellBookFrame's functions

origSpellBookFrame_Update = SpellBookFrame_Update;
SpellBookFrame_Update = function()
	-- Trying not to rebuild the list every time SpellBookFrame_Update occurs,
	-- but the List needs to be built before SpellBookFrame_Update gets called in
	-- the event.
	if (SpellsChanged == true) then
		SpellBookAbridged_CreateSpellList();
		SpellsChanged = false;
	end
	origSpellBookFrame_Update();
end

SpellButton_UpdateButton = function(self)
	if ( not SpellBookFrame.selectedSkillLine ) then
		SpellBookFrame.selectedSkillLine = 2;
	end
	--- Replaced GetSpellTabInfo
	local _, _, offset, numSlots, _, offSpecID, shouldHide, specID = SpellBookAbridged_GetSpellTabInfo(SpellBookFrame.selectedSkillLine);
	SpellBookFrame.selectedSkillLineNumSlots = numSlots;
	SpellBookFrame.selectedSkillLineOffset = offset;
	
	if (not self.SpellName.shadowX) then
		self.SpellName.shadowX, self.SpellName.shadowY = self.SpellName:GetShadowOffset();
	end

	local slot, slotType, slotID = SpellBook_GetSpellBookSlot(self);
	local name = self:GetName();
	local iconTexture = _G[name.."IconTexture"];
	local spellString = _G[name.."SpellName"];
	local subSpellString = _G[name.."SubSpellName"];
	local cooldown = _G[name.."Cooldown"];
	local autoCastableTexture = _G[name.."AutoCastable"];
	local slotFrame = _G[name.."SlotFrame"];
	local normalTexture = _G[name.."NormalTexture"];
	local highlightTexture = _G[name.."Highlight"];
	local texture;
	if ( slot ) then
		texture = GetSpellTexture(slot, SpellBookFrame.bookType);
	end

	-- If no spell, hide everything and return, or kiosk mode and future spell
	if ( not texture or (strlen(texture) == 0) or (slotType == "FUTURESPELL" and IsKioskModeEnabled())) then
		iconTexture:Hide();
		spellString:Hide();
		subSpellString:Hide();
		cooldown:Hide();
		autoCastableTexture:Hide();
		SpellBook_ReleaseAutoCastShine(self.shine);
		self.shine = nil;
		highlightTexture:SetTexture("Interface\\Buttons\\ButtonHilight-Square");
		self:SetChecked(false);
		self:Disable();
		normalTexture:SetVertexColor(1.0, 1.0, 1.0);
		highlightTexture:SetTexture("Interface\\Buttons\\ButtonHilight-Square");
		return;
	else
		self:Enable();
	end

	SpellButton_UpdateCooldown(self);

	local autoCastAllowed, autoCastEnabled = GetSpellAutocast(slot, SpellBookFrame.bookType);
	if ( autoCastAllowed ) then
		autoCastableTexture:Show();
	else
		autoCastableTexture:Hide();
	end
	if ( autoCastEnabled and not self.shine ) then
		self.shine = SpellBook_GetAutoCastShine();
		self.shine:Show();
		self.shine:SetParent(self);
		self.shine:SetPoint("CENTER", self, "CENTER");
		AutoCastShine_AutoCastStart(self.shine);
	elseif ( autoCastEnabled ) then
		self.shine:Show();
		self.shine:SetParent(self);
		self.shine:SetPoint("CENTER", self, "CENTER");
		AutoCastShine_AutoCastStart(self.shine);
	elseif ( not autoCastEnabled ) then
		SpellBook_ReleaseAutoCastShine(self.shine);
		self.shine = nil;
	end

	local spellName, _, spellID = GetSpellBookItemName(slot, SpellBookFrame.bookType);
	local isPassive = IsPassiveSpell(slot, SpellBookFrame.bookType);
	self.isPassive = isPassive;
	
	iconTexture:SetTexture(texture);
	spellString:SetText(spellName);

	self.SpellSubName:SetHeight(6);
	subSpellString:SetText("");
	if spellID then
		local spell = Spell:CreateFromSpellID(spellID);
		spell:ContinueOnSpellLoad(function()
			local subSpellName = spell:GetSpellSubtext();
			if ( subSpellName == "" ) then
				if ( isPassive ) then
					subSpellName = SPELL_PASSIVE;
				end
			end

			subSpellString:SetText(subSpellName);
		end);
	end

	if ( subSpellName == "" ) then
		spellString:SetPoint("LEFT", self, "RIGHT", 5, 1);
	else
		spellString:SetPoint("LEFT", self, "RIGHT", 5, 3);
	end

	iconTexture:Show();
	spellString:Show();
	subSpellString:Show();

	if ( isPassive ) then
		normalTexture:SetVertexColor(0, 0, 0);
		highlightTexture:SetTexture("Interface\\Buttons\\UI-PassiveHighlight");
		spellString:SetTextColor(PASSIVE_SPELL_FONT_COLOR.r, PASSIVE_SPELL_FONT_COLOR.g, PASSIVE_SPELL_FONT_COLOR.b);
	else
		normalTexture:SetVertexColor(1.0, 1.0, 1.0);
		highlightTexture:SetTexture("Interface\\Buttons\\ButtonHilight-Square");
		spellString:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	end

		SpellButton_UpdateSelection(self);
end

SpellBook_GetCurrentPage = function()
	local currentPage, maxPages;
	local numPetSpells = HasPetSpells() or 0;
	if ( SpellBookFrame.bookType == BOOKTYPE_PET ) then
		currentPage = SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET];
		maxPages = ceil(numPetSpells/SPELLS_PER_PAGE);
	elseif ( SpellBookFrame.bookType == BOOKTYPE_SPELL) then
		currentPage = SPELLBOOK_PAGENUMBERS[SpellBookFrame.selectedSkillLine];
		--- Replaced GetSpellTabInfo
		local _, _, _, numSlots = SpellBookAbridged_GetSpellTabInfo(SpellBookFrame.selectedSkillLine);
		maxPages = ceil(numSlots/SPELLS_PER_PAGE);
	end
	return currentPage, maxPages;
end

SpellBook_GetSpellBookSlot = function(spellButton)
	local id = spellButton:GetID()
	if ( SpellBookFrame.bookType == BOOKTYPE_PET ) then
		local slot = id + (SPELLS_PER_PAGE * (SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET] - 1));
		if ( SpellBookFrame.numPetSpells and slot <= SpellBookFrame.numPetSpells) then
		--- Not Modifying Pet Spellbook yet.
		local slotType, slotID = GetSpellBookItemInfo(slot, SpellBookFrame.bookType);
		return slot, slotType, slotID;
		end
	else
		local relativeSlot = id + ( SPELLS_PER_PAGE * (SPELLBOOK_PAGENUMBERS[SpellBookFrame.selectedSkillLine] - 1));
		if ( SpellBookFrame.selectedSkillLineNumSlots and relativeSlot <= SpellBookFrame.selectedSkillLineNumSlots) then
			--- Replaced GetSpellBookItemInfo and added line to pull correct slot.
			local tempSlot = SpellBookFrame.selectedSkillLineOffset + relativeSlot;
			local slot, slotType, slotID = SpellBookAbridged_GetSpellBookItemInfo(tempSlot, SpellBookFrame.bookType);
			return slot, slotType, slotID;
		end
	end
	return nil, nil, nil;
end

SpellBookFrame_UpdateSkillLineTabs = function()
	local numSkillLineTabs = GetNumSpellTabs();
	for i=1, MAX_SKILLLINE_TABS do
		local skillLineTab = _G["SpellBookSkillLineTab"..i];
		local prevTab = _G["SpellBookSkillLineTab"..i-1];
		if ( i <= numSkillLineTabs and SpellBookFrame.bookType == BOOKTYPE_SPELL ) then
			--- Replaced GetSpellTabInfo
			local name, texture, _, _, isGuild, offSpecID, shouldHide, specID = SpellBookAbridged_GetSpellTabInfo(i);
			
			if ( shouldHide ) then
				_G["SpellBookSkillLineTab"..i.."Flash"]:Hide();
				skillLineTab:Hide();
			else
				skillLineTab:SetNormalTexture(texture);
				skillLineTab.tooltip = name;
				skillLineTab:Show();

				-- Set the selected tab
				if ( SpellBookFrame.selectedSkillLine == i ) then
					skillLineTab:SetChecked(true);
				else
					skillLineTab:SetChecked(false);
				end
			end
		else
			_G["SpellBookSkillLineTab"..i.."Flash"]:Hide();
			skillLineTab:Hide();
		end
	end
end

SpellBook_UpdatePlayerTab = function()
	-- Setup skillline tabs
	--- Replaced GetSpellTabInfo
	local _, _, offset, numSlots = SpellBookAbridged_GetSpellTabInfo(SpellBookFrame.selectedSkillLine);
	SpellBookFrame.selectedSkillLineOffset = offset;
	SpellBookFrame.selectedSkillLineNumSlots = numSlots;
	
	SpellBookFrame_UpdatePages();

	SpellBookFrame_UpdateSkillLineTabs();

	SpellBookFrame_UpdateSpells();
end

SpellBookFrame_OpenToPageForSlot = function(realSlot, reason)
	local alreadyOpen = SpellBookFrame:IsShown();
	SpellBookFrame.bookType = BOOKTYPE_SPELL;
	ShowUIPanel(SpellBookFrame);
	if (SpellBookFrame.selectedSkillLine ~= 2) then
		SpellBookFrame.selectedSkillLine = 2;
		SpellBookFrame_Update();
	end

	if (alreadyOpen and reason == OPEN_REASON_PENDING_GLYPH) then
		local page = SPELLBOOK_PAGENUMBERS[SpellBookFrame.selectedSkillLine];
		for i = 1, 12 do
			--- Replaced GetSpellBookItemInfo and added line to select correct spell
			local tempSlot = (i + ( SPELLS_PER_PAGE * (page - 1))) + SpellBookFrame.selectedSkillLineOffset;
			local slot, slotType, spellID = SpellBookAbridged_GetSpellBookItemInfo(tempSlot, SpellBookFrame.bookType);
			if (slotType == "SPELL") then
				if (IsSpellValidForPendingGlyph(spellID)) then
					SpellBookFrame_Update();
					return;
				end
			end
		end
	end

	--- Replaced GetSpellBookItemInfo
	local slot, slotType, spellID = SpellBookAbridged_GetSpellBookItemInfo(realSlot, SpellBookFrame.bookType);
	local relativeSlot = slot - SpellBookFrame.selectedSkillLineOffset;
	local page = math.floor((relativeSlot - 1)/ SPELLS_PER_PAGE) + 1;
	SPELLBOOK_PAGENUMBERS[SpellBookFrame.selectedSkillLine] = page;
	SpellBookFrame_Update();
end