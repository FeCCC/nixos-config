-- select_mode.lua
-- 逻辑：左Shift(0xffe1)切英文，右Shift(0xffe2)切中文

local function processor(key, env)
    local engine = env.engine
    local context = env.engine.context
    local k = key.keycode
    
    -- 0xffe1=左Shift, 0xffe2=右Shift
    if k == 0xffe1 or k == 0xffe2 then
        
        -- 仅在【按键释放 (Release)】时触发
        if key:release() then
            if k == 0xffe1 then
                -- 左 Shift -> 关闭 ascii_mode (中文)
                if context:is_composing() then
                    -- 获取当前输入的拼音串 (例如 "nihao")
                    local raw_input = context.input
                    -- 直接上屏字母
                    engine:commit_text(raw_input)
                    -- 清除当前的输入状态
                    context:clear()
                end
                -- 设置为英文模式
                context:set_option("ascii_mode", true)
            else
                -- 右 Shift -> 开启 ascii_mode (英文)
                context:set_option("ascii_mode", false)
                -- 切换回中文时，清空未上屏的字符，体验更好
                context:clear() 
            end
            
            -- 返回 1 (kAccepted)，拦截该按键，不给 Rime 原生处理
            return 1 
        end
        
        -- 按下 (KeyDown) 时必须【放行】
        -- 否则按住 Shift 配合字母打大写的功能会失效
        return 2 -- kNoop
    end

    return 2 -- kNoop (其他任何按键都不处理，放行)
end

return processor