local ADDON_NAME = ...;

EZJunkMixin = {};

function EZJunkMixin:OnLoad()
	self:RegisterEvent("ADDON_LOADED");
end

function EZJunkMixin:OnEvent(event, ...)
	if (event == "ADDON_LOADED") then
		if (ADDON_NAME == ...) then
			self:UnregisterEvent("ADDON_LOADED");

			self:RegisterEvent("MERCHANT_SHOW");
		end
	elseif (event == "MERCHANT_SHOW") then
		self.OnMerchantShow();
	end
end

function EZJunkMixin:OnMerchantShow(...)
	if ( MerchantFrame:IsVisible() and MerchantFrame.selectedTab == 1 ) then
		local link;
		local itemInfo;
		local containerItemInfo;
		local profitInCopper = 0;
		local itemsSold = 0;

		for bag = 0, 4 do
			for slot = 1, GetContainerNumSlots(bag) do
				link = GetContainerItemLink(bag, slot);

				if (link) then
					itemInfo = EZJunkMixin:GetItemInfo(link);
					containerItemInfo = EZJunkMixin:GetContainerItemInfo(bag, slot);

					if (EZJunkMixin:IsJunk(itemInfo)) then
						--sell item
						UseContainerItem(bag, slot);

						itemsSold = itemsSold + 1;
						profitInCopper = profitInCopper + (itemInfo.SellPrice * containerItemInfo.ItemCount);
					end
				end
			end
		end

		if (profitInCopper > 0 and itemsSold > 0) then
			print("|cFF0DEA38EZ|r |cFF9D9D9DJunk|r: " .. GetCoinTextureString(profitInCopper));
		end
	end
end

function EZJunkMixin:InternalAttachItemValueTooltip(tooltip, checkStack)
	local link = select(2, tooltip:GetItem());

	if (link) then
		local itemInfo = EZJunkMixin:GetItemInfo(link);

		if (itemInfo.SellPrice and itemInfo.SellPrice > 0) then
			local stackCount = 1;

			if (checkStack) then
				local frame = GetMouseFocus();
				local objectType = frame:GetObjectType();

				if (objectType == "Button") then
					stackCount = frame.count or 1;
				end
			end

			local totalValue = itemInfo.SellPrice * (type(stackCount) == "number" and stackCount or 1);
			--local displayValue = GetCoinTextureString(totalValue);
			
			SetTooltipMoney(tooltip, totalValue, nil, format("%s:", SELL_PRICE));
		end
	end
end

function EZJunkMixin:IsJunk(itemInfo)	
	if itemInfo.Rarity == 0 then
		return true
	end
	
	return false
end

function EZJunkMixin:GetItemInfo(link)
	local name, link, rarity, level, minLevel, type, subType, stackCount, equipLoc, icon, sellPrice, classId, subClassId, bindType = GetItemInfo(link);

	return {
		Name = name,
		Link = link,
		Rarity = rarity,
		Level = level,
		MinLevel = minLevel,
		Type = type,
		SubType = subType,
		StackCount = stackCount,
		EquipLocation = equipLoc,
		Icon = icon,
		SellPrice = sellPrice,
		ClassId = classId,
		SubClassId = subClassId,
		BindType = bindType,
		ExpacId = expacId,
		ItemSetId = itemSetId,
		IsCraftingReagent = IsCraftingReagent,
	};
end

function EZJunkMixin:GetContainerItemInfo(bag, slot)
	local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemId = GetContainerItemInfo(bag, slot);

	return {
		Icon = icon,
		ItemCount = itemCount,
		Locked = locked,
		Quality = quality,
		Readable = readable,
		Lootable = lootable,
		ItemLink = itemLink,
		IsFiltered = isFiltered,
		NoValue = noValue,
		ItemId = itemId,
	};
end

local function AttachItemValueTooltip(tooltip, ...)
	if (not MerchantFrame:IsShown()) then
		EZJunkMixin:InternalAttachItemValueTooltip(tooltip, true);
	end
end

local function AttachLinkedItemValueTooltip(tooltip, ...)
	EZJunkMixin:InternalAttachItemValueTooltip(tooltip, false);
end

GameTooltip:HookScript("OnTooltipSetItem", AttachItemValueTooltip);
ItemRefTooltip:HookScript("OnTooltipSetItem", AttachLinkedItemValueTooltip);