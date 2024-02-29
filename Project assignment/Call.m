%Script for simulation of our model implemented in simulink
clear, clc, close all
%% parameters

%separator
rhoA = 20; % kg/m
M = 20; % kg 
Cp = 0.07; % kW/K (kg/min)
lambda = 38.5; % kW (kg/min)
C = 4; % kg/kPa
lambda_s = 36.6; % kW (kg/min)
UA2 = 6.84; % kW/K

%nomail values
F1 = 10.0; %kg/min %%Feed flowrate
F2 = 2.0; %kg/min %%Product flowrate
F3 = 50.0; %kg=min %%Criculating flowrate
F4 = 8.0; %kg=min %%Vapor flowrat
F5 = 8.0; %kg=min %%Condensate flowrate
X1 = 5.0; % percent %%Feed composition
X2N = 25.0; % percent %%Product composition
T1 = 40.0; %C %%Feed temperature
T2 = 84.6; %C %%Product temperature
T3 = 80.6; %C %%Circulating temperature
L2N = 1.0; %m %%Separator level
P2N = 50.5; %kPa %%Operating pressure
F100 = 9.3; %kg=min %%Steam flowrate
T100 = 119.9; %C %%Steam temperature
P100 = 194.7; %kPa %%Steam pressure
Q100 = 339.0; %kW %%Heater duty
F200 = 208.0; %kg=min %%Cooling water flowrate
T200 = 25.0; %C %%Cooling water inlet temp.
T201 = 46.1; %C %%Cooling water outlet temp.
Q200 = 307.9; %kW %%Condenser duty


par = [rhoA,M,Cp,lambda,C,lambda_s, UA2];

inputv =[F1, F2, F3, F4, F5, X1, T1, T2, T3, F100, T100, P100, Q100, F200, T200, T201, Q200].';

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

% Plot the results
figure;

% Plot x1
subplot(3,1,1);
plot(Time, x1, 'b', 'LineWidth', 1.5);
xlabel('Time (h)');
ylabel('x1');
title('x1 Over Time');

% Plot x2
subplot(3,1,2);
plot(Time, x2, 'r', 'LineWidth', 1.5);
xlabel('Time (h)');
ylabel('x2');
title('x2 Over Time');

% Plot x3
subplot(3,1,3);
plot(Time, x3, 'g', 'LineWidth', 1.5);
xlabel('Time (h)');
ylabel('x3');
title('x3 Over Time');