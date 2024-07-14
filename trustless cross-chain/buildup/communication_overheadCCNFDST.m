p = [4, 8, 12, 16, 20];
total_comm_overhead = p .* ((5*256 + 2*160 + 8*256 + 2*256 + 5*256 + 2*160 + 4 * 160) + (256*6 + 160*2) + (8*256 + 2*256 + 160 + 256)) / 8;
preparation_overhead = p .* (5*256 + 2*160 + 8*256 + 2*256 + 5*256 + 2*160 + 4 * 160) / 8;
update_overhead = p .* (256*6 + 160*2) / 8;
verification_overhead = p .* (8*256 + 2*256 + 160 + 256) / 8;

figure;
plot(p, total_comm_overhead, '-o', 'DisplayName', 'Total Communication Overhead');
hold on;
plot(p, preparation_overhead, '-x', 'DisplayName', 'Preparation Phase Overhead');
plot(p, update_overhead, '-s', 'DisplayName', 'Settlement Phase Overhead');
plot(p, verification_overhead, '-d', 'DisplayName', 'Validation Phase Overhead');
hold off;

xlabel('p');
ylabel('Overhead (bytes)');
title('Communication Overhead vs p');
legend('show');
% Remove the gray background by setting the 'Color' property to 'white'
ax = gca;
set(ax, 'Color', 'white');
grid on;
