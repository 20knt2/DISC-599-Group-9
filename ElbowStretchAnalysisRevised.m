file_path = 'F:\DISC598_Neurosci_Team1\DISC599_Team1_MainStudy\KINARM\6374\20250404\CSV\6374_KINARM_ES_20250404_Session5.csv';

% Read values from column BH starting at row 2
TaskScores = readmatrix(file_path, 'Range', 'BH2:BH1000');
TaskScores = TaskScores(~isnan(TaskScores));

% Ensure even number of rows
if mod(length(TaskScores), 2) ~= 0
    error('Expected even number of values for alternating Right/Left format.');
end

num_sessions = length(TaskScores) / 2;

% Preallocate
TaskScoreRight = nan(num_sessions, 1);
TaskScoreLeft  = nan(num_sessions, 1);

% Correction ES pattern
TaskScoreLeft(1)  = TaskScores(1);
TaskScoreRight(1) = TaskScores(2);

for i = 2:num_sessions
    base_idx = 2 * (i - 1);
    TaskScoreRight(i) = TaskScores(base_idx + 1);
    TaskScoreLeft(i)  = TaskScores(base_idx + 2);
end

TaskScore = [TaskScoreLeft, TaskScoreRight]';

% Shared threshold
lineY = 1.96;

% Generate unique colors for each session
colors = lines(num_sessions);

figure;
b = bar(TaskScore, 'grouped');
% Define fixed and additional session colors
fixed_colors = [
    0 0 0;    % black
    0 0 1;    % blue
    1 0 0;    % red
    0 0.5 0   % green
    0.5, 0, 0.5 % purple
];

if num_sessions <= 4
    color_palette = fixed_colors(1:num_sessions, :);
else
    extra_colors = lines(num_sessions - 4);
    color_palette = [fixed_colors; extra_colors];
end

for i = 1:num_sessions
    b(i).FaceColor = color_palette(i, :);
end

ylabel('Task Score');
xlabel('Arm');
set(gca, 'XTick', 1:2, 'XTickLabel', {'Left', 'Right'}, 'FontSize', 12);

% Threshold line
hold on
yline(lineY, '--k', 'Significant Impairment > 1.96', 'Color', 'k', 'LineWidth', 2);

ylim([0, 4.5]);

% Add asterisks for outliers
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
title('Comparing ES Task Score Across Sessions');

% Legend with session colors
legend_handles = gobjects(num_sessions, 1);
for i = 1:num_sessions
    legend_handles(i) = patch(nan, nan, color_palette(i, :));
end

legend(legend_handles, arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false), ...
       'Location', 'northeast');

hold off;
