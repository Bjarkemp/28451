function [sys,x0,str,ts] = predprey_sfun(t,x,u,flag,xinit,par)
 
switch flag,
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
sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 1;
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

% r represents the growth rate of the hares, 
% Hmax represents the maximum population of the hares (in the absence of lynxes), 
% a represents the interaction term that describes how the hares are diminished as a function of the lynx population
% c controls the prey consumption rate for low hare population.
% b represents the growth coefficient of the lynxes,
% d represents the mortality rate of the lynxes

a = par(1); b = par(2); c = par(3); d = par(4); Hmax = par(5);
r=u(1);
dxdt(1)= (r)*x(1)*(1-x(1)/Hmax) - a*x(1)*x(2) / (c+ x(1)) ;
dxdt(2)= b* a*x(1)*x(2) / (c+x(1)) - d*x(2);
sys = [dxdt(1) dxdt(2)];

function sys=mdlOutputs(t,x,u)
% Calculate the outputs of the model block
sys = [x(1) x(2)];