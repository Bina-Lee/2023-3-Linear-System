function x = naiv_gauss_modiA(A,b)
n = length(b); x = zeros(n,1);
for k=1:n-1 % forward elimination
    for i=k+1:n
        for j=k+1:n
            A(i,j) = A(i,j)-A(k,j)*A(i,k)/A(k,k);
        end
    b(i) = b(i)-b(k)*A(i,k)/A(k,k);
    end
end %modi (xmult)
% back substitution
x(n) = b(n)/A(n,n);
for i=n-1:-1:1
    sum = b(i);
    for j=i+1:n
        sum = sum-A(i,j)*x(j);
    end
    x(i) = sum/A(i,i);
end
