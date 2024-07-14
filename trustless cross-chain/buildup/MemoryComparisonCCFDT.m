% Given values
N = [10, 15, 20, 25, 30];
k_max = [15, 30, 45, 60, 75];
mu = 10;

% Calculate the memory overhead for each combination
[NN, KK] = meshgrid(N, k_max);

our_scheme_overhead = (600 .* KK) .* NN / 2;
pidce_overhead = (40 .* 200000 .* NN) / 2;

% Convert to linear scale
our_scheme_overhead_lin = log10(our_scheme_overhead);
pidce_overhead_lin = log10(pidce_overhead);

% Create a 3D bar plot
figure('Position', [10 10 900 600]);
hold on;

% Define the bar widths and offsets
bar_width = 0.2;

% Draw cuboids for each scheme instead of using bar3
colors = {[0/255, 114/255, 189/255], [217/255, 83/255, 25/255]};
for i = 1:length(N)
    for j = 1:length(k_max)
        for scheme = 1:2
            X = [i + (scheme-2)*bar_width - bar_width/2, i + (scheme-2)*bar_width + bar_width/2];
            Y = [j - bar_width/2, j + bar_width/2];
            if scheme == 1
                Z = our_scheme_overhead_lin(j, i);
            else
                Z = pidce_overhead_lin(j, i);
            end
            drawCuboid([X(1), Y(1), 0, bar_width, bar_width, Z], 'FaceColor', colors{scheme}, 'EdgeColor', 'k', 'LineWidth', 1, 'FaceAlpha', 1);
        end
    end
end

% Customize plot appearance
xlabel('External blockchains number ');
ylabel('k_{max} (minutes)');
zlabel('Memory cost (bytes)');
title('Memory Overhead for Different Schemes');

% Add legend
p1 = patch(NaN, NaN, 'k', 'FaceColor', colors{1}, 'FaceAlpha', 1);
p2 = patch(NaN, NaN, 'k', 'FaceColor', colors{2}, 'FaceAlpha', 1);
legend([p1, p2], 'Π_{CCTE}', 'Π_{DCE}');

% Set x and y-axis ticks and labels
set(gca, 'XTick', 1:length(N), 'XTickLabel', N);
set(gca, 'YTick', 1:length(k_max), 'YTickLabel', k_max);

% Rotate y-axis labels
ytickangle(45);

% Set z-axis ticks and labels to reflect original data
zTickData = [1 10 100 1000 10000 100000 1000000 10000000];
set(gca, 'ZTick', log10(zTickData), 'ZTickLabel', zTickData);

grid on;
view(3);
hold off;
