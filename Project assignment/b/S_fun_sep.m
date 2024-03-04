%Separator S function

function [sys,x0,str,ts] = S_fun_sep(t,x,u,flag,xinit,par)

switch flag
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes(xinit);
  case 1,
    sys=mdlDerivatives(t,x,u,par);
  case 3,
    sys=mdlOutputs(t,x,u);
  case { 2, 4, 9 }
     sys = []; % Unused flags
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes(xinit)
sizes = simsizes;
sizes.NumContStates  = 3;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 17;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   % at least one sample time is needed
sys = simsizes(sizes);
% initialize the initial conditions
x0  = xinit; % xinit are the initial values that are sent to the S-function, see first line of the S-function
% str is always an empty matrix
str = [];
% initialize the array of sample times
ts  = [0 0];

function sys=mdlDerivatives(t,x,u,par)
% Assign values to the parameters, par is a vector with parameter values
% that is sent to the S-function

rhoA = par(1);
M = par(2);
Cp = par(3);
lambda = par(4);
C = par(5);
lambda_s = par(6);
UA2 = par(7);

%inputs

F1 = u(1);
F2 = u(2);
F3 = u(3);
F4 = u(4);
F5 = u(5);
X1 = u(6);
T1 = u(7);
T2 = u(8);
T3 = u(9);
F100 = u(10);
T100 = u(11);
P100 = u(12);
Q100 = u(13);
F200 = u(14);
T200 = u(15);
T201 = u(16);
Q200 = u(17);

% Variable identification

L2 = x(1);
X2 = x(2);
P2 = x(3);

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

%Diff system
dxdt(1)= (F1-F4-F2)/rhoA; % mass balance of separator
dxdt(2)= (F1*X1-F2*X2)/M; % Evaporator composition 
dxdt(3)= (F4-F5)/C; % Evaporator pressure

sys = [dxdt(1) dxdt(2) dxdt(3)];

function sys=mdlOutputs(t,x,u)
% Calculate the outputs of the model block
sys = [x(1) x(2) x(3)]