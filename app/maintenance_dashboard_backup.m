
function maintenance_dashboard()

    % Load prediction results
    dataFile = 'data/complete_machine_results.mat';

    if ~isfile(dataFile)
        error('Prediction results file not found.');
    end

    S = load(dataFile);

    if ~isfield(S,'FinalMachineResults')
        error('FinalMachineResults is missing from the saved file.');
    end

    T = S.FinalMachineResults;

    % Create main dashboard window
    fig = uifigure( ...
        'Name','Predictive Maintenance System', ...
        'Position',[100 100 1100 700], ...
        'Color',[0.08 0.11 0.16]);

    % Main layout
    gl = uigridlayout(fig,[5 2]);
    gl.RowHeight = {65,65,100,'1x','1x'};
    gl.ColumnWidth = {'1x','1x'};
    gl.Padding = [20 15 20 15];
    gl.RowSpacing = 12;
    gl.ColumnSpacing = 15;
    gl.BackgroundColor = [0.08 0.11 0.16];

    % Dashboard heading
    heading = uilabel(gl);
    heading.Text = 'PREDICTIVE MAINTENANCE MONITORING';
    heading.FontSize = 22;
    heading.FontWeight = 'bold';
    heading.FontColor = [0.2 0.8 0.95];
    heading.HorizontalAlignment = 'center';
    heading.Layout.Row = 1;
    heading.Layout.Column = [1 2];

    % Machine selection
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

    % Machine information panel
    infoPanel = uipanel(gl);
    infoPanel.Title = 'Machine Information';
    infoPanel.FontWeight = 'bold';
    infoPanel.Layout.Row = 3;
    infoPanel.Layout.Column = [1 2];

    infoGrid = uigridlayout(infoPanel,[1 3]);

    rulLabel = uilabel(infoGrid);
    rulLabel.FontSize = 16;
    rulLabel.FontWeight = 'bold';

    riskLabel = uilabel(infoGrid);
    riskLabel.FontSize = 16;
    riskLabel.FontWeight = 'bold';

    recommendationLabel = uilabel(infoGrid);
    recommendationLabel.WordWrap = 'on';
    recommendationLabel.FontSize = 13;

    % RUL chart
    rulPanel = uipanel(gl);
    rulPanel.Title = 'Predicted Remaining Useful Life';
    rulPanel.Layout.Row = 4;
    rulPanel.Layout.Column = 1;

    rulAxes = uiaxes(rulPanel);
    rulAxes.Position = [45 45 440 190];
    rulAxes.YLabel.String = 'RUL (cycles)';
    rulAxes.XLabel.String = 'Selected Engine';
    rulAxes.Title.String = 'RUL Prediction';

    % Risk distribution chart
    riskPanel = uipanel(gl);
    riskPanel.Title = 'Machine Risk Distribution';
    riskPanel.Layout.Row = 4;
    riskPanel.Layout.Column = 2;

    riskAxes = uiaxes(riskPanel);
    riskAxes.Position = [45 45 440 190];

    % Machine results table
    resultsPanel = uipanel(gl);
    resultsPanel.Title = 'Machine Prediction Records';
    resultsPanel.Layout.Row = 5;
    resultsPanel.Layout.Column = [1 2];

    resultsTable = uitable(resultsPanel);
    resultsTable.Position = [10 10 1020 190];
    resultsTable.Data = T(:, ...
        {'EngineID','PredictedRUL','PredictedRisk', ...
         'MaintenanceRecommendation'});

    % Update dashboard when engine selection changes
    engineDrop.ValueChangedFcn = @updateMachine;

    % Initial display
    updateMachine();

    % Nested dashboard update function
    function updateMachine(~,~)

        selectedID = str2double(engineDrop.Value);

        idx = find(T.EngineID == selectedID,1);

        if isempty(idx)
            return;
        end

        currentRUL = T.PredictedRUL(idx);
        currentRisk = string(T.PredictedRisk(idx));
        recommendation = string(T.MaintenanceRecommendation(idx));

        rulLabel.Text = sprintf('Predicted RUL: %.1f cycles',currentRUL);
        riskLabel.Text = "Risk: " + currentRisk;
        recommendationLabel.Text = "Action: " + recommendation;

        % Update selected engine chart
        cla(rulAxes);
        bar(rulAxes,currentRUL);
        rulAxes.XTick = 1;
        rulAxes.XTickLabel = {engineDrop.Value};
        rulAxes.YLabel.String = 'Remaining cycles';

        % Update risk distribution
        riskCategories = ["Low","Medium","High"];
        riskCounts = zeros(1,3);

        for k = 1:3
            riskCounts(k) = sum( ...
                string(T.PredictedRisk) == riskCategories(k));
        end

        cla(riskAxes);
        bar(riskAxes,riskCounts);
        riskAxes.XTick = 1:3;
        riskAxes.XTickLabel = cellstr(riskCategories);
        riskAxes.YLabel.String = 'Number of engines';
        riskAxes.Title.String = 'Predicted Risk Categories';

    end

end
