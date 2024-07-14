n = [2000, 4000, 6000, 8000, 10000];
Nc = [20, 40, 60, 80, 100];

[N, NC] = meshgrid(n, Nc);

% Calculate the communication overhead for each scheme
ccfdt_overhead = 1324 * N;
pidce_overhead = (312+248 + 52 * NC) .* N;
htlc_overhead = 688 * N;

% Create a 3D bar plot
figure('Position', [10 10 900 600]);
hold on;

% Define the bar widths and offsets
bar_width = 500;
ccfdt_offset = -bar_width;
pidce_offset = 0;
htlc_offset = bar_width;

% Draw cuboids for each scheme instead of using bar3
colors = {[0/255, 114/255, 189/255], [217/255, 83/255, 25/255], [0/255, 158/255, 115/255]};
for i = 1:length(n)
    for j = 1:length(Nc)
        for scheme = 1:3
            X = [i + (scheme-2)*bar_width/2000 - bar_width/4000, i + (scheme-2)*bar_width/2000 + bar_width/4000];
            Y = [j - bar_width/4000, j + bar_width/4000];
            if scheme == 1
                Z = ccfdt_overhead(j, i);
            elseif scheme == 2
                Z = pidce_overhead(j, i);
            else
                Z = htlc_overhead(j, i);
            end
            drawCuboid([X(1), Y(1), 0, bar_width/2000, bar_width/2000, Z], 'FaceColor', colors{scheme}, 'EdgeColor', 'k', 'LineWidth', 1, 'FaceAlpha', 1);
        end
    end
end

% Customize plot appearance
xlabel('Transaction number');
ylabel('Nodes number');
zlabel('Communication cost (bytes)');
title('Communication Overhead for Different Schemes');

p1 = patch(NaN, NaN, 'k', 'FaceColor', [0/255, 114/255, 189/255], 'FaceAlpha', 1);
p2 = patch(NaN, NaN, 'k', 'FaceColor', [217/255, 83/255, 25/255], 'FaceAlpha', 1);
p3 = patch(NaN, NaN, 'k', 'FaceColor', [0/255, 158/255, 115/255], 'FaceAlpha', 1);
legend([p1, p2, p3], 'Π_{CCTE}', 'Π_{DCE}', 'HTLC');

% Set x and y-axis ticks and labels
set(gca, 'XTick', 1:length(n), 'XTickLabel', n);
set(gca, 'YTick', 1:length(Nc), 'YTickLabel', Nc);

% Rotate y-axis labels
ytickangle(45);

grid on;
view(3);
hold off;
