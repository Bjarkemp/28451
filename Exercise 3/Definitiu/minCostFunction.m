function costFunction=minCostFunction(x);
% Variable identification
F=x(1);
T=x(2);
kla=x(3);
X=x(4);
S=x(5);
DO=x(6);
% Biomass price and electricity price
Val=12000;
C=86.7;
%Cost function
costFunction=-((Val*F*X)-(C*kla));