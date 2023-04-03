function x = naiv_gauss_modiD(A,b)
n = length(b); x = zeros(n,1);
for i=1:n-1 % forward elimination
    for j=i+1:n
        xmult = A(j,i)/A(i,i);
        A(j,:) = A(j,:)-xmult*A(i,:);
            %delete 3rd for loop
            %and use row vector (i,:)
        b(j) = b(j)-xmult*b(i);
    end
end
% back substitution
x(n) = b(n)/A(n,n);
for i=n-1:-1:1
    sum = b(i);
    for j=i+1:n
        sum = sum-A(i,j)*x(j);
    end
    x(i) = sum/A(i,i);
end
end