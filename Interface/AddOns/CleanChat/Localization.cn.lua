if GetLocale() == "zhCN" then   -- URL window
  CLEANCHAT_URL_TITLE = "URL list";
  BINDING_NAME_CLEANCHAT_URL = "Toggle URL list";
  CLEANCHAT_URL_STATUS1 = "左键选择一个URL.";
  CLEANCHAT_URL_STATUS2 = "CTRL-C复制URL.";
  CLEANCHAT_NO_URL = "-- No URL --";

  CLEANCHAT_WHO_RESULTS_PATTERN = "%d+ player[s]? total";

  CLEANCHAT_TRANSLATE_CLASS = {
    ["猎人"]  = 1,
    ["术士"] = 2,
    ["牧师"]  = 3,
    ["圣骑士"] = 4,
    ["法师"]    = 5,
    ["盗贼"]   = 6,
    ["德鲁伊"]   = 7,
    ["萨满祭司"]  = 8,
    ["战士"] = 9
  };

  CLEANCHAT_LOADED = " loaded.";
  CLEANCHAT_LOADED_CACHE = CLEANCHAT_VERSION .. " loaded (%d names cached)."

  CLEANCHAT_MYADDONS_DESCRIPTION = "着色名称，显示级别，缩短频道名称等。";

  CLEANCHAT_CHANNELS = {
    {},
    {
      ["__PREFIX"] = "\. ",
      ["General"] = "",
      ["Trade"] = ""
    },
    {
      ["__PREFIX"] = "\. ",
      ["General"] = "",
      ["Trade"] = "",
      ["LocalDefense"] = "",
      ["WorldDefense"] = "",
      ["LookingForGroup"] = "",
      ["GuildRecruitment"] = ""
    },
    {
      ["__PREFIX"] = "\. ",
      ["General"] = "",
      ["Trade"] = "",
      ["LocalDefense"] = "",
      ["WorldDefense"] = "",
      ["LookingForGroup"] = "",
      ["GuildRecruitment"] = ""
    },
    {
      ["__PREFIX"] = "%d\. ",
      ["General"] = "G",
      ["Trade"] = "T",
      ["LocalDefense"] = "L",
      ["WorldDefense"] = "W",
      ["LookingForGroup"] = "LFG",
      ["GuildRecruitment"] = "GR"
    },
    {
      ["__PREFIX"] = "%d\. ",
      ["General"] = "G",
      ["Trade"] = "T",
      ["LocalDefense"] = "L",
      ["WorldDefense"] = "W",
      ["LookingForGroup"] = "LFG",
      ["GuildRecruitment"] = "GR"
    } };

  CLEANCHAT_PREFIX_RAID = {
    [false] = CHAT_RAID_GET,
    [true]  = "%s:\32"
  };

  CLEANCHAT_PREFIX_PARTY = {
    [false] = CHAT_PARTY_GET,
    [true]  = "%s:\32"
  };

  CLEANCHAT_PREFIX_OFFICER = {
    [false] = CHAT_OFFICER_GET,
    [true]  = "%s:\32"
  };

  CLEANCHAT_PREFIX_GUILD = {
    [false] = CHAT_GUILD_GET,
    [true]  = "%s:\32"
  };

  CLEANCHAT_PREFIX_RAIDLEADER = {
    [false] = CHAT_RAID_LEADER_GET,
    [true]  = "[RL] %s:\32"
  };

  CLEANCHAT_PREFIX_RAIDWARNING = {
    [false] = CHAT_RAID_WARNING_GET,
    [true]  = "[RW] %s:\32"
  };

  CLEANCHAT_PREFIX_BG = {
    [false] = CHAT_BATTLEGROUND_GET,
    [true]  = "[BG] %s:\32"
  };

  CLEANCHAT_PREFIX_BGLEADER = {
    [false] = CHAT_BATTLEGROUND_LEADER_GET,
    [true]  = "[BGL] %s:\32"
  };

  CLEANCHAT_HELP = { HIGHLIGHT_FONT_COLOR_CODE .. "/cleanchat" .. LIGHTYELLOW_FONT_COLOR_CODE .. "- Show GUI." };

  CLEANCHAT_STATUS3 = {
    "显示频道名称",
    "不显示通用频道和交易频道",
    "未显示频道名称“通用”、“交易”、“寻求组队”和“本地防务”。",
    "隐藏所有频道名称。",
    "使用缩写频道名称",
    "使用缩写并隐藏其他频道名称。" };

  CLEANCHAT_STATUS4 = "自定义颜色 %s%s %s%s";
  CLEANCHAT_STATUS5 = { "公会", "好友", "陌生人", "队伍", "团队",
    "没有职业的名字", "自己" };
  CLEANCHAT_STATUS6 = "如果名称不符合上述任何条件，使用随机颜色"

  -- GUI
  BINDING_NAME_CLEANCHAT_GUI = "切换图形用户界面";
  CLEANCHAT_CHECKBOX_PREFIX =
  "隐藏及缩写前缀[队伍][团队][公会][官员]。";
  CLEANCHAT_CHANNELS_LABEL = "频道名称：";
  CLEANCHAT_COLORIZE_NICKS = "为聊天消息中的人名着色";
  CLEANCHAT_USE_CLASS_COLORS = "使用职业颜色";
  CLEANCHAT_USE_CURSORKEYS = "键入消息时激活光标键（无 ALT 键）";
  CLEANCHAT_HIDE_CHATBUTTONS = "隐藏聊天按钮";
  CLEANCHAT_COLLECTDATA = "允许插件使用 /who 命令"
  CLEANCHAT_SHOWLEVEL = "显示人物等级";
  CLEANCHAT_SHOWFACTION = "显示阵营"
  CLEANCHAT_MOUSEWHEEL = "鼠标滚轮滚动日志";
  CLEANCHAT_PERSISTENT = "保存聊天历史";
  CLEANCHAT_POPUP = "聊天中提及你的名字，屏幕中心显示。";
  CLEANCHAT_IGNORE_EMOTES = "禁止表情中为名字着色"

end
