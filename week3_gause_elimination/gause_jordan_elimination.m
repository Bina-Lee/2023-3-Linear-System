function b=gause_jordan_elimination(A,b)
n = length(b);
for i=1:n
    b(i)=b(i)/A(i,i);
    A(i,:)=A(i,:)/A(i,i);
    for j=1:n
        if(i==j)
            continue;
        end
        b(j)=b(j)-b(i)*A(j,i);
        A(j,:)=A(j,:)-A(i,:)*A(j,i);
    end
end
end
