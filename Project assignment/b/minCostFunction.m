function costFunction=minCostFunction(x);
% Variable identification
X2=x(1);
F200=x(2);
P2=x(3);
P100=x(4);
F3=x(5);
F2=x(6);
L2=x(2);

F1 = 10.0; %kg/min %%Feed flowrate
% parameters
%separator
rhoA = 20; % kg/m
M = 20; % kg 
Cp = 0.07; % kW/K (kg/min)
lambda = 38.5; % kW (kg/min)
C = 4; % kg/kPa
lambda_s = 36.6; % kW (kg/min)
UA2 = 6.84; % kW/K

%Cost function
% Bisphenol-A is 1.52 dollars a kg
%F100 = 0.16 * (F1 + F3) * (0.1538 * P100 + 90.0 - 0.5616 * P2 + 0.3126 * X2 + 48.43) / lambda_s;
costFunction=(F200+P100)-(F2);
%costFunction=0.16 * (F1 + F3) * (0.1538 * P100 + 90.0 - 0.5616 * P2 + 0.3126 * X2 + 48.43) / lambda_s;