%function main

clear;clc;

video_file=VideoWriter('tree.mp4','MPEG-4');
video_file.FrameRate=15;
open(video_file);

az=30;                              %view point 시작 경도 30도

az=main(1, -pi/3,az,video_file);    %x축방향에서 -pi/3방향으로 speed 1만큼의 부는 바람
az=main(4,  pi/4,az,video_file);    %x축방향에서  pi/4방향으로 speed 4만큼의 부는 바람
   main(2,pi*5/4,az,video_file);    %x축방향에서 5pi/3방향으로 speed 2만큼의 부는 바람
                                        %전부 함수로 호출함

close(video_file);                  %세번의 바람이 지나가면 녹화종료

function az=main(speed,wind_loc,az,video_file)
                                    %가운데 기둥을 만들고 흔들림을 구현하는 함수
                                    %az를 반환하여 다음 함수를 호출할 때
                                    %마지막으로 위치했던 경도에서 시작할 수 있게끔 함
    unit_length=3;                  %나무기둥 한 층의 길이
    unit=30;                        %나무기둥 층 수

    circle_unit=16;                 %기둥 원 구성요소 개수
    radius=5;                       %기둥 원 반지름

    move_z=[1 0 0 0;
            0 1 0 0;
            0 0 1 unit_length;
            0 0 0 1];               %나무기둥의 중심축을 만드는데 필요한 이동 행렬
                                    %아래 첫 for문에서 사용함
    wind_rot=[cos(wind_loc) -sin(wind_loc) 0 0;
              sin(wind_loc)  cos(wind_loc) 0 0;
              0 0 1 0;
              0 0 0 1];             %바람이 부는 정도에 따라 나무를 기울이는 행렬

    angle_array=[zeros(1,50) sin(5.*[0:0.05:5]).*0.0125.*speed.*exp(-[0:0.05:5])];
                                    %바람의 위치에 따라 기울어지는 정도를 결정하는 벡터
                                    %처음 50만큼은 바람이 나무에 닿기 전이라 기울어지는 정도가 0이며
                                    %이후에 바람이 나무에 부딪히는 시점부터 사인파에 지수함수를 곱해서
                                    %크게 흔들리다가 다시 0에 수렴하도록 만듦
                                    %바람의 speed에 따라 시작 진폭이 커짐

    for time=1:150%0:0.05:5         %angle_array vector에 관여함
                                    %한 프레임씩 한번 흔들리는데 총 150프레임
    
        %speed
    
        %angle=sin(5*time)*0.025*exp(-time);
        angle=angle_array(time);    %얼마나 기울어질지를 angle_array vector와 time으로 결정함
    
        angle_product=[ cos(angle) 0 sin(angle) 0;
                       0 1 0 0;
                       -sin(angle) 0 cos(angle) 0;
                       0 0 0 1];    %angle로 결정된만큼 y축기준으로 회전시키는 회전 행렬(pitch)
    
        main_stem_origin=[zeros(2,unit+1);
                          ones(1,unit+1)*unit_length;
                          ones(1,unit+1)];
                                    %나무의 기준축이 되는 좌표로 현재는 전부 z=unit_length에 위치함
                                    %기둥 최상단은 이후 기울기를 사용하는 부분에서 최상층을 사용하기 위해
                                    %한칸을 더 만듦(제일 위층은 원기둥이 아닌 점이 될 예정
        for i=1:unit+1              %나무 층수에서 위에 한칸이 더 있기 때문에 unit+1만큼 for문을 돌림 좌표로 가져옴
            main_stem_origin(:,1:i)=angle_product*main_stem_origin(:,1:i);
                                    %올린만큼의 중심축을 기울일 만큼 y축기준으로 회전시킴(pitch)
                                    %범위가 for문을 도는 변수인 이유는 한층씩 위로 올리기 때문
            if i==unit+1
                break;              %마지막의 z값은 기본값으로 해당 unit_length이므로 별도의 z축 이동이 필요없음
            end
            main_stem_origin(:,1:i)=move_z*main_stem_origin(:,1:i);
                                    %회전한 좌표를 unit_length만큼 z축방향으로 이동함
            main_stem_origin=circshift(main_stem_origin,1,2);
                                    %순환시켜 가장 우측에 있는 아직 이동하지 않은 좌표를
                                    %최하단 좌표로 가져옴
        end

        main_stem_origin=[[0;0;0;1] main_stem_origin];
                                    %모든 층이 만들어졌기 때문에 기존 좌표에 최하단 좌표를 추가 해 줌
    
        %plot3(main_stem_origin(1:3,:)',main_stem_origin(2,:)',main_stem_origin(3,:)');
        %hold on;
    
        main_stem_origin=wind_rot*main_stem_origin;
                                    %바람 정도에 따라 기울어진 중심축을 바람이 부는 방향으로 회전시킴
    
    %     plot3(main_stem_origin(1:3,:)',main_stem_origin(2,:)',main_stem_origin(3,:)');
    %     axis equal;
    %     grid on;
    % 
    %     xlabel('x');
    %     ylabel('y');
    %     zlabel('z');
    
        main_stem_x=[cos(linspace(0,2*pi,circle_unit+1))'*ones(1,unit+1)*radius zeros(circle_unit+1,1)];
                                    %기준축을 중심으로 원을 이룰 좌표 중 x좌표
                                    %정확하게는 circle_unit각형이라고 보는 것이 맞다
                                    %높이를 전부 0으로 만든 후 각도에 따라 회전시킨 후 각 위치로
                                    %이동시킬 예정
        main_stem_y=[sin(linspace(0,2*pi,circle_unit+1))'*ones(1,unit+1)*radius zeros(circle_unit+1,1)];
                                    %기준축을 중심으로 원을 이룰 좌표 중 y좌표
        main_stem_z=zeros(circle_unit+1,unit+2);
                                    %기준축을 중심으로 원을 이룰 좌표 중 z좌표
                                    %전부 높이가 0이기 때문에 zeros로 만듦
    
        for i=2:unit+1              %최하단층은 회전 및 이동이 필요없기 때문에 2부터 회전 및 이동을 하며
                                    %기준축이 총 unit+2개로 이루어져 있고 그중
                                    %제일 위층을 제외하기 때문에 unit+2 - 1까지 반복함
            delta_x=main_stem_origin(1,i+1)-main_stem_origin(1,i-1);
                                    %각 위치별 기울기를 구하기 위한 delta값들을 구하는 식
                                    %각 위치의 위아래 좌표의 차로 delta값을 사용함
                                    %해당 delta값으로 기준축의 해당 위치에서의
                                    %원의 기울기 정도와 방향을 결정함
                                    %해당코드와 아래 두줄 각 delta x,y,z값
            delta_y=main_stem_origin(2,i+1)-main_stem_origin(2,i-1);
            delta_z=main_stem_origin(3,i+1)-main_stem_origin(3,i-1);
                                    %원 자체를 기준축을 회전시키듯이 회전시키게 되면
                                    %원의 방향이 틀어져버리기 때문에
                                    %바람이 부는 위치에 따라서 가지의 축이 회전하게될 수도 있음
    
            cos1=sqrt(delta_y.^2+delta_z.^2)/sqrt(delta_x.^2+delta_y.^2+delta_z.^2);
            sin1=                    delta_x/sqrt(delta_x.^2+delta_y.^2+delta_z.^2);
                                    %delta x,y,z값을 사용해서 기준축을 기준으로 하는 원이
                                    %어느방향으로 얼마나 기울어져야하는지 계산하기 위한 각도에 대한
                                    %삼각함수 값 중 첫번째
            rot1=[ cos1 0 sin1 0;
                  0 1 0 0;
                  -sin1 0 cos1 0;
                  0 0 0 1];
                                    %해당 삼각함수 값들을 활용한 회전행렬로 y축을 기준으로
                                    %x축 방향으로 기울어짐(pitch)
            cos2=delta_z/sqrt(delta_y.^2+delta_z.^2);
            sin2=delta_y/sqrt(delta_y.^2+delta_z.^2);
                                    %두번째 회전행렬을 위한 삼각함수 값
            rot2=[1 0 0 0;
                  0  cos2 sin2 0;
                  0 -sin2 cos2 0;
                  0 0 0 1];         %해당 삼각함수 값을을 이용해 x축을 기준으로 y축 방향으로 기울어짐
                                    %(roll)
            rot=rot2*rot1;          %위 둘의 회전행렬을 곱함으로 인해 기준축이 기울어진 방향으로
                                    %해당 원을 기울이는 회전행렬이 만들어짐

                                    %다만 해당 방식이 정확하게 기울고자 하는 방향으로 원이 정확하게
                                    %기우는 것은 아니다
                                    %방향은 맞지만 x축이나 y축 방향이 아니라면 약간 축 기준으로
                                    %회전하게 된다
            move=[[1 0 0;0 1 0;0 0 1;0 0 0] main_stem_origin(:,i)];
                                    %원이 기준축의 해당위치에 갈 수 있게끔 기준축의
                                    %해당 위치로 이동하게끔 하는 이동행렬
    
            temp=[main_stem_x(:,i)';
                  main_stem_y(:,i)';
                  main_stem_z(:,i)';
                  ones(1,circle_unit+1)];
                                    %원들의 집합을 이루는 좌표들이 matrix 3개(x,y,z)로
                                    %이루어져 있기 때문에 원을 하나씩, x,y,z의 좌표를 추출해서
                                    %temp라는 변수에 넣은 상태로 회전 및 이동 진행함
            temp=move*rot*temp;     %원점에 위치하던 원을 해당 기준축의 해당점이 기울어진 정도만큼 회전시키고
                                    %해당점의 위치로 가도록 하는 행렬곱
    
            main_stem_x(:,i)=temp(1,:)';
            main_stem_y(:,i)=temp(2,:)';
            main_stem_z(:,i)=temp(3,:)';
                                    %이동이 끝났으면 원래 x,y,z좌표에 대입해서
                                    %이동한 좌표가 되게끔 해준다
        end
    
        temp=[main_stem_x(:,unit+2)';
              main_stem_y(:,unit+2)';
              main_stem_z(:,unit+2)';
              ones(1,circle_unit+1)];
        move=[[1 0 0;0 1 0;0 0 1;0 0 0] main_stem_origin(:,unit+2)];
        temp=move*temp;
        main_stem_x(:,unit+2)=temp(1,:)';
        main_stem_y(:,unit+2)=temp(2,:)';
        main_stem_z(:,unit+2)=temp(3,:)';
                                    %최상단의 경우 원이 아닌 한 점으로 모이기 때문에
                                    %굳이 회전을 할 필요가 없음
                                    %해당 지점으로 위치만 이동함
        
        clf;
    
        surf(main_stem_x',main_stem_y',main_stem_z',"FaceColor","#D95319");%,"EdgeColor","none");
                                    %나무의 중심을 surf로 표현함
        hold on;
        title("202201673 이진성");
    
        %surf([-radius*20 radius*20;-radius*20 radius*20],[radius*20 radius*20;-radius*20 -radius*20],[0 0;0 0],"FaceColor","#008F00");
        patch([-radius*20;radius*20;radius*20;-radius*20;-radius*20]', ...
              [-radius*20;-radius*20;radius*20;radius*20;-radius*20]', ...
              [0;0;0;0;0],"FaceColor","#008F00");
                                    %바닥색을 기본 green보다 어두은 #008F00으로 patch함
    
        wind_loc_express(speed,time,wind_loc);
                                    %바람의 경로를 바닥에 표시하는 함수로
                                    %속도와 바람 방향을 입력받음
    
        middle_stem(speed,main_stem_origin(:,10-1:10+1),time,pi*1/4,pi/3,wind_loc);
        middle_stem(speed,main_stem_origin(:,10-1:10+1),time,pi*3/4,pi/3,wind_loc);
%         middle_stem(speed,main_stem_origin(:,10-1:10+1),time,pi*5/4,pi/3,wind_loc);
%         middle_stem(speed,main_stem_origin(:,10-1:10+1),time,pi*7/4,pi/3,wind_loc);
%     
%         middle_stem(speed,main_stem_origin(:,15-1:15+1),time,pi*2/4,pi/3,wind_loc);
%         middle_stem(speed,main_stem_origin(:,15-1:15+1),time,pi*4/4,pi/3,wind_loc);
%         middle_stem(speed,main_stem_origin(:,15-1:15+1),time,pi*6/4,pi/3,wind_loc);
%         middle_stem(speed,main_stem_origin(:,15-1:15+1),time,pi*8/4,pi/3,wind_loc);
%     
%         middle_stem(speed,main_stem_origin(:,20-1:20+1),time,pi*1/4,pi/3,wind_loc);
%         middle_stem(speed,main_stem_origin(:,20-1:20+1),time,pi*3/4,pi/3,wind_loc);
%         middle_stem(speed,main_stem_origin(:,20-1:20+1),time,pi*5/4,pi/3,wind_loc);
%         middle_stem(speed,main_stem_origin(:,20-1:20+1),time,pi*7/4,pi/3,wind_loc);
%     
%         middle_stem(speed,main_stem_origin(:,25-1:25+1),time,pi*2/4,pi/3,wind_loc);
%         middle_stem(speed,main_stem_origin(:,25-1:25+1),time,pi*4/4,pi/3,wind_loc);
%         middle_stem(speed,main_stem_origin(:,25-1:25+1),time,pi*6/4,pi/3,wind_loc);
%         middle_stem(speed,main_stem_origin(:,25-1:25+1),time,pi*8/4,pi/3,wind_loc);
%     
%         middle_stem(speed,main_stem_origin(:,30-1:30+1),time,pi*1/4,pi/3,wind_loc);
%         middle_stem(speed,main_stem_origin(:,30-1:30+1),time,pi*3/4,pi/3,wind_loc);
%         middle_stem(speed,main_stem_origin(:,30-1:30+1),time,pi*5/4,pi/3,wind_loc);
%         middle_stem(speed,main_stem_origin(:,30-1:30+1),time,pi*7/4,pi/3,wind_loc);
        
        middle_stem(speed,main_stem_origin(:,unit-1:unit+1),time,0,0,wind_loc);
                                    %기둥의 위치와 x축 방향에서 얼만큼의 각도만큼 돌아간 위치에 가지가
                                    %나오게 할 것인지 함수로 호출함
                                    %함수에서 가지들을 surf해서 표시함

                                    %위의 20개의 가지들은 모두 중심 기둥에서 60도 만큼 기울어진
                                    %각도로 위치함

                                    %총 21개의 중간 가지를 함수로 호출함
    
        axis equal;
        axis([-radius*15 radius*15 -radius*15 radius*15 0 unit*unit_length*1.5]);
    
        grid on;
    
        xlabel('x');
        ylabel('y');
        zlabel('z');
    
        %view(30,30);

        el=20+15*sin(az/30);        %view point의 위도는 경도와 sin파를 이용해서 만들도록 함
        view(az,el);

        frame=getframe(gcf);
        writeVideo(video_file,frame);

        az=az+0.6;                  %한 프레임 촬영이 끝나면 다음 경도를 지정하며, 증감식으로 구현함
    
        pause(0.00001);
    %end
    end
end
    
function wind_loc_express(speed,time,wind_loc)
    wind_move=[1 0 0 (time-50)*4*speed;
               0 1 0 0;
               0 0 1 0;
               0 0 0 1];            %바람의 위치를 담당하는 matrix
                                    %main function의 time 변수가 50일때 바람이 나무에
                                    %처음 부딪히기 때문에
                                    %중심점을 time이 50일 때 지나게 함
    wind_route=[cos(wind_loc) -sin(wind_loc) 0 0;
                sin(wind_loc)  cos(wind_loc) 0 0;
                0 0 1 0;
                0 0 0 1];           %바람방향에 맞춰서 회전시켜주는 matrix
    wind_express=[-25 0 0 -25 -25;
                  -120 -120 120 120 -120;
                  0 0 0 0 0;
                  1 1 1 1 1];       %바람의 위치를 표시하기 위한 좌표
    wind_move_route=wind_route*wind_move*wind_express;
                                    %기본 좌표에서 위치를 곱하고 방향을 곱해서 바람위치를
                                    %바닥에 표현하기 위한 좌표
    patch(wind_move_route(1,:),wind_move_route(2,:),wind_move_route(3,:),"FaceColor",'r');
                                    %빨간색으로 patch하여 표현함
end

function middle_stem(speed,xyz,time,branch_rot_loc_val,latitude,wind_loc)
                                    %첫번째 가지를 surf하는 함수
                                    %xyz는 가지의 위치에서 기둥이 기운만큼
                                    %가지도 같이 기울어야 하기 때문에
                                    %main함수에서 delta x,y,z를 사용한것처럼 동일하게 사용하기
                                    %위해
                                    %가지의 위치 뿐만 아니라 기둥의 해당 좌표 위아래 좌표도 같이 가져옴
                                    %3차원 공간에서 4열을 사용하기 때문에
                                    %결론적으로 4x3 matrix를 가져옴

                                    %branch_rot_val은 가지가 기둥에서 x축방향에서 z축
                                    %기준으로 얼만큼 회전한 위치에 위치했는지의 값을 가져온다

                                    %latitude는 가지가 기둥의 방향에서 아래쪽으로 얼마나
                                    %회전했는지를 나타냄
                                    %21개의 가지 중 20개의 가지가 위쪽에서 60도만큼 기울었고
                                    %최상단의 가지의 경우 0도로 수직으로 서있음
    
    angle_array=[zeros(1,50) sin(10.*[0:0.05:5]).*0.0125.*speed.*exp(-[0:0.05:5])];
                                    %기둥이 회전하는 것과 동일함
                                    %다만 진동수가 기둥의 두배임( sin(5x) ->sin(10x) )
                                    %기둥과 가지가 서로 다르게 흔들림
    %angle=sin(10*time)*0.025*exp(-time);
    angle=angle_array(time);

    unit_length=2;
    unit=15;

    circle_unit=16;
    radius=1.5;

    x=xyz(1,2);
    y=xyz(2,2);
    z=xyz(3,2);                     %가지가 뻗어나갈 좌표 x,y,z

    delta_x=xyz(1,3)-xyz(1,1);
    delta_y=xyz(2,3)-xyz(2,1);
    delta_z=xyz(3,3)-xyz(3,1);      %가지가 뻗어나갈 좌표가 기울어진 정도를 나타내기 위한
                                    %delta x,y,z

    cos1=sqrt(delta_y.^2+delta_z.^2)/sqrt(delta_x.^2+delta_y.^2+delta_z.^2);
    sin1=                    delta_x/sqrt(delta_x.^2+delta_y.^2+delta_z.^2);
    rot1=[ cos1 0 sin1 0;
          0 1 0 0;
          -sin1 0 cos1 0;
          0 0 0 1];
    cos2=delta_z/sqrt(delta_y.^2+delta_z.^2);
    sin2=delta_y/sqrt(delta_y.^2+delta_z.^2);
    rot2=[1 0 0 0;
          0  cos2 sin2 0;
          0 -sin2 cos2 0;
          0 0 0 1];
    rot=rot2*rot1;                  %main에서 사용한 rot와 동일함

    angle_product=[ cos(angle) 0 sin(angle) 0;
                   0 1 0 0;
                   -sin(angle) 0 cos(angle) 0;
                   0 0 0 1];        %바람방향으로 회전시키기 위한 행렬
                                    %main에서와 동일한 구조
    move_z=[1 0 0 0;
            0 1 0 0;
            0 0 1 unit_length;
            0 0 0 1];               %가지의 중심축 좌표를 구성할 떄 사용하는 이동좌표
                                    %main에서와 동일한 구조

    middle_stem_origin=[zeros(2,unit+1);
                        ones(1,unit+1)*unit_length;
                        ones(1,unit+1)];
                                    %가지의 중심축 좌표, 구성 전
                                    %main에서와 동일함
    for i=1:unit+1
        middle_stem_origin(:,1:i)=angle_product*middle_stem_origin(:,1:i);
        if i==unit+1
            break;
        end
        middle_stem_origin(:,1:i)=move_z*middle_stem_origin(:,1:i);
        middle_stem_origin=circshift(middle_stem_origin,1,2);
                                    %main에서와 동일하게 중심축을 기울이는 for loop
                                    %해당 for loop에서는 바람 정도에 따라 기울어지기만 함
    end
    middle_stem_origin=[[0;0;0;1] middle_stem_origin];
                                    %main에서와 동일하게 최하단에 좌표를 하나 더 추가해줌
    wind_rot=[cos(wind_loc) -sin(wind_loc) 0 0;
              sin(wind_loc)  cos(wind_loc) 0 0;
              0 0 1 0;
              0 0 0 1];             %main에서와 동일하게 바람이 부는 방향으로 기준축을 회전시킴

    branch_rot_loc_before_back=[ cos(branch_rot_loc_val) sin(branch_rot_loc_val) 0 0;
                                -sin(branch_rot_loc_val) cos(branch_rot_loc_val) 0 0;
                                0 0 1 0;
                                0 0 0 1];
                                    %가지방향으로 기울이는데에 있어서
                                    %y축 기준으로 x축 방향으로(pitch) 회전시키고 해당 각도로 돌리는데
                                    %이전에 가지방향 반대로 돌려서 기울어지려는 방향이 x축과 동일하게끔
                                    %맞추기 위한 행렬
    branch_rot_latitude=[1 0 0 0;
                   0 cos(latitude) -sin(latitude) 0;
                   0 sin(latitude)  cos(latitude) 0;
                   0 0 0 1];        %y축 기준으로 x축 방향(pitch)으로 가지가 기둥이 뻗어있는 방향에서
                                    %기울고자 하는 방향으로 회전시킴
                                    %여기서는 20개의 가지는 60도만큼 기울고
                                    %한개의 가지는 기울지 않음 위를 보고있음

    branch_rot_loc=[cos(branch_rot_loc_val) -sin(branch_rot_loc_val) 0 0;
                    sin(branch_rot_loc_val)  cos(branch_rot_loc_val) 0 0;
                    0 0 1 0;
                    0 0 0 1];       %x축 방향으로 기울어진 기준축 좌표를
                                    %가지가 뻗어나가고자 하는 방향으로 회전시킴

    middle_stem_origin=branch_rot_loc*branch_rot_latitude*branch_rot_loc_before_back*wind_rot*middle_stem_origin;
                                    %바람정도에 따라 기운 기준축 좌표에서
                                    % 1. 바람이 부는 방향으로 회전(바람이 부는 방향으로 흔들리게 됨
                                    % 2. 가지가 뻗는 각도 반대방향으로 일단 회전
                                    % 3. 60도 기울여서 옆으로 뻗도록 함
                                    % 4. 다시 가지가 뻗는 각도 방향으로 회전시켜서
                                    %   가지가 뻗는 방향으로 뻗도록 함

    middle_stem_x=[zeros(circle_unit+1,1) cos(linspace(0,2*pi,circle_unit+1))'*ones(1,unit)*radius zeros(circle_unit+1,1)];
    middle_stem_y=[zeros(circle_unit+1,1) sin(linspace(0,2*pi,circle_unit+1))'*ones(1,unit)*radius zeros(circle_unit+1,1)];
    middle_stem_z=zeros(circle_unit+1,unit+2);
                                    %main과 동일하게 원 좌표를 만듦
                                    %가지의 시작점이 기존 기둥의 중심이기 떄문에
                                    %연산 편의를 위해 시점은 종점과 동일하게 원이 아닌 점으로 처리함
                                    %잠시후에 설명하겠지만 원을 기울이는데에 delta값을 사용하는데
                                    %최하단은 그 아래 좌표가 없기때문에 delta값을 형성할 수 없음도
                                    %원이 아닌 점으로 처리한 이유로 작용함

    branch_loc=[1 0 0 x;
                0 1 0 y;
                0 0 1 z;
                0 0 0 1];           %가지가 뻗어나가기 시작할 위치로 이동하는 행렬

    temp_middle=[middle_stem_x(:,1)';
                 middle_stem_y(:,1)';
                 middle_stem_z(:,1)';
                 ones(1,circle_unit+1)];
    temp_middle=branch_loc*temp_middle;
                                    %가장 아래층은 원이 아닌 점이기 때문에 해당 가지가 뻗어나가는 좌표로
                                    %이동만 시켜줌
                                    %또 가장 아래층이라서 중심축에서 이 위치의 아래 위치가 없음
                                    %따라서 delta값을 형성할 수 없음

    middle_stem_x(:,1)=temp_middle(1,:)';
    middle_stem_y(:,1)=temp_middle(2,:)';
    middle_stem_z(:,1)=temp_middle(3,:)';
                                    %이동시키고 원래 matrix에 넣어줌

    for i=2:unit+1
        delta_x_middle=middle_stem_origin(1,i+1)-middle_stem_origin(1,i-1);
        delta_y_middle=middle_stem_origin(2,i+1)-middle_stem_origin(2,i-1);
        delta_z_middle=middle_stem_origin(3,i+1)-middle_stem_origin(3,i-1);
                                    %아래와 위의 좌표를 이용해서 좌표의 기울기, delta값을 구함

        cos1_middle=sqrt(delta_y_middle.^2+delta_z_middle.^2)/sqrt(delta_x_middle.^2+delta_y_middle.^2+delta_z_middle.^2);
        sin1_middle=                        delta_x_middle/sqrt(delta_x_middle.^2+delta_y_middle.^2+delta_z_middle.^2);
        rot1_middle=[ cos1_middle 0 sin1_middle 0;
                     0 1 0 0;
                     -sin1_middle 0 cos1_middle 0;
                     0 0 0 1];
        cos2_middle=delta_z_middle/sqrt(delta_y_middle.^2+delta_z_middle.^2);
        sin2_middle=delta_y_middle/sqrt(delta_y_middle.^2+delta_z_middle.^2);
        rot2_middle=[1 0 0 0;
                     0  cos2_middle sin2_middle 0;
                     0 -sin2_middle cos2_middle 0;
                     0 0 0 1];
        rot_middle=rot2_middle*rot1_middle;
                                    %main에서와 동일하게 원이 기준축이 기울어진만큼
                                    %회전하도록 하는 행렬
        move_middle=[[1 0 0;0 1 0;0 0 1;0 0 0] middle_stem_origin(:,i)];
                                    %main에서와 동일하게 가지의 중심축의 해당 좌표로
                                    %이동하게 하는 행렬
        temp_middle=[middle_stem_x(:,i)';
                     middle_stem_y(:,i)';
                     middle_stem_z(:,i)';
                     ones(1,circle_unit+1)];
                                    %원 하나씩 옮기기 위한 temp변수
        temp_middle=branch_loc*rot*move_middle*rot_middle*temp_middle;
                                    %원점에 위치한 원을
                                    % 1. 제자리에서 가지가 기운 방향으로 회전시켜서 기울임
                                    % 2. 가지의 중심축의 위치로 원을 옮김
                                    % 3. 원래의 나무기둥이 기울어진 만큼 회전시켜서 기울임
                                    % 4. 나무가 뻗어나가는 좌표로 한번더 이동시켜줌
                                    %최종적으로 기둥이 뻗어나가는 위치에서
                                    %기둥이 기울어진만큼 가지의 중심축이 기울어진데서
                                    %해당 중심축이 바람에 의해서 기울어진 위치에서
                                    %기울어진만큼 회전한 원의 좌표가 만들어짐
        middle_stem_x(:,i)=temp_middle(1,:)';
        middle_stem_y(:,i)=temp_middle(2,:)';
        middle_stem_z(:,i)=temp_middle(3,:)';
                                    %원래 matrix에 값을 다시 넣어줌
    end

    temp_middle=[middle_stem_x(:,unit+2)';
                 middle_stem_y(:,unit+2)';
                 middle_stem_z(:,unit+2)';
                 ones(1,circle_unit+1)];
    move_middle=[[1 0 0;0 1 0;0 0 1;0 0 0] middle_stem_origin(:,unit+2)];
    temp_middle=branch_loc*rot*move_middle*temp_middle;
                                    %중간 가지의 최상단 지점들을
                                    % 1. 가지가 뻗어나가기 시작하는 위치로 이동
                                    % 2. 가지의 끝점으로 이동
                                    %결론적으로 가지의 끝점으로 이동시킴
    middle_stem_x(:,unit+2)=temp_middle(1,:)';
    middle_stem_y(:,unit+2)=temp_middle(2,:)';
    middle_stem_z(:,unit+2)=temp_middle(3,:)';

    surf(middle_stem_x',middle_stem_y',middle_stem_z',"FaceColor","#D95319");%,"EdgeColor","none");
                                    %함수를 호출할때 지정한 위치에서 지정한 각도로 뻗어나오는 나뭇가지를
                                    %surf함
    middle_stem_origin=branch_loc*rot*middle_stem_origin;
                                    %중간 가지의 기준축의 시작이 원점에 있었기 때문에
                                    %잔가지를 호출하기 위해 가지가 뻗어나가기 시작하는 위치로 이동시켜
                                    %실제 가지의 위치로 이동시킴

    sub_stem(speed,middle_stem_origin(:,unit-1:unit+1),time,branch_rot_loc_val+pi*1/4,pi/4,wind_loc);
    sub_stem(speed,middle_stem_origin(:,unit-1:unit+1),time,branch_rot_loc_val+pi*3/4,pi/4,wind_loc);
%     sub_stem(speed,middle_stem_origin(:,unit-1:unit+1),time,branch_rot_loc_val+pi*5/4,pi/4,wind_loc);
%     sub_stem(speed,middle_stem_origin(:,unit-1:unit+1),time,branch_rot_loc_val+pi*7/4,pi/4,wind_loc);
% 
%     sub_stem(speed,middle_stem_origin(:,unit*2/3-1:unit*2/3+1),time,branch_rot_loc_val+pi*0/4,pi/4,wind_loc);
%     sub_stem(speed,middle_stem_origin(:,unit*2/3-1:unit*2/3+1),time,branch_rot_loc_val+pi*2/4,pi/4,wind_loc);
%     sub_stem(speed,middle_stem_origin(:,unit*2/3-1:unit*2/3+1),time,branch_rot_loc_val+pi*4/4,pi/4,wind_loc);
%     sub_stem(speed,middle_stem_origin(:,unit*2/3-1:unit*2/3+1),time,branch_rot_loc_val+pi*6/4,pi/4,wind_loc);
% 
%     sub_stem(speed,middle_stem_origin(:,unit/3-1:unit/3+1),time,branch_rot_loc_val+pi*1/4,pi/4,wind_loc);
%     sub_stem(speed,middle_stem_origin(:,unit/3-1:unit/3+1),time,branch_rot_loc_val+pi*3/4,pi/4,wind_loc);
%     sub_stem(speed,middle_stem_origin(:,unit/3-1:unit/3+1),time,branch_rot_loc_val+pi*5/4,pi/4,wind_loc);
%     sub_stem(speed,middle_stem_origin(:,unit/3-1:unit/3+1),time,branch_rot_loc_val+pi*7/4,pi/4,wind_loc);

    sub_stem(speed,middle_stem_origin(:,unit-1:unit+1),time,0,0,wind_loc);
                                    %잔가지를 surf하기 위해 함수를 호출
                                    %중간가지를 호출할 때와 동일한 방식이며
                                    %앞에서 호출된 21개의 중간 가지에서 각각 13개씩의 가지를 호출
                                    %총 273개의 잔가지를 함수로 호출해서 surf함

                                    %중간가지를 호출할 때와 마찬가지로
                                    %12개의 잔가지는 중간가지가 뻗어나가는 방향에서 45도만큼 기운
                                    %방향으로 뻗어나가고
                                    %한개의 잔가지는 중간가지가 뻗어나가는 방향 그대로 뻗어나감
%end
end

function sub_stem(speed,xyz,time,branch_rot_loc_val,latitude,wind_loc)
                                    %중간가지를 호출하는 함수와 거의 유사함
                                    %가지의 길이, 반지름 등을 제외하고는 거의 다 동일함

    
    angle_array=[zeros(1,50) sin(15.*[0:0.05:5]).*0.0125.*speed.*exp(-[0:0.05:5])];
                                    %잔가지가 흔들리는 진동수는 중앙의 기둥이 흔들리는 진동수의 3배이다
                                    %sin(5x) ->sin(15x)
    %angle=sin(15*time)*0.05*exp(-time);
    angle=angle_array(time);

    unit_length=1;
    unit=15;

    circle_unit=8;
    radius=0.5;

    x=xyz(1,2);
    y=xyz(2,2);
    z=xyz(3,2);

    delta_x=xyz(1,3)-xyz(1,1);
    delta_y=xyz(2,3)-xyz(2,1);
    delta_z=xyz(3,3)-xyz(3,1);

    cos1=sqrt(delta_y.^2+delta_z.^2)/sqrt(delta_x.^2+delta_y.^2+delta_z.^2);
    sin1=                    delta_x/sqrt(delta_x.^2+delta_y.^2+delta_z.^2);
    rot1=[ cos1 0 sin1 0;
          0 1 0 0;
          -sin1 0 cos1 0;
          0 0 0 1];
    cos2=delta_z/sqrt(delta_y.^2+delta_z.^2);
    sin2=delta_y/sqrt(delta_y.^2+delta_z.^2);
    rot2=[1 0 0 0;
          0  cos2 sin2 0;
          0 -sin2 cos2 0;
          0 0 0 1];
    rot=rot2*rot1;

    angle_product=[ cos(angle) 0 sin(angle) 0;
                   0 1 0 0;
                   -sin(angle) 0 cos(angle) 0;
                   0 0 0 1];
    move_z=[1 0 0 0;
            0 1 0 0;
            0 0 1 unit_length;
            0 0 0 1];

    sub_stem_origin=[zeros(2,unit+1);
                     ones(1,unit+1)*unit_length;
                     ones(1,unit+1)];
    for i=1:unit+1
        sub_stem_origin(:,1:i)=angle_product*sub_stem_origin(:,1:i);
        if i==unit+1
            break;
        end
        sub_stem_origin(:,1:i)=move_z*sub_stem_origin(:,1:i);
        sub_stem_origin=circshift(sub_stem_origin,1,2);
    end
    sub_stem_origin=[[0;0;0;1] sub_stem_origin];

    wind_rot=[cos(wind_loc) -sin(wind_loc) 0 0;
              sin(wind_loc)  cos(wind_loc) 0 0;
              0 0 1 0;
              0 0 0 1];

    branch_rot_loc_before_back=[ cos(branch_rot_loc_val) sin(branch_rot_loc_val) 0 0;
                                -sin(branch_rot_loc_val) cos(branch_rot_loc_val) 0 0;
                                0 0 1 0;
                                0 0 0 1];

    branch_rot_latitude=[1 0 0 0;
                   0 cos(latitude) -sin(latitude) 0;
                   0 sin(latitude)  cos(latitude) 0;
                   0 0 0 1];

    branch_rot_loc=[cos(branch_rot_loc_val) -sin(branch_rot_loc_val) 0 0;
                    sin(branch_rot_loc_val)  cos(branch_rot_loc_val) 0 0;
                    0 0 1 0;
                    0 0 0 1];

    sub_stem_origin=branch_rot_loc*branch_rot_latitude*branch_rot_loc_before_back*wind_rot*sub_stem_origin;

    sub_stem_x=[zeros(circle_unit+1,1) cos(linspace(0,2*pi,circle_unit+1))'*ones(1,unit)*radius zeros(circle_unit+1,1)];
    sub_stem_y=[zeros(circle_unit+1,1) sin(linspace(0,2*pi,circle_unit+1))'*ones(1,unit)*radius zeros(circle_unit+1,1)];
    sub_stem_z=zeros(circle_unit+1,unit+2);

    branch_loc=[1 0 0 x;
                0 1 0 y;
                0 0 1 z;
                0 0 0 1];

    temp_sub=[sub_stem_x(:,1)';
              sub_stem_y(:,1)';
              sub_stem_z(:,1)';
              ones(1,circle_unit+1)];
    temp_sub=branch_loc*temp_sub;

    sub_stem_x(:,1)=temp_sub(1,:)';
    sub_stem_y(:,1)=temp_sub(2,:)';
    sub_stem_z(:,1)=temp_sub(3,:)';

    for i=2:unit+1
        delta_x_sub=sub_stem_origin(1,i+1)-sub_stem_origin(1,i-1);
        delta_y_sub=sub_stem_origin(2,i+1)-sub_stem_origin(2,i-1);
        delta_z_sub=sub_stem_origin(3,i+1)-sub_stem_origin(3,i-1);

        cos1_sub=sqrt(delta_y_sub.^2+delta_z_sub.^2)/sqrt(delta_x_sub.^2+delta_y_sub.^2+delta_z_sub.^2);
        sin1_sub=                        delta_x_sub/sqrt(delta_x_sub.^2+delta_y_sub.^2+delta_z_sub.^2);
        rot1_sub=[ cos1_sub 0 sin1_sub 0;
                  0 1 0 0;
                  -sin1_sub 0 cos1_sub 0;
                  0 0 0 1];
        cos2_sub=delta_z_sub/sqrt(delta_y_sub.^2+delta_z_sub.^2);
        sin2_sub=delta_y_sub/sqrt(delta_y_sub.^2+delta_z_sub.^2);
        rot2_sub=[1 0 0 0;
                  0  cos2_sub sin2_sub 0;
                  0 -sin2_sub cos2_sub 0;
                  0 0 0 1];
        rot_sub=rot2_sub*rot1_sub;
        move_sub=[[1 0 0;0 1 0;0 0 1;0 0 0] sub_stem_origin(:,i)];

        temp_sub=[sub_stem_x(:,i)';
                  sub_stem_y(:,i)';
                  sub_stem_z(:,i)';
                  ones(1,circle_unit+1)];
        temp_sub=branch_loc*rot*move_sub*rot_sub*temp_sub;

        sub_stem_x(:,i)=temp_sub(1,:)';
        sub_stem_y(:,i)=temp_sub(2,:)';
        sub_stem_z(:,i)=temp_sub(3,:)';
    end

    temp_sub=[sub_stem_x(:,unit+2)';
                 sub_stem_y(:,unit+2)';
                 sub_stem_z(:,unit+2)';
                 ones(1,circle_unit+1)];
    move_sub=[[1 0 0;0 1 0;0 0 1;0 0 0] sub_stem_origin(:,unit+2)];
    temp_sub=branch_loc*rot*move_sub*temp_sub;
    sub_stem_x(:,unit+2)=temp_sub(1,:)';
    sub_stem_y(:,unit+2)=temp_sub(2,:)';
    sub_stem_z(:,unit+2)=temp_sub(3,:)';

    surf(sub_stem_x',sub_stem_y',sub_stem_z',"FaceColor","#D95319");%,"EdgeColor","none");

    sub_stem_origin=branch_loc*rot*sub_stem_origin;

    leaf(speed,sub_stem_origin(:, 5-1: 5+1),time,branch_rot_loc_val+pi*1/4,pi/4,wind_loc);
    leaf(speed,sub_stem_origin(:, 5-1: 5+1),time,branch_rot_loc_val+pi*3/4,pi/4,wind_loc);
%     leaf(speed,sub_stem_origin(:, 5-1: 5+1),time,branch_rot_loc_val+pi*5/4,pi/4,wind_loc);
%     leaf(speed,sub_stem_origin(:, 5-1: 5+1),time,branch_rot_loc_val+pi*7/4,pi/4,wind_loc);
% 
%     leaf(speed,sub_stem_origin(:, 7-1: 7+1),time,branch_rot_loc_val+pi*0/4,pi/4,wind_loc);
%     leaf(speed,sub_stem_origin(:, 7-1: 7+1),time,branch_rot_loc_val+pi*2/4,pi/4,wind_loc);
%     leaf(speed,sub_stem_origin(:, 7-1: 7+1),time,branch_rot_loc_val+pi*4/4,pi/4,wind_loc);
%     leaf(speed,sub_stem_origin(:, 7-1: 7+1),time,branch_rot_loc_val+pi*6/4,pi/4,wind_loc);
% 
%     leaf(speed,sub_stem_origin(:, 9-1: 9+1),time,branch_rot_loc_val+pi*1/4,pi/4,wind_loc);
%     leaf(speed,sub_stem_origin(:, 9-1: 9+1),time,branch_rot_loc_val+pi*3/4,pi/4,wind_loc);
%     leaf(speed,sub_stem_origin(:, 9-1: 9+1),time,branch_rot_loc_val+pi*5/4,pi/4,wind_loc);
%     leaf(speed,sub_stem_origin(:, 9-1: 9+1),time,branch_rot_loc_val+pi*7/4,pi/4,wind_loc);
% 
%     leaf(speed,sub_stem_origin(:,11-1:11+1),time,branch_rot_loc_val+pi*0/4,pi/4,wind_loc);
%     leaf(speed,sub_stem_origin(:,11-1:11+1),time,branch_rot_loc_val+pi*2/4,pi/4,wind_loc);
%     leaf(speed,sub_stem_origin(:,11-1:11+1),time,branch_rot_loc_val+pi*4/4,pi/4,wind_loc);
%     leaf(speed,sub_stem_origin(:,11-1:11+1),time,branch_rot_loc_val+pi*6/4,pi/4,wind_loc);
% 
%     leaf(speed,sub_stem_origin(:,13-1:13+1),time,branch_rot_loc_val+pi*1/4,pi/4,wind_loc);
%     leaf(speed,sub_stem_origin(:,13-1:13+1),time,branch_rot_loc_val+pi*3/4,pi/4,wind_loc);
%     leaf(speed,sub_stem_origin(:,13-1:13+1),time,branch_rot_loc_val+pi*5/4,pi/4,wind_loc);
%     leaf(speed,sub_stem_origin(:,13-1:13+1),time,branch_rot_loc_val+pi*7/4,pi/4,wind_loc);
% 
%     leaf(speed,sub_stem_origin(:,15-1:15+1),time,branch_rot_loc_val+pi*0/4,pi/4,wind_loc);
%     leaf(speed,sub_stem_origin(:,15-1:15+1),time,branch_rot_loc_val+pi*2/4,pi/4,wind_loc);
%     leaf(speed,sub_stem_origin(:,15-1:15+1),time,branch_rot_loc_val+pi*4/4,pi/4,wind_loc);
%     leaf(speed,sub_stem_origin(:,15-1:15+1),time,branch_rot_loc_val+pi*6/4,pi/4,wind_loc);
                                    %나뭇가지들을 호출했던 것과 동일한 방식으로 나뭇잎을 호출함
                                    %273개의 잔가지에서 각각 24개의 나뭇잎을 호출함
                                    %총 6552개의 나뭇잎이 호출되어 patch됨

%end
end

function leaf(speed,xyz,time,branch_rot_loc_val,latitude,wind_loc)

    
    angle_array=[zeros(1,50) sin(20.*[0:0.05:5]).*0.0125.*speed.*exp(-[0:0.05:5])];
                                    %나뭇잎의 진동수는 기둥 진동수의 4배
                                    %sin(5x) -> sin(20x)
    %angle=sin(20*time)*exp(-time);
    angle=angle_array(time);

    x=xyz(1,2);
    y=xyz(2,2);
    z=xyz(3,2);

    delta_x=xyz(1,3)-xyz(1,1);
    delta_y=xyz(2,3)-xyz(2,1);
    delta_z=xyz(3,3)-xyz(3,1);

    cos1=sqrt(delta_y.^2+delta_z.^2)/sqrt(delta_x.^2+delta_y.^2+delta_z.^2);
    sin1=                    delta_x/sqrt(delta_x.^2+delta_y.^2+delta_z.^2);
    rot1=[ cos1 0 sin1 0;
          0 1 0 0;
          -sin1 0 cos1 0;
          0 0 0 1];
    cos2=delta_z/sqrt(delta_y.^2+delta_z.^2);
    sin2=delta_y/sqrt(delta_y.^2+delta_z.^2);
    rot2=[1 0 0 0;
          0  cos2 sin2 0;
          0 -sin2 cos2 0;
          0 0 0 1];
    rot=rot2*rot1;

    angle_product=[ cos(angle) 0 sin(angle) 0;
                   0 1 0 0;
                   -sin(angle) 0 cos(angle) 0;
                   0 0 0 1];

    split=4;                        %사각형 일부와 원의 일부로 구성되는 나뭇잎 좌표에서
                                    %원의 구성할 요소의 갯수
    coordinate=[1 cos(linspace(pi/2,pi,split)) -1 -2 -2 -2 -1.9 -0.9 cos(linspace(-pi/2,0,split));
                1 sin(linspace(pi/2,pi,split)) -0.9 -1.9 -2 -2 -2 -1 sin(linspace(-pi/2,0,split));
                zeros(1,split*2+7);
                ones(1,split*2+7)]; %나뭇잎 기본 좌표
                                    %기본적으로는 좌하단에서 시작해서 우상단으로 향하는 모양임
    coordinate=circshift(coordinate,2,split+3);
    rot_l=[cos(pi/4) -sin(pi/4) 0 0;
           sin(pi/4)  cos(pi/4) 0 0;
           0 0 1 0;
           0 0 0 1];                %나뭇잎 좌표를 45도 기울일 행렬
    re_size=[sqrt(0.5)*2 0 0 0;
             0 sqrt(0.5)*2 0 0;
             0 0 1 0;
             0 0 0 1];              %나뭇잎 사이즈를 조정하는 행렬
                                    %회전 후 길이가 sqrt(2)의 비율을 띄기 때문에 편의를 위해
                                    %약간의 조정이 필요함
    move1=[1 0 0 0;
           0 1 0 2*2;
           0 0 1 0;
           0 0 0 1];                %나뭇잎의 끝부분을 원점으로 가져오기 위한 이동 행렬
    rot_latitude=[1 0 0 0;
                  0 cos(latitude) -sin(latitude) 0;
                  0 sin(latitude)  cos(latitude) 0;
                  0 0 0 1];         %나뭇가지와 다르게
                                    %나뭇가지가 뻗어가는 방향의 수직방향에서
                                    %나뭇가지가 뻗는 방향으로 얼만큼의 각도로
                                    %나뭇잎이 나게 할건지 회전시키는 행렬
                                    %여기에서는 모두 45도를 사용함(roll)
    rot_longitude=[cos(branch_rot_loc_val) -sin(branch_rot_loc_val) 0 0;
                   sin(branch_rot_loc_val)  cos(branch_rot_loc_val) 0 0;
                   0 0 1 0;
                   0 0 0 1];        %나뭇가지가 뻗어가는 방향에서 몇도 회전한 위치에
                                    %나뭇잎을 위치시킬지 회전시키는 행렬(yaw)
    leaf_origin=rot_longitude*rot_latitude*move1*re_size*rot_l*coordinate;
                                    %나뭇잎을 만들어서 조정하고 기본적으로 회전시켜서 위치시킴
                                    % 1. 45도 회전시켜서 나뭇잎이 y축방향을 향하도록 함
                                    % 2. 사이즈를 조정해서 sqrt(2)값을 조정
                                    % 3. 나뭇잎의 시작점이 원점으로 오게끔 이동
                                    % 4. 평면에 붙어있는 나뭇잎을 45도만큼 roll, 세움
                                    % 5. 나뭇잎이 뻗어가는 방향에서 얼마나 회전시킬지 정해서
                                    %   회전시킴(yaw)
%     leaf(4:6,:)=[zeros(1,length(leaf));
%                  ones(1,length(leaf));
%                  zeros(1,length(leaf))];
    %patch(leaf(1,:),leaf(2,:),leaf(3,:),'g');%,"EdgeColor","none");%leaf(4:6));
%     axis equal;
%     grid on;
    %view(50,40)

    wind_rot_before_back=[ cos(wind_loc) sin(wind_loc) 0 0;
                          -sin(wind_loc) cos(wind_loc) 0 0;
                          0 0 1 0;
                          0 0 0 1]; %나뭇가지 기울일때와 마찬가지로 pitch회전으로 기울이기 떄문에
                                    %미리 반대방향으로 회전시키는 행렬
    wind_rot=[cos(wind_loc) -sin(wind_loc) 0 0;
              sin(wind_loc)  cos(wind_loc) 0 0;
              0 0 1 0;
              0 0 0 1];             %다시 원래방향으로 yaw회전시키기 위한 행렬

    leaf_origin=wind_rot*angle_product*wind_rot_before_back*leaf_origin;
                                    %기본적인 방향을 잡은 나뭇잎을 바람이 부는 정도만큼 회전시킴
                                    % 1. 일단 기울어지는 반대방향으로 yaw 회전
                                    % 2. pitch회전으로 바람에 따라 기울임
                                    % 3. 다시 원래대로 yaw회전시켜서 결론적으로 바람이 부는 방향으로 기울임

    branch_loc=[1 0 0 x;
                0 1 0 y;
                0 0 1 z;
                0 0 0 1];           %나뭇잎이 시작하는 가지의 지점으로 이동하는 행렬

    leaf_origin=branch_loc*rot*leaf_origin;
                                    %바람에의해 기울어진 나뭇잎을 잔가지의 위치와 각도에 따라 회전시킴
                                    % 1. 잔가지의 해당 위치가 기울어진 정도에 따라 기울임
                                    % 2. 나뭇잎 시작지점인 나뭇가지의 좌표로 데려감

    %surf(sub_stem_x',sub_stem_y',sub_stem_z',"FaceColor","#D95319");%,"EdgeColor","none");
    patch(leaf_origin(1,:),leaf_origin(2,:),leaf_origin(3,:),'g');%,"EdgeColor","none");%leaf(4:6));
                                    %나뭇잎은 patch를 이용하여 표현함
%end
end
