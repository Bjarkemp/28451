%% this is a simulink implementation of the predator prey model described in Chapter 3 of AM book

% In the model, r represents the growth rate of the hares, Hmax represents the
% maximum population of the hares (in the absence of lynxes), a represents the
% interaction term that describes how the hares are diminished as a function of the
% lynx population and c controls the prey consumption rate for low hare population.
%  b represents the growth coefficient of the lynxes and d
% represents the mortality rate of the lynxes
close all , clear,  clc

%step 1 openloop simulations
%define model parameters
a = 3.2; b = 0.6; c = 50; d = 0.56; Hmax = 125; r = 1.6 ;
par = [a b c d Hmax r];

% time
t0 = 0;  tfin = 100;% yr
time = [t0 tfin]; % yr

% initial conditions
xinit = [15 20]; u0 = r;

%% simulate the system
sim('predprey_nonlin',time)
yo = ynonlin;
to = t;

%% plot the results
figure(1)
plot(to,yo)
ylabel('Population (#)')
xlabel('time (yr)')
legend('Hare','Lynx')
legend('Orientation','horizontal')
legend('boxoff')
title('Step 1 Natural dynamics of Hares and Lynx')

%step 2 find the steady-state for this system using the trim function
[xe ue] = trim('predprey_nonlin'); %input and output ports are defined as C=[0 1]
ue=1.6;  % user defined reference value for the input

%% linearize the system around the steady-sate (or equilibrium or stationary) point
[sizes,xdummy,xstring] = predprey_port ;
[A,B,C,D] = linmod('predprey_port', xe, ue);

%% simulate the linear model around equilibrium /or steadystate point
u=ue;
x0=xe;
lsys = ss(A,B,C,D); dt = 1;
tl = t0:dt:tfin; % time should be equidistant
v = (u-ue) * ones([length(tl),1]) ; % v is the deviation variable: v=u-ue ; v must have the same numbers as time vector
z0 = (x0-xe); % this is the deviation variable
[wl,tl,zl]= lsim(lsys,v,tl,z0) ;
xev = xe * ones([length(tl),1])'; % xe (a scalar) converted to a vector of values
xl = zl + xev' ;
yl = wl + xev';
% plot the results
figure(2)
subplot(211)
plot(tl,yl)
ylabel('Population (#)')
xlabel('time (yr)')
legend('Hare','Lynx')
legend('Orientation','horizontal')
legend('boxoff')
title('Step 2a Prediction of Lynx & Hares with the linear model')
hold on
%% simulate the nonlinear model using steady state as initial values
xinit = xe;
sim('predprey_nonlin')
tnl = t;
ynl =ynonlin;

subplot(212)
plot(tnl,ynl)
ylabel('Population (#)')
xlabel('time (yr)')
legend('Hare','Lynx')
legend('Orientation','horizontal')
legend('boxoff')
title('Step2b Comparison of the models for prediction of Lynx dynamics')
hold off

%% Step 3 Check what happens when the linear model is used beyond the point of linearisation (i.e.beyond steadystate point
u=ue*1.05; % let us perturb the initial conditions at which there is equilibrium.
x0=xe*1.05;
dt = 1;
tl = t0:dt:tfin; % time should be equidistant
v = (u-ue) * ones([length(tl),1]) ; % v is the deviation variable: v=u-ue ; v must have the same numbers as time vector
z0 = (x0-xe); % this is the deviation variable
[wl,tl2,zl]= lsim(lsys,v,tl,z0) ;
xev = xe * ones([length(tl),1])';
xl2 = zl + xev' ;
yl2 = wl + xev';
% one can also use simulink block diagram for linear models as well
%sim('predprey_lin)
xinit=x0;
sim('predprey_nonlin')
tnl2 = t; ynl2 =ynonlin;

figure(3)
subplot(211)
plot(tl2,yl2)
ylabel('Population (#)')
xlabel('time (yr)')
legend('Hare','Lynx')
legend('Orientation','horizontal')
legend('boxoff')
title(['Step3a Linear model description of predator-prey dynamics beyond equilbrium point'])
subplot(212)
plot(tnl2,ynl2)
ylabel('Population (#)')
xlabel('time (yr)')
legend('Hare','Lynx')
legend('Orientation','horizontal')
legend('boxoff')
title(['Step3b Nonlinear model description of predator-prey dynamics beyond equilbrium point (correct)'])

for i=1:gcf
    saveas(i,num2str(i),'tif')
end
