N = [10, 15, 20, 25, 30];
kmax = 1; % hour
mu = 2; % hours
B = 600; % bytes

% Memory cost calculation
memory_cost = N .* (kmax + mu) * B;

% Plot
figure;
plot(N, memory_cost, '-o', 'DisplayName', 'Memory Cost');
xlabel('N');
ylabel('Memory Cost (bytes)');
title('Memory Cost vs N');
legend('show');
grid on;

% Remove the gray background by setting the 'Color' property to 'white'
ax = gca;
set(ax, 'Color', 'white');
