
function maintenance_dashboard()

    % Load saved prediction results
    dataFile = 'data/complete_machine_results.mat';

    if ~isfile(dataFile)
        error('Prediction results file not found.');
    end

    S = load(dataFile);

    if ~isfield(S,'FinalMachineResults')
        error('FinalMachineResults is missing.');
    end

    T = S.FinalMachineResults;
    % Load feature importance
    F = load('data/feature_importance.mat');
    FeatureImportance = F.FeatureImportance;

    % Calculate dashboard statistics
    riskValues = string(T.PredictedRisk);

    totalMachines = height(T);
    highRiskCount = sum(riskValues == "High");
    mediumRiskCount = sum(riskValues == "Medium");
    lowRiskCount = sum(riskValues == "Low");
    averageRUL = mean(T.PredictedRUL);

    % Load high-risk alert report
    alertFile = 'data/high_risk_alerts.csv';

    if isfile(alertFile)
        HighRiskAlerts = readtable(alertFile);
    else
        HighRiskAlerts = T(riskValues == "High", :);
    end

    % Calculate alert statistics
    totalAlerts = height(HighRiskAlerts);

    fprintf('\n========== DASHBOARD ALERT SUMMARY ==========\n');
    fprintf('Total machines: %d\n', totalMachines);
    fprintf('High-risk alerts: %d\n', totalAlerts);
    fprintf('=============================================\n');

    % Main dashboard window
    fig = uifigure( ...
        'Name','Predictive Maintenance System', ...
        'Position',[50 30 1350 850], ...
        'Color',[0.08 0.11 0.16]);

    fig.WindowState = 'fullscreen';

    % Main layout
    gl = uigridlayout(fig,[9 2]);

    gl.RowHeight = {32,30,28,100,65,280,320,220,250};
    gl.ColumnWidth = {'1x','1x'};
    gl.Padding = [18 15 18 15];
    gl.RowSpacing = 12;
    gl.ColumnSpacing = 15;
    gl.BackgroundColor = [0.08 0.11 0.16];
    % Enable vertical scrolling
    gl.Scrollable = 'on';
    % Dashboard heading
    heading = uilabel(gl);
    heading.Text = 'PREDICTIVE MAINTENANCE MONITORING';
    heading.FontSize = 22;
    heading.FontWeight = 'bold';
    heading.FontColor = [0.2 0.8 0.95];
    heading.HorizontalAlignment = 'center';
    heading.Layout.Row = 1;
    heading.Layout.Column = [1 2];

    % Engine selection
    selectLabel = uilabel(gl);
    selectLabel.Text = 'Select Engine ID:';
    selectLabel.FontColor = [1 1 1];
    selectLabel.FontSize = 14;
    selectLabel.Layout.Row = 2;
    selectLabel.Layout.Column = 1;

    engineDrop = uidropdown(gl);
    engineDrop.Items = cellstr(string(T.EngineID));
    engineDrop.Value = engineDrop.Items{1};
    engineDrop.Layout.Row = 2;
    engineDrop.Layout.Column = 2;
    % KPI panel
    kpiPanel = uipanel(gl);
    kpiPanel.Title = 'SYSTEM OVERVIEW';
    kpiPanel.ForegroundColor = [0.1 0.85 1.0];
    kpiPanel.FontWeight = 'bold';
    kpiPanel.Layout.Row = 4;
    kpiPanel.Layout.Column = [1 2];
    kpiPanel.BackgroundColor = [0.11 0.15 0.21];

    kpiGrid = uigridlayout(kpiPanel,[1 5]);
    kpiGrid.ColumnWidth = {'1x','1x','1x','1x','1x'};
    kpiGrid.Padding = [5 4 5 4];
    kpiGrid.ColumnSpacing = 6;

    % KPI values
    kpiTitles = {'Total Engines','High Risk', ...
        'Medium Risk','Low Risk','Average RUL'};

    kpiValues = {sprintf('%d',totalMachines), ...
        sprintf('%d',highRiskCount), ...
        sprintf('%d',mediumRiskCount), ...
        sprintf('%d',lowRiskCount), ...
        sprintf('%.1f',averageRUL)};

    kpiColors = {[0.2 0.8 0.95], ...
        [1 0.35 0.35], ...
        [1 0.75 0.25], ...
        [0.3 0.85 0.5], ...
        [0.3 0.8 1]};

    for i = 1:5

        card = uipanel(kpiGrid);
        card.BackgroundColor = [0.92 0.95 0.98];

        cardGrid = uigridlayout(card,[2 1]);
        cardGrid.RowHeight = {25,'1x'};
        cardGrid.Padding = [4 4 4 4];
        cardGrid.Padding = [3 3 3 3];

        titleLabel = uilabel(cardGrid);
        titleLabel.Text = kpiTitles{i};
        titleLabel.FontSize = 10;
        titleLabel.FontColor = [0.15 0.18 0.22];
        titleLabel.FontWeight = 'bold';
        titleLabel.HorizontalAlignment = 'center';
        titleLabel.Layout.Row = 1;

        valueLabel = uilabel(cardGrid);
        valueLabel.Text = kpiValues{i};
        valueLabel.FontSize = 19;
        valueLabel.FontWeight = 'bold';
        valueLabel.FontColor = kpiColors{i};
        valueLabel.HorizontalAlignment = 'center';
        valueLabel.Layout.Row = 2;

    end

    % Machine information panel
    infoPanel = uipanel(gl);
    infoPanel.Title = 'SELECTED MACHINE INFORMATION';
    infoPanel.ForegroundColor = [0.1 0.85 1.0];
    infoPanel.FontWeight = 'bold';
    infoPanel.BackgroundColor = [0.92 0.95 0.98];
    infoPanel.Layout.Row = 5;
    infoPanel.Layout.Column = [1 2];

    infoGrid = uigridlayout(infoPanel,[1 3]);
    infoGrid.Padding = [8 5 8 5];
    infoGrid.ColumnWidth = {'1x','1x','1.5x'};

    rulLabel = uilabel(infoGrid);
    rulLabel.FontSize = 15;
    rulLabel.FontWeight = 'bold';

    riskLabel = uilabel(infoGrid);
    riskLabel.FontSize = 15;
    riskLabel.FontWeight = 'bold';

    recommendationLabel = uilabel(infoGrid);
    recommendationLabel.WordWrap = 'on';
    recommendationLabel.FontSize = 12;

    % RUL chart
    rulPanel = uipanel(gl);
    rulPanel.Title = 'Predicted Remaining Useful Life';
    rulPanel.Layout.Row = 6;
    rulPanel.Layout.Column = 1;

    rulAxes = uiaxes(rulPanel);
    rulAxes.Units = 'normalized';
    rulAxes.Position = [0.12 0.18 0.82 0.72];
    rulAxes.YLabel.String = 'RUL (cycles)';
    rulAxes.XLabel.String = 'Selected Engine';
    rulAxes.Title.String = 'RUL Prediction';

    % Risk distribution chart
    riskPanel = uipanel(gl);
    riskPanel.Title = 'Machine Risk Distribution';
    riskPanel.Layout.Row = 6;
    riskPanel.Layout.Column = 2;

    riskAxes = uiaxes(riskPanel);
    riskAxes.Units = 'normalized';
    riskAxes.Position = [0.12 0.18 0.82 0.72];

    % Feature importance panel
    importancePanel = uipanel(gl);
    importancePanel.Title = 'Top 10 Features Influencing Failure Risk';
    importancePanel.Layout.Row = 7;
    importancePanel.Layout.Column = [1 2];

    importanceAxes = uiaxes(importancePanel);
    importanceAxes.Units = 'normalized';
    importanceAxes.Position = [0.08 0.12 0.88 0.80];

    topFeatures = FeatureImportance(1:min(10,height(FeatureImportance)),:);

    barh(importanceAxes,topFeatures.Importance);
    importanceAxes.FontSize = 10;
    importanceAxes.YTickLabel = cellstr(topFeatures.Feature);
    importanceAxes.TickLabelInterpreter = 'none';
    importanceAxes.YDir = 'reverse';

    importanceAxes.YTick = 1:height(topFeatures);
    importanceAxes.YTickLabel = cellstr(topFeatures.Feature);
    importanceAxes.YDir = 'reverse';

    importanceAxes.XLabel.String = 'Importance Score';
    importanceAxes.Title.String = 'Machine Learning Feature Importance';

    grid(importanceAxes,'on');

    % Results table
    resultsPanel = uipanel(gl);
    resultsPanel.Title = 'Machine Prediction Records';
    resultsPanel.Layout.Row = 8;
    resultsPanel.Layout.Column = [1 2];

    tableGrid = uigridlayout(resultsPanel,[1 1]);
    tableGrid.Padding = [5 5 5 5];

    resultsTable = uitable(tableGrid);

    resultsTable.Data = T(:, ...
        {'EngineID','PredictedRUL','PredictedRisk', ...
        'MaintenanceRecommendation'});

    % Sensor monitoring button
    sensorButton = uibutton(gl,'push');

    sensorButton.Text = 'OPEN SENSOR MONITOR';
    sensorButton.FontWeight = 'bold';
    sensorButton.FontSize = 13;
    sensorButton.BackgroundColor = [0.1 0.65 0.85];
    sensorButton.FontColor = [1 1 1];

    sensorButton.Layout.Row = 3;
    sensorButton.Layout.Column = [1 2];
     
    % Automated High-Risk Alert Panel
    alertPanel = uipanel(gl);

    alertPanel.Title = 'CRITICAL MACHINE ALERTS';
    alertPanel.ForegroundColor = [1 0.3 0.3];
    alertPanel.FontWeight = 'bold';
    alertPanel.BackgroundColor = [0.11 0.15 0.21];

    alertPanel.Layout.Row = 9;
    alertPanel.Layout.Column = [1 2];

    % Alert panel layout
    alertGrid = uigridlayout(alertPanel,[1 1]);
    alertGrid.Padding = [6 6 6 6];

    % Alert table
    alertTable = uitable(alertGrid);

    alertTable.Data = HighRiskAlerts(:, ...
        {'EngineID','PredictedRUL','PredictedRisk', ...
        'MaintenanceRecommendation','PriorityScore'});

    alertTable.ColumnName = { ...
        'Engine ID', ...
        'Predicted RUL', ...
        'Risk Level', ...
        'Maintenance Action', ...
        'Priority'};

    alertTable.RowName = {};

    alertTable.FontSize = 11;
    alertTable.ColumnWidth = ...
        {90,110,100,260,80};
    sensorButton.ButtonPushedFcn = @(src,event) sensor_monitor();
    % Engine selection callback
    engineDrop.ValueChangedFcn = @updateMachine;

    % Initial dashboard display
    updateMachine();
   

    % Update selected machine
    function updateMachine(~,~)

        selectedID = str2double(engineDrop.Value);

        idx = find(T.EngineID == selectedID,1);

        if isempty(idx)
            return;
        end

        currentRUL = T.PredictedRUL(idx);
        currentRisk = string(T.PredictedRisk(idx));

        recommendation = ...
            string(T.MaintenanceRecommendation(idx));

        rulLabel.Text = sprintf( ...
            'Predicted RUL: %.1f cycles',currentRUL);

        riskLabel.Text = sprintf('Risk: %s',currentRisk);

        recommendationLabel.Text = ...
            sprintf('Action: %s',recommendation);

        % Update RUL chart - 10 engines with lowest RUL
        cla(rulAxes);

        [~, sortedIndices] = sort(T.PredictedRUL, 'ascend');

        topCount = min(10, height(T));
        topIndices = sortedIndices(1:topCount);

        topRUL = T.PredictedRUL(topIndices);
        topEngineIDs = T.EngineID(topIndices);

        bar(rulAxes, topRUL);

        rulAxes.XTick = 1:topCount;
        rulAxes.XTickLabel = string(topEngineIDs);
        rulAxes.XTickLabelRotation = 45;

        rulAxes.YLabel.String = 'Remaining cycles';
        rulAxes.XLabel.String = 'Engine ID';
        rulAxes.Title.String = '10 Engines Requiring Attention';

        % Update risk distribution
        riskCategories = ["Low","Medium","High"];

        riskCounts = [lowRiskCount, ...
            mediumRiskCount,highRiskCount];

        cla(riskAxes);
        bar(riskAxes,riskCounts);

        riskAxes.XTick = 1:3;
        riskAxes.XTickLabel = cellstr(riskCategories);
        riskAxes.YLabel.String = 'Number of engines';
        riskAxes.Title.String = 'Predicted Risk Categories';

    end

end
