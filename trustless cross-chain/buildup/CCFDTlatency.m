figure;

k_max = [15, 30, 45, 60, 75];  % This line is not in your original code, but we need to define k_max

% CCFDT latency
CCFDT_latency_det = 4 * ones(size(k_max));  % deterministic consensus context
plot(k_max, CCFDT_latency_det, 'LineWidth', 2);
hold on;

CCFDT_latency_prob = 4 + k_max;  % probabilistic consensus context
plot(k_max, CCFDT_latency_prob, 'LineWidth', 2);

% Π_DCE latency
Pi_DCE_latency_prob = 2 + 2 + 2 + 2*k_max + 2;  % probabilistic consensus context
plot(k_max, Pi_DCE_latency_prob, 'LineWidth', 2);

Pi_DCE_latency_det = 2 + 2 + 2 + 2;  % deterministic consensus context
plot(k_max, Pi_DCE_latency_det*ones(size(k_max)), 'LineWidth', 2);

% HTLC latency with different delta_t
delta_t = [10, 15, 20];  % minutes
for i = 1:length(delta_t)
    HTLC_latency = 2 + 2 + delta_t(i) + 3 .*k_max + 2;  % updated
    plot(k_max, HTLC_latency, 'LineWidth', 2);
end

% Customize plot appearance
xlabel('k_{max} (minutes)');
ylabel('Latency Cost (minutes)');
title('Latency for Different Schemes');
legend('Π_{CCTE} - deterministic', 'Π_{CCTE} - probabilistic', 'Π_{DCE} - probabilistic', 'Π_{DCE} - deterministic', 'HTLC, ∆t=10', 'HTLC, ∆t=15', 'HTLC, ∆t=20', 'Location', 'northwest');

% Set plot style
grid on;
set(gca, 'YScale', 'log'); % Set y-axis to logarithmic scale
hold off;
