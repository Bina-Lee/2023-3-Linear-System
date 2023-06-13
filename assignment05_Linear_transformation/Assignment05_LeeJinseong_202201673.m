clear;clc;

x=[0 1 1 4 7 7 8 8 7 4 1 0 0;
   0 0 6 0 6 0 0 8 8 2 8 8 0;
   1 1 1 1 1 1 1 1 1 1 1 1 1];
x(1:2,:)=x(1:2,:)-4;
    %중심으로 이동,
    %사이즈를 조절 한 후에 이동시킬 예정

for s=0:10:1080 %360도 * 3바퀴
    th=s*pi/180;
    rotSelf=2*th;   %본인 스스로 회전하도록 하는 회전값
    rotSelfArray=[cos(rotSelf) -sin(rotSelf) 0;
              sin(rotSelf) cos(rotSelf) 0;
              0 0 1];   %본인 스스로는 반시계 방향으로 회전함
    size=s/50;  %회전값을 사용하여 사이즈 증가도 바로 할 수 있게끔 함
    sizeArray=[size 0 0;0 size 0;0 0 1];
        %다음 행렬로 사이즈를 조절함
    loc=[1 0 size*10;0 1 size*10;0 0 1];
        %사이즈와 비례하게 위치도 이동함
        %최초 M의 위치를 중앙으로 옮겼기 떄문에
        %단순 이동뿐만이 아니더라도
        %해당 코드가 없으면 제자리에서 회전함
    rotArray=[cos(th) sin(th) 0;
              -sin(th) cos(th) 0;
              0 0 1];
        %중심을 기준으로 회전하는 코드
    r=rotArray*loc*sizeArray*rotSelfArray*x;
        %순서대로 
            %스스로 돌고
            %크기가 증가하고
            %중앙에서 바깥쪽으로 이동하고
            %중앙을 기준으로 회전함
    clf;
    axis equal; %가로 세로 비율을 동일하게 함
    axis([-500 500 -500 500]);
        %이미지가 보이는 영역을 [-500 500 -500 500]으로 제한함
    line(r(1,:),r(2,:));    %최종적으로 만들어진 시간별 M을 출력
    annotation('textbox',[.3 .5 .3 .3],'String','과제05_ 이진성_ 202201673','FitBoxToText','on');
        %이름 띄우는 코드
    pause(0.00001);
end