function CreateStatus(src, statuses, cb)
    local self = {};
    self.source = src;
    self.status = statuses;

    self.getStatusByName = function(statusName)
        for index, status in pairs(self.status) do
            if (status.name == statusName) then return status; end
        end

        return nil;
    end

    self.set = function(statusName, value)
        local status = self.getStatusByName(statusName);
        status.val = value;
    end

    self.add = function(statusName, value)
        local status = self.getStatusByName(statusName);
        if ((status.val + value) > Config.MaxStatus) then
            return status.val = Config.MaxStatus;
        end

        status.val = status.val + value;
    end

    self.remove = function(statusName, value)
        local status = self.getStatusByName(statusName);
        if ((status.val - value) < 0) then value = 0; end

        status.val = status.val - value;
    end

    self.getPercent = function(statusName)
        local status = self.getStatusByName(statusName);
        return (status.val / Config.MaxStatus) * 100;
    end

    return self;
end