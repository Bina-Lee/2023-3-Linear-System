x=[1;2;1;3]

W1=[0.1 0.2 0.1 0.2;
    0.3 0.4 0.3 0.4;
    0.5 0.6 0.5 0.6];
W2=[0.1 0.3 0.7;
    0.2 0.4 0.2;
    0.5 0.5 0.3;
    0.7 0.6 0.1];
W3=[0.7 0.5 0.1 0.3;
    0.8 0.6 0.2 0.4];

z1=W1*x;
y1=sigmoid(z1);
z2=W2*y1;
y2=sigmoid(z2);
z3=W3*y2;
y =sigmoid(z3)

function y_=sigmoid(x_)
    y_ = (1./(1+exp(-x_)));
end