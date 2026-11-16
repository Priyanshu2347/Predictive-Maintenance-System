
classdef FeatureExtractor

    methods (Static)

        function features = extract(data)

            required = {
                'Temperature'
                'Vibration'
                'Pressure'
                'RPM'
                'Current'
                'Humidity'
                };

            for i = 1:length(required)

                if ~ismember(required{i}, ...
                        data.Properties.VariableNames)

                    error('Missing sensor column: %s',required{i});

                end

            end

            temperature = data.Temperature;
            vibration = data.Vibration;
            pressure = data.Pressure;
            rpm = data.RPM;
            current = data.Current;
            humidity = data.Humidity;

            features.AverageTemperature = mean(temperature);
            features.MaximumTemperature = max(temperature);

            features.TemperatureIncrease = ...
                (temperature(end)-temperature(1)) / ...
                max(height(data)-1,1);

            features.AverageVibration = mean(vibration);

            features.VibrationRMS = ...
                sqrt(mean(vibration.^2));

            features.PeakVibration = max(vibration);

            features.AveragePressure = mean(pressure);

            features.AverageRPM = mean(rpm);

            features.RPMVariation = std(rpm);

            features.AverageCurrent = mean(current);

            features.AverageHumidity = mean(humidity);

            disp('Feature extraction completed.');

        end

    end

end
