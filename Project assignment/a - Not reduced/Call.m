%Script for simulation of our model implemented in simulink
clear, clc, close all
%% parameters
%% parameters
rhoA = 20; % kg/m
M = 20; % kg 
Cp = 0.07; % kW/K (kg/min)
lambda = 38.5; % kW (kg/min)
C = 4; % kg/kPa
lambda_s = 36.6; % kW (kg/min)
UA2 = 6.84; % kW/K
%%States
T2 = 84.6; %C %%Product temperature
T3 = 80.6; %C %%Circulating temperature
F4 = 8.0; %kg=min %%Vapor flowrate
F5 = 8.0; %kg=min %%Condensate flowrate
T100 = 119.9; %C %%Steam temperature
Q100 = 339.0; %kW %%Heater duty
F100 = 9.3; %kg/min %%Steam flowrate
Q200 = 307.9; %kW %%Condenser duty
T201 = 46.1; %C %%Cooling water outlet temp.

%disturbance variables
F1 = 10.0; %kg/min %%Feed flowrate
X1 = 5.0; % percent %%Feed composition
T1 = 40.0; %C %%Feed temperature
T200 = 25.0; %C %%Cooling water inlet temp.

%Controlled variables
F2 = 2.0; %kg/min %%Product flowrate
F3 = 50.0; %kg=min %%Criculating flowrate
P100 = 194.7; %kPa %%Steam pressure
F200 = 208.0; %kg=min %%Cooling water flowrate

%Nomial values for controlled variables
L2N = 1; %m %%separator level
X2N = 25; % percent %% product composition
P2N = 50.5; % kPa % operating pressure

par = [rhoA,M,Cp,lambda,C,lambda_s, UA2, T2, T3, F4, F5, T100, Q100, F100, Q200, T201];

inputv =[F2, F3, P100, F200, F1, X1, T1, T200].';%%for all inputs

%Define initial conditions
L2int = L2N ; % m %%separator level
X2int = X2N; % percent %% product composition
P2int = P2N; % kPa % operating pressure
xinit = [L2int, X2int, P2int];

%Define simulation start/end time
t0=0;
tint=0.05;
tfin=168.0;

%Define simulation options
%%%Simulation options were set in our_simulinkmSfunc.mdl;
Simulink_Project1%_mSfunc
%Solve the model
sim('Simulink_Project1.mdl')

% Access the time data
Time = ans.tout;

% Access the output data
x1 = ans.y(:,1);
x2 = ans.y(:,2);
x3 = ans.y(:,3);

% Convert time from hours to days
Time_days = Time / 24; % Assuming 24 hours in a day

% Plot the results
figure;

% Plot x1
subplot(3,1,1);
plot(Time_days, x1, 'b', 'LineWidth', 1.5);
xlabel('Time (days)');
ylabel('L2 [m]');
title('Separator level Over Time');

% Plot x2
subplot(3,1,2);
plot(Time_days, x2, 'r', 'LineWidth', 1.5);
xlabel('Time (days)');
ylabel('X2 [mol%]');
title('Product composition Over Time');

% Plot x3
subplot(3,1,3);
plot(Time_days, x3, 'g', 'LineWidth', 1.5);
xlabel('Time (days)');
ylabel('P2 [kPa]');
title('Operating pressure Over Time');

% Save figure
saveas(gcf, 'Evaporator_1.png');
