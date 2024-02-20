clear variables
close all


% Define limits for the variables if possible

xMax=[30    25      inf     5       inf         5]; % Upper boundary for P1, P2, x1, x2, x3, x4
xMin=[18    14      0       0       0           0]; % Lower boundary for P1, P2, x1, x2, x3, x4

% Define guess for initial value
xInitial=[28 22 1 4 1 1];  % Initial guess for P1, P2, x1, x2, x3, x4. Always in this order


options=optimset('MaxFunEvals',1e5,'MaxIter ',1e4,'Display','on','TolFun',1e-8,'TolX',1e-8);
[xOpt,fval,exitflag,output,lambda,grad,hessian] = fmincon(@minCostFunction,xInitial,[],[],[],[],xMin,xMax,@nonlinearcon,options); %Optimisation of 
% the objective function (fuel use) in @burners given that the
% variables are linked by the model (@nonlinearcon)

disp('The amount of fuel oil used by generator 1 is : ')
x1=xOpt(3)

disp('The amount of fuel oil used by generator 2 is : ')
x3=xOpt(5)

disp ('The total of fuel oil used by the two generators is: ')
fval


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