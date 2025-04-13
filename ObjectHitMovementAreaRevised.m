file_path = 'F:\DISC598_Neurosci_Team1\DISC599_Team1_MainStudy\KINARM\6374\20250404\CSV\6374_KINARM_OH_20250404_Session5.csv';

% Read all session values from columns AR (Right) and AT (Left), starting at row 2
MovementAreaRight = 10000 * readmatrix(file_path, 'Range', 'AR2:AR1000');
MovementAreaLeft  = 10000 * readmatrix(file_path, 'Range', 'AT2:AT1000');

% Remove NaNs
MovementAreaRight = MovementAreaRight(~isnan(MovementAreaRight));
MovementAreaLeft  = MovementAreaLeft(~isnan(MovementAreaLeft));

% Ensure equal number of sessions
if length(MovementAreaRight) ~= length(MovementAreaLeft)
    error('Mismatch in session counts between Right and Left arm data.');
end

num_sessions = length(MovementAreaRight);

% Combine into 2 x N matrix
MovementArea = [MovementAreaLeft, MovementAreaRight]';

% Fixed Min/Max Values
minLeft = 890;
maxLeft = 1910;
minRight = 940;
maxRight = 1970;

% Define a set of colors for the first 5 sessions (black, blue, red, green, purple)
session_colors = [
    0, 0, 0;   % black
    0, 0, 1;   % blue
    1, 0, 0;   % red
    0, 0.5, 0; % green
    0.5, 0, 0.5 % purple
];

% Plot
figure;
b = bar(MovementArea, 'grouped');

% Assign colors to the bars for each session
for i = 1:num_sessions
    if i <= 5  % For sessions 1 to 5
        b(i).FaceColor = session_colors(i, :);
    else
        b(i).FaceColor = [0.5, 0.5, 0.5];  % Gray for any additional sessions
    end
end

% Set labels and title
ylabel('Movement Area (cm^2)', 'FontSize', 12);
xlabel('Hand', 'FontSize', 12);
set(gca, 'XTick', 1:2, 'XTickLabel', {'Left', 'Right'}, 'FontSize', 12);

% Add Min & Max lines
hold on
hMaxLeft = plot([0.5, 1.5], [maxLeft, maxLeft], '--r', 'LineWidth', 2);
hMinLeft = plot([0.5, 1.5], [minLeft, minLeft], '--b', 'LineWidth', 2);
hMaxRight = plot([1.5, 2.5], [maxRight, maxRight], '--r', 'LineWidth', 2);
hMinRight = plot([1.5, 2.5], [minRight, minRight], '--b', 'LineWidth', 2);

% Add Labels for Min/Max Lines
text(1, maxLeft + 100, 'Left Max', 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(1, minLeft - 100, 'Left Min', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(2, maxRight + 100, 'Right Max', 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(2, minRight - 100, 'Right Min', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');

% Set y-axis limits
ylim([0, 3500]);

% Add asterisks for values outside threshold
for i = 1:num_sessions
    for hand = 1:2  % 1 = Left, 2 = Right
        val = MovementArea(hand, i);
        max_val = (hand == 1) * maxLeft + (hand == 2) * maxRight;
        min_val = (hand == 1) * minLeft + (hand == 2) * minRight;

        % Check if value is out of bounds and add asterisks
        if val > max_val
            text(b(i).XEndPoints(hand), val + 50, '*', ...
                'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
        elseif val < min_val
            text(b(i).XEndPoints(hand), val - 50, '*', ...
                'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
        end
    end
end

% Title
title('Comparing Movement Area Across Sessions');

% Create the legend for sessions only (excluding the threshold lines)
legend_entries = arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false);


% Create the final legend including sessions and threshold lines
legend(legend_entries,'Location', 'Best');

hold off;
