clear variables
close all
clc

% Define limits for the variables if possible

xMin=[0     288.5   0       0.1     0   0]; % Lower boundary for F, T, kla, X, S, DO
xMax=[1     318.5   1000    10      10  0.009502693527]; % Upper boundary for F, T, kla, X, S, DO

% Define guess for initial value
xInitial=[0.5 298 250 4 0.01 0.0024];  % Initial guess for F, T, kla, X, S, DO. 


options=optimset('MaxFunEvals',1e5,'MaxIter ',1e4,'Display','on','TolFun',1e-8,'TolX',1e-8);
[xOpt,fval,exitflag,output,lambda,grad,hessian] = fmincon(@minCostFunction,xInitial,[],[],[],[],xMin,xMax,@nonlinearcon,options); %Optimisation of 
% the objective function (fuel use) in @burners given that the
% variables are linked by the model (@nonlinearcon)

disp('The Flow is : ')
Opt_flow=xOpt(1)

disp('The temperature is : ')
Opt_temp=xOpt(2)

disp('The kLa is: ')
Opt_kla=xOpt(3)
OptPar=[Opt_flow Opt_temp Opt_kla];

%Simulink inputs 
F = Opt_flow; %L/h
S_f = 10; %g/L
temp = Opt_temp; %h^-1 
kla = Opt_kla; %K

%Defining the parameters for Arrhenius parameters 
A=1e10;
B=3e90;
Eg=58;
Gd=550;
R=8.314e-3;

%parameters
V=2;  %L 
K_s=0.1; % g/L
K_o=0.0002; % g/L
Y_xs=0.4; %g/g 

O_sat=0.21*(0.027*exp(1142/temp))*32e-3; %g/L; mmol/L--> g/L
micro_max=A*exp(-(Eg/(R*temp)))/(1+(B*exp(-(Gd/(R*temp)))));

par = [Y_xs,micro_max,K_s,K_o,O_sat];

%initial conditions
x_init = xInitial(4); 
s_init = xInitial(5); 
o_init = xInitial(6); 

xinit = [x_init s_init o_init]; 

%Defining time simulation 
t0 = 0; 
t_interval = 1; 
t_final = 168; 

%Definesimulation options
%Simulation options wereset in our_simulinkmSfunc.mdl;
Exercise3_simulink;
%Solve the model
sim('Exercise3_simulink')

t = get(ans,"tout");
y = get(ans,"y");

O_conc=y(:,3)./O_sat.*100; % g/L/g/L-->%
t_days = t./24;

O_conc=y(:,3)./O_sat.*100; % g/L/g/L-->%

fs=12;
figure(1)

subplot(3,1,1)
plot(t,y(:,1),'b','LineWidth',1.5)
xlabel('Time (h)','FontSize',fs,'FontWeight','bold') 
ylabel('Biomass (C-mmol.L^-^1)','FontSize',fs,'FontWeight','bold')
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold')
ylim([3 5])
subplot(3,1,2)
plot(t,y(:,2),'b','LineWidth',1.5)
xlabel('Time (h)','FontSize',fs,'FontWeight','bold') 
ylabel('Substrate (O-mmol.L^-^1)','FontSize',fs,'FontWeight','bold')
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold') 
subplot(3,1,3)
plot(t,O_conc,'b','LineWidth',1.5)
xlabel('Time (h)','FontSize',fs,'FontWeight','bold') 
ylabel('Oxygen (C-mmol.L^-^1)','FontSize',fs,'FontWeight','bold')
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold')


Val=12000; %dkk
C=86.7; %dkk

operating_profit=(Val*Opt_flow*y(:,1))-(C*Opt_kla);
over_time=operating_profit.*t;
average_profit=mean(operating_profit);

figure(2)
plot(t,over_time);

figure(3);
plot(t,operating_profit)

