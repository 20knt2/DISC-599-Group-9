% Define single CSV file path
file_path = 'F:\DISC598_Neurosci_Team1\DISC599_Team1_MainStudy\KINARM\6374\20250404\CSV\6374_KINARM_APP_20250404_Session5.csv';

% Read column AR from row 3 down
allValues_m = readmatrix(file_path, 'Range', 'AR3:AR1000');  % Read from AR3 downward
allValues_cm = 100 * allValues_m;  % Convert from meters to cm
allValues_cm = allValues_cm(~isnan(allValues_cm));  % Remove empty rows

% Check for even number of rows (Right-Left alternating)
if mod(length(allValues_cm), 2) ~= 0
    error('Expected alternating Right/Left rows. Found uneven number of rows.');
end

% Split into Right (odd rows) and Left (even rows)
FinalDisplacementRight = allValues_cm(1:2:end);
FinalDisplacementLeft  = allValues_cm(2:2:end);
num_sessions = length(FinalDisplacementRight);

% Combine into 2 x N matrix: rows = Left, Right
FinalDisplacement = [FinalDisplacementLeft, FinalDisplacementRight]';

% Fixed Min/Max Thresholds
minLeft = 0.22;
maxLeft = 0.98;
minRight = 0.23;
maxRight = 0.99;

% Define fixed colors for the first four sessions and purple for the fifth session
fixed_colors = [
    0, 0, 0;     % Black for session 1
    0, 0, 1;     % Blue for session 2
    1, 0, 0;     % Red for session 3
    0, 0.5, 0;   % Green for session 4
    0.5, 0, 0.5; % Purple for session 5
];

% Create grouped bar chart
figure;
b = bar(FinalDisplacement, 'grouped');

% Assign session colors
for i = 1:num_sessions
    if i <= 5
        b(i).FaceColor = fixed_colors(i, :);  % Use fixed color for sessions 1-5
    else
        b(i).FaceColor = rand(1, 3);  % Random color for sessions beyond 5
    end
end

ylabel('Final Displacement (cm)')
xlabel('Arm')
categories = {'Left', 'Right'};
set(gca, 'XTick', 1:2, 'XTickLabel', categories, 'FontSize', 12);

% Add Min & Max threshold lines
hold on
plot([0.5, 1.5], [maxLeft, maxLeft], '--r', 'LineWidth', 2)
plot([0.5, 1.5], [minLeft, minLeft], '--b', 'LineWidth', 2)
plot([1.5, 2.5], [maxRight, maxRight], '--r', 'LineWidth', 2)
plot([1.5, 2.5], [minRight, minRight], '--b', 'LineWidth', 2)

% Add labels for threshold lines
text(1, maxLeft + 0.05, 'Left Max', 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(1, minLeft - 0.05, 'Left Min', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(2, maxRight + 0.05, 'Right Max', 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(2, minRight - 0.05, 'Right Min', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');

% Set y-axis limits manually
ylim([0, 1.5])

% Add asterisks for outliers
for i = 1:num_sessions
    for hand = 1:2  % 1 = Left, 2 = Right
        value = FinalDisplacement(hand, i);
        max_val = (hand == 1) * maxLeft + (hand == 2) * maxRight;
        min_val = (hand == 1) * minLeft + (hand == 2) * minRight;

        if value > max_val
            text(b(i).XEndPoints(hand), value + 0.02, '*', ...
                'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
        elseif value < min_val
            text(b(i).XEndPoints(hand), value - 0.02, '*', ...
                'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
        end
    end
end

% Title
title('Comparing Final Displacement Across Sessions')

% Create legend without the max/min lines
legend_entries = arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false);
legend(b, legend_entries, 'Location', 'Best')

hold off
