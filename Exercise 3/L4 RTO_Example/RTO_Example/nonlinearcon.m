function [c,ceq]=nonlinearcon(x,par)

%Variable identification
F=x(1);
T=x(2);
kLa=x(3);
X=x(4);
S=x(5);
DO=x(6);

Ks = par(1);
Ko = par(2);
Yxs = par(3);
V = par(4);
sf = par(5); 
of = par(6);
mumax = par(7);
osat = par(8);
VC = par(9);
C = par(10);

% Inequality constraints (none)
c=[];

% Calculate mu based on Monod kinetics
mu=mumax*(S/(Ks+S)) * (DO/(Ko+DO));

%Equality constraints. Given by the model
ceq(1)=mu * X - (F/V) * X; % biomass
ceq(2)=(F/V) * (sf-S) - (1/Yxs) * mu * X; % substrate
ceq(3)=(F/V) * (of-DO) - ((1/Yxs) - 1) * mu * X + kLa * (osat - DO); % oxygen


