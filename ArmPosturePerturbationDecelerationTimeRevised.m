% Define path to single session file
file_path = 'F:\DISC598_Neurosci_Team1\DISC599_Team1_MainStudy\KINARM\6374\20250404\CSV\6374_KINARM_APP_20250404_Session5.csv';

% Read column AN starting from row 3
allValues = readmatrix(file_path, 'Range', 'AN3:AN1000');  % Adjust row limit as needed
allValues = allValues(~isnan(allValues));  % Remove any empty rows

% Check for even number of values (Right-Left alternating)
if mod(length(allValues), 2) ~= 0
    error('Uneven number of rows — expected Right/Left alternating values.');
end

% Split into Right (odd rows) and Left (even rows)
DecelerationTimeRight = allValues(1:2:end);  % Right = rows 1,3,5,...
DecelerationTimeLeft  = allValues(2:2:end);  % Left  = rows 2,4,6,...

num_sessions = length(DecelerationTimeRight);

% Rearranged for plotting: rows = Left/Right, cols = Sessions
DecelerationTime = [DecelerationTimeLeft, DecelerationTimeRight]';

% Fixed Min/Max Values
minLeft = 0.16;
maxLeft = 0.34;
minRight = 0.16;
maxRight = 0.35;

% Define fixed colors for the first four sessions and purple for the fifth session
fixed_colors = [
    0, 0, 0;     % Black for session 1
    0, 0, 1;     % Blue for session 2
    1, 0, 0;     % Red for session 3
    0, 0.5, 0;   % Green for session 4
    0.5, 0, 0.5; % Purple for session 5
];

% Create Bar Chart
figure;
b = bar(DecelerationTime, 'grouped');

% Assign colors for each session
for i = 1:num_sessions
    if i <= 5
        b(i).FaceColor = fixed_colors(i, :);  % Use fixed color for sessions 1-5
    else
        b(i).FaceColor = rand(1, 3);  % Random color for sessions beyond 5
    end
end

ylabel('Deceleration Time (s)')
xlabel('Arm')
categories = {'Left Arm', 'Right Arm'};
set(gca, 'XTick', 1:2, 'XTickLabel', categories, 'FontSize', 12);

% Add Min/Max reference lines
hold on
plot([0.5, 1.5], [maxLeft, maxLeft], '--r', 'LineWidth', 2)
plot([0.5, 1.5], [minLeft, minLeft], '--b', 'LineWidth', 2)
plot([1.5, 2.5], [maxRight, maxRight], '--r', 'LineWidth', 2)
plot([1.5, 2.5], [minRight, minRight], '--b', 'LineWidth', 2)

% Add text labels for threshold lines
text(1, maxLeft + 0.015, 'Left Max', 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(1, minLeft - 0.015, 'Left Min', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(2, maxRight + 0.015, 'Right Max', 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(2, minRight - 0.015, 'Right Min', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');

% Set y-axis limits
ylim([0, 0.4])

% Add asterisks for values above max or below min
for i = 1:num_sessions
    for hand = 1:2  % 1 = Left, 2 = Right
        value = DecelerationTime(hand, i);
        max_val = (hand == 1) * maxLeft + (hand == 2) * maxRight;
        min_val = (hand == 1) * minLeft + (hand == 2) * minRight;
        
        if value > max_val
            text(b(i).XEndPoints(hand), value + 0.01, '*', 'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'red');
        elseif value < min_val
            text(b(i).XEndPoints(hand), value - 0.01, '*', 'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'blue');
        end
    end
end

% Title
title('Comparing Deceleration Time Across Sessions')

% Legend for sessions only (no max/min lines)
legend_entries = arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false);
legend(b, legend_entries, 'Location', 'Best')

hold off
