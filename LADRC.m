%线性自抗扰控制
clear all;
close all;

kp = 6; kd =0.001;
T=0.001;
yo = zeros(3, 1);
y = zeros(3, 1);
vo = zeros(2, 1);
zo = zeros(3, 1);
v1 = 0;
ut = 0;
htl = 1.8;
b = 133;

for k=1:1:20000
	time(k) = k * T;
	clock = k * T;
    
	%v(k) = sign(sin(k*T));
    % v(k) = 1;
    v(k) = 0.0005 * k;
    ytmp = PlantModel(yo, ut, clock, T);
	y(k) = ytmp(1);
    dy(k) = ytmp(2);

	% vd = TD_ADRC(vo, v1, T, htl);
    vd = TD_Levant(vo, v1, T);
	zd = LESO_ADRC(zo, y(k), ut, T);

	e1(k) = vd(1) - zd(1);
	e2(k) = vd(2) - zd(2);
	%u0(k) = kp *fal(e1(k), alfa01, delta0)+kd * fal(e2(k), alfa02, delta0);
    u0(k) = kp * e1(k) + kd * e2(k);
	u(k) = u0(k)-zd(3)/b;

	v1 = v(k);
	vo = vd;
	zo = zd;

	ut = u(k);
    yo = ytmp;
end

figure(1);
plot(time, v, 'r',time, y, 'k:', 'linewidth', 2);
% plot(time, e1, 'r', 'linewidth', 2);
legend('ideal position signal', 'position tracking signal');

function f = fst(x1,x2,delta,T)
    d = delta * T;
    d0 = T * d;
    y = x1 + T * x2;
    a0 = sqrt(d^2 + 8 * delta * abs(y));
    
    if abs(y) > d0
        a = x2 + (a0 - d) / 2 * sign(y);
    else
        a = x2 + y / T;
    end
    
    if abs(a) > d
        f = -delta * sign(a);
    else
        f = -delta * a/d;
    end
end

function y = fal(epec,alfa,delta)
	if abs(epec) > delta
		y = abs(epec)^alfa * sign(epec);
	else
		y = epec / (delta^(1 - alfa));
	end
end

function v = TD_ADRC(vo, yd, T, delta)
	v = zeros(2, 1);
	x1 = vo(1) - yd;
	x2 = vo(2);
	v(1) = vo(1) + T * vo(2);
	v(2) = vo(2) + T * fst(x1, x2, delta, T);
end

function z = LESO_ADRC(zo, y, uo, T)
    w0 = 7.5;

	z = zeros(3, 1);
	e = zo(1) - y;
	z(1) = zo(1) + T * (z(2) -  3 * w0 * e);
	z(2) = zo(2) + T * (z(3) - 3 * w0 * w0 * e + 133 * uo);
	z(3) = zo(3) - T * w0 * w0 * w0 * e;
end

function dy = PlantModel(yo, ut, clock, T)
	dy = zeros(3, 1);
	f = -25 * yo(2) + 33 * sin(pi * clock);
    %f = -25 * yo(2) + 0.5 * sign(sin(pi * clock));
    dy(1) = yo(1) + yo(2) * T;
	dy(2) = yo(2) + yo(3) * T;
	dy(3) = (f + 133 * ut) ;
end

function v = TD_Levant(zo, y, T)
    v = zeros(2, 1);
    alfa = 2;
    nmna = 6;
    v(1) = zo(1) + T * (zo(2) - nmna * sqrt(abs(zo(1) - y)) * sign(zo(1) - y));
    v(2) = zo(2) - T * alfa * sign(zo(1) - y);
end
