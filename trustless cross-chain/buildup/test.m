% Define the range of blockchains and nodes in the retailer group
blockchains = [10, 20, 30, 40, 50];
nodes = [10, 20, 30, 40, 50];

% Calculate gas costs for each scheme
num_blockchains = length(blockchains);
num_nodes = length(nodes);

gas_costs = zeros(num_blockchains, num_nodes, 3);

for i = 1:num_blockchains
    for j = 1:num_nodes
        N = blockchains(i);
        k = nodes(j);

        gas_costs(i, j, 1) = (1846677 + 1593068 + 349517) + k * 252786;
        gas_costs(i, j, 2) = 3690283 + k * 181591;
        gas_costs(i, j, 3) = 1156622 * N;
    end
end

% Create 3D bar plot for all schemes
figure;
hold on;

% Plot the bars for each scheme
colors = {'b', 'g', 'r'};
offsets = [-0.25, 0, 0.25];
bar_width = 0.2;

for scheme = 1:size(gas_costs, 3)
    for i = 1:num_blockchains
        for j = 1:num_nodes
            % Draw the cuboid
            X = [i + offsets(scheme) - bar_width/2, i + offsets(scheme) + bar_width/2];
            Y = [j - bar_width/2, j + bar_width/2];
            Z = gas_costs(i, j, scheme);
            drawCuboid([X(1), Y(1), 0, bar_width, bar_width, Z], 'FaceColor', colors{scheme}, 'EdgeColor', 'k', 'LineWidth', 1, 'FaceAlpha', 0.8);
        end
    end
end

% Customize plot appearance
title('Gas Cost Comparison of Fungible Data Transfer Schemes');
hXLabel = xlabel('Number of Blockchains');
hYLabel = ylabel('Number of Nodes in Retailer Group');
hZLabel = zlabel('Gas Cost');

% Add legend
p1 = patch(NaN, NaN, 'b', 'FaceAlpha', 0.8);
p2 = patch(NaN, NaN, 'g', 'FaceAlpha', 0.8);
p3 = patch(NaN, NaN, 'r', 'FaceAlpha', 0.8);
legend([p1, p2, p3], 'Fungible Data Update Protocol', 'Decentralized Cryptocurrency Exchange Protocol', 'Hash Time Lock Contract');

% Show the figure
hold off;
grid on;
view(3);
set(gca,'xtick',1:5,'xticklabel',blockchains);
set(gca,'ytick',1:5,'yticklabel',nodes);

% Create a callback function to update the axis labels when the view is changed
set(gca, 'CameraViewAngleMode', 'manual');
set(gcf, 'WindowButtonMotionFcn', @update_labels);

function update_labels(~, ~)
    % Update axis labels
    hTitle = get(gca,'title');
    hXLabel = get(gca,'XLabel');
    hYLabel = get(gca,'YLabel');
    hZLabel = get(gca,'ZLabel');
    set([hTitle, hXLabel, hYLabel, hZLabel], 'Units', 'normalized');
    set([hTitle, hXLabel, hYLabel, hZLabel], 'Units', 'normalized');
    ax_pos = get(gca, 'Position');
    [az, el] = view;

    x_label_pos = [ax_pos(1) + ax_pos(3)/2, ax_pos(2) - 0.1];
    y_label_pos = [ax_pos(1) - 0.1, ax_pos(2) + ax_pos(4)/2];
    z_label_pos = [ax_pos(1) - 0.15, ax_pos(2) + ax_pos(4) + 0.1];

    set(hXLabel, 'Position', x_label_pos, 'Rotation', -az);
    set(hYLabel, 'Position', y_label_pos, 'Rotation', el);
    set(hZLabel, 'Position', z_label_pos, 'Rotation', 0);

    drawnow;
end

