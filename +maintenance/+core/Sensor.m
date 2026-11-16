
classdef Sensor < handle

    properties
        SensorName
        Unit
        CurrentValue = 0
    end

    methods

        function obj = Sensor(name,unit,value)

            obj.SensorName = name;
            obj.Unit = unit;
            obj.CurrentValue = value;

        end

        function updateValue(obj,value)

            obj.CurrentValue = value;

        end

        function displaySensor(obj)

            fprintf('Sensor: %s\n',obj.SensorName);
            fprintf('Value: %.2f %s\n', ...
                obj.CurrentValue,obj.Unit);

        end

    end

end
