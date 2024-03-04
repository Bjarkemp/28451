%Script for simulation of our model implemented in simulink
clear, clc, close all

xMin=[0     0     40     0        0       0     0.3  0]; % Lower boundary for F100, F200, P2, P100, F3, F2, L2, X2
xMax=[inf   400   80     400      100     inf   2    inf]; % Upper boundary for F100, F200, P2, P100, F3, F2, L2, X2

% Define guess for initial value
xInitial=[9.3 208 50.5 194.7 50.0 2  1 25];  % Initial guess (nomial values) for  F100, F200, P2, P100, F3, L2, F2, X2

options=optimset('MaxFunEvals',1e5,'MaxIter ',1e4,'Display','on','TolFun',1e-8,'TolX',1e-8);
[xOpt,fval,exitflag,output,~,grad,hessian] = fmincon(@minCostFunction,xInitial,[],[],[],[],xMin,xMax,@nonlinearcon,options); %Optimisation of 
% the objective function (fuel use) in @burners given that the
% variables are linked by the model (@nonlinearcon)

disp('The Flow of steam (F100) is : ')
%Opt_steam=xOpt(1)

disp('The flow of cooling water (F200) is : ')
%Opt_cool=xOpt(2)

%OptPar=[xOpt(1) xOpt(2) xOpt(3) xOpt(4) xOpt(5) xOpt(6) xOpt(7)];

%Simulink inputs 
F2 = xOpt(6);
F3 = xOpt(5);
F100 = xOpt(1);
F200 = xOpt(2);
P2 = xOpt(3);
X2 = xOpt(8);

%% parameters

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

%Controlled variables
X2N = 25.0; % percent %%Product composition
L2N = 1.0; %m %%Separator level
P2N = 50.5; %kPa %%Operating pressure

par = [rhoA,M,Cp,lambda,C,lambda_s, UA2];


inputv =[ F3, F4, F5, X1, T1, T2, T3, F100, T100, P100, Q100, F200, T200, T201, Q200].';

%Define initial conditions
L2int = L2N ; % m %%separator level
X2int = X2; % percent %% product composition
P2int = P2; % kPa % operating pressure
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
