p = [4, 8, 12, 16, 20];

% Off-chain cost calculations
ccnfdst_overhead = p * 2 * 0.047;
ibc_overhead = p * 2 * 0.047;
xcmp_overhead = zeros(1, length(p));
layer_zero_overhead = p * 2 * 0.047;

% Plot
figure;
hold on;

plot(p, ccnfdst_overhead, '-o', 'DisplayName', 'CCNFDST', 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 2);
plot(p, ibc_overhead, '-x', 'DisplayName', 'IBC', 'Color', [0.9290, 0.6940, 0.1250], 'LineWidth', 2);
plot(p, xcmp_overhead, '-s', 'DisplayName', 'XCMP', 'Color', [0.4940, 0.1840, 0.5560], 'LineWidth', 2);
plot(p, layer_zero_overhead, '-d', 'DisplayName', 'Layer Zero', 'Color', [0.4660, 0.6740, 0.1880], 'LineWidth', 2);

xlabel('p');
ylabel('Overhead (millisecond)');
title('Off-chain Cost vs p');
legend('show');
grid on;
hold off;

% Remove the gray background by setting the 'Color' property to 'white'
ax = gca;
set(ax, 'Color', 'white');
