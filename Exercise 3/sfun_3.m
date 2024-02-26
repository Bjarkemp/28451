function [sys,x0,str,ts] = sfun_3(t,x,u,flag,xinit,par)

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
sizes.NumContStates  = 3;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 4;
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

Ks = par(1);
Ko = par(2);
Yxs = par(3);
V = par(4);
sf = par(5); 
of = par(6);
mumax = par(7);
osat = par(8);

F=u(1);
sf=u(2);
T=u(3);
kla=u(4);


% Calculate mu based on Monod kinetics
mu=mumax*(x(2)/(Ks+x(2))) * (x(3)/(Ko+x(3)));

dxdt(1)= mu * x(1) - (F/V) * x(1); % biomass
dxdt(2)= (F/V) * (sf-x(2)) - (1/Yxs) * mu * x(1); % substrate 
dxdt(3)= (F/V) * (of-x(3)) - ((1/Yxs) - 1) * mu * x(1) + kla * (osat - x(3)); % oxygen

sys = [dxdt(1) dxdt(2) dxdt(3)];

function sys=mdlOutputs(t,x,u)
% Calculate the outputs of the model block
sys = [x(1) x(2) x(3)];