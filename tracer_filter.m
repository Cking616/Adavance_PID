clear all;
close all;

ts = 0.001;
x = [0,0];
for k=1:1:3000
    time(k) = k *ts;
    
    u0=1.0*sin(1*2*pi*k*ts);
    u = u0 + 0.1 * rands(1);
    
    r =1800;
    h = 0.015;
    T = ts;
    delta = r * h;
    delta0 = delta * h;
    y = x(1) - u + h * x(2);
    a0 = sqrt(delta * delta + 8 *r * abs(y));
    if abs(y) <= delta0
        a = x(2) + y / h;
    else
        a = x(2) + 0.5 *(a0 -delta) *sign(y);
    end
    if abs(a) <=delta
        fst2 = -r * a / delta;
    else
        fst2 = -r * sign(a);
    end
    
    x(1) = x(1) + T *x(2);
    x(2) = x(2) + T * fst2;
    rin0(k) = u0;
    rin(k) = u;
    x1(k) = x(1);
end
figure(1);
plot(time, rin, 'k', time, x1, 'k');
xlabel('time(s)');
ylabel('rin,x1');
figure(2);
plot(time,rin0, 'k', time, x1, 'k');
xlabel('time(s)');
ylabel('rin0,x1');
