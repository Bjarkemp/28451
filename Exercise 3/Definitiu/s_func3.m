function [sys,x0,str,ts] = s_func3(t,x,u,flag,xinit,par)

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


Y_xs=par(1);
micro_max = par(2);
K_s = par(3);
K_o = par(4);
O_sat = par(5);
% The oxygen transfer coefficient is modeled as an input to the block

F=u(1);
S_f=u(2);
temp=u(3);
kla=u(4);

%other constants
V=2;
O_f=0;

mu=(micro_max*x(2)/(K_s+x(2))*(x(3)/(K_o+x(3))));

dxdt(1)=mu*x(1)-(F/V)*x(1);
dxdt(2)=(F/V)*(S_f-x(2))-(1/Y_xs*mu*x(1));
dxdt(3)=(F/V)*(O_f-x(3))-(((1/Y_xs)-1)*mu*x(1))+(kla*(O_sat-x(3)));

sys = [dxdt(1) dxdt(2) dxdt(3)];

function sys=mdlOutputs(t,x,u)
% Calculate the outputs of the model block
sys = [x(1) x(2) x(3)];


