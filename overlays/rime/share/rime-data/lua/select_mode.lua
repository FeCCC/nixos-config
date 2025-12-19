-- select_mode.lua
-- 逻辑：
-- 1. 左 Shift: 切换英文 + 上屏字母 (Commit Raw)
-- 2. 右 Shift: 切换中文 + 清空缓冲
-- 3. 防误触: 如果按住 Shift 打了大写字母，松开时不切换模式

local function processor(key, env)
    local engine = env.engine
    local context = engine.context
    local k = key.keycode
    
    -- === 1. 侦测组合键行为 ===
    -- 如果按下的键【不是】左右Shift
    if k ~= 0xffe1 and k ~= 0xffe2 then
        -- 如果此时 Shift 键是按下状态 (修饰符状态)
        -- 说明用户正在输入 Shift+A 之类的组合
        if key:shift() then
            env.has_combo = true
        end
        return 2 -- 放行其他按键
    end

    -- === 2. 处理 Shift 键本身 (0xffe1, 0xffe2) ===
    
    -- 情况 A: Shift 按下 (KeyDown)
    if not key:release() then
        -- 既然 Shift 刚按下，重置组合键标记
        env.has_combo = false 
        return 2 -- 放行，让系统知道 Shift 按下了
    end

    -- 情况 B: Shift 松开 (Release/KeyUp)
    if key:release() then
        
        -- 【关键判断】如果刚才有过组合键行为（如输出了大写），则不切换模式
        if env.has_combo then
            env.has_combo = false -- 重置状态
            return 2 -- 放行，什么都不做
        end

        -- 没有组合键，说明是“单击 Shift”，执行切换逻辑
        if k == 0xffe1 then
            -----------------------------------------
            -- 左 Shift -> 变英文 + 上屏 raw input
            -----------------------------------------
            if context:is_composing() then
                local raw_input = context.input
                engine:commit_text(raw_input) -- 上屏字母
                context:clear() -- 清除缓冲
            end
            context:set_option("ascii_mode", true)

        else
            -----------------------------------------
            -- 右 Shift -> 变中文 + 清除缓冲
            -----------------------------------------
            context:set_option("ascii_mode", false)
            context:clear() 
        end
        
        return 1 -- 拦截这次 Shift 松开事件，避免 Rime 原生逻辑干扰
    end

    return 2
end

return processor