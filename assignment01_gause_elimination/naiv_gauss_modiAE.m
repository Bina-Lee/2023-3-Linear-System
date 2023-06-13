function b = naiv_gauss_modiAE(A,b)
n = length(b);
for k=1:n-1 % forward elimination
    for i=k+1:n
        for j=k+1:n
            A(i,j) = A(i,j)-A(k,j)*A(i,k)/A(k,k);
        end
    b(i) = b(i)-b(k)*A(i,k)/A(k,k);
    end
end %modi (xmult)
% back substitution
b(n) = b(n)/A(n,n);
for i=n-1:-1:1
    for j=i+1:n
        b(i) = b(i)-A(i,j)*b(j);
    end
    b(i) = b(i)/A(i,i);
end%remove x and return b
end