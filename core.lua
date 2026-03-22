Core = {}
Core.Hooks = {}

function Core.DebugPrint(msg)
    if Config.Debug then print('[ATM DEBUG]', msg) end
end

-- Hooks system
function Core.RegisterHook(name, fn)
    Core.Hooks[name] = Core.Hooks[name] or {}
    table.insert(Core.Hooks[name], fn)
end

function Core.TriggerHook(name, ...)
    if not Core.Hooks[name] then return end
    for _,fn in pairs(Core.Hooks[name]) do fn(...) end
end

-- Framework
local QBCore, ESX = nil, nil

CreateThread(function()
    local fw = Config.Systems.Framework
    if fw == 'qbcore' or fw == 'qbox' then
        QBCore = exports['qb-core']:GetCoreObject()
    elseif fw == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
    end
end)

function Core.GetPlayer(src)
    local fw = Config.Systems.Framework
    if fw == 'qbox' then return exports.qbx_core:GetPlayer(src)
    elseif fw == 'qbcore' then return QBCore.Functions.GetPlayer(src)
    elseif fw == 'esx' then return ESX.GetPlayerFromId(src)
    end
end

function Core.GetCops()
    local cops = 0
    local function isCop(job)
        for _,v in pairs(Config.PoliceJobs) do
            if v == job then return true end
        end
    end

    if Config.Systems.Framework == 'qbox' then
        for _,p in pairs(exports.qbx_core:GetQBPlayers()) do
            if isCop(p.PlayerData.job.name) then cops += 1 end
        end
    end

    return cops
end

-- Inventory
function Core.HasItem(src, item)
    return exports.ox_inventory:Search(src, 'count', item) > 0
end

function Core.AddItem(src, item, amount)
    exports.ox_inventory:AddItem(src, item, amount)
end

function Core.RemoveItem(src, item, amount)
    exports.ox_inventory:RemoveItem(src, item, amount)
end

-- Target
function Core.InitTarget(cb)
    exports.ox_target:addModel(Config.ATMs, {
        {
            label='Hack ATM',
            icon='fas fa-laptop-code',
            onSelect=function(data) cb(data.entity) end
        }
    })
end

-- Dispatch
function Core.Dispatch(src, coords)
    if Config.Systems.Dispatch == 'tk' then
        exports['tk_dispatch']:addCall({coords=coords, jobs=Config.DispatchJobs})
    end
end

-- Utils
function Core.Notify(src, msg)
    TriggerClientEvent('ox_lib:notify', src, {description=msg})
end

function Core.Progress(label, time)
    return lib.progressBar({duration=time, label=label})
end
