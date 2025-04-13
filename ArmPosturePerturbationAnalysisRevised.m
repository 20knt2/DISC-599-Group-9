% Define full file path (single CSV with alternating R/L sessions)
file_path = 'F:\DISC598_Neurosci_Team1\DISC599_Team1_MainStudy\KINARM\6374\20250404\CSV\6374_KINARM_APP_20250404_Session5.csv';

% Read column AV starting from row 3
allScores = readmatrix(file_path, 'Range', 'AV3:AV1000');
allScores = allScores(~isnan(allScores));

% Check if number of scores is even (alternating R/L)
if mod(length(allScores), 2) ~= 0
    error('Number of rows is not even — check data formatting.');
end

% Split into Right and Left
TaskScoresRight = allScores(1:2:end);  % Odd rows: Right
TaskScoresLeft  = allScores(2:2:end);  % Even rows: Left
num_sessions = length(TaskScoresRight);

% Combine into matrix for plotting
TaskScores = [TaskScoresLeft, TaskScoresRight]';  % 2 x N

% Color scheme: fixed first 4, random rest
fixed_colors = [0 0 0; 0 0 1; 1 0 0; 0 0.5 0;0.5, 0, 0.5];  % black, blue, red, green
random_colors = lines(max(num_sessions - 5, 0));
colors = [fixed_colors(1:min(5, num_sessions), :); random_colors];

% Create Bar Chart
figure;
b = bar(TaskScores, 'grouped');

% Apply colors
for i = 1:num_sessions
    b(i).FaceColor = colors(i, :);
end

ylabel('Task Score');
xlabel('Arm');
set(gca, 'XTick', 1:2, 'XTickLabel', {'Left', 'Right'}, 'FontSize', 12);

% Threshold line
lineY = 1.96;
hold on
yline(lineY, '--k', 'Significant Impairment > 1.96', 'Color', 'black', ...
    'LineWidth', 2, 'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'top');

% Y-limits
ylim([0 4.5]);

% Asterisks for scores above threshold
for i = 1:num_sessions
    for hand = 1:2
        value = TaskScores(hand, i);
        if value > lineY
            text(b(i).XEndPoints(hand), value + 0.1, '*', ...
                'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'red');
        end
    end
end

% Title
title('Comparing Arm Posture Perturbation Across Sessions');

% Legend with matching session colors
legend_handles = gobjects(num_sessions, 1);
for i = 1:num_sessions
    legend_handles(i) = patch(nan, nan, colors(i, :));
end
legend_labels = arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false);
legend(legend_handles, legend_labels, 'Location', 'Best');

hold off;
