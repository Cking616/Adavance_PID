clear all;
close all;

ts=0.0005;
sys=tf(1, [0.1,1,0]);
dsys=c2d(sys,ts,'z');
[num,den]=tfdata(dsys,'v');

%sys1=tf(1, [0.5,1]);
%dsys1=c2d(sys1,ts,'tucsin');
%[num1, den1]=tfdata(dsys1,'v');
%disp(den1(2));
%disp(num1(1));
num1 = 475 / 1024;den1 = 549 / 1024;den2 = 0;
u_1=0.0;u_2=0.0;u_3=0.0;
yd_1=0;yd_2=0;yd_3=0;
y_1=0;y_2=0;y_3=0;
v_1=0;v_2=0;v_3=0;
kp_0=200 * 1000 / 2048;kvff=1;kaff=0;
t_po = 30;
cur_e = 0;
kp=kp_0;
Tc = 3;

x=[0,0,0]';
error_1=0;

for k=1:1:20000
    time(k)=k*ts;

    S=4;
    if S==1
        if mod(time(k),5) < 1
            yd(k)=mod(time(k),1);
        elseif mod(time(k),5) < 4
            yd(k)=1;
        else
            yd(k)=1-mod(time(k),1);
        end
        yd(k)=yd(k);
    elseif S==2
        if mod(time(k),2) < 1
            yd(k)=mod(time(k),1);
        else
            yd(k)=1-mod(time(k),1);
        end
        yd(k)=yd(k);
    elseif S==3
         yd(k)=mod(time(k),1.0);
    elseif S==4
        if mod(time(k),10) < 2
            yd(k)=(time(k)) * (time(k));
        elseif mod(time(k),10) < 3
            yd(k)= time(k) * 4 - 4;
        elseif mod(time(k),10) < 5
            yd(k)=12 - (5 - time(k)) * (5 - time(k));
        elseif mod(time(k),10) < 7
            yd(k)= 12 - (time(k) - 5) * (time(k) - 5);
        elseif mod(time(k),10) < 8   
            yd(k)= 8 - (time(k) - 7) * 4;
        else
            yd(k)= (10 - time(k)) * (10 - time(k));
        end
        yd(k)=yd(k);
    end

    if v_1 > 0
        if v_2 > 0
            kaff = 2.0;
        else
            kaff = 1.4;
        end
    else
        if v_2 > 0
            kaff = 0;
        else
            kaff = 1.8;
        end
    end

    if cur_e > 0
        if cur_e > t_po
            kp = 1.55 * kp_0;
        else
            kp = (1.5 * cur_e / t_po + 0.05) * kp_0;
        end
    else
        if cur_e < -t_po
            kp = 1.55 * kp_0;
        else
            kp = (1.5 * (-cur_e) / t_po + 0.05) * kp_0;
        end
    end
    u_1=kp*x(1)+kvff*x(2)+kaff*x(3);
    u_1= u_1 * 924 / 1024 + u_2 * 50 / 1024 + u_3 * 50 / 1024;
    u(k)=u_1;

    if u(k)>=5
        u(k)=5;
    end
    if u(k)<=-5;
        u(k)=-5;
    end

    acc(k) = (u(k) - u_2) / ts;
    if k > 1
        if acc(k) -  acc(k - 1) > Tc
            acc(k) =  acc(k - 1) + Tc;
        end
    
        if acc(k) -  acc(k - 1) < -Tc
            acc(k) =  acc(k - 1) - Tc;
        end
    else
        if acc(k) > Tc
            acc(k) = Tc;
        end
    
        if acc(k) < -Tc
            acc(k) = - Tc;
        end
    end
    
    if acc(k)>=15
        acc(k)=15;           
    end
    if acc(k)<=-15
        acc(k)=-15;       
    end
    
    u(k) = u_2 + ts * acc(k);
    u_1 = u(k);

    y(k)=-den(2)*y_1-den(3)*y_2+num(2)*u_1+num(3)*u_2;
    error(k)=yd(k)-y(k);

    yd_3=yd_2;yd_2=yd_1;yd_1=yd(k);
    y_3=y_2;y_2=y_1;y_1=y(k);
    u_3=u_2;u_2=u_1;
    v_1 = (yd_1-yd_2) / ts;

    if v_1 > 5
        v_1=5;
    end

    if v_1 < -5
        v_1=-5;
    end

    v_1 = den1 * v_2 + num1 * v_1 + den2 * v_3;

    x(1)=error(k);
    x(2)= v_1;
    x(3)=(v_1 - v_2)/ ts;
    if x(3) > 0.1
        x(3) = 0.1;
    end
    if x(3) < -0.1
        x(3) = -0.1;
    end
    v_2 = v_1;
    v_3 = v_1;

    error_1=error(k);
    error_100(k) = error(k) * 100 * 1000;
    cur_e = error_100(k);
end

figure(1);
plot(time,yd,'r',time,y,'k:','linewidth',2);
legend('Ideal position signal','Position tracking');

figure(2);
plot(time,error_100,'r','linewidth',2);
legend('error position');

figure(3);
plot(time,u,'r','linewidth',2);
legend('speed');

figure(4);
plot(time,acc,'r','linewidth',2);
legend('acceleration');
