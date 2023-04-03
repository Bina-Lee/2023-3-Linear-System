%p90
format long

B=[-5 3;4 -3]
condB=cond(B)
invB=inv(B)

C=[-5 3;4.999999 -3]
cond(C)
inv(C)

D=[-4.99999 3;4.999999 -2.99999]
condD=cond(D)
invD=inv(D)

%p91
A=[1 -2 3 0;0 1 1 -2;2 2 4 1;0 0 1 7]
condA=cond(A)
invA=inv(A)

%p92
B=magic(4)
condB=cond(B)
rcondB=rcond(B)
invB=inv(B)

%p93
beta=0.001
B2=B+(beta*eye(length(B)))
condB2=cond(B2)
invB2=inv(B2)

%p94
beta=0.01
B3=B+(beta*eye(length(B)))
condB3=cond(B3)
invB3=inv(B3)

%p95
beta=0.1
B4=B+(beta*eye(length(B)))
condB4=cond(B4)
invB4=inv(B4)

%p96
C=[7 1 1 -1;-1 0 2 -1;0 3 2 0;-2 0 4 -2]
condition_number_C=cond(C)
invC=inv(C)