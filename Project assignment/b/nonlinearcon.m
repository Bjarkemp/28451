function [c,ceq]=nonlinearcon(x)
% Variable identification
F100=x(1);
F200=x(2);
P2=x(3);
P100=x(4);
F3=x(5);
F2=x(6);
L2=x(7);
X2=x(8);

% parameters
%separator
rhoA = 20; % kg/m
M = 20; % kg 
Cp = 0.07; % kW/K (kg/min)
lambda = 38.5; % kW (kg/min)
C = 4; % kg/kPa
lambda_s = 36.6; % kW (kg/min)
UA2 = 6.84; % kW/K

%disturbance variables
F1 = 10.0; %kg/min %%Feed flowrate
F4 = 8.0; %kg=min %%Vapor flowrate
F5 = 8.0; %kg=min %%Condensate flowrate
X1 = 5.0; % percent %%Feed composition
T1 = 40.0; %C %%Feed temperature
T2 = 84.6; %C %%Product temperature
T3 = 80.6; %C %%Circulating temperature
T100 = 119.9; %C %%Steam temperature
P100 = 194.7; %kPa %%Steam pressure
Q100 = 339.0; %kW %%Heater duty
T200 = 25.0; %C %%Cooling water inlet temp.
T201 = 46.1; %C %%Cooling water outlet temp.
Q200 = 307.9; %kW %%Condenser duty

X2min = 25;

%Equations - evaporator
T2 = 0.5616 * P2 + 0.3126 * X2 + 48.43;
T3 = 0.507 * P2 + 55.0;
F4 = (Q100 - F1 * Cp * (T2 - T1)) / lambda;

%Equations - steam jacket
T100 = 0.1538 * P100 + 90.0;
Q100 = 0.16 * (F1 + F3) * (T100 - T2);
F100 = Q100 / lambda_s;

%Equations - condenser
Q200 = UA2 * (T3 - T200) /(1 + UA2 /(2 * Cp * F200));
T201 = T200 + Q200 /(F200 * Cp);
F5 = Q200 / lambda;

% Inequality constraints
c=[X2min - X2];
 
%Equality constraints. Given by the model
ceq(1)=(F1-F4-F2)/rhoA; % mass balance of separator
ceq(2)=(F1*X1-F2*X2)/M; % Evaporator composition
ceq(3)=(F4-F5)/C; % Evaporator pressure