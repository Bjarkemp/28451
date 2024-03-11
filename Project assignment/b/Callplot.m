%Script for simulation of our model implemented in simulink
clear, clc, close all

xMin=[25   0     40     0        0       0     0.3]; % Lower boundary for X2, F200, P2, P100, F3, F2, L2 
xMax=[inf  400   80     400      100     inf   2]; % Upper boundary for X2, F200, P2, P100, F3, F2, L2,

% Define guess for initial value
xInitial=[25 208 50.5 194.7 50.0 2  1];  % Initial guess (nomial values) for  X2, F200, P2, P100, F3, L2, F2

options=optimset('MaxFunEvals',1e5,'MaxIter ',1e4,'Display','on','TolFun',1e-8,'TolX',1e-8);
[xOpt,fval,exitflag,output,~,grad,hessian] = fmincon(@minCostFunction,xInitial,[],[],[],[],xMin,xMax,@nonlinearcon,options); %Optimisation of 
% the objective function (fuel use) in @burners given that the
% variables are linked by the model (@nonlinearcon)

%disp('The Flow of steam (F100) is : ')
%Opt_steam=xOpt(1)

%disp('The flow of cooling water (F200) is : ')
%Opt_cool=xOpt(2)

%OptPar=[xOpt(1) xOpt(2) xOpt(3) xOpt(4) xOpt(5) xOpt(6) ];

%Simulink inputs - controlled variables and manipulated
X2 = xOpt(1);
F200 = xOpt(2);
P2 = xOpt(3);
P100 = xOpt(4);
F3 = xOpt(5);
F2 = xOpt(6);
L2 = xOpt(7);

%% parameters
rhoA = 20; % kg/m
M = 20; % kg 
Cp = 0.07; % kW/K (kg/min)
lambda = 38.5; % kW (kg/min)
C = 4; % kg/kPa
lambda_s = 36.6; % kW (kg/min)
UA2 = 6.84; % kW/K

par = [rhoA,M,Cp,lambda,C,lambda_s, UA2];

%%States
%T2 = 84.6; %C %%Product temperature
%T3 = 80.6; %C %%Circulating temperature
%F4 = 8.0; %kg=min %%Vapor flowrate
%F5 = 8.0; %kg=min %%Condensate flowrate
%T100 = 119.9; %C %%Steam temperature
%Q100 = 339.0; %kW %%Heater duty
%F100 = 9.3; %kg/min %%Steam flowrate
%Q200 = 307.9; %kW %%Condenser duty
%T201 = 46.1; %C %%Cooling water outlet temp.



%disturbance variables
F1 = 10.0; %kg/min %%Feed flowrate
X1 = 5.0; % percent %%Feed composition
T1 = 40.0; %C %%Feed temperature
T200 = 25.0; %C %%Cooling water inlet temp.

%manipulated variables
inputv =[F2, F3, P100, F200].';-0.1+0.1*rand(1)

%Define initial conditions for controlled variables
L2int = L2 ; % m %%separator level
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

F2step = ans.s(:,1);

% Define noise parameters
sigma_x1 = 0.005 * mean(x1); % Composition noise for x1 (0.5% of the mean)
sigma_x2 = 0.005 * mean(x2); % Composition noise for x2 (0.5% of the mean)
sigma_x3 = 2; % Pressure noise for x3 (2 kPa)

% Generate noise
noise_x1 = sigma_x1 * randn(size(x1)); % Composition noise for x1
noise_x2 = sigma_x2 * randn(size(x2)); % Composition noise for x2
noise_x3 = sigma_x3 * randn(size(x3)); % Pressure noise for x3

% Add noise to signals
x1_noisy = x1 + noise_x1;
x2_noisy = x2 + noise_x2;
x3_noisy = x3 + noise_x3;

% Convert time from hours to days
Time_days = Time / 24; % Assuming 24 hours in a day

% % Define the time points for the step changes
% t_step1 = 10 / 24; % Convert hours to days
% t_step2 = 60 / 24; % Convert hours to days
% t_end = 168 / 24;  % Convert hours to days

% % Define F2 values at different time points
% F2_initial = F2; % Initial F2 value
% F2_step1 = F2_initial + 0.2 * F2_initial; % F2 value after the first step
% F2_step2 = F2_initial; % F2 value after the second step

% Plot the results
figure;

% Plot x1
subplot(3,1,1);
plot(Time_days, x1_noisy, 'b.', 'LineWidth', 1.5);
xlabel('Time (days)');
ylabel('L2 [m]');
title('Separator level Over Time');
ylim([0, 2.3]);

% Plot the step changes in F2
yyaxis right;
hold on;
plot(Time_days, F2step, 'y-', 'LineWidth', 1.5);
ylabel('F2 [kg/min]');
ylim([1.2, max(F2step) * 1.2]); % Adjust ylim for F2
hold off;

% Plot x2
subplot(3,1,2);
plot(Time_days, x2_noisy, 'r.', 'LineWidth', 1.5);
xlabel('Time (days)');
ylabel('X2 [mol%]');
title('Product composition Over Time');
ylim([0, 37]);

% Plot the step changes in F2
yyaxis right;
hold on;
plot(Time_days, F2step, 'y-', 'LineWidth', 1.5);
ylabel('F2 [kg/min]');
ylim([1.2, max(F2step) * 1.2]); % Adjust ylim for F2
hold off;

% Plot x3
subplot(3,1,3);
plot(Time_days, x3_noisy, 'g.', 'LineWidth', 1.5);
xlabel('Time (days)');
ylabel('P2 [kPa]');
title('Operating pressure Over Time');
ylim([38, 82]);

% Plot the step changes in F2
yyaxis right;
hold on;
plot(Time_days, F2step, 'y-', 'LineWidth', 1.5);
ylabel('F2 [kg/min]');
ylim([1.2, max(F2step) * 1.2]); % Adjust ylim for F2
hold off;

% Save figure
saveas(gcf, 'Evaporator_3_with_step_change_lines.png');

