clear variables
close all



%Parameters

%  saturation concentration of oxygen
P_O2 = 0.21; % atm
k_H = 0.9740 %0.027*exp(1142/318.5); %mmol O2 / L * atm (calculated at max temp
% percent saturation of oxygen

osat = ((P_O2 * k_H)/36); % (mmol O2 / L) / (mg/mmol) 
% 0.462 = oxygen saturation concentration at 25°C (*2 hence O2)

%temperature dependency
A = 1E10; %(h-1) 
B = 3E90; %(h-1)
Eg = 58; %(kJ/mol) 
Gd = 550; %(kJ/mol)
R = 8.314E-3; %kJ/(mol*K)
mumax = A * exp(-Eg/(R*318.5))/(1+B*exp(-Gd/(R*318.5)));

Ks = 0.1; % g/L
Ko = 0.2E-3; % g/L
Yxs = 0.4; %g/g
kla = 0 %h^-1
sf = 10; %g/L 
of = 0; %g/L

%cost function
VC = 12000 %dkk
C = 86.7 % Dkk


par = [Ks,Ko,Yxs,kla,sf,of,mumax,osat,VC,C];

% Define limits for the variables if possible

xMax=[1    318.5      1000      10       10         osat]; % Upper boundary for F, T, kLa, X, S, DO
xMin=[0    288.5      0      0.1       0           0]; % Lower boundary for F, T, kLa, X, S, DO

% Define guess for initial value
xInitial=[0.5 298 250 4 0.01 0.0024];  % Initial guess for F, T, kLa, X, S, DO Always in this order


options=optimset('MaxFunEvals',1e5,'MaxIter ',1e4,'Display','on','TolFun',1e-8,'TolX',1e-8);
[xOpt,fval,exitflag,output,lambda,grad,hessian] = fmincon(@minCostFunction,xInitial,[],[],[],[],xMin,xMax,@nonlinearcon,options); %Optimisation of 
% the objective function (fuel use) in @burners given that the
% variables are linked by the model (@nonlinearcon)

disp('The Flow is : ')
x1=xOpt(1)

disp('The temperature is : ')
x2=xOpt(2)

disp('The kLa is: ')
x3=xOpt(3)




%% Contour plot
vP1=linspace(xMin(1),xMax(1),10);     % Vector values P1
vX1=linspace(xMin(3),7,10);   % Vector values x1
x0=[22 4 1 1];
for i=1:length(vP1)
    P1=vP1(i);       
    for j=1:length(vX1)
        x1=vX1(j);
        par=[P1 x1];   
        [xSolution,fval]=fminsearch(@modelSolve,x0,[],par); % this one uses simplex algorithm.
        %[xSolution,fval]=fsolve(@modelSolve1,x0,[],par); % this one uses
        %fsolve algoritm
        x3=xSolution(3);
        cost(j,i)=x1+x3;   %Cost for the corresponding value of P1 and P3
    end        
end
 [xP1,yX1]=meshgrid(vP1,vX1);                % Grid for plotting
contour(xP1,yX1,cost,30) 
set(gca,'LineWidth',2,'FontSize',14)
 title('Contour plot of cost as function of P1 and x1')
xlabel('Power to first generator P1')
ylabel('Fuel to first generator x_1')
colorbar

saveas(1,'contourplot','tiff')