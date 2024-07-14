kmax = [15, 30, 45, 60, 75];

% Calculate the total time cost of NFT update for each scheme
ccnfdst_nft_update_time = 1 + kmax + 1 + 1;
ccnfdst_epoch_time = 1 + kmax + 1 + 1 + kmax + 1;
ibc_time = 1 + 1 + 1;
xcmp_time = 1 + kmax + 1 + kmax + 1;
layer_zero_time = 1 + kmax + 1 + 1 + kmax + 1 + 1;

% Plot the total time cost of NFT update
figure;
hold on;

plot(kmax, ccnfdst_nft_update_time, '-o', 'LineWidth', 2, 'DisplayName', 'CCNFDST (NFT Update)');
plot(kmax, ccnfdst_epoch_time, ':o', 'LineWidth', 2, 'DisplayName', 'CCNFDST (Epoch)');
plot(kmax, ibc_time * ones(size(kmax)), '--s', 'LineWidth', 2, 'DisplayName', 'IBC');
plot(kmax, xcmp_time, '-.^', 'LineWidth', 2, 'DisplayName', 'XCMP');
plot(kmax, layer_zero_time, '-v', 'LineWidth', 2, 'DisplayName', 'Layer Zero');

% Customize plot appearance
xlabel('kmax (minutes)');
ylabel('Total Time Cost (minutes)');
title('Total Time Cost of NFT Update and Epoch for Different Schemes');
legend('show');

grid on;
hold off;
