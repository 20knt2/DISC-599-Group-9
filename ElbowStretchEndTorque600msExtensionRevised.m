% Path to single CSV file
file_path = 'F:\DISC598_Neurosci_Team1\DISC599_Team1_MainStudy\KINARM\6374\20250404\CSV\6374_KINARM_ES_20250404_Session5.csv';

% Read data from column BF (starting from row 2 to capture Session 1)
allValues = readmatrix(file_path, 'Range', 'BF2:BF1000');
allValues = allValues(~isnan(allValues));

% Check length
if mod(length(allValues), 2) ~= 0
    error('Expected even number of values (Right/Left alternating).');
end

% Total number of sessions
num_sessions = length(allValues) / 2;

% Preallocate
EndTorque600msExtensionRight = nan(num_sessions, 1);
EndTorque600msExtensionLeft  = nan(num_sessions, 1);

% --- Correction ES Row Logic ---
% Session 1: Left = row 1 (Excel row 2), Right = row 2 (Excel row 3)
EndTorque600msExtensionLeft(1)  = allValues(1);
EndTorque600msExtensionRight(1) = allValues(2);

% Remaining Sessions: Right on even rows, Left on odd rows
for i = 2:num_sessions
    base_idx = 2 * (i - 1);  % offset in allValues
    EndTorque600msExtensionRight(i) = allValues(base_idx + 1);  % even index (Right)
    EndTorque600msExtensionLeft(i)  = allValues(base_idx + 2);  % odd index (Left)
end

% Combine for plotting: rows = Left, Right
EndTorque600msExtension = [EndTorque600msExtensionLeft, EndTorque600msExtensionRight]';

% --- Threshold Values (same for both arms) ---
minBound = -1.93;
maxBound = -0.88;

% --- Plotting ---
figure;
b = bar(EndTorque600msExtension, 'grouped');

% Define fixed colors for the first five sessions (fifth session being purple)
fixed_colors = [
    0, 0, 0;     % Black for session 1
    0, 0, 1;     % Blue for session 2
    1, 0, 0;     % Red for session 3
    0, 0.5, 0;   % Green for session 4
    0.5, 0, 0.5; % Purple for session 5
];

% Assign session colors
for i = 1:num_sessions
    if i <= 5
        b(i).FaceColor = fixed_colors(i, :);  % Use fixed color for sessions 1-5
    else
        b(i).FaceColor = rand(1, 3);  % Random color for sessions beyond 5
    end
end

ylabel('End Torque (N*m)');
xlabel('Arm');
set(gca, 'XTick', 1:2, 'XTickLabel', {'Left Arm', 'Right Arm'}, 'FontSize', 12);

% --- Plotting Threshold Lines (shared) ---
hold on
plot([0.5, 2.5], [maxBound, maxBound], '--r', 'LineWidth', 2);
plot([0.5, 2.5], [minBound, minBound], '--b', 'LineWidth', 2);

% Threshold labels (centered between arms)
text(1.5, maxBound + 0.1, 'Upper Limit', 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(1.5, minBound - 0.2, 'Lower Limit', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');

% Y-axis limits
ylim([-3, 0]);

% Asterisks for values outside shared thresholds (always placed below bar)
for i = 1:num_sessions
    for hand = 1:2  % 1 = Left, 2 = Right
        val = EndTorque600msExtension(hand, i);
        if val > maxBound || val < minBound
            x_pos = b(i).XEndPoints(hand);
            y_pos = val - 0.1;  % Always offset downward
            text(x_pos, y_pos, '*', ...
                'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
        end
    end
end



% Title
title('Comparing End Torque 600 ms Extension Across Sessions');

% Create legend for sessions only
legend_entries = arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false);
legend(b, legend_entries, 'Location', 'Best');

hold off
