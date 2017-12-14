clear all;
close all;

ts=0.001;
sys=tf(5.235e0005,[1,87.35,1.047e004,0])
dsys=c2d(sys,ts,'Z');
[num,den]=tfdata(dsys,'v');

u_1=0.0;u_2=0.0;u_3=0.0;
yd_1=rand;
y_1=0;y_2=0;y_3=0;

x=[0,0,0];
error_1=0;

for k=1:1:3000
    time(k)=ts*k;

    kp=1.0;ki=2.0;kd=0.01;

    S=1;
    if S==1
        if mod(time(k),2)<1
            yd(k)=mod(time(k),1);
        else
            yd(k)=1-mod(time(k),1);
        end
        yd(k)=yd(k)-0.5;
    end
    if S==2
        yd(k)=mod(time(k),1.0);
    end
    if S==3
        yd(k)=rand;
        dyd(k)=(yd(k)-yd_1)/ts;
        while abs(dyd(k))>=5.0
            yd(k)=rand;
            dyd(k)=abs(yd(k)-yd_1)/ts;
        end
    end

    u(k)=kp*x(1)+kd*x(2)+ki*x(3);

    if u(k)>=10
        u(k)=10;
    end
    if u(k)<=-10;
        u(k)=-10;
    end

    y(k)=-den(2)*y_1-den(3)*y_2-den(4)*y_3+num(2)*u_1+num(3)*u_2+num(4)*u_3;
    error(k)=yd(k)-y(k);

    yd_1=yd(k);

    u_3=u_2;u_2=u_1;u_1=u(k);
    y_3=y_2;y_2=y_1;y_1=y(k);

    x(1)=error(k);
    x(2)=(error(k)-error_1)/ts;
    x(3)=x(3)+error(k)*ts;
    xi(k)=x(3);

    error_1=error(k);
    D=0;
    if D==1
        plot(time, yd, 'b', time, y ,'r');
        pause(0.0000000000);
    end
end
figure(1);
plot(time, yd, 'r', time, y , 'k:', 'linewidth', 2);
legend('Ideal position signal', 'Position tracking');

