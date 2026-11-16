
function sensor_monitor()

    % Load saved sensor history
    dataFile = 'data/sensor_history.mat';

    if ~isfile(dataFile)
        error('Sensor history file not found. Complete Step 7.6 first.');
    end

    S = load(dataFile);

    sensorHistory = S.sensorHistory;
    testEngineIDs = S.testEngineIDs;

    % Create monitoring window
    fig = uifigure( ...
        'Name','Sensor Degradation Monitoring', ...
        'Position',[150 100 1000 650], ...
        'Color',[0.08 0.11 0.16]);

    mainGrid = uigridlayout(fig,[3 2]);
    mainGrid.RowHeight = {60,60,'1x'};
    mainGrid.ColumnWidth = {'1x','1x'};
    mainGrid.Padding = [20 15 20 15];
    mainGrid.RowSpacing = 12;
    mainGrid.ColumnSpacing = 15;
    mainGrid.BackgroundColor = [0.08 0.11 0.16];
    mainGrid.RowHeight
    mainGrid.ColumnWidth
    mainGrid.Padding

    % Heading
    heading = uilabel(mainGrid);
    heading.Text = 'SENSOR DEGRADATION MONITORING';
    heading.FontSize = 21;
    heading.FontWeight = 'bold';
    heading.FontColor = [0.2 0.8 0.95];
    heading.HorizontalAlignment = 'center';
    heading.Layout.Row = 1;
    heading.Layout.Column = [1 2];

    % Engine selector
    engineLabel = uilabel(mainGrid);
    engineLabel.Text = 'Select Engine:';
    engineLabel.FontColor = [1 1 1];
    engineLabel.FontSize = 14;
    engineLabel.Layout.Row = 2;
    engineLabel.Layout.Column = 1;

    engineDrop = uidropdown(mainGrid);
    engineDrop.Items = cellstr(string(testEngineIDs));
    engineDrop.Value = engineDrop.Items{1};
    engineDrop.Layout.Row = 2;
    engineDrop.Layout.Column = 2;

    % Sensor selector and chart panel
    chartPanel = uipanel(mainGrid);
    chartPanel.Title = 'Sensor Trend';
    chartPanel.Layout.Row = 3;
    chartPanel.Layout.Column = [1 2];

    chartGrid = uigridlayout(chartPanel,[3 1]);
    chartGrid.RowHeight = {40,40,'1x'};
    chartGrid.Padding = [10 8 10 8];

    sensorDrop = uidropdown(chartGrid);
    sensorDrop.Items = cellstr("Sensor " + (1:21));
    sensorDrop.Value = 'Sensor 1';
    sensorDrop.Layout.Row = 1;
    % Sensor condition indicator
    statusLabel = uilabel(chartGrid);
    statusLabel.Text = 'Sensor Status: Waiting for analysis';
    statusLabel.FontSize = 14;
    statusLabel.FontWeight = 'bold';
    statusLabel.FontColor = [0.1 0.1 0.1];
    statusLabel.BackgroundColor = [0.9 0.9 0.9];
    statusLabel.HorizontalAlignment = 'center';
    statusLabel.Layout.Row = 2;

    ax = uiaxes(chartGrid);
    ax.BackgroundColor = [0.96 0.97 0.99];
    ax.FontSize = 12;
    ax.LineWidth = 1.2;
    ax.Layout.Row = 3;
    ax.XLabel.String = 'Operating Cycle';
    ax.YLabel.String = 'Sensor Reading';
    ax.Title.String = 'Sensor Degradation Trend';

    % Update chart when selection changes
    engineDrop.ValueChangedFcn = @updateChart;
    sensorDrop.ValueChangedFcn = @updateChart;

    updateChart();

    function updateChart(~,~)

        engineID = str2double(engineDrop.Value);
        sensorNumber = str2double( ...
            erase(sensorDrop.Value,'Sensor '));

        index = find(testEngineIDs == engineID,1);

        engineData = sensorHistory{index};

        cycles = engineData(:,2);
        readings = engineData(:,sensorNumber + 5);
        % Compare early readings with recent readings
        n = length(readings);

        windowSize = max(5,ceil(0.2*n));

        baseline = readings(1:max(1,floor(0.6*n)));
        recent = readings(max(1,n-windowSize+1):n);

        baselineMedian = median(baseline);
        recentMedian = median(recent);

        % Robust estimate of baseline variation
        baselineMAD = median(abs(baseline-baselineMedian));
        baselineSigma = 1.4826 * baselineMAD;

        % Fallback if baseline variation is zero
        if baselineSigma < 1e-10
            baselineSigma = std(baseline);
        end

        if baselineSigma < 1e-10
            deviationScore = 0;
        else
            deviationScore = abs(recentMedian-baselineMedian) ...
                / baselineSigma;
        end

        % Assign statistical condition
        if deviationScore >= 3
            sensorStatus = 'CRITICAL';
            statusColor = [1 0.3 0.3];

        elseif deviationScore >= 2
            sensorStatus = 'WARNING';
            statusColor = [1 0.75 0.2];

        else
            sensorStatus = 'NORMAL';
            statusColor = [0.3 0.85 0.5];
        end

        statusLabel.Text = sprintf( ...
            'Sensor Status: %s | Deviation Score: %.2f', ...
            sensorStatus,deviationScore);

        statusLabel.FontColor = [0.08 0.1 0.13];
        statusLabel.BackgroundColor = statusColor;

        cla(ax);
        plot(ax,cycles,readings,'LineWidth',1.5);

        ax.Title.String = sprintf( ...
            'Engine %d - Sensor %d',engineID,sensorNumber);

        ax.XLabel.String = 'Operating Cycle';
        ax.YLabel.String = 'Sensor Reading';
        grid(ax,'on');

    end

end
