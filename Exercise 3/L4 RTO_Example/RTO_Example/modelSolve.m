function j =modelSolve(x,par)

%Variable identification
P1=par(1);
x1=par(2);
P2=x(1);
x2=x(2);
x3=x(3);
x4=x(4);


%Equality constraints. Given by the model
ceq(1)=4.5*x1+0.1*x1^2+4.0*x2+0.06*x2^2-P1;
ceq(2)=4.0*x3+0.05*x3^2+3.5*x4+0.02*x4^2-P2;
ceq(3)=P1+P2-50;
ceq(4)=x2+x4-5;
j=ceq*ceq'; % fminsearch requires a scalar value
