
classdef CSVLoader

    methods (Static)

        function data = loadData(filename)

            if ~isfile(filename)
                error('Dataset file not found.');
            end

            data = readtable(filename);

            if isempty(data)
                error('Dataset is empty.');
            end

            fprintf('Dataset loaded successfully.\n');
            fprintf('Total Rows: %d\n',height(data));
            fprintf('Total Columns: %d\n',width(data));

        end

    end

end
