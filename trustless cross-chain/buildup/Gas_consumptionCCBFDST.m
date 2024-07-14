p = [4, 8, 12, 16, 20];

% Case 2
total_overhead_case2 = p * 806394 + ((p - 1) .* p / 2 * 184496 + 91467 + p * 165848) + p * 303793 + p * 185258;
preparation_overhead_case2 = p * 806394;
execution_overhead_case2 = (p - 1) .* p / 2 * 184496 + 91467 + p * 165848;
settlement_overhead_case2 = p * 303793;
validation_overhead_case2 = p * 185258;

% Case 1
total_overhead_case1 = p * 806394 + ((p - 1) .* p / 2 * 184496 + 91467 + p * 165848) + p * 303793 + p * 306972;
preparation_overhead_case1 = p * 806394;
execution_overhead_case1 = (p - 1) .* p / 2 * 184496 + 91467 + p * 165848;
settlement_overhead_case1 = p * 303793;
validation_overhead_case1 = p * 306972;

% Plot
figure;
plot(p, total_overhead_case2, '-o', 'DisplayName', 'Case 2: Total Overhead');
hold on;
plot(p, total_overhead_case1, '-x', 'DisplayName', 'Case 1: Total Overhead');
plot(p, preparation_overhead_case2, '-s', 'DisplayName', 'Preparation Overhead');
plot(p, execution_overhead_case2, '-d', 'DisplayName', 'Execution Overhead');
plot(p, settlement_overhead_case2, '-^', 'DisplayName', 'Settlement Overhead');
plot(p, validation_overhead_case2, '-v', 'DisplayName', 'Validation Overhead 1');
plot(p, validation_overhead_case1, '-p', 'DisplayName', 'Validation Overhead 2');
hold off;

xlabel('p');
ylabel('Overhead');
title('Overhead vs p for Case 1 and Case 2');
legend('show');
grid on;

% Remove the gray background by setting the 'Color' property to 'white'
ax = gca;
set(ax, 'Color', 'white');
