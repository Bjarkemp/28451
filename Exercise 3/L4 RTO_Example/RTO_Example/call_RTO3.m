clear variables
close all

%Parameters

% Saturation concentration of oxygen
P_O2 = 0.21; % atm
k_H = 0.027 * exp(1142 / 318.5); % mmol O2 / L * atm (calculated at max temp)
osat = ((P_O2 * k_H) / 32); % (mmol O2 / L) / (mg/mmol)

%temperature dependency
A = 1E10; %(h-1) 
B = 3E90; %(h-1)
Eg = 58; %(kJ/mol) 
Gd = 550; %(kJ/mol)
R = 8.314E-3; %kJ/(mol*K)
mumax = A * exp(-Eg/(R*318.5))/(1+B*exp(-Gd/(R*318.5)));


Ks = 0.1; % g/L
Ko = 0.2E-3; % g/L
Yxs = 0.4; %g/g
V = 2; % L
sf = 10; %g/L 
of = 0; %g/L

%cost function
VC = 12000; %dkk
C = 86.7; % Dkk


par = [Ks, Ko, Yxs, V, sf, of, mumax, osat, VC, C];

% Define limits for the variables if possible

xMax=[1    318.5      1000      10       10         0.0064]; % Upper boundary for F, T, kLa, X, S, DO
xMin=[0    288.5      0      0.1       0           0]; % Lower boundary for F, T, kLa, X, S, DO

% Define guess for initial value
xInitial=[0.5 298 250 4 0.01 0.0024];  % Initial guess for F, T, kLa, X, S, DO Always in this order


options=optimset('MaxFunEvals',1e5,'MaxIter ',1e4,'Display','on','TolFun',1e-8,'TolX',1e-8);
[xOpt,fval,exitflag,output,lambda,grad,hessian] = fmincon(@(x) minCostFunction(x,par), xInitial,[],[],[],[],xMin,xMax, @(x) nonlinearcon(x, par),options); %Optimisation of 
% the objective function (fuel use) in @burners given that the
% variables are linked by the model (@nonlinearcon)

disp('The Flow is : ')
flow=xOpt(1)

disp('The temperature is : ')
temp=xOpt(2)

disp('The kLa is: ')
oxygen=xOpt(3)

xinit=[flow temp oxygen];

%Defining time simulation 
t0 = 0; 
t_interval = 0.5; 
t_final = 168;

% Saturation concentration of oxygen
P_O2 = 0.21; % atm
k_H = 0.027 * exp(1142 / temp); % mmol O2 / L * atm (calculated at max temp)
osat_opt = ((P_O2 * k_H) / 32); % (mmol O2 / L) / (mg/mmol)



%temperature dependency
A = 1E10; %(h-1) 
B = 3E90; %(h-1)
Eg = 58; %(kJ/mol) 
Gd = 550; %(kJ/mol)
R = 8.314E-3; %kJ/(mol*K)
mumax_opt = A * exp(-Eg/(R*temp))/(1+B*exp(-Gd/(R*temp)));

par = [Ks, Ko, Yxs, V, sf, of, mumax_opt, osat_opt];


%Definesimulation options
%Simulation options wereset in our_simulinkmSfunc.mdl;
exercise3_simulink;
%Solve the model
sim('exercise3_simulink')


