p = [4, 8, 12, 16, 20];
l = [5, 20];

% Communication cost calculations
ccnfdi_overhead = p .* ((5*256+3*160)+(7*256+5*160+5*256+3*160)+(256*6+160*2)+(7*256+256*6+160*4))/8;
ibc_overhead = p .* ((5*256+3*160)*4+(7*256+2*256)*2)/8;
xcmp_overhead = p .* (5*256+3*160)*4/8;

% Plot
figure;
hold on;

plot(p, ccnfdi_overhead, '-o', 'DisplayName', 'Π_{B-CCDI}', 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 2);
plot(p, ibc_overhead, '-x', 'DisplayName', 'IBC', 'Color', [0.9290, 0.6940, 0.1250], 'LineWidth', 2);
plot(p, xcmp_overhead, '-s', 'DisplayName', 'XCMP', 'Color', [0.4940, 0.1840, 0.5560], 'LineWidth', 2);

for i = 1:length(l)
    layer_zero_overhead = p .* ((5*256+3*160)*4 + l(i) * 600 * 2+ l(i) * (7*256+2*256)*2) / 8;
    plot(p, layer_zero_overhead, '-d', 'DisplayName', sprintf('Layer Zero Overhead (l = %d)', l(i)), 'Color', [0.4660, 0.6740, 0.1880], 'LineWidth', 2);
end

xlabel('The number of SD to be updated');
ylabel('Communication cost (bytes)');
title('Communication Cost vs p');
legend('show');
grid on;
hold off;

% Remove the gray background by setting the 'Color' property to 'white'
ax = gca;
set(ax, 'Color', 'white');
