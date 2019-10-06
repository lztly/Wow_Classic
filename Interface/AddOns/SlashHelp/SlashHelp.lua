--[[	SlashHelp
	by SDPhantom
	http://www.phantomweb.org	]]
------------------------------------------

local name,addon=...;
SlashHelp=addon;

--------------------------
--[[	Local Pointers	]]
--------------------------
local math=math;
local ipairs=ipairs;
local unpack=unpack;
local GameTooltip=GameTooltip;
local UIParent=UIParent;

--------------------------
--[[	Event frame	]]
--------------------------
addon.EventFrame=CreateFrame("Frame");
addon.EventFrame:RegisterEvent("ADDON_LOADED");
addon.EventFrame:SetScript("OnEvent",function(self,event,...)
	if event=="ADDON_LOADED" and (...)==name then
		addon.ListFrame.FilteredList=addon:BuildFilter(nil);--	FilterCache is reused so pointer never changes
	end
end);

--------------------------
--[[	Global settings	]]
--------------------------
addon.MaxListSize=32;

addon.FrameBackdrop={
	Settings={
		bgFile="Interface/Tooltips/UI-Tooltip-Background", 
		edgeFile="Interface/Tooltips/UI-Tooltip-Border",
		tile=true,tileSize=16,edgeSize=16, 
		insets={left=5,right=5,top=5,bottom=5}
	};
	BorderColor={TOOLTIP_DEFAULT_COLOR.r,TOOLTIP_DEFAULT_COLOR.g,TOOLTIP_DEFAULT_COLOR.b};
	BackgroundColor={TOOLTIP_DEFAULT_BACKGROUND_COLOR.r,TOOLTIP_DEFAULT_BACKGROUND_COLOR.g,TOOLTIP_DEFAULT_BACKGROUND_COLOR.b};
};

addon.GroupTypes={
	{ID="Slash"	,Label="按字母顺序"};
	{ID="Group"	,Label="按类型"};
};
for i,j in ipairs(addon.GroupTypes) do addon.GroupTypes[j.ID]=j; end

addon.CommandTypes={
	{ID="Chat"	,Color={0,0.75,0}	,Label="聊天相关"};
	{ID="Emote"	,Color={0.75,0,0.5}	,Label="表情相关"};
	{ID="Secure"	,Color={0.5,0.5,1}	,Label="命令 (受保护)"};
	{ID="Slash"	,Color={0.75,0.5,0}	,Label="命令 (一般)"};
}
for i,j in ipairs(addon.CommandTypes) do addon.CommandTypes[j.ID]=j; end

addon.Parent=ChatFrame1EditBox;

--------------------------
--[[	List Frame	]]
--------------------------
do
	local frame=CreateFrame("Frame",name.."ListFrame",addon.Parent);
	frame:SetPoint("BOTTOMLEFT",addon.Parent,"TOPLEFT",3,-6);
	frame:SetPoint("BOTTOMRIGHT",addon.Parent,"TOPRIGHT",-3,-6);
	frame:SetHeight(400);
	frame:Hide();

	frame:SetBackdrop(addon.FrameBackdrop.Settings);
	frame:SetBackdropBorderColor(unpack(addon.FrameBackdrop.BorderColor));
	frame:SetBackdropColor(unpack(addon.FrameBackdrop.BackgroundColor));

	frame.Offset=0;
	frame.ListItems={};

	local tex=frame:CreateTexture(nil,"OVERLAY");
	tex:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
	tex:SetBlendMode("ADD");
	tex:SetVertexColor(1,0.875,0,0.75);
	frame.Highlight=tex;

	tex=frame:CreateTexture(nil,"OVERLAY");
	tex:SetTexture(1,0.875,0);
	tex:SetWidth(4);
	tex:SetHeight(388);
	tex:SetPoint("TOPRIGHT",-5,-6);
	frame.ScrollBar=tex;

	local function ListOnEnter(self)
		frame.Highlight:SetAllPoints(self);
		frame.Highlight:Show();

		addon.CurrentMouseItem=self;
		local cx,cy=UIParent:GetCenter();
		local px,py=addon.Parent:GetCenter();
		local ptr=self.Command;
		local color=addon.CommandTypes[ptr.Type].Color;

		GameTooltip:Hide();
		GameTooltip:SetOwner(self,"ANCHOR_"..(px>cx and "LEFT" or "RIGHT"));
		GameTooltip:AddDoubleLine(ptr.Slash,ptr.Token,color[1],color[2],color[3],color[1],color[2],color[3]);
		GameTooltip:AddLine(addon.CommandTypes[ptr.Type].Label,color[1],color[2],color[3]);
		if ptr.Aliases and #ptr.Aliases>1 then
			GameTooltip:AddLine(" ");
			for i,j in ipairs(ptr.Aliases) do
				GameTooltip:AddDoubleLine(i<=1 and "其他可用命令：" or " ",j,nil,nil,nil,color[1],color[2],color[3]);
			end
		end
		if ptr.AddOn then
			local ptr=ptr.AddOn;
			GameTooltip:AddLine(" ");
			GameTooltip:AddDoubleLine("插件",ptr.Name..((ptr.Version and ptr.Name:sub(-(#ptr.Version),-1)~=ptr.Version) and " "..ptr.Version or ""));
			if ptr.Author then GameTooltip:AddDoubleLine(" ","作者: "..ptr.Author); end
			if ptr.Notes then GameTooltip:AddLine(ptr.Notes,nil,nil,nil,true); end
		end
		GameTooltip:Show();
	end

	local function ListOnLeave(self)
		frame.Highlight:Hide();

		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide();
			addon.CurrentMouseItem=nil;
		end
	end

	function frame:ScrollTo(val)
		self.Offset=math.max(math.min(val,#self.FilteredList-addon.MaxListSize),0);
		addon:UpdateFrames();
		if addon.CurrentMouseItem then ListOnEnter(addon.CurrentMouseItem); end
	end

	function frame:ScrollBy(val)
		self.Offset=math.max(math.min(self.Offset+val,#self.FilteredList-addon.MaxListSize),0);
		addon:UpdateFrames();
		if addon.CurrentMouseItem then ListOnEnter(addon.CurrentMouseItem); end
	end

	frame:EnableMouseWheel(1);
	frame:SetScript("OnMouseWheel",function(self,delta) self:ScrollBy(-delta*3); end);

	for i=1,addon.MaxListSize do
		local obj=CreateFrame("Frame",nil,frame);
		obj:SetPoint("TOPLEFT",8,-8-(i-1)*12);
		obj:SetPoint("RIGHT",-12,0);
		obj:SetHeight(12);
		obj:Hide();

		local text=obj:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
		text:SetPoint("LEFT");
		text:SetJustifyH("LEFT");
		text:SetText("/Test");
		obj.SlashText=text;

		text=obj:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
		text:SetPoint("RIGHT");
		text:SetJustifyH("RIGHT");
		text:SetText("TEST");
		obj.TokenText=text;

		obj:SetScript("OnEnter",ListOnEnter);
		obj:SetScript("OnLeave",ListOnLeave);

		frame.ListItems[i]=obj;
	end

	addon.ListFrame=frame;
end

function addon:RepositionFrames()
	local cx,cy=UIParent:GetCenter();
	local px,py=self.Parent:GetCenter();

	local vpt,vrpt=(py>cy and "TOP" or "BOTTOM"),(py>cy and "BOTTOM" or "TOP");

	self.ListFrame:ClearAllPoints();
	self.ListFrame:SetPoint(vpt.."LEFT",self.Parent,vrpt.."LEFT",3,py>cy and 6 or -6);
	self.ListFrame:SetPoint(vpt.."RIGHT",self.Parent,vrpt.."RIGHT",-3,py>cy and 6 or -6);
end

function addon:UpdateFrames()
	local list=self.ListFrame.FilteredList;
	local listlen=#list;
	if listlen>0 then
		self.ListFrame:Show();

		local limit=math.min(listlen,addon.MaxListSize);
		local frameheight=limit*12+16;
		self.ListFrame.Offset=math.max(math.min(self.ListFrame.Offset,listlen-self.MaxListSize),0);
		self.ListFrame:SetHeight(frameheight);
		for i,j in ipairs(self.ListFrame.ListItems) do
			if i>limit then
				j:Hide();
			else
				j:Show();

				local ptr=list[i+self.ListFrame.Offset];
				j.Command=ptr;
				j.SlashText:SetText(ptr.Slash);
				j.TokenText:SetText(ptr.Token);
				j.SlashText:SetTextColor(unpack(self.CommandTypes[ptr.Type].Color));
				j.TokenText:SetTextColor(unpack(self.CommandTypes[ptr.Type].Color));
			end
		end

		self.ListFrame.ScrollBar:SetPoint("TOPRIGHT",-5,-(frameheight-12)*self.ListFrame.Offset/listlen-6);
		self.ListFrame.ScrollBar:SetHeight((frameheight-12)*limit/listlen);
	else
		self.ListFrame:Hide();
	end
end

----------------------------------
--[[	List Frame Hooks	]]
----------------------------------
function addon:SetOwner(frame)
	self.Parent=frame;
	self.ListFrame:SetParent(frame);
	self:RepositionFrames();
	self.ListFrame:Show();
end

function addon:ClearOwner(frame)
	if self.Parent and frame==self.Parent then
		self.Parent=nil;
		self.ListFrame:Hide();
	end
end

function addon:SetFilter(frame)
	if self.Parent and frame==self.Parent then
		self.ListFrame.Offset=0;
		self:BuildFilter(frame:GetText());--	FilterCache is reused so returned table pointer never changes
		self:UpdateFrames();
		self:RepositionFrames();
	end
end

--	API hooks
hooksecurefunc("ChatEdit_OnEditFocusGained",function(self) addon:SetOwner(self); end);
hooksecurefunc("ChatEdit_OnEditFocusLost",function(self) addon:ClearOwner(self); end);
hooksecurefunc("ChatEdit_OnTextChanged",function(self) addon:SetFilter(self); end);
hooksecurefunc("ChatEdit_OnTextSet",function(self) addon:SetFilter(self); end);
