% Path to the file
file_path = 'F:\DISC598_Neurosci_Team1\DISC599_Team1_MainStudy\KINARM\6374\20250404\CSV\6374_KINARM_ES_20250404_Session5.csv';

% Read values from column BB starting at row 2
allValues = readmatrix(file_path, 'Range', 'BB2:BB1000');
allValues = allValues(~isnan(allValues));

% Ensure even number of values
if mod(length(allValues), 2) ~= 0
    error('Expected even number of rows: alternating Right/Left values.');
end

num_sessions = length(allValues) / 2;

% Preallocate
PeakSpeed600msExtensionRight = nan(num_sessions, 1);
PeakSpeed600msExtensionLeft  = nan(num_sessions, 1);

% Correction ES pattern
PeakSpeed600msExtensionLeft(1)  = allValues(1);
PeakSpeed600msExtensionRight(1) = allValues(2);

for i = 2:num_sessions
    idx = 2 * (i - 1);
    PeakSpeed600msExtensionRight(i) = allValues(idx + 1);
    PeakSpeed600msExtensionLeft(i)  = allValues(idx + 2);
end

% --- ACO: Convert to degrees ---
PeakSpeed600msExtension = [PeakSpeed600msExtensionLeft, PeakSpeed600msExtensionRight]' * (180/pi);

% --- OL: Single threshold for both arms ---
minBound = 234; % degrees
maxBound = 292; % degrees

% --- Plotting ---
figure;
b = bar(PeakSpeed600msExtension, 'grouped');

% Define session colors
session_colors = [
    0, 0, 0;    % black
    0, 0, 1;    % blue
    1, 0, 0;    % red
    0, 0.5, 0;  % green
    0.5, 0, 0.5 % purple
];

% Assign colors
for i = 1:num_sessions
    if i <= 5
        b(i).FaceColor = session_colors(i, :);
    else
        b(i).FaceColor = [0.5, 0.5, 0.5];  % gray for >5 sessions
    end
end

ylabel('Peak Speed (°/s)');
xlabel('Arm');
set(gca, 'XTick', 1:2, 'XTickLabel', {'Left', 'Right'}, 'FontSize', 12);

% Threshold lines (same for both arms)
hold on
plot([0.5, 2.5], [maxBound, maxBound], '--r', 'LineWidth', 2);
plot([0.5, 2.5], [minBound, minBound], '--b', 'LineWidth', 2);

% Threshold labels
text(1.5, maxBound + 5, 'Upper Limit', 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'center');
text(1.5, minBound - 7, 'Lower Limit', 'Color', 'blue', 'FontSize', 10, 'HorizontalAlignment', 'center');

% Set axis limits
ylim([150, 320]);

% --- Asterisks for violations ---
for i = 1:num_sessions
    for hand = 1:2
        val = PeakSpeed600msExtension(hand, i);
        if val > maxBound
            text(b(i).XEndPoints(hand), val + 5, '*', ...
                'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
        elseif val < minBound
            if val > 0
                text(b(i).XEndPoints(hand), val + 5, '*', ...
                    'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
            else
                text(b(i).XEndPoints(hand), val - 5, '*', ...
                    'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
            end
        end
    end
end

% Title
title('Comparing Peak Speed 600 ms Extension Across Sessions');

% --- Legend (sessions only) ---
legend_handles = gobjects(num_sessions, 1);
for i = 1:num_sessions
    legend_handles(i) = patch(nan, nan, b(i).FaceColor);
end
legend_entries = arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false);
legend(legend_handles, legend_entries, 'Location', 'northeast');

hold off;
