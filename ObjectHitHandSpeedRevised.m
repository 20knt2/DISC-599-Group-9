file_path = 'F:\DISC598_Neurosci_Team1\DISC599_Team1_MainStudy\KINARM\6374\20250404\CSV\6374_KINARM_OH_20250404_Session5.csv';

% Read all data from columns AQ and AS starting at row 2
rightValues = readmatrix(file_path, 'Range', 'AQ2:AQ1000');
leftValues  = readmatrix(file_path, 'Range', 'AS2:AS1000');

% Remove NaNs and convert to percentage
rightValues = 100 * rightValues(~isnan(rightValues));
leftValues  = 100 * leftValues(~isnan(leftValues));

% Ensure both sides have the same number of sessions
if length(rightValues) ~= length(leftValues)
    error('Mismatch in number of sessions between Right and Left hands.');
end

num_sessions = length(rightValues);

% Combine into 2 x N matrix
HandSpeed = [leftValues, rightValues]';

% Fixed Min/Max Values
minLeft = 20.7;
maxLeft = 41.2;
minRight = 21.0;
maxRight = 42.3;

% Define a set of colors for the first 5 sessions (black, blue, red, green, purple)
session_colors = [
    0, 0, 0;   % black
    0, 0, 1;   % blue
    1, 0, 0;   % red
    0, 0.5, 0;   % green
    0.5, 0, 0.5 % purple
];

% Plot
figure;
b = bar(HandSpeed, 'grouped');

% Assign colors to the bars for each session
for i = 1:num_sessions
    if i <= 5  % For sessions 1 to 5
        b(i).FaceColor = session_colors(i, :);
    else
        b(i).FaceColor = [0.5, 0.5, 0.5];  % Gray for any additional sessions
    end
end

ylabel('Hand Speed (cm/s)');
xlabel('Hand');
set(gca, 'XTick', 1:2, 'XTickLabel', {'Left', 'Right'}, 'FontSize', 12);

% Add Min & Max lines
hold on
plot([0.5, 1.5], [maxLeft, maxLeft], '--r', 'LineWidth', 2)
plot([0.5, 1.5], [minLeft, minLeft], '--b', 'LineWidth', 2)
plot([1.5, 2.5], [maxRight, maxRight], '--r', 'LineWidth', 2)
plot([1.5, 2.5], [minRight, minRight], '--b', 'LineWidth', 2)

% Add Labels for Min/Max Lines
text(1, maxLeft + 2, 'Left Max', 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(1, minLeft - 2, 'Left Min', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(2, maxRight + 2, 'Right Max', 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(2, minRight - 2, 'Right Min', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');

% Set y-axis limits
ylim([0, 80])

% Add asterisks for values outside threshold
for i = 1:num_sessions
    for hand = 1:2  % 1 = Left, 2 = Right
        val = HandSpeed(hand, i);
        max_val = (hand == 1) * maxLeft + (hand == 2) * maxRight;
        min_val = (hand == 1) * minLeft + (hand == 2) * minRight;

        if val > max_val || val < min_val
            text(b(i).XEndPoints(hand), val + 2, '*', ...
                'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
        end
    end
end

% Title
title('Comparing Hand Speed Across Sessions');

% Create the legend for sessions only (excluding the threshold lines)
legend_entries = arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false);

% Remove threshold lines from the legend
legend_handles = gobjects(num_sessions, 1);
for i = 1:num_sessions
    legend_handles(i) = patch(nan, nan, session_colors(min(i, 5), :));  % Only up to 5 sessions
end

legend([legend_handles], legend_entries, 'Location', 'Best');

hold off;
