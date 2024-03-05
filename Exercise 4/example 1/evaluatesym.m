close all
clear all
clc

load linmodval.mat
% initial conditions
x1=1;
x2=0
u=0;

A1=eval(A);
B1=eval(B);
C1=eval(C);
D1=eval(D);

save linmodval A1 B1 C1 D1 A B C D