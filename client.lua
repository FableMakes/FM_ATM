local hacking = false

CreateThread(function()
    Core.InitTarget(StartHack)
end)

function StartHack(entity)
    if hacking then return end

    if not lib.callback.await('atm:hasItem', false) then
        lib.notify({description='Need buzzer'})
        return
    end

    local coords = GetEntityCoords(entity)
    if not lib.callback.await('atm:canHack', false, coords) then return end

    hacking = true
    TriggerServerEvent('atm:dispatch')

    local success = exports['bd-minigames']:PinCracker(
        math.random(Config.Minigame.Pins[1], Config.Minigame.Pins[2]),
        Config.Minigame.Time
    )

    if success then
        Core.Progress('Accessing ATM...', Config.HackTime)
        TriggerServerEvent('atm:reward', coords)
    else
        TriggerServerEvent('atm:fail')
    end

    hacking = false
end

RegisterNetEvent('atm:stun', function()
    SetPedToRagdoll(PlayerPedId(), 5000, 5000, 0, false, false, false)
end)
