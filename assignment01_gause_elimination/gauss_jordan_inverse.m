function B=gauss_jordan_inverse(A)
n = length(A);
B=eye(n);
for i=1:n
    B(i,:)=B(i,:)/A(i,i);
    A(i,:)=A(i,:)/A(i,i);
    for j=1:n
        if(i==j)
            continue;
        end
        B(j,:)=B(j,:)-B(i,:)*A(j,i);
        A(j,:)=A(j,:)-A(i,:)*A(j,i);
    end
end
end
