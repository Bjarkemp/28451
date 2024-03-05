function costFunction=minCostFunction(x);
% Variable identification
X2=x(1);
F200=x(2);
P2=x(3);
P100=x(4);
F3=x(5);
F2=x(6);
L2=x(2);

%Cost function
costFunction=(F200+P100)-F2;