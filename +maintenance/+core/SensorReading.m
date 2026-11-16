
classdef SensorReading

    properties
        Timestamp
        Temperature
        Vibration
        Pressure
        RPM
        Current
        Humidity
    end

    methods

        function obj = SensorReading(time,temp,vib, ...
                pressure,rpm,current,humidity)

            obj.Timestamp = time;
            obj.Temperature = temp;
            obj.Vibration = vib;
            obj.Pressure = pressure;
            obj.RPM = rpm;
            obj.Current = current;
            obj.Humidity = humidity;

        end

    end

end
