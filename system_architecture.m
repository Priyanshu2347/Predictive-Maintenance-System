
function system_architecture

fig = uifigure( ...
    'Name','Predictive Maintenance System Architecture', ...
    'Position',[100 100 1150 800], ...
    'Color',[0.94 0.96 0.99]);

gl = uigridlayout(fig,[8 2]);
gl.RowHeight = {55,75,75,75,100,75,85,85};
gl.ColumnWidth = {'1x','1x'};
gl.Padding = [20 15 20 15];
gl.RowSpacing = 12;
gl.ColumnSpacing = 15;
gl.BackgroundColor = [0.94 0.96 0.99];

addBlock(gl,'PREDICTIVE MAINTENANCE SYSTEM', ...
    'Machine Health Monitoring and Failure Prediction',1,[1 2],1);

addBlock(gl,'NASA C-MAPSS DATASET', ...
    'Historical engine cycles and sensor measurements',2,[1 2],2);

addBlock(gl,'DATA PREPROCESSING', ...
    'Loading | Validation | Cleaning | Normalization',3,[1 2],3);

addBlock(gl,'FEATURE EXTRACTION', ...
    'Sensor trends | Statistical features | Anomaly detection',4,[1 2],3);

addBlock(gl,'RUL PREDICTION', ...
    'Bagged Trees Regression',5,1,2);

addBlock(gl,'RISK CLASSIFICATION', ...
    'Bagged Trees Classification',5,2,2);

addBlock(gl,'MAINTENANCE DECISION ENGINE', ...
    'Risk categories | Priority scores | Recommendations',6,[1 2],3);

addBlock(gl,'INTERACTIVE MATLAB DASHBOARD', ...
    'Charts | Sensor Monitor | Machine Records | Alerts',7,[1 2],1);

addBlock(gl,'OUTPUT AND REPORTS', ...
    'Predicted RUL | Risk levels | Maintenance actions | CSV reports',8,[1 2],2);

end

function addBlock(parent,heading,description,row,col,themeID)

% Professional color palette
themes = {
    [0.10 0.24 0.42], [1.00 1.00 1.00];  % Navy
    [0.84 0.91 0.98], [0.08 0.18 0.32];  % Light blue
    [0.88 0.94 0.92], [0.08 0.25 0.22]   % Light teal
    };

bg = themes{themeID,1};
fg = themes{themeID,2};

p = uipanel(parent);
p.Layout.Row = row;
p.Layout.Column = col;
p.BackgroundColor = bg;
p.BorderType = 'line';
p.BorderWidth = 1;

g = uigridlayout(p,[2 1]);
g.RowHeight = {'1.2x','1x'};
g.Padding = [8 5 8 5];
g.RowSpacing = 2;
g.BackgroundColor = bg;

t = uilabel(g);
t.Text = heading;
t.FontSize = 16;
t.FontWeight = 'bold';
t.FontColor = fg;
t.HorizontalAlignment = 'center';
t.VerticalAlignment = 'center';

d = uilabel(g);
d.Text = description;
d.FontSize = 12;
d.FontWeight = 'bold';
d.FontColor = fg;
d.HorizontalAlignment = 'center';
d.VerticalAlignment = 'center';

end
