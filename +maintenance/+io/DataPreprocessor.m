
classdef DataPreprocessor

    methods (Static)

        function cleanedData = preprocess(data)

            sensorColumns = {
                'Temperature'
                'Vibration'
                'Pressure'
                'RPM'
                'Current'
                'Humidity'
                };

            data = rmmissing(data,'DataVariables', ...
                {'Timestamp','Failure'});

            if isempty(data)
                error('No valid records remain.');
            end

            for i = 1:length(sensorColumns)

                col = sensorColumns{i};
                values = data.(col);

                if ~isnumeric(values)
                    error('Sensor column must be numeric.');
                end

                values(~isfinite(values)) = NaN;

                medianValue = median(values,'omitnan');

                if isnan(medianValue)
                    error('No valid readings in %s.',col);
                end

                values(isnan(values)) = medianValue;

                data.(col) = values;

            end

            cleanedData = data;

            for i = 1:length(sensorColumns)

                col = sensorColumns{i};
                values = cleanedData.(col);

                minValue = min(values);
                maxValue = max(values);

                if maxValue == minValue
                    normalized = zeros(size(values));
                else
                    normalized = (values-minValue) ./ ...
                        (maxValue-minValue);
                end

                cleanedData.([col '_Normalized']) = normalized;

            end

            disp('Data preprocessing completed.');

            fprintf('Total records: %d\n',height(cleanedData));
            fprintf('Total columns: %d\n',width(cleanedData));

        end

    end

end
