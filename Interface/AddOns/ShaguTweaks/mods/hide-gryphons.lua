local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
  title = MRBCAT["Hide Gryphons"],
  description = MRBCAT["Hides the gryphons left and right of the action bar."],
  expansions = { ["vanilla"] = true, ["tbc"] = true },
  enabled = nil,
})

module.enable = function(self)
  MainMenuBarLeftEndCap:Hide()
  MainMenuBarRightEndCap:Hide()
end
