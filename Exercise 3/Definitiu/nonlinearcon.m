function [c,ceq]=nonlinearcon(x)
Y_xs=0.4; %g/g;
K_s=0.1; %g/L
K_o =0.2e-3; %g/L
S_f=10; 
O_f=0;
A=1e10;
B=3e90;
Eg=58;
Gd=550;
R=8.314e-3;
V=2;

%Variable identification
F=x(1);
T=x(2);
kla=x(3);
X=x(4);
S=x(5);
DO=x(6);
%equations 
O2_T_dep = 1*0.21*(0.027*exp(1142/T))*32e-3;
mu_max_T_Dep = A*exp(-Eg/(R*T))/(1+(B*exp(-Gd/(R*T))));
mu=(mu_max_T_Dep*(S/(K_s+S))*(DO/(K_o+DO)));

% Inequality constraints for O2sat upper boundary
c=DO-O2_T_dep;


%Equality constraints. Given by the model
ceq(1)=mu*X-(F/V)*X;
ceq(2)=(F/V)*(S_f-S)-((1/Y_xs)*mu*X);
ceq(3)=(F/V)*(O_f-DO)-(((1/Y_xs)-1)*mu*X)+(kla*(O2_T_dep-DO));