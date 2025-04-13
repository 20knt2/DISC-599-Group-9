% Define file path (single CSV)
file_path = 'F:\DISC598_Neurosci_Team1\DISC599_Team1_MainStudy\KINARM\6374\20250404\CSV\6374_KINARM_APP_20250404_Session5.csv';

% Read full column AT (displacement values in meters)
allDisplacements_m = readmatrix(file_path, 'Range', 'AT3:AT1000');  % Adjust upper row limit if needed
allDisplacements_cm = 100 * allDisplacements_m;  % Convert to cm

% Remove NaNs and determine how many sessions are present
allDisplacements_cm = allDisplacements_cm(~isnan(allDisplacements_cm));
num_sessions = length(allDisplacements_cm) / 2;

if mod(num_sessions, 1) ~= 0
    error('Mismatch in row count: Make sure data alternates as Right, Left per session.');
end

% Separate into Left and Right by alternating rows
MaxDisplacementRight = allDisplacements_cm(1:2:end);  % Odd rows (1st, 3rd, ...)
MaxDisplacementLeft  = allDisplacements_cm(2:2:end);  % Even rows (2nd, 4th, ...)

% Rearrange Data to Ensure Correct Grouping
MaxDisplacement = [MaxDisplacementLeft, MaxDisplacementRight]';  % (2 x Sessions)

% Fixed Min/Max Values
minRight = 1.32;
maxRight = 4.02;
minLeft = 1.37;
maxLeft = 4.05;

% Define custom colors for each session
custom_colors = [
    0, 0, 0;     % Black for session 1
    0, 0, 1;     % Blue for session 2
    1, 0, 0;     % Red for session 3
    0 0.5 0     % green
    0.5 0 0.5 %purple
];     
    

% Create Bar Chart
figure;
b = bar(MaxDisplacement, 'grouped');

% Assign custom colors to each session
for i = 1:num_sessions
    b(i).FaceColor = custom_colors(i, :);
end

ylabel('Maximum Displacement (cm)')
xlabel('Arm')
categories = {'Left', 'Right'};
set(gca, 'XTick', 1:2, 'XTickLabel', categories, 'FontSize', 12);

% Add Min & Max lines for each arm
hold on
plot([0.5, 1.5], [maxLeft, maxLeft], '--r', 'LineWidth', 2)
plot([0.5, 1.5], [minLeft, minLeft], '--b', 'LineWidth', 2)
plot([1.5, 2.5], [maxRight, maxRight], '--r', 'LineWidth', 2)
plot([1.5, 2.5], [minRight, minRight], '--b', 'LineWidth', 2)

% Labels for Min/Max
text(1, maxLeft + 0.2, 'Left Max', 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(1, minLeft - 0.2, 'Left Min', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(2, maxRight + 0.2, 'Right Max', 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(2, minRight - 0.2, 'Right Min', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');

ylim([0, 5])

% Add asterisks for values above max or below min
for i = 1:num_sessions
    for hand = 1:2  % 1 = Left, 2 = Right
        value = MaxDisplacement(hand, i);
        max_val = (hand == 1) * maxLeft + (hand == 2) * maxRight;
        min_val = (hand == 1) * minLeft + (hand == 2) * minRight;
        
        if value > max_val
            text(b(i).XEndPoints(hand), value + 0.1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'red');
        elseif value < min_val
            text(b(i).XEndPoints(hand), value - 0.1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'blue');
        end
    end
end

title('Comparing Maximum Displacement Across Sessions')

% Legend
legend_entries = arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false);
legend(b, legend_entries, 'Location', 'Best')

hold off
