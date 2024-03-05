close all
clear all
clc

syms x1 x2 u
f1=x1^2+sin(x2)-1;
f2=-x2^3+u;
g1=2*x1+x2;



% a11=diff(f1,x1);
% a12=diff(f1,x2);
% a21=diff(f2,x1);
% a22=diff(f2,x2);
%A=[a11,a12;a21,a22];

A=jacobian([f1;f2],[x1;x2]);
B=jacobian([f1;f2],[u]);
C=jacobian([g1],[x1;x2]);
D=jacobian([g1],[u]);

figure(1)
subplot(211)
ezplot(f1)
subplot(212)
ezplot(f2)

save lin A B C D
