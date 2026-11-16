
classdef AnomalyDetector
    methods (Static)
        function results = detect(data)

            sensorColumns = {
                'Temperature'
                'Vibration'
                'Pressure'
                'RPM'
                'Current'
                'Humidity'
                };

            anomalyFlags = false(height(data),1);
            anomalyScores = zeros(height(data),1);

            for i = 1:length(sensorColumns)

                values = data.(sensorColumns{i});

                center = median(values);
                spread = median(abs(values-center));

                if spread == 0
                    scores = zeros(size(values));
                else
                    scores = 0.6745 * abs(values-center) / spread;
                end

                sensorAnomalies = scores > 3.5;

                anomalyFlags = anomalyFlags | sensorAnomalies;
                anomalyScores = max(anomalyScores,scores);

            end

            results = data(:,sensorColumns);
            results.AnomalyScore = anomalyScores;
            results.IsAnomaly = anomalyFlags;

            disp('Anomaly detection completed.');

            fprintf('Total records: %d\n',height(data));
            fprintf('Anomalies detected: %d\n',sum(anomalyFlags));

        end
    end
end
