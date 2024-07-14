figure;

% CCFDT latency
CCFDT_latency = 4 * ones(size(k_max));
plot(k_max, CCFDT_latency, 'LineWidth', 2);
hold on;

% Π_DCE latency
Pi_DCE_latency = 2 + 2 + k_max + 2;
plot(k_max, Pi_DCE_latency, 'LineWidth', 2);

% HTLC latency with different delta_t
delta_t = [20, 40, 60];  % minutes
for i = 1:length(delta_t)
    HTLC_latency = 2 + 2 + delta_t(i) + k_max + 2;
    plot(k_max, HTLC_latency, 'LineWidth', 2);
end

% Customize plot appearance
xlabel('k_{max} (minutes)');
ylabel('Latency (minutes)');
title('Latency for Different Schemes');
legend('CCFDT', 'Π_DCE', 'HTLC, ∆t=20', 'HTLC, ∆t=40', 'HTLC, ∆t=60', 'Location', 'northwest');

% Set plot style
grid on;
hold off;
