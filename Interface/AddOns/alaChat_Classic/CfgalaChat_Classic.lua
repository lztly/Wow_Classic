U1RegisterAddon("alaChat_Classic", {
    title = "聊天增强",
    tags = { TAG_CHAT, },
    desc = "提供聊天复制、职业着色、频道切换条、TAB切换频道、聊天表情等功能。\n按住CTRL拖动可以移动位置",
    load = "NORMAL",
    defaultEnable = 1,
    nopic = 1,
    minimap = 'LibDBIcon10_alaChat_Classic', 
    icon = [[Interface\Addons\alaChat_Classic\icon\emote_nor]],

    {
        text = "全部配置选项",
        callback = function(cfg, v, loading)
                InterfaceOptionsFrame_Show();
                InterfaceOptionsFrame_OpenToCategory("alaChat_Classic");
        end
    },
    {
        text = "透明度",
        var = "alpha",
        getvalue = function() return alac_GetConfig("alpha"); end,
        type = "spin",
        range = { 0.10, 1.00, 0.05 },
        callback = function(cfg, v, loading)
            if(loading) then return end
            alac_SetConfig('alpha', v);
        end,
    },
    {
        text = "缩放比例",
        var = "scale",
        getvalue = function() return alac_GetConfig("scale"); end,
        type = "spin",
        range = { 0.00, 2.00, 0.05 },
        callback = function(cfg, v, loading)
            if(loading) then return end
            alac_SetConfig('scale', v);
        end,
    },
    {
        text = '位置',
        type = 'radio',
        var = 'position',
        getvalue = function() return alac_GetConfig("position"); end,
        options = {'输入框下方', 'BELOW_EDITBOX', '输入框上方', 'ABOVE_EDITOBX', "聊天框上方", "ABOVE_CHATFRAME"},
        callback = function(cfg, v, loading)
            if(loading) then return end
            alac_SetConfig('position', v);
        end
    },
    {
        text = '方向',
        type = 'radio',
        var = 'direction',
        getvalue = function() return alac_GetConfig("direction"); end,
        options = {'水平', 'HORIZONTAL', '垂直', 'VERTICAL',},
        callback = function(cfg, v, loading)
            if(loading) then return end
            alac_SetConfig('direction', v);
        end
    },
    {
        var = 'shortChannelName',
        text = '短频道名',
        getvalue = true,
        getvalue = function() return alac_GetConfig("shortChannelName"); end,
        callback = function(cfg, v, loading)
            if(loading) then return end
            alac_SetConfig('shortChannelName', v);
        end,
    },
    {
        text = '短频道名格式',
        type = 'radio',
        var = 'shortChannelNameFormat',
        getvalue = function() return alac_GetConfig("shortChannelNameFormat"); end,
        options = {'数字.中文', 'NW', '中文', 'W', "数字", "N"},
        callback = function(cfg, v, loading)
            if(loading) then return end
            alac_SetConfig('shortChannelNameFormat', v);
        end
    },
    {
        var = 'chatEmote',
        text = '聊天表情',
        getvalue = true,
        getvalue = function() return alac_GetConfig("chatEmote"); end,
        callback = function(cfg, v, loading)
            if(loading) then return end
            alac_SetConfig('chatEmote', v);
        end,
    },
    {
        var = 'channel_Ignore_Switch',
        text = '公共频道屏蔽按钮',
        getvalue = true,
        getvalue = function() return alac_GetConfig("channel_Ignore_Switch"); end,
        callback = function(cfg, v, loading)
            if(loading) then return end
            alac_SetConfig('channel_Ignore_Switch', v);
        end,
    },
    {
        var = 'bfWorld_Ignore_Switch',
        text = '世界频道屏蔽按钮',
        getvalue = true,
        getvalue = function() return alac_GetConfig("bfWorld_Ignore_Switch"); end,
        callback = function(cfg, v, loading)
            if(loading) then return end
            alac_SetConfig('bfWorld_Ignore_Switch', v);
        end,
    },
    {
        var = 'copy',
        text = '聊天复制',
        getvalue = true,
        getvalue = function() return alac_GetConfig("copy"); end,
        callback = function(cfg, v, loading)
            if(loading) then return end
            alac_SetConfig('copy', v);
        end,
    },

});
