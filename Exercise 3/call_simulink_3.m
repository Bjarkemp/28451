%Script for simulation of our model implemented in simulink
clear, clc, close all
%% parameters
V = 2; % L 
F = 0.5; % L/h
Ks = 0.1; % g/L
Ko = 0.2E-3; % g/L
Yxs = 0.4; %g/g
kla = 250; %h-1
sf = 10; %g/L 
of = 0; %g/Ll

% Temperature dependency
T = 298; % K
A = 1E10; %(h-1) 
B = 3E90; %(h-1)
Eg = 58; %(kJ/mol) 
Gd = 550; %(kJ/mol)
R = 8.314E-3; %kJ/(mol*K)
mumax = A * exp(-Eg/(R*T))/(1+B*exp(-Gd/(R*T)));

%  saturation concentration of oxygen
P_O2 = 0.21; % atm
k_H = 0.027*exp(1142/T); %mmol O2 / L * atm
% percent saturation of oxygen



osat = ((P_O2 * k_H)/36); % (mmol O2 / L) / (mg/mmol) 
% 0.462 = oxygen saturation concentration at 25°C (*2 hence O2)

par = [V,F,Ks,Ko,Yxs,kla,sf,of,mumax,osat];

%Define initial conditions
x = 3 ; % g/l biomass
s = 0; % g/l substrate
o = 0; % g/l oxygen
xinit = [x, s, o];

%Define simulation start/end time
t0=0;
tint=0.005;
tfin=20.0;

%Define simulation options
%%%Simulation options were set in our_simulinkmSfunc.mdl;
simulink_1%_mSfunc
%Solve the model
sim('simulink_1.mdl')

fs=12;
figure
subplot(3,1,1)
plot(t,y(:,1),'b','LineWidth',1.5)
xlabel('Time (h)','FontSize',fs,'FontWeight','bold') 
ylabel('Biomass conc (g.L^-^1)','FontSize',fs,'FontWeight','bold') 
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold') 
subplot(3,1,2)
plot(t,y(:,2),'b','LineWidth',1.5)
xlabel('Time (h)','FontSize',fs,'FontWeight','bold') 
ylabel('Substrate conc (g.L^-^1)','FontSize',fs,'FontWeight','bold') 
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold')
subplot(3,1,3)
plot(t,y(:,3)/osat*100,'b','LineWidth',1.5)
xlabel('Time (h)','FontSize',fs,'FontWeight','bold') 
ylabel('Oxygen conc (%sat)','FontSize',fs,'FontWeight','bold') 
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold')
ylim([0 100]); % Set the y-axis limits
%% save figure
saveas(gcf,'GrowthPlot_Simulinkm','tiff')