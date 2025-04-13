file_path = 'F:\DISC598_Neurosci_Team1\DISC599_Team1_MainStudy\KINARM\6374\20250404\CSV\6374_KINARM_OHA_20250404_Session5.csv';

% Read TaskScores from column BC starting at row 2
TaskScores = readmatrix(file_path, 'Range', 'BC2:BC1000');
TaskScores = TaskScores(~isnan(TaskScores));  % Remove any blank rows

num_sessions = length(TaskScores);

% Generate unique colors for each session
colors = lines(num_sessions);

% Create bar chart with unique colors
figure;
b = bar(TaskScores, 'FaceColor', 'flat');

% Fixed colors for sessions 1 to 4
fixed_colors = [
    0 0 0;    % black
    0 0 1;    % blue
    1 0 0;    % red
    0 0.5 0     % green
    0.5, 0, 0.5 %purple
];

% Generate additional colors if needed
if num_sessions > 4
    extra_colors = lines(num_sessions - 4);
    color_palette = [fixed_colors; extra_colors];
else
    color_palette = fixed_colors(1:num_sessions, :);
end

% Assign colors
for i = 1:num_sessions
    b.CData(i, :) = color_palette(i, :);
end


ylabel('Task Score');
xlabel('Session');

% X-axis labels as "Session 1", ..., "Session N"
categories = arrayfun(@(x) sprintf('Session %d', x), 1:num_sessions, 'UniformOutput', false);
set(gca, 'XTick', 1:num_sessions, 'XTickLabel', categories, 'FontSize', 12);

% Threshold line
lineY = 1.96;
yline(lineY, '--k', 'Significant Impairment > 1.96', 'Color', 'k', 'LineWidth', 2);

ylim([0, 3]);

% Add asterisks for out-of-range values
hold on;
for i = 1:num_sessions
    if TaskScores(i) > lineY
        text(i, TaskScores(i) + 0.2, '*', ...
            'HorizontalAlignment', 'center', 'FontSize', 20, 'Color', 'black');
    end
end

% Title
title('Comparing Object Hit and Avoid Task Scores Across Sessions');

% Legend with session colors
legend_handles = gobjects(num_sessions, 1);
for i = 1:num_sessions
    legend_handles(i) = patch(nan, nan, color_palette(i, :));
end

legend(legend_handles, categories, 'Location', 'Best');
