file_path = 'F:\DISC598_Neurosci_Team1\DISC599_Team1_MainStudy\KINARM\6374\20250404\CSV\6374_KINARM_OHA_20250404_Session5.csv';

% Read Target Hits (as percentage) from AI2 to AI1000 and clean up
TargetHits = readmatrix(file_path, 'Range', 'AI2:AI1000') / 200 * 100;
TargetHits = TargetHits(~isnan(TargetHits));
num_sessions = length(TargetHits);

% Define preset colors for sessions 1 to 5 (black, blue, red, green, purple)
session_colors = [
    0, 0, 0;   % black
    0, 0, 1;   % blue
    1, 0, 0;   % red
    0, 0.5, 0;   % green
    0.5, 0, 0.5 % purple
];

% Create bar chart with session-specific colors
figure
b = bar(TargetHits, 'FaceColor', 'flat');
for i = 1:num_sessions
    if i <= 5  % For sessions 1 to 5
        b.CData(i, :) = session_colors(i, :);
    else
        b.CData(i, :) = [0.5, 0.5, 0.5];  % Gray for sessions beyond 5, if any
    end
end

ylabel('Target Hits (%)')
xlabel('Session')

% Set x-axis labels
categories = arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false);
set(gca, 'XTick', 1:num_sessions, 'XTickLabel', categories, 'FontSize', 12)

% Thresholds
lineYupper = 81;
lineYlower = 55;

% Add min/max lines
hold on
yline(lineYupper, '--r', 'Upper Limit', 'LineWidth', 2)
yline(lineYlower, '--b', 'Lower Limit', 'LineWidth', 2)

% Set y-axis limits
ylim([0, 100])

% Add asterisks for out-of-range values
for i = 1:num_sessions
    val = TargetHits(i);
    if val > lineYupper
        text(i, val + 4, '*', 'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
    elseif val < lineYlower
        text(i, val + 8, '*', 'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
    end
end

% Title
title('Comparing Target Hits Across Sessions')

% Create color-coded legend (without threshold lines)
legend_entries = arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false);

% Remove threshold lines from the legend
legend_handles = gobjects(num_sessions, 1);
for i = 1:num_sessions
    legend_handles(i) = patch(nan, nan, session_colors(min(i, 5), :));
end

legend([legend_handles], legend_entries, 'Location', 'Best');

hold off;
