% Parameters
kmax = [2, 4, 6, 8, 10];
mu = [15, 30, 45, 60, 75];
N = [10, 20, 30];

[K, M, NN] = ndgrid(kmax, mu, N);

% Calculate the memory overhead for each combination
ccnfdst_overhead = NN .* (K) .* 300;
ibc_overhead = NN .* (NN - 1) .* (K) .* 300;
xcmp_overhead = NN .* (K) * 100000000;

% Create a 3D scatter plot
figure;
hold on;

colors = {'b', 'g', 'r'};
markers = {'o', 's', '^'};
scheme_names = {'Π_{CCDI}', 'IBC', 'XCMP'};

for n = 1:numel(N)
    for k = 1:numel(kmax)
        for m = 1:numel(mu)
            for scheme = 1:3
                x = k;
                y = m + (numel(mu) + 1) * (n - 1); % Separate subplots in a column-like arrangement
                if scheme == 1
                    z = ccnfdst_overhead(k, m, n);
                elseif scheme == 2
                    z = ibc_overhead(k, m, n);
                else
                    z = xcmp_overhead(k, m, n);
                end
                scatter3(x, y, z, 100, colors{scheme}, markers{scheme}, 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 1);
            end
        end
    end
end

% Customize plot appearance
xlabel('k_{max} ');
ylabel('External blockchains number');
zlabel('Memory cost (bytes)');

% Add legend
legend(scheme_names, 'Location', 'best');

% Adjust y-axis ticks and labels to show the subplots
yticks = (numel(mu) + 1) / 2 : (numel(mu) + 1) : numel(mu) * numel(N);
yticklabels = cellstr(num2str(N'));
yticklabels = cellfun(@(x) ['N = ', x], yticklabels, 'UniformOutput', false);
set(gca, 'YTick', yticks, 'YTickLabel', yticklabels);

% Set the z-axis to log scale
set(gca, 'ZScale', 'log');

grid on;
view(3);
hold off;
