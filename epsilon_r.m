clc, close all, clear all;
%% script to find the value of the relative dielectric constant ----------------------------
LightSpeed = physconst(’LightSpeed’);
fc = 2.07e9; % measured cut-off frequency
h = 2e-3;
L(1) = 8.0 0; W(1) = 0.70 ;
L(2) = 7.4 0; W(2) = 8.30 ;
L(3) = 8.2 0; W(3) = 0.20 ;
L(4) = 7.4 0; W(4) = 9.00 ;
L = L.*1e-3;  W = W.*1e-3;
alpha = sqrt (1+12.*h ./W) ;
epsilon_eff_V = (LightSpeed ./(8* f c *L) ) . ˆ 2 ;
epsilon_r_V = (2 .* alpha .* epsilon_eff_V - alpha+1) . / ( alpha+1) ;

epsilon_eff = mean(epsilon_eff_V)
epsilon_r = mean(epsilon_r_V)
