local _, ItemProfConstants = ...

local frame = CreateFrame( "Frame" )
frame.name = "ItemTooltipIconConfig"

local profsCheck
local questCheck
local vendorCheck
local iconSizeSlider
local iconSizeLabel
local iconDemoTexture

local PROF_CHECK = {}
local QUEST_CHECK = {}

local configDefaultShowProfs = true
local configDefaultShowQuests = true
local configDefaultProfFlags = 0xFF
local configDefaultQuestFlags = 0x1FFFFF
local configDefaultIncludeVendor = false
local configDefaultIconSize = 16

local userVariables



local function SaveAndQuit() 

	local profFlags = 0
	-- Ignore the profession flags if master profession checkbox is unchecked
	for i=0, 7 do
		local bitMask = bit.lshift( 1, i )
		local isChecked = PROF_CHECK[ bitMask ]:GetChecked()
		if isChecked then
			profFlags = profFlags + bitMask
		end
	end
	
	local questFlags = 1		-- Normal quests flag
	for i=1, 19 do
		local bitMask = bit.lshift( 1, i )
		local isChecked = QUEST_CHECK[ bitMask ]:GetChecked()
		if isChecked then
			questFlags = questFlags + bitMask
		end
	end
	
	
	userVariables.showProfs = profsCheck:GetChecked()
	userVariables.showQuests = questCheck:GetChecked()
	userVariables.profFlags = profFlags
	userVariables.questFlags = questFlags
	userVariables.includeVendor = vendorCheck:GetChecked()
	userVariables.iconSize = iconSizeSlider:GetValue()

	ItemProfConstants:ConfigChanged()
end



local function ToggleProfCheckbox() 

	local isChecked = profsCheck:GetChecked()
	-- How do I call as a stored function CheckButton:Enable()?
	for k,v in pairs( PROF_CHECK ) do
		if isChecked then
			v:Enable()
		else
			v:Disable()
		end
	end
	
end


local function ToggleQuestCheckbox() 

	local isChecked = questCheck:GetChecked()
	if isChecked then
		for k,v in pairs( QUEST_CHECK ) do
			v:Enable()
		end
	else
		for k,v in pairs( QUEST_CHECK ) do
			v:Disable()
		end
	end
	
end


local function RefreshWidgets()

	-- Sync the widgets state with the config variables
	profsCheck:SetChecked( userVariables.showProfs )
	questCheck:SetChecked( userVariables.showQuests )
	vendorCheck:SetChecked( userVariables.includeVendor )
	local profFlags = userVariables.profFlags
	local questFlags = userVariables.questFlags
	iconSizeSlider:SetValue( userVariables.iconSize )
	
	-- Update the profession checkboxes
	for i=0, 7 do
		local bitMask = bit.lshift( 1, i )
		local isSet = bit.band( profFlags, bitMask )
		PROF_CHECK[ bitMask ]:SetChecked( isSet ~= 0 )
	end

	-- Update the quest checkboxes
	for i=1, 19 do
		local bitMask = bit.lshift( 1, i )
		local isSet = bit.band( questFlags, bitMask )
		QUEST_CHECK[ bitMask ]:SetChecked( isSet ~= 0 )
	end
	
	-- Set checkboxes enabled/disabled
	ToggleProfCheckbox()
	ToggleQuestCheckbox()
end


local function IconSizeChanged( self, value ) 

	-- Called when the icon slider widget changes value
	iconDemoTexture:SetSize( value, value )
	iconSizeLabel:SetText( value )
end


local function InitVariables()
	
	local configRealm = ItemProfConstants.configTooltipIconsRealm
	local configChar = ItemProfConstants.configTooltipIconsChar
	
	
	if not ItemTooltipIconsConfig then
		ItemTooltipIconsConfig = {}
	end
	
	if not ItemTooltipIconsConfig[ configRealm ] then
		ItemTooltipIconsConfig[ configRealm ] = {}
	end
	
	if not ItemTooltipIconsConfig[ configRealm ][ configChar ] then
		ItemTooltipIconsConfig[ configRealm ][ configChar ] = {}
	end
	
	userVariables = ItemTooltipIconsConfig[ configRealm ][ configChar ]
	
	if userVariables.showProfs == nil then
		userVariables.showProfs = configDefaultShowProfs
	end
	
	if userVariables.showQuests == nil then
		userVariables.showQuests = configDefaultShowQuests
	end
	
	if userVariables.profFlags == nil then
		userVariables.profFlags = configDefaultProfFlags
	end
	
	if userVariables.questFlags == nil then
		userVariables.questFlags = configDefaultQuestFlags
	end
	
	if userVariables.includeVendor == nil then
		userVariables.includeVendor = configDefaultIncludeVendor
	end
	
	if userVariables.iconSize == nil then
		userVariables.iconSize = configDefaultIconSize
	end
	
	
	RefreshWidgets()
	ItemProfConstants:ConfigChanged()
end


local function CreateCheckbox( name, x, y, label, tooltip )

	local check = CreateFrame( "CheckButton", name, frame, "ChatConfigCheckButtonTemplate" ) --"OptionsCheckButtonTemplate" )
	_G[ name .. "Text" ]:SetText( label )
	check.tooltip = tooltip
	check:SetPoint( "TOPLEFT", x, y )

	return check
end


local dialogHeader = frame:CreateFontString( nil, "OVERLAY", "GameTooltipText" )
dialogHeader:SetFont( "Fonts\\ARHei.TTF", 10, "THINOUTLINE" )
dialogHeader:SetPoint( "TOPLEFT", 20, -20 )
dialogHeader:SetText( "These options allow you control which icons are displayed on the item tooltips.\nThe quest icon can be filtered to display on items needed for quests of specific class/profession." )


profsCheck = CreateCheckbox( "ItemTooltipIconsConfigCheck0", 20, -50, " 启用专业图标", "If enabled profession icons will be displayed on items that are crafting materials" )
profsCheck:SetScript( "OnClick", ToggleProfCheckbox )

PROF_CHECK[ 1 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck0a", 45, -70, " 烹饪", nil )
PROF_CHECK[ 2 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck0b", 45, -90, " 急救", nil )
PROF_CHECK[ 4 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck0c", 45, -110, " 炼金", nil )
PROF_CHECK[ 8 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck0d", 45, -130, " 锻造", nil )
PROF_CHECK[ 16 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck0e", 245, -70, " 附魔", nil )
PROF_CHECK[ 32 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck0f", 245, -90, " 工程", nil )
PROF_CHECK[ 64 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck0g", 245, -110, " 制皮", nil )
PROF_CHECK[ 128 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck0h", 245, -130, " 裁缝", nil )


questCheck = CreateCheckbox( "ItemTooltipIconsConfigCheck1", 20, -180, " 启用任务图标", "If enabled quest icons will be displayed on items that are needed by quests" )
questCheck:SetScript( "OnClick", ToggleQuestCheckbox )

QUEST_CHECK[ 0x00002 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1b", 45, -200, " 联盟", nil )
QUEST_CHECK[ 0x00004 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1c", 45, -220, " 部落", nil )


local classQuestLabel = frame:CreateFontString( "ClassQuestLabel", "OVERLAY", "GameTooltipText" )
classQuestLabel:SetFont( "Fonts\\ARHei.TTF", 14, "THINOUTLINE" )
classQuestLabel:SetPoint( "TOPLEFT", 45, -255 )
classQuestLabel:SetTextColor( 1, 0.85, 0.15 )
classQuestLabel:SetText( "Class Quests" )

QUEST_CHECK[ 0x00008 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1d1", 45, -270, " 德鲁伊", nil )
QUEST_CHECK[ 0x00010 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1d2", 45, -290, " 猎人", nil )
QUEST_CHECK[ 0x00020 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1d3", 45, -310, " 法师", nil )
QUEST_CHECK[ 0x00040 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1d4", 245, -270, " 圣骑士", nil )
QUEST_CHECK[ 0x00080 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1d5", 245, -290, " 牧师", nil )
QUEST_CHECK[ 0x00100 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1d6", 245, -310, " 盗贼", nil )
QUEST_CHECK[ 0x00200 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1d7", 445, -270, " 萨满祭司", nil )
QUEST_CHECK[ 0x00400 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1d8", 445, -290, " 术士", nil )
QUEST_CHECK[ 0x00800 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1d9", 445, -310, " 战士", nil )



local profQuestLabel = frame:CreateFontString( "ProfQuestLabel", "OVERLAY", "GameTooltipText" )
profQuestLabel:SetFont( "Fonts\\ARHei.TTF", 14, "THINOUTLINE" )
profQuestLabel:SetPoint( "TOPLEFT", 45, -345 )
profQuestLabel:SetTextColor( 1, 0.85, 0.15 )
profQuestLabel:SetText( "专业任务" )

QUEST_CHECK[ 0x01000 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1e1", 45, -360, " 烹饪", nil )
QUEST_CHECK[ 0x02000 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1e2", 45, -380, " 急救", nil )
QUEST_CHECK[ 0x04000 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1e3", 45, -400, " 炼金", nil )
QUEST_CHECK[ 0x08000 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1e4", 45, -420, " 锻造", nil )
QUEST_CHECK[ 0x10000 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1e5", 245, -360, " 附魔", nil )
QUEST_CHECK[ 0x20000 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1e6", 245, -380, " 工程", nil )
QUEST_CHECK[ 0x40000 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1e7", 245, -400, " 制皮", nil )
QUEST_CHECK[ 0x80000 ] = CreateCheckbox( "ItemTooltipIconsConfigCheck1e8", 245, -420, " 裁缝", nil )


vendorCheck = CreateCheckbox( "ItemTooltipIconsConfigCheck2", 20, -470, " 供应商物品", "Display icons on items sold by vendors" )


iconSizeSlider = CreateFrame( "Slider", "ItemTooltipIconsConfigSlider0", frame, "OptionsSliderTemplate" )
iconSizeSlider:SetPoint( "TOPLEFT", 20, -520 )
iconSizeSlider:SetMinMaxValues( 8, 32 )
iconSizeSlider:SetValueStep( 1 )
iconSizeSlider:SetStepsPerPage( 1 )
iconSizeSlider:SetWidth( 200 )
iconSizeSlider:SetObeyStepOnDrag( true )
iconSizeSlider:SetScript( "OnValueChanged", IconSizeChanged )
_G[ "ItemTooltipIconsConfigSlider0Text" ]:SetText( "图标大小" )
_G[ "ItemTooltipIconsConfigSlider0Low" ]:SetText( nil )
_G[ "ItemTooltipIconsConfigSlider0High" ]:SetText( nil )

iconSizeLabel = frame:CreateFontString( nil, "OVERLAY", "GameTooltipText" )
iconSizeLabel:SetFont( "Fonts\\ARHei.TTF", 12, "THINOUTLINE" )
iconSizeLabel:SetPoint( "TOPLEFT", 225, -522 )

iconDemoTexture = frame:CreateTexture( nil, "OVERLAY" )
iconDemoTexture:SetPoint( "TOPLEFT", 300, -520 )
iconDemoTexture:SetTexture( GetSpellTexture( 4036 ) )


frame.okay = SaveAndQuit
frame:SetScript( "OnShow", RefreshWidgets )
frame:SetScript( "OnEvent", InitVariables )
frame:RegisterEvent( "VARIABLES_LOADED" )


InterfaceOptions_AddCategory( frame )