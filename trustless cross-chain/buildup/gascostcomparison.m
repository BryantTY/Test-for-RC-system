p = [4, 8, 12, 16, 20];

% Gas cost calculations
ccnfdt_total_gas_overhead = p .*548292 + ((p-1) .*p / 2 .*184496+91467+p*165848) + p .*303793 + p .*185258;
ibc_total_gas_overhead = p .*244282*4+p .*(115964+25506+45232+22321)*2+((p-1) .*p/2 .*184496+91467) ;
xcmp_total_gas_overhead = p .*244282*4+p .*115964*2+ p*19718*2+ (p-1) .*p/2 .*184496 + 91467;
layer_zero_total_gas_overhead = p .*244282*4+ p .*(115964+25506+45232+22321)*2+((p-1) .*p/2 .*184496+91467)+p .*299611*2;

% Plot
figure;
hold on;

plot(p, ccnfdt_total_gas_overhead, '-o', 'DisplayName', 'Π_{B-CCDI}', 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 2);
plot(p, ibc_total_gas_overhead, '-x', 'DisplayName', 'IBC', 'Color', [0.9290, 0.6940, 0.1250], 'LineWidth', 2);
plot(p, xcmp_total_gas_overhead, '-s', 'DisplayName', 'XCMP', 'Color', [0.4940, 0.1840, 0.5560], 'LineWidth', 2);
plot(p, layer_zero_total_gas_overhead, '-d', 'DisplayName', 'Layer Zero', 'Color', [0.4660, 0.6740, 0.1880], 'LineWidth', 2);

xlabel('The number of NFDs to be updated');
ylabel('Gas cost');
title('Gas Cost vs p');
legend('show');
grid on;
hold off;

% Remove the gray background by setting the 'Color' property to 'white'
ax = gca;
set(ax, 'Color', 'white');
