function x = naiv_gauss_modiABD(A,b)
n = length(b); x = zeros(n,1);
for i=1:n-1 % forward elimination
    for j=i+1:n
        b(j) = b(j)-b(i)*A(j,i)/A(i,i);
        A(j,:)=A(j,:)-A(i,:)*A(j,i)/A(i,i);
    end
end %modi (xmult)
% back substitution
x(n) = b(n)/A(n,n);
for i=n-1:-1:1
    x(i) = b(i);
    for j=i+1:n
        x(i) = x(i)-A(i,j)*x(j);
    end
    x(i) = x(i)/A(i,i);
end %modi (sum) to (x(i))
end