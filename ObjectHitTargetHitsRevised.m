file_path = 'F:\DISC598_Neurosci_Team1\DISC599_Team1_MainStudy\KINARM\6374\20250404\CSV\6374_KINARM_OH_20250404_Session5.csv';

% Read all session values from column AI (starting at row 2)
TargetHits = readmatrix(file_path, 'Range', 'AI2:AI1000');
TargetHits = TargetHits(~isnan(TargetHits)) / 3;  % Convert to %

num_sessions = length(TargetHits);

% Define custom colors for sessions 1 to 5 (black, blue, red, green, purple)
session_colors = [
    0, 0, 0;    % black
    0, 0, 1;    % blue
    1, 0, 0;    % red
    0, 0.5, 0;  % green
    0.5, 0, 0.5 % purple
];

% Create bar chart
figure;
b = bar(TargetHits, 'FaceColor', 'flat');

% Assign custom colors to the bars
for i = 1:num_sessions
    if i <= 5
        b.CData(i, :) = session_colors(i, :);  % For sessions 1 to 5
    else
        b.CData(i, :) = [0.5, 0.5, 0.5];  % Gray for any additional sessions beyond 5
    end
end

ylabel('Target Hits (%)');
xlabel('Session');

% X-axis labels
categories = arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false);
set(gca, 'XTick', 1:num_sessions, 'XTickLabel', categories, 'FontSize', 12);

% Threshold lines
lineYupper = 87;
lineYlower = 62;
yline(lineYupper, '--r', 'Upper Limit', 'LineWidth', 2);
yline(lineYlower, '--b', 'Lower Limit', 'LineWidth', 2);

% Y-axis limits
ylim([0 100]);

% Add asterisks for out-of-range values
hold on;
for i = 1:num_sessions
    val = TargetHits(i);
    if val > lineYupper || val < lineYlower
        text(i, val + 4, '*', 'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
    end
end

% Title
title('Comparing Target Hits Across Sessions');

% Legend
legend_entries = arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false);

% Create the legend handles for sessions (up to 5 sessions with custom colors)
legend_handles = gobjects(num_sessions, 1);
for i = 1:num_sessions
    legend_handles(i) = patch(nan, nan, session_colors(min(i, 5), :));  % Only up to 5 sessions with custom colors
end

% Create the final legend
legend([legend_handles], legend_entries, 'Location', 'Best');

hold off;
