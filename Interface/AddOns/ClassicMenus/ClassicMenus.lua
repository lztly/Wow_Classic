
-------------------------------------
-- 右鍵菜單增強
-------------------------------------

local locale = GetLocale()

local AddFriend = C_FriendList and C_FriendList.AddFriend or AddFriend or function() end
local SendWho = C_FriendList and C_FriendList.SendWho or SendWho or function() end

local UnitPopupButtonsExtra = {
    ["SEND_WHO"] = { enUS ="Query Detail",  zhCN = "查询玩家", zhTW = "查詢玩家" },
    ["NAME_COPY"] = { enUS ="Get Name",     zhCN = "获取名字", zhTW = "獲取名字" },
    ["GUILD_ADD"] = { enUS ="Guild Invite", zhCN = "公会邀请", zhTW = "公會邀請" },
    ["FRIEND_ADD"] = { enUS ="Add Friend",  zhCN = "添加好友", zhTW = "添加好友" },
}

for k, v in pairs(UnitPopupButtonsExtra) do
    v.text = v[locale] or k
    UnitPopupButtons[k] = v
end

tinsert(UnitPopupMenus["FRIEND"], 1, "NAME_COPY")
tinsert(UnitPopupMenus["FRIEND"], 1, "SEND_WHO")
tinsert(UnitPopupMenus["FRIEND"], 1, "FRIEND_ADD")
tinsert(UnitPopupMenus["FRIEND"], 1, "GUILD_ADD")

tinsert(UnitPopupMenus["CHAT_ROSTER"], 1, "NAME_COPY")
tinsert(UnitPopupMenus["CHAT_ROSTER"], 1, "SEND_WHO")
tinsert(UnitPopupMenus["CHAT_ROSTER"], 1, "FRIEND_ADD")
tinsert(UnitPopupMenus["CHAT_ROSTER"], 1, "INVITE")

tinsert(UnitPopupMenus["GUILD"], 1, "NAME_COPY")
tinsert(UnitPopupMenus["GUILD"], 1, "FRIEND_ADD")

local function popupClick(self, info)
    local editBox
    local name, server = UnitName(info.unit)
    if (info.value == "NAME_COPY") then
        editBox = ChatEdit_ChooseBoxForSend()
        local hasText = (editBox:GetText() ~= "")
        ChatEdit_ActivateChat(editBox)
        editBox:Insert(name)
        if (not hasText) then editBox:HighlightText() end
    end
end

hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which, unit, name, userData)
    if (UIDROPDOWNMENU_MENU_LEVEL > 1) then return end
    if (unit and (unit == "target" or string.find(unit, "party"))) then
        local info
        info = UIDropDownMenu_CreateInfo()
        info.text = UnitPopupButtonsExtra["NAME_COPY"].text
        info.arg1 = {value="NAME_COPY",unit=unit}
        info.func = popupClick
        info.notCheckable = true
        UIDropDownMenu_AddButton(info)
    end
end)

hooksecurefunc("UnitPopup_OnClick", function(self)
	local unit = UIDROPDOWNMENU_INIT_MENU.unit
	local name = UIDROPDOWNMENU_INIT_MENU.name
	local server = UIDROPDOWNMENU_INIT_MENU.server
	local fullname = name
    local editBox
	--if (server and (not unit or UnitRealmRelationship(unit) ~= LE_REALM_RELATION_SAME)) then
	--	fullname = name .. "-" .. server
	--end
    if (self.value == "NAME_COPY") then
        editBox = ChatEdit_ChooseBoxForSend()
        local hasText = (editBox:GetText() ~= "")
        ChatEdit_ActivateChat(editBox)
        editBox:Insert(fullname)
        if (not hasText) then editBox:HighlightText() end
    elseif (self.value == "FRIEND_ADD") then
        AddFriend(fullname)
    elseif (self.value == "SEND_WHO") then
        SendWho("n-"..name)
    elseif (self.value == "GUILD_ADD") then
        GuildInvite(fullname)
    end
end)
