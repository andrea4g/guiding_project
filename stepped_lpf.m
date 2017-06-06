clear all; clc;
%%
%   LPF STEPPED IMPEDANCE
%
%% data (insert data here)
% filter
f0 = 2.81e9;                     % f0 central frequency
%f0 = 3.2e9;                       % f0 central frequency
type = ".5db";                  % type of the filter
                                % "flat" = Butterworth
                                % "3dB"  = Chebyshev 3dB ripple
                                % ".5dB" = Chebyshev 0.5dB ripple
frange = (1e9 : 1e7 : 7e9);     % frequncy range
IL = 30;                        % insertion loss
f = 4.8e9;                      % frequency of insertion loss
r0 = 50;
Npresent = "yes";                % if N is given type "yes" otherwise "no"
N = 7;                         % if no comment this line
% microstrip
vph = physconst('LightSpeed');  % default
epsr = 4;
h = 2e-3;
measureh = "mm";                % if d is in inches type "in" otherwise "mm"
len = 1/8;                      % write the lenght between quotes
%% Find the order filter
Omega = abs(f / f0);
if Npresent == "no"
  switch type
    case "flat"
      logOmega = log10(10 ^ (IL / 10) - 1) / log10(Omega);  % changing base of the logarithm
      N = 0.5 * logOmega;                                   % find N
      N = ceil(N);                                          % round N to the upper integer
    case "3db"
      epsilon = sqrt(10 ^ ((3) / 10) - 1);
      N = (acosh(sqrt((IL ^ 2 - 1) / (epsilon ^ 2)))) / (acosh(Omega));
      N = ceil(N);
    case ".5db"
      epsilon = sqrt(10 ^ ((0.5) / 10) - 1);
      N = (acosh(sqrt((IL ^ 2 - 1) / (epsilon ^ 2)))) / (acosh(Omega));
      N = ceil(N);
  end
end
%% Find the prototype coefficients
switch type
  %% Butterworth filter
  case "flat"
    switch N
      case 1
        g = [2.0000 1.0000];
      case 2
        g = [1.4142 1.4142 1.0000];
      case 3
        g = [1.0000 2.0000 1.0000 1.0000];
      case 4
        g = [0.7654 1.8478 1.8478 0.7654 1.0000];
      case 5
        g = [0.6180 1.6180 2.0000 1.6180 0.6180 1.0000];
      case 6
        g = [0.5176 1.4142 1.9318 1.9318 1.4142 0.5176 1.0000];
      case 7
        g = [0.4450 1.2470 1.8019 2.0000 1.8019 1.2470 0.4450 1.0000];
      case 8
        g = [0.3902 1.1111 1.6629 1.9615 1.9615 1.6629 1.1111 0.3902 1.0000];
      case 9
        g = [0.3473 1.0000 1.5321 1.8794 2.0000 1.8794 1.5321 1.0000 0.3473 1.0000];
      case 10
        g = [0.3129 0.9080 1.4142 1.7820 1.9754 1.9754 1.7820 1.4142 0.9080 0.3129 1.0000];
    end
  %% Chebyshev 3dB ripple
  case "3db"
    switch N
      case 1
        g = [1.9953 1.0000];
      case 2
        g = [3.1013 0.5339 5.8095];
      case 3
        g = [3.3487 0.7117 3.3487 1.0000];
      case 4
        g = [3.4389 0.7483 4.3471 0.5920 5.8095];
      case 5
        g = [3.4817 0.7618 4.5381 0.7618 3.4817 1.0000];
      case 6
        g = [3.5045 0.7685 4.6061 0.7929 4.4641 0.6033 5.8095];
      case 7
        g = [3.5181 0.7723 4.6386 0.8039 4.6386 0.7723 3.5181 1.0000];
      case 8
        g = [3.5277 0.7745 4.6575 0.8089 4.6990 0.8018 4.4990 0.6073 5.8095];
      case 9
        g = [3.5340 0.7760 4.6692 0.8118 4.7272 0.8118 4.6692 0.7760 3.5340 1.0000];
      case 10
        g = [3.5384 0.7771 4.6768 0.8136 4.7425 0.8164 4.7260 0.8051 4.5142 0.6091 5.8095];
    end
  %% Chebyshev .5dB ripple
  case ".5db"
    switch N
      case 1
        g = [0.6986 1.0000];
      case 2
        g = [1.4029 0.7071 1.9841];
      case 3
        g = [1.5963 1.0967 1.5963 1.0000];
      case 4
        g = [1.6703 1.1926 2.3661 0.8419 1.9841];
      case 5
        g = [1.7058 1.2296 2.5408 1.2296 1.7058 1.0000];
      case 6
        g = [1.7254 1.2479 2.6064 1.3137 2.4758 0.8696 1.9841];
      case 7
        g = [1.7373 1.2582 2.6383 1.3443 2.6383 1.2582 1.7373 1.0000];
      case 8
        g = [1.7451 1.2647 2.6564 1.3590 2.6964 1.3389 2.5093 0.8796 1.9841];
      case 9
        g = [1.7504 1.2690 2.6678 1.3673 2.7939 1.3673 2.6678 1.2690 1.7504 1.0000];
      case 10
        g = [1.7543 1.2721 2.6754 1.3725 2.7392 1.3806 2.7231 1.3485 2.5239 0.8842 1.9841];
    end
    %%
end % end switch type
%% Value of L and C (lumped elements)
% T network
for i = 1:N
  if mod(i, 2) == 1 % i is odd (dispari)
    Lt(i) = (g(i) * r0) / (2 * pi * f0);
  else % i is even (pari)
    Ct(i) = g(i) / (r0 * 2 * pi * f0);
  end
end
% delete zero elements in the vector
Lt(Lt == 0) = [];
Ct(Ct == 0) = [];
% graph frequency respose of T network
LPF = rfckt.lclowpasstee('L',Lt,'C',Ct);
analysis_LPF = analyze(LPF, frange);

% Pi network
for i = 1:N
  if mod(i, 2) == 1 % i is odd (dispari)
    Cpi(i) = g(i) / (r0 * 2 * pi * f0);
  else % i is even (pari)
    Lpi(i) = (g(i) * r0) / (2 * pi * f0);
  end
end
% delete zero elements in the vector
Lpi(Lpi == 0) = [];
Cpi(Cpi == 0) = [];
% print the frequency response of Pi network
LPF_pi = rfckt.lclowpasspi('L',Lpi,'C',Cpi);
analysis_LPF  = analyze(LPF_pi, frange);

%% Stepped impedance PI
theta = 2 * pi * len; %length microstrip is fixed
for i = 1:N
  if mod(i, 2) == 1 % i is odd
    Zinf(i) = (g(i) * r0) / (theta); %inductor
%     y=exp(Zinf(i)*sqrt(epsr)/60);
%     W_over_h(i) = (2*y-sqrt(((2*y)^2)-32));
    A = Zinf(i)*sqrt((epsr+1)/2)/60+((epsr-1)/(epsr+1))*(0.23+0.11/epsr);
    W_over_h(i) = 8*exp(A)/(exp(2*A)-2);
  else % i is even (pari)
    Zinf(i) = (r0 * theta) / (g(i)); %capacitor
    B = 377*pi/(2*Zinf(i)*sqrt(epsr)) ;
    W_over_h(i) = (2/pi)*(B-1-log(2*B-1)+((epsr-1)/(2*epsr))*(log(B-1)+0.39-(0.61/epsr)));
    %W_over_h(i) = 2*pi+(B-1-log(2*B-1)-((epsr-1)/(2*epsr))*(log(B-1)+0.39-(0.61/epsr)));
  end
   Width(i)  = W_over_h(i)* h ;
   epseff(i) = (epsr+1)/2+(epsr-1)/(2*sqrt(1+12/W_over_h(i)));
   lenght(i) = vph * len * 1 / (f0 * sqrt(epseff(i)));
end
Width,  lenght

% display frequency response of the stepped impedance filter
 for i=1:N
micro(i) = rfckt.microstrip('height', h, 'LineLength',lenght(i), 'Width',Width(i), 'EpsilonR', epseff(i));
 end
switch N
	case 1
        Cascade_microstrip_pi  = rfckt.cascade('Ckts', {micro(1)});
    case 2
        Cascade_microstrip_pi  = rfckt.cascade('Ckts', {micro(1), micro(2)});
    case 3
        Cascade_microstrip_pi  = rfckt.cascade('Ckts', {micro(1), micro(2), micro(3)});
    case 4
        Cascade_microstrip_pi  = rfckt.cascade('Ckts', {micro(1), micro(2), micro(3), micro(4)});
    case 5
        Cascade_microstrip_pi  = rfckt.cascade('Ckts', {micro(1), micro(2), micro(3), micro(4), micro(5)});
    case 6
        Cascade_microstrip_pi  = rfckt.cascade('Ckts', {micro(1), micro(2), micro(3), micro(4), micro(5), micro(6)});
    case 7
        Cascade_microstrip_pi  = rfckt.cascade('Ckts', {micro(1), micro(2), micro(3), micro(4), micro(5), micro(6), micro(7)});
    case 8
        Cascade_microstrip_pi  = rfckt.cascade('Ckts', {micro(1), micro(2), micro(3), micro(4), micro(5), micro(6), micro(7), micro(8)});
    case 9
        Cascade_microstrip_pi  = rfckt.cascade('Ckts', {micro(1), micro(2), micro(3), micro(4), micro(5), micro(6), micro(7), micro(8), micro(9)});
    case 10
        Cascade_microstrip_pi  = rfckt.cascade('Ckts', {micro(1), micro(2), micro(3), micro(4), micro(5), micro(6), micro(7), micro(8), micro(9), micro(10)});
end
analisys_Microstrip_pi = analyze(Cascade_microstrip_pi, frange);
%% plots
figure, hold on
plot(LPF_pi,'S21')
plot(Cascade_microstrip_pi,'S21')
title('Comparison between Lumped, Microstrip [PI]'),  xlabel('frequency [GHz]')

%% Stepped impedance T
if 1==0
theta = 2 * pi * len; %length microstrip is fixed
for i = 1:N
  if mod(i, 2) == 1 % i is odd
    Zinf(i) = (r0 * theta) / (g(i)); %capacitor
%     y=exp(Zinf(i)*sqrt(epsr)/60);
%     W_over_h(i) = (2*y-sqrt(((2*y)^2)-32));
    A = Zinf(i)*sqrt((epsr+1)/2)/60+((epsr-1)/(epsr+1))*(0.23+0.11/epsr);
    W_over_h(i) = 8*exp(A)/(exp(2*A)-2);
  else % i is even (pari)
    Zinf(i) = (g(i) * r0) / (theta); %inductor
    B = 377*pi/(2*Zinf(i)*sqrt(epsr)) ;
    W_over_h(i) = (2/pi)*(B-1-log(2*B-1)+((epsr-1)/(2*epsr))*(log(B-1)+0.39-(0.61/epsr)));
    %W_over_h(i) = 2*pi+(B-1-log(2*B-1)-((epsr-1)/(2*epsr))*(log(B-1)+0.39-(0.61/epsr)));
  end
   Width(i)  = W_over_h(i)* h ;
   epseff(i) = (epsr+1)/2+(epsr-1)/(2*sqrt(1+12/W_over_h(i)));
end
W_over_h,  Width, epseff
% necessary to use txline here to have acorrect result
%here i did approx the epsilon_eff of the W/h calc with epsilon_r
for i = 1:N
  l(i) = vph * len * 1 / (f0 * sqrt(epseff(i)));
end
%% display frequency response of the stepped impedance filter
 for i=1:N
micro(i) = rfckt.microstrip('height', h, 'LineLength',l(i), 'Width',Width(i), 'EpsilonR', epseff(i));
 end
Cascade_microstrip_t = rfckt.cascade('Ckts', {micro(1), micro(2), micro(3), micro(4), micro(5), micro(6), micro(7)});
analisys_Microstrip_t = analyze(Cascade_microstrip_t, frange);
%% plots
figure, hold on
plot(LPF,'S21')
plot(Cascade_microstrip_t,'S21')
title('Comparison between Lumped, Microstrip [T]'),  xlabel('frequency [GHz]')
end
