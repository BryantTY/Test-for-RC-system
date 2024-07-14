kmax = [5, 10];

% CCNFDI
CCNFDI_det = 2 + 2 + 2; % deterministic consensus-based blockchain
CCNFDI_prob = 2 + kmax + 2 + 2 + kmax; % probabilistic consensus-based blockchain

% IBC
IBC_det = 2 + 2 + 2;
IBC_prob = 2 + kmax + 2 + 2 + kmax + kmax; % probabilistic consensus-based blockchain

% XCMP
XCMP_det = 2 + 2 + 2 + 2; % deterministic consensus-based blockchain
XCMP_prob = 2 + kmax + 2 + 2 + kmax + 2; % probabilistic consensus-based blockchain

LayerZero_det = 2 + 2 + 2 ; % deterministic consensus-based blockchain
LayerZero_prob = 2 + kmax + 2 + kmax + 2 + kmax; % probabilistic consensus-based blockchain


% Plotting
figure;
hold on;

plot(kmax, CCNFDI_det*ones(size(kmax)), 'k--', 'LineWidth', 2, 'DisplayName', 'Π_{B-CCDI} - deterministic');
plot(kmax, CCNFDI_prob, 'k-', 'LineWidth', 2, 'DisplayName', 'Π_{B-CCDI} - probabilistic');
plot(kmax, CCNFDI_mixed, 'k:', 'LineWidth', 2, 'DisplayName', 'Π_{B-CCDI} - mixed');

plot(kmax, IBC*ones(size(kmax)), 'b:', 'LineWidth', 2, 'DisplayName', 'IBC');

plot(kmax, XCMP_det*ones(size(kmax)), 'g-.', 'LineWidth', 2, 'DisplayName', 'XCMP - deterministic');
plot(kmax, XCMP_prob, 'g-', 'LineWidth', 2, 'DisplayName', 'XCMP - probabilistic');
plot(kmax, XCMP_send_det, 'g:', 'LineWidth', 2, 'DisplayName', 'XCMP - send deterministic');
plot(kmax, XCMP_receive_prob, 'g-.', 'LineWidth', 2, 'DisplayName', 'XCMP - receive probabilistic');

plot(kmax, LayerZero_det*ones(size(kmax)), 'r--', 'LineWidth', 2, 'DisplayName', 'LayerZero - deterministic');
plot(kmax, LayerZero_prob, 'r-', 'LineWidth', 2, 'DisplayName', 'LayerZero - probabilistic');
plot(kmax, LayerZero_send_det, 'r:', 'LineWidth', 2, 'DisplayName', 'LayerZero - send deterministic');
plot(kmax, LayerZero_receive_prob, 'r-.', 'LineWidth', 2, 'DisplayName', 'LayerZero - receive probabilistic');

xlabel('k_{max} (minutes)');
ylabel('Latency cost (minutes)');
title('Latency cost for different blockchain technologies');
legend('show');
hold off;

% Change the Y-axis to logarithmic scale
set(gca, 'YScale', 'log')


