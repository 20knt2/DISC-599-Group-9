% Path to the file
file_path = 'F:\DISC598_Neurosci_Team1\DISC599_Team1_MainStudy\KINARM\6374\20250404\CSV\6374_KINARM_ES_20250404_Session5.csv';

% Read data from column AZ starting from row 2
allValues = readmatrix(file_path, 'Range', 'AZ2:AZ1000');
allValues = allValues(~isnan(allValues));

% Check length
if mod(length(allValues), 2) ~= 0
    error('Expected even number of values (alternating Right/Left).');
end

num_sessions = length(allValues) / 2;

% Preallocate
EndTorque600msFlexionRight = nan(num_sessions, 1);
EndTorque600msFlexionLeft  = nan(num_sessions, 1);

% Session 1 flipped: Left = row 1, Right = row 2
EndTorque600msFlexionLeft(1)  = allValues(1);
EndTorque600msFlexionRight(1) = allValues(2);

% Remaining sessions: Right even, Left odd
for i = 2:num_sessions
    base_idx = 2 * (i - 1);
    EndTorque600msFlexionRight(i) = allValues(base_idx + 1);
    EndTorque600msFlexionLeft(i)  = allValues(base_idx + 2);
end

% Combine Left/Right into 2xN matrix
EndTorque600msFlexion = [EndTorque600msFlexionLeft, EndTorque600msFlexionRight]';

% Thresholds (same for both arms)
minBound = -2.10;
maxBound = -0.43;

% Plot
figure;
b = bar(EndTorque600msFlexion, 'grouped');

% Color settings
fixed_colors = [
    0 0 0;      % black
    0 0 1;      % blue
    1 0 0;      % red
    0 0.5 0;    % green
    0.5 0 0.5   % purple
];

% Apply colors
for i = 1:num_sessions
    if i <= 5
        b(i).FaceColor = fixed_colors(i, :);
    else
        b(i).FaceColor = rand(1,3);  % Random color if >5 sessions
    end
end

ylabel('End Torque (N*m)');
xlabel('Arm');
set(gca, 'XTick', 1:2, 'XTickLabel', {'Left Arm', 'Right Arm'}, 'FontSize', 12);

% Add threshold lines
hold on
plot([0.5, 2.5], [maxBound, maxBound], '--r', 'LineWidth', 2);
plot([0.5, 2.5], [minBound, minBound], '--b', 'LineWidth', 2);

% Add labels for threshold lines (centered)
text(1.5, maxBound + 0.1, 'Upper Limit', 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(1.5, minBound - 0.2, 'Lower Limit', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');

ylim([-2.5, 0.5]);

% Add asterisks for outliers
for i = 1:num_sessions
    for hand = 1:2  % 1=Left, 2=Right
        val = EndTorque600msFlexion(hand, i);
        
        if val > maxBound || val < minBound
            x_pos = b(i).XEndPoints(hand);
            
            if val > 0
                text(x_pos, val + 0.1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
            else
                text(x_pos, val - 0.1, '*', 'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
            end
        end
    end
end

% Title
title('Comparing End Torque 600 ms Flexion Across Sessions');

% Legend (sessions only)
legend_handles = gobjects(num_sessions, 1);
for i = 1:num_sessions
    legend_handles(i) = patch(nan, nan, b(i).FaceColor);
end

session_labels = arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false);
legend(legend_handles, session_labels, 'Location', 'northeast');

hold off;
