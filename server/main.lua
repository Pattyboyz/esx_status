local statuses = {};

function initializeStatus(src, player)
    local status = {};

    MySQL.Async.fetchScalar('SELECT status FROM users WHERE identifier = @identifier', {
        ['@identifier'] = player.identifier
    }, function(result)
        if (result and #result > 0) then
            status = json.decode(result);
        end

        statuses[src] = CreateStatus(src, status);
        TriggerClientEvent('esx_status:load', src, statuses[src].status, src);
    end)
end
RegisterNetEvent('esx:playerLoaded');
AddEventHandler('esx:playerLoaded', initializeStatus);

function onPlayerDropped(src)
    local status = statuses[src];
    if (not status) then return; end

    local identifier = GetPlayerIdentifier(src);
    MySQL.Async.execute('UPDATE users SET status = @status WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@status'] = json.encode(status.status),
    });

    status = nil;
end
AddEventHandler('esx:playerDropped', onPlayerDropped);

function addStatus(src, statusName, value)
    local status = statuses[src];
    if (not status) then return; end

    status.add(statusName, value);
    TriggerClientEvent('esx_status:update', status.source, status.status);
end
RegisterNetEvent('esx_status:add');
AddEventHandler('esx_status:add', addStatus);

function removeStatus(src, statusName, value)
    local status = statuses[src];
    if (not status) then return; end

    status.remove(statusName, value);
    TriggerClientEvent('esx_status:update', status.source, status.status);
end
RegisterNetEvent('esx_status:remove');
AddEventHandler('esx_status:remove', removeStatus);

function setStatus(src, statusName, value)
    local status = statuses[src];
    if (not status) then return; end

    status.set(statusName, value);
    TriggerClientEvent('esx_status:update', status.source, status.status);
end
RegisterNetEvent('esx_status:set');
AddEventHandler('esx_status:set', setStatus);

AddEventHandler('esx_status:getStatus', function(src, statusName, cb)
    local status = statuses[src];
    if (not status) then return cb(nil); end
    
    cb(status.getStatusByName(statusName));
end)

Citizen.CreateThread(function()
    while (true) do
        
        for _, status in pairs(statuses) do
            status.remove('hunger', 10000);
            status.remove('thirst', 10000);
            status.remove('drunk', 100000);
            status.add('stress', 5000);

            TriggerClientEvent('esx_status:update', status.source, status.status);
        end

        Citizen.Wait(Config.TickTime);
    end
end)