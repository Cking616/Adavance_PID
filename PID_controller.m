clear all;
close all;

ts = 0.001;
sys = tf(5.235e005, [1, 87.35, 1.047e004, 0]);
dsys = c2d(sys, ts, 'Z');
[num, den]=tfdata(dsys,'v');

u_1=0.0;u_2=0.0;u_3=0.0;
y_1=0.0;y_2=0.0;y_3=0.0;
x=[0,0,0];
error_1=0
for k=1:1:500
    time(k)=k*ts;

    S=1;
    if S==1
        kp=0.50;ki=0.001;kd=0.001;
        yd(k)=1;
    elseif S==2
        kp=0.50;ki=0.001;kd=0.001;
        yd(k)=sign(sin(2*2*pi*k*ts));
    elseif S==3
        kp=1.5;ki=1.0;kd=0.01;
        yd(k)=0.5*sin(2*2*pi*k*ts);
    end

    u(k)=kp*x(1)+kd*x(2)+ki*x(3);
    if u(k)>=10
        u(k)=10;
    end
    if u(k)<=-10
        u(k)=10;
    end

    y(k)=-den(2)*y_1-den(3)*y_2-den(4)*y_3+num(2)*u_1+num(3)*u_2+num(4)*u_3;

    error(k)=yd(k)-y(k);

    u_3=u_2;u_2=u_1;u_1=u(k);
    y_3=y_2;y_2=y_1;y_1=y(k);

    x(1)=error(k);
    x(2)=(error(k)-error_1)/ts;
    x(3)=x(3)+error(k)*ts;

    error_1=error(k);
end

figure(1);
plot(time, yd, 'r', time, y, 'k:', 'linewidth', 2);
legend('Ideal position signal','Position tracking');
