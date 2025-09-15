return{
    descriptions = {
        --Back={},
        --Blind={},
        --Edition={},
        --Enhanced={},
        Joker = {
            j_hrzi_supreme_justice = {
                name = '最高正义',
                text = {
                    '如果{C:attention}消耗品槽位是空的{}',
                    '并且回合一开始',
                    '生成一张{C:tarot}正义{}和一张{C:spectral}即视感{}'
                    }
            },

            j_hrzi_skygazer = {
                name = '观天者',
                text = {
                    '选择盲注时，有{C:green}#1#/#2#{}的几率',
                    '生成一张{C:dark_edition}负片{}',
                    '{C:tarot}月亮，太阳，世界{}和{C:tarot}星星{}',
                    '{C:inactive}(各一张){}',
                }
            },

            j_hrzi_gacha = {
                name = '原神模拟器',
                text = {
                    '打开{C:attention}补充包{}时，',
                    '有概率获得{C:attention}随机{}数额的{C:money}钱{}'
                }
            },

            j_hrzi_end_credits = {
                name = '片尾字幕',
                text = {
                    '每回合{C:attention}最后一次时{}，增加{X:mult,C:white}X#1#{}倍率',
                    '每回合{C:attention}最后一次时{}，{X:mult,C:white}X#2#{}倍率',
                }
            },

            j_hrzi_quarry = {
                name = '采石场',
                text = {
                    '打出的{C:attention}石头牌{}会给{C:money}$#1#{}'
                }
            },

            j_hrzi_event_horizon = {
                name = '事件视界',
                text = {
                    '离开商店时，摧毁消耗品槽位里的{C:planet}星球牌{}',
                    '每两个被摧毁的{C:planet}星球牌{}会生成',
                    '一张{C:spectral}黑洞{}'
                }
            },

            j_hrzi_to_apotheosis = {
                name = '百炼成神',
                text = {
                    '打出{C:attention}隐藏手型{}时，',
                    '增加{X:mult,C:white}X#1#{}倍率',
                    '{C:inactive}当前为{X:mult,C:white}X#2#{}{C:inactive}倍率{}'
                }
            },

            j_hrzi_geologist = {
                name = '石头学家',
                text = {
                    "{C:attention}完整牌组{}内每有一张",
                    "{C:attention}石头牌",
                    "{C:mult}+3{}倍率",
                    "{C:inactive}当前为{C:mult}+#1#{C:inactive}倍率{}",
                }
            },

            j_hrzi_stonehenge = {
                name = '巨石阵',
                text = {
                    '打出的{C:attention}石头牌{}{X:chips,C:white}X#1#{}筹码',
                    '每一个计分的{C:attention}石头牌{}会增加{X:chips,C:white}X0.5{}筹码',
                    '{C:inactive}出牌后会重置{}'
                }
            },

            j_hrzi_brainwashing = {
                name = '洗脑术',
                text = {
                    '{X:dark_edition,C:white}^#1#{}倍率',
                    '如果打出的牌没有万能牌的次数达到三次，',
                    '{C:red,E:1}自毁自己',
                    '{C:inactive}#2#次后自毁自己'
                }
            },

            j_hrzi_monopoly_man = {
                name = '大富翁',
                text = {
                    '每丢弃一张{C:attention}金牌{}时',
                    '将盲注要求降低{C:attention}15%{}'
                }
            },

            j_hrzi_sinful_deal = {
                name = '罪恶交易',
                text = {
                    '跳过{C:attention}补充包{}时，',
                    '生成一张{C:tarot}恶魔{}牌'
                }
            },

            j_hrzi_cremedlc = {
                name = '百里挑一',
                text = {
                    '选择{C:attention}盲注{}时',
                    '失去{C:money}$#1#{}',
                    '生成一张{C:dark_edition}负片{}{C:blue}普通{}小丑'
                }
            },

            j_hrzi_headshot = {
                name = '血鹰',
                text = {
                    '{C:attention}卖掉{}小丑时',
                    '将当前盲注要求降低{C:attentioin}35%{}'
                }
            },

            j_hrzi_thechosen = {
                name = '天选之子',
                text = {
                    '如果打出的牌是',
                    '{V:1}#2#{C:attention}A{}',
                    '{X:mult,C:white}X#1#{}倍率',
                    '{s:0.8,C:inactive}回合结束时改变需求花色',
                }
            }
        },
        --[[]
        Other={},
        ]]
        Planet={
            c_hrzi_asteroid = {
                name = '小行星',
                text = {
                    "{S:0.8}（{S:0.8,V:1}等级#1#{S:0.8}）{}",
                    "升级{C:attention}壁垒",
                    "{C:mult}+#2#{}倍率并且",
                    "{C:chips}+#3#{}筹码",
                }

            }
        },
        --[[]
        Spectral={},
        Stake={},
        Tag={},
        Tarot={},
        Voucher={},
        ]]
    },

    misc = {
        --achievement_descriptions={},
        --achievement_names={},
        --blind_states={},
        --challenge_names={},
        --collabs={},
        --dictionary={},
        --high_scores={},
        --labels={},

        poker_hand_descriptions={
            ['hrzi_Rampart'] = {
                '五张石头牌'
            }
        },

        poker_hands={
            ['hrzi_Rampart'] = "壁垒"
        },

        --quips={},
        --ranks={},
        --suits_plural={},
        --suits_singular={},
        --tutorial={},
        --v_dictionary={},
        --v_text={},
    }
}
