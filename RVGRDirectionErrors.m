file_path = 'F:\DISC598_Neurosci_Team1\DISC599_Team1_MainStudy\KINARM\6374\20250404\CSV\6374_KINARM_RVGR_20250404_Session5.csv';

% Read values from column BH starting at row 2
DirectionErrors = readmatrix(file_path, 'Range', 'BH2:BH1000');
DirectionErrors = DirectionErrors(~isnan(DirectionErrors));

% Ensure even number of rows
if mod(length(DirectionErrors), 2) ~= 0
    error('Expected even number of values for alternating Right/Left format.');
end

num_sessions = length(DirectionErrors) / 2;

% Preallocate
DirectionErrorsRight = nan(num_sessions, 1);
DirectionErrorsLeft  = nan(num_sessions, 1);


% Correction RVGR pattern
DirectionErrorsLeft(1)  = DirectionErrors(1);
DirectionErrorsRight(1) = DirectionErrors(2);

for i = 2:num_sessions
    base_idx = 2 * (i - 1);
    DirectionErrorsRight(i) = DirectionErrors(base_idx + 1);
    DirectionErrorsLeft(i)  = DirectionErrors(base_idx + 2);
end

TaskScore = [DirectionErrorsLeft, DirectionErrorsRight]';

% Define separate limits
minLeft = 1;
maxLeft = 14;
minRight = 0;
maxRight = 13;

% Color settings
colors = lines(num_sessions);
fixed_colors = [
    0 0 0;    % black
    0 0 1;    % blue
    1 0 0;    % red
    0 0.5 0   % green
    0.5 0 0.5 % purple
];

if num_sessions <= 4
    color_palette = fixed_colors(1:num_sessions, :);
else
    extra_colors = lines(num_sessions - 4);
    color_palette = [fixed_colors; extra_colors];
end

% Plot
figure;
b = bar(TaskScore, 'grouped');

for i = 1:num_sessions
    b(i).FaceColor = color_palette(i, :);
end

ylabel('Direction Errors');
xlabel('Arm');
set(gca, 'XTick', 1:2, 'XTickLabel', {'Left', 'Right'}, 'FontSize', 12);

hold on

% Add limit lines for Left Arm
plot([0.5, 1.5], [maxLeft, maxLeft], '--r', 'LineWidth', 2);
plot([0.5, 1.5], [minLeft, minLeft], '--b', 'LineWidth', 2);
text(1, maxLeft + 2, 'Left Max', 'HorizontalAlignment', 'center', 'Color', 'r', 'FontSize', 10);
text(1, minLeft + 2, 'Left Min', 'HorizontalAlignment', 'center', 'Color', 'b', 'FontSize', 10);

% Add limit lines for Right Arm
plot([1.5, 2.5], [maxRight, maxRight], '--r', 'LineWidth', 2);
plot([1.5, 2.5], [minRight, minRight], '--b', 'LineWidth', 2);
text(2, maxRight + 2, 'Right Max', 'HorizontalAlignment', 'center', 'Color', 'r', 'FontSize', 10);
text(2, minRight + 2, 'Right Min', 'HorizontalAlignment', 'center', 'Color', 'b', 'FontSize', 10);

% Set axis limits
ylim([0, 36]);

% Add asterisks for values outside limits
for i = 1:num_sessions
    for hand = 1:2
        val = TaskScore(hand, i);
        if (hand == 1 && (val > maxLeft || val < minLeft)) || ...
           (hand == 2 && (val > maxRight || val < minRight))
            text(b(i).XEndPoints(hand), val + 0.02, '*', ...
                'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
        end
    end
end

% Title
title('Comparing RVGR Direction Errors Across Sessions');

% Legend (only sessions)
legend_handles = gobjects(num_sessions, 1);
for i = 1:num_sessions
    legend_handles(i) = patch(nan, nan, color_palette(i, :));
end

categories = arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false);
legend(legend_handles, categories, 'Location', 'northeast');

hold off
