local cooldowns = {}

lib.callback.register('atm:hasItem', function(src)
    return Core.HasItem(src, Config.RequiredItem)
end)

lib.callback.register('atm:canHack', function(src, coords)
    if Core.GetCops() < Config.RequiredPolice then return false end

    local key = math.floor(coords.x)..':'..math.floor(coords.y)
    if cooldowns[key] and os.time() < cooldowns[key] then return false end

    return true
end)

RegisterNetEvent('atm:dispatch', function()
    local src = source
    Core.Dispatch(src, GetEntityCoords(GetPlayerPed(src)))
end)

RegisterNetEvent('atm:reward', function(coords)
    local src = source

    Core.TriggerHook('beforeReward', src)

    local key = math.floor(coords.x)..':'..math.floor(coords.y)
    cooldowns[key] = os.time() + Config.Cooldown

    local amount = math.random(Config.Rewards.Min, Config.Rewards.Max)
    Core.AddItem(src, Config.Rewards.Item, amount)

    Core.TriggerHook('afterReward', src, amount)
end)

RegisterNetEvent('atm:fail', function()
    local src = source

    if math.random(1,100) <= Config.BreakChance then
        Core.RemoveItem(src, Config.RequiredItem, 1)
        TriggerClientEvent('atm:stun', src)
    end

    Core.TriggerHook('onFail', src)
end)
