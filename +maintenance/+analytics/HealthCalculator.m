
classdef HealthCalculator
    methods (Static)
        function result = calculate(features)

            weights = [
                0.25
                0.25
                0.15
                0.15
                0.10
                0.10
                ];

            limits = [
                100
                10
                10
                2000
                30
                100
                ];

            values = [
                features.MaximumTemperature
                features.VibrationRMS
                features.AveragePressure
                features.AverageRPM
                features.AverageCurrent
                features.AverageHumidity
                ];

            scores = zeros(6,1);

            for i = 1:6
                if i == 3
                    scores(i) = min(values(i)/limits(i),1)*100;
                else
                    scores(i) = max(0, ...
                        100-values(i)/limits(i)*100);
                end
            end

            healthScore = sum(scores.*weights);

            result.HealthScore = healthScore;

            if healthScore >= 80
                result.Status = "Healthy";
            elseif healthScore >= 60
                result.Status = "Warning";
            else
                result.Status = "Critical";
            end

            result.ParameterScores = scores;

            disp('Machine health calculation completed.');
            fprintf('Health Score: %.2f%%\n',healthScore);
            fprintf('Machine Status: %s\n',result.Status);
        end
    end
end
