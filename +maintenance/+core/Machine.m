
classdef Machine < handle

    properties
        MachineID
        MachineName
        MachineType
        Status = "Unknown"
        HealthScore = 0
        Sensors = {}
    end

    methods

        function obj = Machine(id,name,type)

            obj.MachineID = id;
            obj.MachineName = name;
            obj.MachineType = type;

        end

        function addSensor(obj,sensor)

            obj.Sensors{end+1} = sensor;

        end

        function displayInfo(obj)

            fprintf('\nMachine ID: %s\n',obj.MachineID);
            fprintf('Machine Name: %s\n',obj.MachineName);
            fprintf('Machine Type: %s\n',obj.MachineType);
            fprintf('Status: %s\n',obj.Status);
            fprintf('Health Score: %.2f%%\n',obj.HealthScore);
            fprintf('Total Sensors: %d\n',length(obj.Sensors));

        end

    end

end
