function costFunction=minCostFunction(x,par)

% Variable identification
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

%Cost function: 
costFunction=VC*F*X-C*kLa;