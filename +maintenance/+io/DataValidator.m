
classdef DataValidator

    methods (Static)

        function validate(data)

            requiredColumns = {
                'Timestamp'
                'Temperature'
                'Vibration'
                'Pressure'
                'RPM'
                'Current'
                'Humidity'
                'Failure'
                };

            for i = 1:length(requiredColumns)

                if ~ismember(requiredColumns{i}, ...
                        data.Properties.VariableNames)

                    error('Missing column: %s',requiredColumns{i});

                end

            end

            if any(ismissing(data),'all')
                warning('Dataset contains missing values.');
            else
                disp('No missing values detected.');
            end

            sensorColumns = {
                'Temperature'
                'Vibration'
                'Pressure'
                'RPM'
                'Current'
                'Humidity'
                };

            for i = 1:length(sensorColumns)

                values = data.(sensorColumns{i});

                if any(~isfinite(values)) || any(values < 0)
                    error('Invalid sensor readings detected.');
                end

            end

            if ~all(ismember(data.Failure,[0 1]))
                error('Failure column must contain 0 or 1.');
            end

            disp('Dataset validation completed.');

        end

    end

end
