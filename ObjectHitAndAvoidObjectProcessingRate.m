file_path = 'F:\DISC598_Neurosci_Team1\DISC599_Team1_MainStudy\KINARM\6374\20250404\CSV\6374_KINARM_OHA_20250404_Session5.csv';

% Read Object Processing Rate from BB2 to BB1000
ObjectProcessingRate = readmatrix(file_path, 'Range', 'BB2:BB1000');
ObjectProcessingRate = ObjectProcessingRate(~isnan(ObjectProcessingRate));  % Remove any NaNs

num_sessions = length(ObjectProcessingRate);

% Define preset colors for sessions 1 to 5 (black, blue, red, green, purple)
session_colors = [
    0, 0, 0;   % black
    0, 0, 1;   % blue
    1, 0, 0;   % red
    0, 0.5, 0;   % green
    0.5, 0, 0.5 % purple
];

% Create bar chart with unique session colors
figure
b = bar(ObjectProcessingRate, 'FaceColor', 'flat');
for i = 1:num_sessions
    if i <= 5  % For sessions 1 to 5
        b.CData(i, :) = session_colors(i, :);
    else
        b.CData(i, :) = [0.5, 0.5, 0.5];  % Gray for sessions beyond 5, if any
    end
end

ylabel('Object Processing Rate (#/s)')
xlabel('Session')

% X-axis labels
categories = arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false);
set(gca, 'XTick', 1:num_sessions, 'XTickLabel', categories, 'FontSize', 12)

% Define limits
lineYupper = 2.53;
lineYlower = 1.68;

% Add threshold lines
hold on
yline(lineYupper, '--r', 'Upper Limit', 'LineWidth', 2)
yline(lineYlower, '--b', 'Lower Limit', 'LineWidth', 2)

% Set y-axis range
ylim([0, 3])

% Add asterisks for values above max or below min
for i = 1:num_sessions
    rate = ObjectProcessingRate(i);
    if rate > lineYupper
        text(i, rate + 0.1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
    elseif rate < lineYlower
        text(i, rate + 0.1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
    end
end

% Title
title('Comparing Object Processing Rate Across Sessions')

% Create color-coded legend (without threshold lines)
legend_entries = arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false);

% Remove threshold lines from the legend
legend_handles = gobjects(num_sessions, 1);
for i = 1:num_sessions
    legend_handles(i) = patch(nan, nan, session_colors(min(i, 5), :));
end

legend([legend_handles], legend_entries, 'Location', 'Best');

hold off;
