p = [4, 8, 12, 16, 20];

% Overhead calculations
total_overhead = p * 2 * 0.047;
preparation_overhead = p * 0.047;
validation_overhead = p * 0.047;

% Plot
figure;
plot(p, total_overhead, '-o', 'DisplayName', 'Total Overhead');
hold on;
plot(p, preparation_overhead, '--x', 'DisplayName', 'Preparation Phase Overhead');
plot(p, validation_overhead, '-.s', 'DisplayName', 'Validation Phase Overhead');
hold off;

xlabel('p');
ylabel('Overhead (milliseconds)');
title('Overhead vs p');
legend('show');
grid on;

% Remove the gray background by setting the 'Color' property to 'white'
ax = gca;
set(ax, 'Color', 'white');
