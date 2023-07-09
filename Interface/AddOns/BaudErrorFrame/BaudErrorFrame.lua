BaudErrorList = {};
local SelectedError = 1;
local SoundTime = 0;
local QueueError = {};
local EnableSound = true;

function BaudErrorFrame_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("ADDON_ACTION_BLOCKED");
	this:RegisterEvent("MACRO_ACTION_BLOCKED");
	this:RegisterEvent("ADDON_ACTION_FORBIDDEN");
	UIParent:UnregisterEvent("ADDON_ACTION_FORBIDDEN");
	this:RegisterEvent("MACRO_ACTION_FORBIDDEN");
	UIParent:UnregisterEvent("MACRO_ACTION_FORBIDDEN");

	tinsert(UISpecialFrames,this:GetName());

	SlashCmdList["BaudErrorFrame"] = function()
		if BaudErrorFrame:IsShown() then
			BaudErrorFrame:Hide()
		else
			BaudErrorFrame:Show();
		end
	end
	SLASH_BaudErrorFrame1 = "/bauderror";
	SLASH_BaudErrorFrame2 = "/error";
	seterrorhandler(BaudErrorFrameHandler);
end

function BaudErrorFrame_OnEvent()
	if(event=="VARIABLES_LOADED")then
		if(type(BaudErrorFrameConfig)~="table")then
			BaudErrorFrameConfig = {};
		end
  
		for Key, Value in ipairs(QueueError)do
			BaudErrorFrameShowError(Value);
		end
		QueueError = nil;
	elseif (event=="ADDON_ACTION_BLOCKED") then
		BaudErrorFrameAdd(arg1.." 被阻止使用 "..arg2,4);
	elseif (event=="MACRO_ACTION_BLOCKED") then
		BaudErrorFrameAdd("宏被阻止使用 "..arg1,4);
	elseif (event=="ADDON_ACTION_FORBIDDEN") then
		BaudErrorFrameAdd(arg1.." 禁止使用 "..arg2.." (仅限暴雪使用)",4);
	elseif (event=="MACRO_ACTION_FORBIDDEN") then
		BaudErrorFrameAdd("宏被禁止使用 "..arg1.." (仅限暴雪使用)",4);
	end
end

function BaudErrorFrameMinimapButton_OnEnter()
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT", 0, -10);
	GameTooltip:ClearLines()
	GameTooltip:AddLine("Lua错误")
	GameTooltip:AddLine("Lua错误报告", .3, 1, .6)
	GameTooltip:Show();
end

function BaudErrorFrameMinimapButton_OnLeave()
	GameTooltip:Hide();
end

function BaudErrorFrameMinimapButton_OnShow()
	this:ClearAllPoints();
	if diminfopanel then
		this:SetPoint("LEFT", diminfo_Time, "RIGHT", 20, -1);
	else
		this:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -55, 13);
	end
end

function BaudErrorFrameHandler(Error)
	BaudErrorFrameAdd(Error,3);
end

function BaudErrorFrameShowError(Error)
	if(GetTime() > SoundTime) and EnableSound then
		PlaySoundFile("Interface\\AddOns\\BaudErrorFrame\\error.mp3");
		SoundTime = GetTime() + 1;
	end
end

function BaudErrorFrameAdd(Error, Retrace)
	for Key, Value in pairs(BaudErrorList)do
		if(Value.Error==Error)then
			if(Value.Count < 99)then
				Value.Count = Value.Count + 1;
				BaudErrorFrameEditBoxUpdate();
			end
			return;
		end
	end
	if BaudErrorFrameConfig then
		BaudErrorFrameShowError(Error);
	else
		tinsert(QueueError, Error);
	end
	tinsert(BaudErrorList,{Error=Error,Count=1,Stack=debugstack(Retrace)});
	BaudErrorFrameMinimapCount:SetText("报错"..getn(BaudErrorList));	
	BaudErrorFrameMinimapButton:Show();
	BaudErrorFrameScrollBar_Update();
end

function BaudErrorFrame_Select(Index)
	SelectedError = Index;
	BaudErrorFrameScrollBar_Update();
	BaudErrorFrameDetailScrollFrameScrollBar:SetValue(0);
end

function BaudErrorFrame_OnShow()
	BaudErrorFrameScrollBar_Update();
end

function BaudErrorFrame_OnHide() end

function BaudErrorFrameEntry_OnClick()
	BaudErrorFrame_Select(this:GetID());
end

function BaudErrorFrameClearButton_OnClick()
	BaudErrorList = {};
	BaudErrorFrameMinimapButton:Hide();
	this:GetParent():Hide();
end

function BaudErrorFrameScrollValue()
	if BaudErrorList and type(BaudErrorList)=="table"then
		local value=getn(BaudErrorList)
		return value
	end
end

function BaudErrorFrameScrollBar_Update()
	if not BaudErrorFrame:IsShown() then return end
	local Index, Button, ButtonText, Text;

	local Frame = BaudErrorFrameListScrollBox;
	local FrameName = Frame:GetName();
	local ScrollBar = getglobal(FrameName.."ScrollBar");
	local Highlight = getglobal(FrameName.."Highlight");
	local Total = getn(BaudErrorList);
	FauxScrollFrame_Update(ScrollBar,Total,Frame.Entries,16);
	Highlight:Hide();
	for Line = 1, Frame.Entries do
		Index = Line + FauxScrollFrame_GetOffset(ScrollBar);
		Button = getglobal(FrameName.."Entry"..Line);
		ButtonText = getglobal(FrameName.."Entry"..Line.."Text");
		if(Index <= Total)then
			Button:SetID(Index);
			ButtonText:SetText(BaudErrorList[Index].Error);
			Button:Show();
			if(Index==SelectedError)then
				Highlight:SetPoint("TOP",Button);
				Highlight:Show();
			end
		else
			Button:Hide();
		end
	end
	BaudErrorFrameEditBoxUpdate();
end

function BaudErrorFrameEditBoxUpdate()
	if BaudErrorList[SelectedError]then
		BaudErrorFrameEditBox.TextShown = BaudErrorList[SelectedError].Error.."\n数量: "..BaudErrorList[SelectedError].Count.."\n\n调用堆栈:\n"..BaudErrorList[SelectedError].Stack;
	else
		BaudErrorFrameEditBox.TextShown = "";
	end
	BaudErrorFrameEditBox:SetText(BaudErrorFrameEditBox.TextShown);
end

function BaudErrorFrameEditBox_OnTextChanged(this)
	if(this:GetText()~=this.TextShown)then
		this:SetText(this.TextShown);
		this:ClearFocus();
		return;
	end
	BaudErrorFrameDetailScrollFrame:UpdateScrollChildRect();
end

function BaudErrorFrameEditBox_OnTextSet() end