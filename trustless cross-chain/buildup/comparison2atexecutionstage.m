% Define the range of trading pairs
trading_pairs = [1000, 2000, 4000, 8000, 16000];

% Calculate gas costs for each scheme
num_trading_pairs = length(trading_pairs);

gas_costs = zeros(num_trading_pairs, 3);

for i = 1:num_trading_pairs
    m = trading_pairs(i);
    
    gas_costs(i, 1) = (901193+21000*2) * m;
    gas_costs(i, 2) = (1053080+21000*3) * m;
    gas_costs(i, 3) = (163898 + 79752) * 4 * m;
end

% Create a bar plot for all schemes
figure;
hold on;

colors = {'b', 'g', 'r'};
barWidth = 0.8;

b = bar(trading_pairs, gas_costs, barWidth, 'grouped');
for k = 1:size(gas_costs, 2)
    b(k).FaceColor = colors{k};
end

% Customize plot appearance
title('Gas Cost Comparison of Cross-chain Token Transfer Schemes');
xlabel('Number of Trading Pairs');
ylabel('Gas Cost');

% Add legend
legend('FDU', 'Decentralized Cryptocurrency Exchange Protocol', 'HTLC');

% Show the figure
hold off;
grid on;
