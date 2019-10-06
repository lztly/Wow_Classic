--[[	SlashHelp Options
	by SDPhantom
	http://www.phantomweb.org	]]
------------------------------------------

local name,addon=...;

--------------------------
--[[	Local Settings	]]
--------------------------
RadioboxBaseX=75;
RadioboxBaseY=-6;
CheckboxBaseX=50;
CheckboxBaseY=-36;

--------------------------
--[[	Saved Var Init	]]
--------------------------
SlashHelpOptions={
	SortType="Slash";
	Show={};
};
addon.Options=SlashHelpOptions;

for i,j in ipairs(addon.CommandTypes) do addon.Options.Show[j.ID]=true; end

----------------------------------
--[[	Saved Var Loader	]]
----------------------------------
addon.EventFrame:RegisterEvent("ADDON_LOADED");
addon.EventFrame:HookScript("OnEvent",function(self,event,...)
	if event=="ADDON_LOADED" and (...)==name then
		addon.Options=SlashHelpOptions;

		for i,j in pairs(addon.OptionsFrame.SortGroupButtons) do
			j:SetChecked(i==addon.Options.SortType and 1 or 0);
		end

		for i,j in pairs(addon.OptionsFrame.ShowCheckboxes) do
			j:SetChecked(addon.Options.Show[i] and 1 or 0);
		end
	end
end);

--------------------------
--[[	Options Frame	]]
--------------------------
do
	local frame=CreateFrame("Frame",name.."OptionsFrame",addon.Parent);
	frame:SetWidth(200);
	frame:SetHeight(110);
	frame:SetPoint("BOTTOMLEFT",addon.ListFrame,"BOTTOMRIGHT",-3,0);
	frame:Hide();

	frame:SetBackdrop(addon.FrameBackdrop.Settings);
	frame:SetBackdropBorderColor(unpack(addon.FrameBackdrop.BorderColor));
	frame:SetBackdropColor(unpack(addon.FrameBackdrop.BackgroundColor));

	frame.SortGroupButtons={};
	frame.ShowCheckboxes={};

	local text=frame:CreateFontString(nil,"OVERLAY","GameFontNormalSmall");
	text:SetPoint("TOPLEFT",8,-8);
	text:SetText("排序:");

	text=frame:CreateFontString(nil,"OVERLAY","GameFontNormalSmall");
	text:SetPoint("TOPLEFT",8,-40);
	text:SetText("显示:");

	local function GroupButtonOnClick(self)
		for i,j in pairs(frame.SortGroupButtons) do j:SetChecked(j==self and 1 or 0); end
		addon.Options.SortType=self.ID;
		addon:BuildFilter();
		addon:UpdateFrames();
	end
	for i,j in ipairs(addon.GroupTypes) do
		local btn=CreateFrame("Checkbutton",name.."OptionsFrameRadioButton"..i,frame,"UIRadioButtonTemplate");
		btn:SetPoint("TOPLEFT",RadioboxBaseX,RadioboxBaseY-(i-1)*16);
		btn:SetWidth(16);
		btn:SetHeight(16);

		local text=_G[name.."OptionsFrameRadioButton"..i.."Text"];
		text:SetText(j.Label);

		btn.ID=j.ID;
		btn:SetChecked(1);
		btn:SetScript("OnClick",GroupButtonOnClick);

		frame.SortGroupButtons[j.ID]=btn;
	end

	local function ShowButtonOnClick(self) addon.Options.Show[self.ID]=(self:GetChecked() and true or false);addon:BuildFilter();addon:UpdateFrames(); end
	for i,j in ipairs(addon.CommandTypes) do
		local btn=CreateFrame("Checkbutton",name.."OptionsFrameCheckButton"..i,frame,"UICheckButtonTemplate");
		btn:SetPoint("TOPLEFT",CheckboxBaseX,CheckboxBaseY-(i-1)*16);
		btn:SetWidth(24);
		btn:SetHeight(24);

		local text=_G[name.."OptionsFrameCheckButton"..i.."Text"];
		text:SetTextColor(unpack(j.Color));
		text:SetText(j.Label);

		btn.ID=j.ID;
		btn:SetChecked(1);
		btn:SetScript("OnClick",ShowButtonOnClick);

		frame.ShowCheckboxes[j.ID]=btn;
	end

	addon.OptionsFrame=frame;
end

----------------------------------
--[[	Options Frame Hooks	]]
----------------------------------
hooksecurefunc(addon,"SetOwner",function(self,frame)
	self.OptionsFrame:SetParent(frame);
	self.OptionsFrame:Show();
end)

hooksecurefunc(addon,"ClearOwner",function(self,frame)
	if self.Parent==nil then--	Original function already cleared this
		self.OptionsFrame:Hide();
	end
end)

hooksecurefunc(addon,"RepositionFrames",function(self)
	local cx,cy=UIParent:GetCenter();
	local px,py=self.Parent:GetCenter();

	local vpt,hpt,hrpt=(py>cy and "TOP" or "BOTTOM"),(px>cx and "RIGHT" or "LEFT"),(px>cx and "LEFT" or "RIGHT");

	self.OptionsFrame:ClearAllPoints();
	self.OptionsFrame:SetPoint(vpt..hpt,self.ListFrame,vpt..hrpt,px>cx and 3 or -3,0);
end);
