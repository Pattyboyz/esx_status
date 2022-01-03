local Status = {};
local playerServerId;

function getStatusData()
    local status = {};
    for i=1, #Status, 1 do
        status[#status+1] = {
            name = Status[i].name,
			val = Status[i].val,
			percent = (Status[i].val / Config.MaxStatus) * 100
        };
    end

    return status;
end

RegisterNetEvent('esx_status:load');
AddEventHandler('esx_status:load', function(statu, src)
    Status = status;
    playerServerId = src;

    TriggerEvent('esx_status:loaded');
end)

RegisterNetEvent('esx_status:add');
AddEventHandler('esx_status:add', function(statusName, value)
    TriggerServerEvent('esx_status:add', playerServerId, statusName, value);
end)

RegisterNetEvent('esx_status:remove');
AddEventHandler('esx_status:remove', function(statusName, value)
    TriggerServerEvent('esx_status:remove', playerServerId, statusName, value);
end)

RegisterNetEvent('esx_status:set');
AddEventHandler('esx_status:set', function(statusName, value)
    TriggerServerEvent('esx_status:set', playerServerId, statusName, value);
end)

RegisterNetEvent('esx_status:update');
AddEventHandler('esx_status:update', function(status)
    Status = status;
end)

AddEventHandler('esx_status:getStatusData', function(cb)
    cb(getStatusData());
end)