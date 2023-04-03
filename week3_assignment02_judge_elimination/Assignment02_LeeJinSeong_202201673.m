function x=Assignment02_LeeJinSeong_202201673(A,b)

n=size(A,1); x = zeros(n,1);
stts="C";   %status : Can't know
for i=1:n-1
    while A(i,i) == 0   %연산하려는 pivot계수가 0인 경우 연산이 불가하므로
        A(i:n,:)=circshift(A(i:n,:),-1,1);  %순환시켜 연산이 가능하도록
        b(i:n)=circshift(b(i:n),-1);        %처리함
    end
    j=i+1;  %for loop을 사용하려고 했지만
            %for loop index issue로 인하여 while loop을 사용함
            %원래는 for j=i+1:n이었음

            %for loop index를 loop안에서 값을 바꾸더라도
            %그다음 loop에서 변경사항이 적용되지 않아
            %for loop에서는 제대로 작동하지 않음

            %c에서 for(int i=0;i<10;i++)이라고 할때
            %i=5인 상태에서 i--;를 하고 다음 loop으로 가면
            %i=5로 한바퀴 더 돌 수 있지만
            %MATLAB의 for loop은
            %i=i-1을 한 것과 관계없이
            %다음 loop의 i값은 6이다...
    while j<n+1
        b(j)=b(j)-A(j,i)*b(i)/A(i,i);   %pivot계수의 값에 따라 b의 값을 수정
        A(j,:)=A(j,:)-A(j,i)*A(i,:)/A(i,i); %pivot계수의 값에 따라
                                            %A의 row vector를 하나씩 수정
                                            %pivot계수 아래의 값들을 소거함
        if [A(j,:) b(j)]==zeros(1, size(A,2)+1) %소거한 row vector가
                                                %0이라면(종속이라면)
            A(j:n,:)=circshift(A(j:n,:),-1,1);  %순환함수로 제일 아래로 내림
            b(j:n)=circshift(b(j:n),-1);        %b도 마찬가지로 아래로 내림
            j=j-1;  %원래 있던 값이 아래로 내려갔기 떄문에 기존 j+1인덱스에 있던 값은
                    %j로 왔기 때문에 1씩 증가되는 상황에서 다시 1을 빼서
                    %순환으로 위로 올라온 값에 대한 소거를 다시 해줘야함
            n=n-1;  %종속인 제일 아랫줄에 있는 zeros(size(A),1)은 의미가 없기 때문에
                    %column size가 1만큼 작아짐
        end
        if n>size(A,2)  %rank>p(행의 개수)
            stts="N";
            x="No Result";
            break;
        end
        j=j+1;  %j증감, 원래는 for loop이어서 필요없었음
    end
end
if strcmp(stts,"C") %No Result상태가 아니라면
    if n<size(A,2)  %rank<p (행의 개수) : 1차 종속
        x="too many Result";
    else
        x(n) = b(n)/A(n,n); %xn의 값을 구함
        for i=n-1:-1:1
            sum = b(i);
            for j=i+1:n
                sum = sum-A(i,j)*x(j);  %값을 이항해 xi를 구할 준비
            end
            x(i) = sum/A(i,i);  %A(i,i)값까지ㅏ 활용해 xi를 구함
        end 
        x=x(1:n);   %종속이 발견되어 n의 값이 감소한 경우
                    %n보다 큰 x값은 0으로 채워져 있음(최초 x=zeros)
                    %따라서 사이즈를 종속인 열들의 갯수를 제외한 새로운 n으로 맞춰줘야함
    end
end

end