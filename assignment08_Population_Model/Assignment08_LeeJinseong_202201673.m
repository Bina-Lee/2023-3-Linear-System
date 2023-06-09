clear;clc;
L=[0 2.3 0.4;
   0.6 0 0;
   0 0.3 0];
syms x_s [3 1];             %x(sym)라는 뜻...
syms lambda;
lambda_I=eye(3)*lambda;
L_lI=L-lambda_I;            %L-lambda
lambda=solve(det(L_lI)==0); %lambda값이 될수 있는 케이스 추출
lambda=lambda(lambda>1);    %추출된 lambda값 중 유효한(1보다 큰)값만 추출
                            %한개라는 가정하에 아래 코드를 진행함
lambda_I=eye(3)*lambda;     %유효한 lambda값으로 한번 더 진행
L_lI=L-lambda_I;
x_s(1)=1;                   %x들의 비를 구하기 떄문에 x1을 1이라 가정하고
                            %x2,x3를 구할 예정
x=[x_s(1);NaN;NaN];         %진짜 답이 될 x vector
                            %답이 나오지 않은 x는 NaN으로 표기
L_lI_x=L_lI*x_s;            %L-lambda * x

for j=2:3                   %해당 모델은 x2, x3순으로 답이 나오기 때문에 사실 상관없음
                            %순차적으로 답이 나오지 않는 모델에서 앞의 값을
                            %다시 구하기 위해 for문을 사용함
    for i=2:3               %행별로 해를 추출하기 위한 for문
                            %x1의 경우 x1=1이라고 가정하고 시작했기 때문에
                            %오류 유발할 수 있음
        if sum(isnan(x)) > 0
                            %해가 다 구해졌다면 연산을 할 필요 없음
                            %오히려 형식이 sym이라 해당 구문이 없으면
                            %값이 제대로 나오지 않음
            solve_x=solve(L_lI_x(i,:)==zeros(1,3));
                            %x까지 곱한 결과에서 근 추출
            if length(solve_x)==1
                            %근을 1개만 반환했다면
                            %x1값을 임의로 지정하고 여러개의 근이 나오면
                            %처리가 불가능하기 때문에
                            %근이 하나만 나온 경우 근이라고 판별하고 아래 코드 실행함
                for k=2:3   %나온 근이 x2의 근인지 x3의 근인지 판별하는 for문
                    if L_lI(i,k) ~= 0 && isnan(x(k))
                            %해당 근이 나온 자리의 계수가 0이 아니고
                            %근이 아직 정해지지 않은 상태라면
                            %뒤의 조건이 없으면 덮어쓰기 되어서 오류가 날 수 있음
                        x_s(k)=solve_x;
                            %syms vector에 해당 근 대입
                        x(k)=solve_x;
                            %실제 답 vector에 해당 근 대입
                        L_lI_x=L_lI*x_s;
                            %적용된 값으로 업데이트
                        break;
                            %둘중에 어느 근인지 판별되었으면
                            %굳이 다음 근을 계산할 필요가 없어서 작성한 break
                            %없어도 연산을 하는데 문제가 되지는 않음
                    end
                end
            end
        end
    end
end
x=round((x/sum(x))*1200)    %강의자료에서 전체 개체수를 1200이라고 가정하였기 때문에
                            %전체 개체수를 1200으로 맞출 수 있도록 하고
                            %비율을 맞춤
%답은 [738;369;92]가 나옴
%강의자료에는 738이 아닌 739로 나오는데
%실제 비율 적용시 738.5가 나오며
%강의자료에서 근사치로 739를 나타냄
%매트랩에서 반올림 결과로 738을 반환했기 때문에
%문제가 될 것은 없어 보임