function b = naiv_gauss_modiE(A,b)
n = length(b);
for k=1:n-1 % forward elimination
    for i=k+1:n
        xmult = A(i,k)/A(k,k);
        for j=k+1:n
            A(i,j) = A(i,j)-xmult*A(k,j);
        end
    b(i) = b(i)-xmult*b(k);
    end
end
% back substitution
b(n) = b(n)/A(n,n);
for i=n-1:-1:1
    for j=i+1:n
        b(i) = b(i)-A(i,j)*b(j);
    end
    b(i) = b(i)/A(i,i);
end%remove x and return b
end