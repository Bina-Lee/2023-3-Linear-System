function b = naiv_gauss_modiADE(A,b)
n = length(b);
for i=1:n-1 % forward elimination
    for j=i+1:n
        b(j) = b(j)-b(i)*A(j,i)/A(i,i);
        A(j,:)=A(j,:)-A(i,:)*A(j,i)/A(i,i);
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