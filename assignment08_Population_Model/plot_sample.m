clear;clc;

L=[0 2.3 0.4;
   0.6 0 0;
   0 0.3 0];
x=[739 369 92]';
t=0:3;
y1=L*x;
y2=L*y1;
y3=L*y2;
figure(2);clf;
plot(t,[x(1) y1(1) y2(1) y3(1)]);
hold on;
plot(t,[x(2) y1(2) y2(2) y3(2)],'r');
plot(t,[x(3) y1(3) y2(3) y3(3)],'k');
xlabel('Year');
ylabel('Numbers of Female Animal');

