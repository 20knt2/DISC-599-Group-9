file_path = 'F:\DISC598_Neurosci_Team1\DISC599_Team1_MainStudy\KINARM\6374\20250404\CSV\6374_KINARM_VGR_20250404_Session5.csv';

% Read values from column BH starting at row 2
allValues = readmatrix(file_path, 'Range', 'BH2:BH1000');
allValues = allValues(~isnan(allValues));

% Ensure even number of rows
if mod(length(allValues), 2) ~= 0
    error('Expected even number of values for alternating Right/Left format.');
end

num_sessions = length(allValues) / 2;

% Preallocate
TaskScoreRight = nan(num_sessions, 1);
TaskScoreLeft  = nan(num_sessions, 1);

% Standard order: Right = even rows, Left = odd rows
for i = 1:num_sessions
    base_idx = 2 * (i - 1);
    TaskScoreRight(i) = allValues(base_idx + 1);
    TaskScoreLeft(i)  = allValues(base_idx + 2);
end

% Combine into 2 x N matrix (Left, Right)
TaskScore = [TaskScoreLeft, TaskScoreRight]';

% Shared threshold
lineY = 1.96;

% Color scheme: black, blue, red, green for first 4, then random
fixed_colors = [0 0 0; 0 0 1; 1 0 0; 0 0.5 0; 0.5, 0, 0.5];  % black, blue, red, green
random_colors = lines(max(num_sessions - 5, 0));
color_palette = [fixed_colors(1:min(num_sessions, 5), :); random_colors];

% Plot
figure;
b = bar(TaskScore, 'grouped');

for i = 1:num_sessions
    b(i).FaceColor = color_palette(i, :);
end

ylabel('Task Score');
xlabel('Arm');
set(gca, 'XTick', 1:2, 'XTickLabel', {'Left', 'Right'}, 'FontSize', 12);

% Add threshold line (black) without adding it to legend
hold on
yline(lineY, '--k', 'Significant Impairment > 1.96', 'Color', 'black', ...
    'LineWidth', 2, 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'top');

% Set axis limits
ylim([0, 4.5]);

% Add asterisks for values above threshold
for i = 1:num_sessions
    for hand = 1:2
        val = TaskScore(hand, i);
        if val > lineY
            text(b(i).XEndPoints(hand), val + 0.1, '*', ...
                'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
        end
    end
end

% Title
title('Comparing VGR Task Score Across Sessions');

% Create legend (exclude threshold line)
legend_handles = gobjects(num_sessions, 1);
for i = 1:num_sessions
    legend_handles(i) = patch(nan, nan, color_palette(i, :));
end

legend(legend_handles, ...
       arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false), ...
       'Location', 'northeast');  
hold off;
