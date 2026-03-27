% =========================================================
% RF Link Budget Calculator
% Author: Pranjul Kumar
% System: Drone Telemetry - 865-867 MHz ISM Band
% IIT Jammu M.Tech
% =========================================================

clc; clear; close all;

%% ---- SYSTEM PARAMETERS (edit here) --------------------

TX_power_dBm     = 30;       % TX output power (dBm)
TX_antenna_dBi   = 2.5;      % TX antenna gain (dBi) - dipole
TX_cable_loss_dB = 1.0;      % TX cable + connector loss (dB)

freq_MHz         = 866;      % Centre frequency (MHz)
distance_km      = 15;       % Link distance (km)

RX_antenna_dBi   = 9.0;      % RX antenna gain (dBi) - Yagi/tracker
RX_cable_loss_dB = 1.0;      % RX cable + connector loss (dB)
RX_sens_dBm      = -121;     % Receiver sensitivity (dBm) - SiK radio

required_margin_dB = 10;     % Minimum acceptable link margin (dB)
fade_margin_dB     = 15;     % Fade margin for real-world conditions

%% ---- CALCULATIONS -------------------------------------

% Effective Isotropic Radiated Power
EIRP_dBm = TX_power_dBm + TX_antenna_dBi - TX_cable_loss_dB;

% Free-Space Path Loss (Friis formula)
FSPL_dB = 20*log10(distance_km) + 20*log10(freq_MHz) + 32.45;

% Received signal power
RX_signal_dBm = EIRP_dBm + RX_antenna_dBi - RX_cable_loss_dB - FSPL_dB;

% Link margin
link_margin_dB = RX_signal_dBm - RX_sens_dBm;

% Maximum theoretical range (0 dB margin)
budget_dB  = EIRP_dBm + RX_antenna_dBi - RX_cable_loss_dB - RX_sens_dBm;
max_range_km  = 10^((budget_dB - 20*log10(freq_MHz) - 32.45) / 20);

% Practical range (with required margin)
prac_range_km = 10^((budget_dB - required_margin_dB ...
                - 20*log10(freq_MHz) - 32.45) / 20);

% Range with full fade margin
fade_range_km = 10^((budget_dB - required_margin_dB - fade_margin_dB ...
                - 20*log10(freq_MHz) - 32.45) / 20);

%% ---- RESULTS DISPLAY ----------------------------------

fprintf('\n========================================\n');
fprintf('   RF LINK BUDGET RESULTS\n');
fprintf('   Frequency : %d MHz\n', freq_MHz);
fprintf('   Distance  : %.1f km\n', distance_km);
fprintf('========================================\n');
fprintf('  EIRP                  : %+.1f dBm\n', EIRP_dBm);
fprintf('  Free-Space Path Loss  : %.1f dB\n',   FSPL_dB);
fprintf('  Received Signal       : %+.1f dBm\n', RX_signal_dBm);
fprintf('  RX Sensitivity        : %+.1f dBm\n', RX_sens_dBm);
fprintf('  Link Margin           : %.1f dB\n',   link_margin_dB);
fprintf('----------------------------------------\n');
fprintf('  Max theoretical range : %.1f km\n',   max_range_km);
fprintf('  Practical range       : %.1f km\n',   prac_range_km);
fprintf('  Range (with fade)     : %.1f km\n',   fade_range_km);

if link_margin_dB >= required_margin_dB + 10
    fprintf('  Status : EXCELLENT LINK\n');
elseif link_margin_dB >= required_margin_dB
    fprintf('  Status : GOOD LINK\n');
elseif link_margin_dB >= 0
    fprintf('  Status : MARGINAL LINK\n');
else
    fprintf('  Status : LINK FAILURE\n');
end
fprintf('========================================\n\n');

%% ---- RANGE vs FREQUENCY PLOT -------------------------

freq_range = 400:10:2500;
range_vs_freq = 10.^((budget_dB - 20*log10(freq_range) - 32.45) / 20);

figure(1);
plot(freq_range, range_vs_freq, 'b-', 'LineWidth', 2);
hold on;
plot(freq_MHz, prac_range_km, 'ro', 'MarkerSize', 10, ...
     'MarkerFaceColor', 'r');
xline(866, '--k', '866 MHz (your system)', 'LabelVerticalAlignment', 'bottom');
xlabel('Frequency (MHz)');
ylabel('Practical Range (km)');
title('Practical Range vs Frequency');
legend('Range curve', 'Your system (866 MHz)', 'Location', 'northeast');
grid on;

%% ---- LINK MARGIN vs DISTANCE PLOT --------------------

dist_range = 1:0.5:50;
fspl_range = 20*log10(dist_range) + 20*log10(freq_MHz) + 32.45;
margin_range = EIRP_dBm + RX_antenna_dBi - RX_cable_loss_dB ...
               - fspl_range - RX_sens_dBm;

figure(2);
plot(dist_range, margin_range, 'b-', 'LineWidth', 2);
hold on;
yline(required_margin_dB, '--r', 'Min required margin (10 dB)', ...
      'LabelHorizontalAlignment', 'left');
yline(0, '-k', 'Link failure threshold', ...
      'LabelHorizontalAlignment', 'left');
plot(distance_km, link_margin_dB, 'go', 'MarkerSize', 10, ...
     'MarkerFaceColor', 'g');
xline(distance_km, '--g', sprintf('%.0f km (your system)', distance_km), ...
      'LabelVerticalAlignment', 'bottom');
xlabel('Distance (km)');
ylabel('Link Margin (dB)');
title('Link Margin vs Distance @ 866 MHz');
legend('Link margin', 'Min required', 'Failure threshold', ...
       'Your system', 'Location', 'northeast');
grid on;
ylim([-20 80]);

%% ---- SENSITIVITY ANALYSIS ----------------------------

fprintf('Sensitivity Analysis — effect of antenna gain on range:\n');
fprintf('%-20s %-15s %-15s\n', 'RX Antenna Gain', ...
        'Practical Range', 'Link Margin');
fprintf('%s\n', repmat('-', 1, 50));

gains = [2.5, 5, 7, 9, 12, 15];
for g = gains
    b = EIRP_dBm + g - RX_cable_loss_dB - RX_sens_dBm;
    r = 10^((b - required_margin_dB - 20*log10(freq_MHz) - 32.45)/20);
    fspl_at_dist = 20*log10(distance_km) + 20*log10(freq_MHz) + 32.45;
    m = EIRP_dBm + g - RX_cable_loss_dB - fspl_at_dist - RX_sens_dBm;
    fprintf('  %-18s %-15s %-15s\n', ...
            sprintf('%.1f dBi', g), ...
            sprintf('%.1f km', r), ...
            sprintf('%.1f dB', m));
end
