close all
clear all
clc
syms s
% describe state-space model
A=[0 1;
-2 -3];
B=[0;
4];
C=[1 0];

H=C*(s*eye(2)-A)^-1*B;

pretty(H)