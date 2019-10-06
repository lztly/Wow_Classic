--[[	SlashHelp
	by SDPhantom
	http://www.phantomweb.org	]]
------------------------------------------

local name,addon=...;

--------------------------
--[[	Local Pointers	]]
--------------------------
local _G=_G;
local math=math;
local table=table;
local ipairs=ipairs;
local pairs=pairs;
local rawget=rawget;
local rawset=rawset;
local tonumber=tonumber;
local type=type;
local IsSecureCmd=IsSecureCmd;
local ChatTypeInfo=ChatTypeInfo;
local SlashCmdList=SlashCmdList;

--------------------------
--[[	Metatables	]]
--------------------------
local CIKeyMeta={--	Forces keys to be case-insensitive
	__index=function(t,k) return rawget(t,type(k)=="string" and k:lower() or k); end;
	__newindex=function(t,k,v) return rawset(t,type(k)=="string" and k:lower() or k,v); end;
}

--------------------------
--[[	Cache Vars	]]
--------------------------
--	Filter cache
local FilterCache={};
local LastFilter="";

--	Scanner cache
local AddOnInfo={};
local SlashInfo={};
local SlashGroupLookup={};
local SlashOrder={};
local GroupOrder={};
local TokenLookup={};

setmetatable(AddOnInfo,CIKeyMeta);
setmetatable(SlashInfo,CIKeyMeta);

--	Progressive scanner queue
local ScanCache={};

--------------------------
--[[	Local Funcs	]]
--------------------------
local SortSlashCommands;--	function()
local RegisterSlashCommand;--	function(slash,token,cmdtype,addonid)
do
	local SlashSortFlag=false;
	local GroupSortFlag=false;

	local function StringSortFunc(v1,v2)
		local s1,s2=v1:lower(),v2:lower();
		local l1,l2=#v1,#v2;
		local len=math.min(l1,l2);
		if len<=0 then
			return l1<l2;
		else
			for i=1,len do
--				Following code checks letter before case (A < a < B < b < C < c < etc)
				local b1,b2=s1:byte(i),s2:byte(i);
				if b1~=b2 then return b1<b2;--	Check lower() conversion
				else
					b1,b2=v1:byte(i),v2:byte(i);--	Check case (upper before lower)
					if b1~=b2 then return b1<b2; end
				end
			end
			return l1<l2;
		end
	end

	SortSlashCommands=function()
		if SlashSortFlag then
			table.sort(SlashOrder,StringSortFunc);
			SlashSortFlag=false;
		end
		
		if GroupSortFlag then
			table.sort(GroupOrder,StringSortFunc);
			for i,j in pairs(SlashGroupLookup) do table.sort(j,StringSortFunc); end
			GroupSortFlag=false;
		end
	end

	RegisterSlashCommand=function(slash,token,cmdtype,addonid)
		local addon=AddOnInfo[addonid or ""];
		if not addon and (addonid or "")~="" then
			local id,title,notes=GetAddOnInfo(addonid);
			local author=GetAddOnMetadata(addonid,"Author");
			local version=GetAddOnMetadata(addonid,"Version");
			if id then
				addon={
					ID=id;
					Name=title;
					Version=version;
					Author=author;
					Notes=notes;
				};
				AddOnInfo[addonid]=addon;
			end
		end
		
		local aliases;
		if token then
			aliases=SlashGroupLookup[token];
			if not aliases then
				aliases={};
				SlashGroupLookup[token]=aliases;
				table.insert(GroupOrder,token);
				GroupSortFlag=true;
			end
		else
			token=("<%s>"):format(UNKNOWN);
		end

		local data=SlashInfo[slash];
		if not data then
			data={}; SlashInfo[slash]=data;
			if aliases then table.insert(aliases,slash); end
			table.insert(SlashOrder,slash);
			SlashSortFlag=true;
		end

		data.Slash=slash;
		data.Token=token;
		data.Type=cmdtype;
		data.Aliases=aliases;
		data.AddOn=addon;
	end

	addon.EventFrame:HookScript("OnUpdate",function() if SlashSortFlag or GroupSortFlag then SortSlashCommands(); end end);
end

--------------------------
--[[	Filter Func	]]
--------------------------
function addon:BuildFilter(filter)
	filter=(filter or LastFilter):lower();
	table.wipe(FilterCache);

	if filter:find("^/") then
		if self.Options.SortType=="Group" then--	Group sort
			for i,j in ipairs(GroupOrder) do
				for k,l in ipairs(SlashGroupLookup[j]) do
					local ptr=SlashInfo[l];
					if filter==l:sub(1,math.min(#filter,#l)):lower() and self.Options.Show[ptr.Type] then
						table.insert(FilterCache,ptr);
					end
				end
			end
		else--						Slash sort (default)
			for i,j in ipairs(SlashOrder) do
				local ptr=SlashInfo[j];
				if filter==j:sub(1,math.min(#filter,#j)):lower() and self.Options.Show[ptr.Type] then
					table.insert(FilterCache,ptr);
				end
			end
		end
	end

	LastFilter=filter;
	return FilterCache;
end

--------------------------
--[[	Scanner Funcs	]]
--------------------------
local function InitializeTokenLookup(tbl)
	local ptr=TokenLookup[tbl];
	if not ptr then ptr={};TokenLookup[tbl]=ptr; end
	for i,j in pairs(getmetatable(tbl).__index) do ptr[j]=i; end
	for i,j in pairs(tbl) do ptr[j]=i; end
end

local function AddToTokenLookup(tbl,index)
	local ptr=TokenLookup[tbl];
	if not ptr then ptr={};TokenLookup[tbl]=ptr; end
	ptr[tbl[index]]=index;
end

local function ImportHashEntry(hashlist,index,tokenlist,cmdtype)
	local secure,id=issecurevariable(hashlist,index);
	local func=hashlist[index];
	RegisterSlashCommand(
		index:lower()
		,TokenLookup[tokenlist] and TokenLookup[tokenlist][func]
		,cmdtype
		,((not secure and id~="") and id or nil)
	);
end

local function ImportHashList(hashlist,tokenlist,cmdtype)
	for i,j in pairs(hashlist) do ImportHashEntry(hashlist,i,tokenlist,cmdtype); end
end

local function InitialScan()
	for i,j in pairs(_G) do
		if type(j)=="string" and j:find("^/") then
			if not SlashInfo[j] then
				local token,isemote=i:match("^SLASH_(.-)%d+$"),false;
				if not token then token,isemote=_G["EMOTE"..(i:match("^EMOTE(%d+)_CMD%d+$") or 0).."_TOKEN"],true; end

				if token then
					local cmdtype;

					if isemote then			cmdtype="Emote";
					elseif IsSecureCmd(j) then	cmdtype="Secure";
					elseif ChatTypeInfo[token] then	cmdtype="Chat"
					elseif SlashCmdList[token] then	cmdtype="Slash";
					end

					if cmdtype then
						local secure,id;
						if cmdtype=="Slash" then secure,id=issecurevariable(i); end
						RegisterSlashCommand(j,token,cmdtype,((not secure and id~="") and id or nil));
					end
				end
			end
		end
	end

--	Scan for functions injected straight into the hash table
	InitializeTokenLookup(SlashCmdList);
	ImportHashList(hash_SlashCmdList,SlashCmdList,"Slash");

	SortSlashCommands();
	addon:BuildFilter(nil);
end

local function ProgressiveScan()
	if #ScanCache>0 then
		for i,j in ipairs(ScanCache) do
			local cmdlist={};
			local k,str=1,_G["SLASH_"..j..1];
			while str do
				local secure,id=issecurevariable("SLASH_"..j..k);
				RegisterSlashCommand(str,j,"Slash",((not secure and id~="") and id or nil));
				k=k+1;str=_G["SLASH_"..j..k];--	k needs to be incremented before referenced for str
			end

		end
		table.wipe(ScanCache);

		SortSlashCommands();
		addon:BuildFilter(nil);
	end
end

--------------------------------------------------
--[[	Progressive Scanner Trigger Hook	]]
--------------------------------------------------
do	local oldmeta=getmetatable(SlashCmdList);
	local newindexfunc=function(t,k,v)
		if v==nil then return; end--	This can happen if nil is to be set to an index that doesn't exist
		rawset(t,k,v);

		AddToTokenLookup(t,k);
		ScanCache[#ScanCache+1]=k;
	end;
	if oldmeta then
		if oldmeta.__newindex then
			hooksecurefunc(oldmeta,"__newindex",newindexfunc);
		else
			oldmeta.__newindex=newindexfunc;
		end
	else
		setmetatable(SlashCmdList,{__newindex=newindexfunc});
	end
	addon.EventFrame:HookScript("OnUpdate",function() if #ScanCache>0 then ProgressiveScan(); end end);
end

do	local oldmeta=getmetatable(hash_SlashCmdList);
	local sortflag=false;
	local newindexfunc=function(t,k,v)
		if v==nil then return; end--	This can happen if nil is to be set to an index that doesn't exist
		rawset(t,k,v);

		ImportHashEntry(t,k,SlashCmdList,"Slash");
		sortflag=true;
--		SortSlashCommands();
	end;
	if oldmeta then
		if oldmeta.__newindex then
			hooksecurefunc(oldmeta,"__newindex",newindexfunc);
		else
			oldmeta.__newindex=newindexfunc;
		end
	else
		setmetatable(hash_SlashCmdList,{__newindex=newindexfunc});
	end
	addon.EventFrame:HookScript("OnUpdate",function() if sortflag then SortSlashCommands();sortflag=false; end end);
end

----------------------------------
--[[	Initial Scanner Event	]]
----------------------------------
addon.EventFrame:RegisterEvent("ADDON_LOADED");
addon.EventFrame:HookScript("OnEvent",function(self,event,...) if event=="ADDON_LOADED" and (...)==name then InitialScan(); end end);
