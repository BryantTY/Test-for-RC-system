kmax = [15, 30, 45, 60, 75];
mu = [15, 30, 45, 60, 75];
t = 1;
N = [10, 20, 30];

[K, M, NN] = ndgrid(kmax, mu, N);

% Calculate the memory overhead for each combination
ccnfdst_overhead = NN .* (K + M) ./ t * 600;
ibc_overhead = NN .* (NN - 1) .* M ./ t * 600;
xcmp_overhead = NN .* (K + M) ./ t * 200 * 1000;

figure;
n_N = numel(N);

colors = {'b', 'r', 'g'};
offsets = [-0.25, 0, 0.25];
bar_width = 0.2;

for j = 1:n_N
    % Create a subplot for each value of N
    subplot(1, n_N, j);
    hold on;
    set(gca, 'ZScale', 'log');

    % Plot the memory overheads for each scheme
    for k = 1:numel(kmax)
        for m = 1:numel(mu)
            for scheme = 1:3
                X = [k + offsets(scheme) - bar_width/2, k + offsets(scheme) + bar_width/2];
                Y = [m - bar_width/2, m + bar_width/2];
                if scheme == 1
                    Z = ccnfdst_overhead(k, m, j);
                elseif scheme == 2
                    Z = ibc_overhead(k, m, j);
                else
                    Z = xcmp_overhead(k, m, j);
                end
                drawCuboid([X(1), Y(1), 1, bar_width, bar_width, Z-1], 'FaceColor', colors{scheme}, 'EdgeColor', 'k', 'LineWidth', 1, 'FaceAlpha', 0.8);
            end
        end
    end

    % Customize the appearance of the plot
    xlabel('kmax (minutes)');
    ylabel('µ (minutes)');
    zlabel('Memory Overhead (bytes)');
    title(sprintf('N = %d', N(j)));
    if j == 1
        p1 = patch(NaN, NaN, 'b', 'FaceAlpha', 0.8);
        p2 = patch(NaN, NaN, 'r', 'FaceAlpha', 0.8);
        p3 = patch(NaN, NaN, 'g', 'FaceAlpha', 0.8);
        legend([p1, p2, p3], 'CCNFDST', 'IBC', 'XCMP');
    end
    view(3); % Make sure the subplot has a 3D view
    grid on;
    set(gca, 'xtick', 1:5, 'xticklabel', kmax);
    set(gca, 'ytick', 1:5, 'yticklabel', mu);
    hold off;
end
