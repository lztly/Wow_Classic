--[[
	Lysidia's Casting Bar Timer
	
	Very simple addon to provide a timer to the standard casting bar frame, also support the "mirror" bar.

	No Configuration, install and go.
]]

LCB_FontSize			= 10;		-- Size of Text Font

CastingBarTimer_DisplayString	= " (%0.1fs)";

-- Function: Add count down timer to the Cast/Channelling Bar Frame.
function LysCastingBarFrame_OnUpdate( self, ... )
	local timerValue	= self.maxValue - self.value;
	local textDisplay	= self.Text;
	local _, text, displayName, tempText;

	if ( self.casting ) then
		text = CastingInfo(self.unit);
	elseif ( self.channeling ) then
		text = CastingInfo(self.unit);
		timerValue = self.value;
	end
	
	if ( text ) then
		displayName = text..CastingBarTimer_DisplayString;
	end

	if (displayName ~= nil) then
		if (timerValue) then
			if (timerValue > 0.01) then
				-- Shrink the font a little to fit more text in
				local fontName, fontHeight, fontFlags = textDisplay:GetFont();
				textDisplay:SetFont(fontName, LCB_FontSize, fontFlags);

				-- Update with the new text
				textDisplay:SetText( format(displayName, timerValue) );
			end
		end
	end
	
end

-- Function: Add count down timer to the Mirror Bar Frame
function LysMirrorBarFrame_OnUpdate(self, elapsed)
	local text		= _G[self:GetName().."Text"];
	local displayName	= text:GetText();

--	DEFAULT_CHAT_FRAME:AddMessage("LCT DEBUG: I got called!", 1, 1, 1);

	if (displayName) then
		local tempName	 = string.gsub(displayName, "(.+)", "");
		tempName	= tempName..CastingBarTimer_DisplayString;

		if ((self.value) and (self.value > 0.01)) then
			-- Shrink the font a little to fit more text in
			local fontName, fontHeight, fontFlags = text:GetFont();
			text:SetFont(fontName, LCB_FontSize, fontFlags);

			-- Update with the new text
			text:SetText( format(tempName, self.value) );
		end
	end
end

-- Hook the Blizzard OnUpdate handlers, using hooksecurefunc, reduces the risk of tainting.
--hooksecurefunc("CastingBarFrame_OnUpdate", LysCastingBarFrame_OnUpdate);
CastingBarFrame:HookScript("OnUpdate", LysCastingBarFrame_OnUpdate)

--hooksecurefunc("MirrorTimerFrame_OnUpdate", LysMirrorBarFrame_OnUpdate);
MirrorTimer1:HookScript("OnUpdate", LysMirrorBarFrame_OnUpdate)
MirrorTimer2:HookScript("OnUpdate", LysMirrorBarFrame_OnUpdate)
MirrorTimer3:HookScript("OnUpdate", LysMirrorBarFrame_OnUpdate)