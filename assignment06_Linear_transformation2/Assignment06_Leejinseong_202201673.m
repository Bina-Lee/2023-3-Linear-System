d=[ 0  5 5  0 -5 5   0 -5 -5   0  5 -5  0;
    0 -5 5  0  5 5   0  5 -5   0 -5 -5  0;
   20  0 0 20  0 0 -20  0  0 -20  0  0 20;
    1  1 1  1  1 1   1  1  1   1  1  1  1]; 
d(3,:)=d(3,:)-20;
p=[1 2 3;
   4 5 6;
   5 6 7;
   8 9 10;
   9 10 11;
   11 12 13;
   1 8 9;
   2 3 7];  
c=['b' 'r' 'g' 'w' 'k' 'c' 'm' 'y']';

x3=0;
r_Rev=20; % Radius of revolution
noRot1=2; % no of 1st rotation
noRev=16;% no of revolution (공전)
noRot2=4;% no of 2nd rotation (자전)

x3_1=0;

orbit1 = [0,0,20];
vpoint_cal = [80,80,80+x3];
vpoint_view = [80,80,80];

vgain = 10000;

axis_range=[-80 80 -80 80 -80+x3_1 80+x3_1];

for x1 = [0:0.4:20]
    clf;
    psi = 4*pi * x1/20;
    Rz_u = [cos(psi) -sin(psi) 0 x1; 
            sin(psi) cos(psi) 0 0; 
            0 0 1 0; 
            0 0 0 1];
    y_before = Rz_u*d;
    dist_vpoint = sqrt((y_before(1,1)-vpoint_cal(1))^2 ...
                    + (y_before(2,1)-vpoint_cal(2))^2 ...
                    + (y_before(3,1)-vpoint_cal(3))^2);
    y = y_before./(dist_vpoint.^2).* vgain;

    subplot(2,2,1);

    line([y(1,:) y(1,1)], [y(2,:) y(2,1)], [y(3,:) y(3,1)]);
    line([60 0 0], [0 0 0], [0 0 0],'Color','r');
    line([0 0 0], [0 60 0], [0 0 0],'Color','g');
    line([0 0 0], [0 0 0], [0 0 60],'Color','k');
    orbit1 = [orbit1; y(1,1) y(2,1), y(3,1)];
    line(orbit1(:,1), orbit1(:,2), orbit1(:,3));
    for i = 1:1:8
        patch([y(1,p(i,1)) y(1,p(i,2)) y(1,p(i,3))], ...
              [y(2,p(i,1)) y(2,p(i,2)) y(2,p(i,3))], ...
              [y(3,p(i,1)) y(3,p(i,2)) y(3,p(i,3))], ...
              c(i));
    end
    xlabel('x1-axis'); ylabel('x2-axis'); zlabel('x3-axis');
    title('202201673 이진성');

    xticks(-80:20:80);
    yticks(-80:20:80);

    axis equal;
    axis(axis_range);
    view(vpoint_view); grid;
    pause(0.000001);
end

for x1 = [0:0.4:10]
    clf;
    psi = pi * x1/5;
    Sf_r = [cos(psi) -sin(psi) 0 0; 
            sin(psi) cos(psi) 0 0; 
            0 0 1 0; 
            0 0 0 1];
    Sp_r= [cos(psi/4) 0 -sin(psi/4) 0;
           0 1 0 0;
           sin(psi/4) 0 cos(psi/4) 0;
           0 0 0 1];
    M_m = [1 0 0 20;0 1 0 0;0 0 1 0;0 0 0 1];
    y_before = M_m*Sp_r*Sf_r*d;
    dist_vpoint = sqrt((y_before(1,1)-vpoint_cal(1))^2 ...
                    + (y_before(2,1)-vpoint_cal(2))^2 ...
                    + (y_before(3,1)-vpoint_cal(3))^2);
    y = y_before./(dist_vpoint.^2).* vgain;

    subplot(2,2,1);

    line([y(1,:) y(1,1)], [y(2,:) y(2,1)], [y(3,:) y(3,1)]);
    line([60 0 0], [0 0 0], [0 0 0],'Color','r');
    line([0 0 0], [0 60 0], [0 0 0],'Color','g');
    line([0 0 0], [0 0 0], [0 0 60],'Color','k');
    orbit1 = [orbit1; y(1,1) y(2,1), y(3,1)];
    line(orbit1(:,1), orbit1(:,2), orbit1(:,3));
    for i = 1:1:8
        patch([y(1,p(i,1)) y(1,p(i,2)) y(1,p(i,3))], ...
              [y(2,p(i,1)) y(2,p(i,2)) y(2,p(i,3))], ...
              [y(3,p(i,1)) y(3,p(i,2)) y(3,p(i,3))], ...
              c(i));
    end
    xlabel('x1-axis'); ylabel('x2-axis'); zlabel('x3-axis');
    title('202201673 이진성');

    xticks(-80:20:80);
    yticks(-80:20:80);

    axis equal;
    axis(axis_range);
    view(vpoint_view); grid;
    pause(0.000001);
end

orbit2=orbit1;
line_orbit=[y(3,1) 0];

for deg = [0 * 360 : 4 : 4 * 360 ]
    clf;
    %x1 = 20 * cos(deg*pi/180);
    %x2 = 20 * sin(deg*pi/180);
    x3_1= -deg / 720 * 20;
    x3 = x3_1  + randn(1);

    vpoint_cal = [80*cos(psi/4+pi/3),
                  80*sin(psi/4+pi/3),
                  80+x3_1];

    vpoint_view = [80*cos(psi/4+pi/3),
                   80*sin(psi/4+pi/3),
                   80];

    psi = deg*4 * pi/180;
    Sf_r = [cos(psi) -sin(psi) 0 0; 
            sin(psi) cos(psi) 0 0; 
            0 0 1 0; 
            0 0 0 1];
    Sp_r= [cos(pi/2) 0 -sin(pi/2) 0;
           0 1 0 0;
           sin(pi/2) 0 cos(pi/2) 0;
           0 0 0 1];
    M_m = [1 0 0 20;0 1 0 0;0 0 1 0;0 0 0 1];
    Rv_s=[cos(psi/4) -sin(psi/4) 0 0;
          sin(psi/4) cos(psi/4) 0 0;
          0 0 1 x3;
          0 0 0 1];
    y_before = Rv_s*M_m*Sp_r*Sf_r*d;
    dist_vpoint = sqrt((y_before(1,1)-vpoint_cal(1))^2 ...
                    + (y_before(2,1)-vpoint_cal(2))^2 ...
                    + (y_before(3,1)-vpoint_cal(3))^2);
    y = y_before./(dist_vpoint.^2).* vgain;

    orbit1 = [orbit1; y(1,1), y(2,1), y(3,1)];

    subplot(2,2,1);

    line([y(1,:) y(1,1)], [y(2,:) y(2,1)], [y(3,:) y(3,1)]);
    line([60 0 0], [0 0 0], [0 0 0],'Color','r');
    line([0 0 0], [0 60 0], [0 0 0],'Color','g');
    line([0 0 0], [0 0 0], [0 0 60],'Color','k');

    line(orbit1(:,1), orbit1(:,2), orbit1(:,3));
    for i = 1:1:8
        patch([y(1,p(i,1)) y(1,p(i,2)) y(1,p(i,3))], ...
              [y(2,p(i,1)) y(2,p(i,2)) y(2,p(i,3))], ...
              [y(3,p(i,1)) y(3,p(i,2)) y(3,p(i,3))], ...
              c(i));
    end
    xlabel('x1-axis'); ylabel('x2-axis'); zlabel('x3-axis');
    title('202201673 이진성');

    xticks(-80:20:80);
    yticks(-80:20:80);

    ztick_begin=axis_range(5);
    ztick_range=round(ztick_begin/20)*20:20:160;
    zticks(ztick_range);

    axis equal;
    axis_range=[-80 80 -80 80 -80+x3_1 80+x3_1];
    axis(axis_range);

    view(vpoint_view); grid;

    %===================================================

    vpoint_cal = [100*cos(psi/4+pi/3),
                  100*sin(psi/4+pi/3),
                  x3_1];

    vpoint_view = [80*cos(psi/4+pi/3),
                   80*sin(psi/4+pi/3),
                   0];

    psi = deg*4 * pi/180;
    Sf_r = [cos(psi) -sin(psi) 0 0; 
            sin(psi) cos(psi) 0 0; 
            0 0 1 0; 
            0 0 0 1];
    Sp_r= [cos(pi/2) 0 -sin(pi/2) 0;
           0 1 0 0;
           sin(pi/2) 0 cos(pi/2) 0;
           0 0 0 1];
    M_m = [1 0 0 20;0 1 0 0;0 0 1 0;0 0 0 1];
    Rv_s=[cos(psi/4) -sin(psi/4) 0 0;
          sin(psi/4) cos(psi/4) 0 0;
          0 0 1 x3;
          0 0 0 1];
    y_before = Rv_s*M_m*Sp_r*Sf_r*d;
    dist_vpoint = sqrt((y_before(1,1)-vpoint_cal(1))^2 ...
                    + (y_before(2,1)-vpoint_cal(2))^2 ...
                    + (y_before(3,1)-vpoint_cal(3))^2);
    y = y_before./(dist_vpoint.^2).* vgain;

    orbit2 = [orbit2; y(1,1), y(2,1), y(3,1)];

    subplot(2,2,2);

    line([y(1,:) y(1,1)], [y(2,:) y(2,1)], [y(3,:) y(3,1)]);
    line([60 0 0], [0 0 0], [0 0 0],'Color','r');
    line([0 0 0], [0 60 0], [0 0 0],'Color','g');
    line([0 0 0], [0 0 0], [0 0 60],'Color','k');
    line(orbit2(:,1), orbit2(:,2), orbit2(:,3));
    for i = 1:1:8
        patch([y(1,p(i,1)) y(1,p(i,2)) y(1,p(i,3))], ...
              [y(2,p(i,1)) y(2,p(i,2)) y(2,p(i,3))], ...
              [y(3,p(i,1)) y(3,p(i,2)) y(3,p(i,3))], ...
              c(i));
    end
    xlabel('x1-axis'); ylabel('x2-axis'); zlabel('x3-axis');

    ztick_begin=axis_range(5);
    ztick_range=round(ztick_begin/20)*20:20:160;
    zticks(ztick_range);

    axis equal;
    axis_range=[-80 80 -80 80 -80+x3_1 80+x3_1];
    axis(axis_range);

    vpoint_view(1) = 80*cos(psi/4+pi/2);
    vpoint_view(2) = 80*sin(psi/4+pi/2);
    vpoint_view(3)=0;

    view(vpoint_view); grid;

    %===================================================

    line_orbit=[line_orbit;[x3_1 x3-x3_1]];

    subplot(2,2,3:4);

    line(line_orbit(:,1), line_orbit(:,2));

    axis([line_orbit(end,1)-20 line_orbit(end,1)+20 -3 3]);

    grid;

    pause(0.0000001);
end