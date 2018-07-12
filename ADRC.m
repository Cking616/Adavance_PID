clear all;
close all;

b = 133;

kp = 10; kd =0.0009;
T=0.001;
yo = zeros(3, 1);
y = zeros(3, 1);
vo = zeros(2, 1);
zo = zeros(3, 1);
v1 = 0;
ut = 0;
alfa01=200/201; alfa02=201/200;
delta0 = 2 * T;


for k=1:1:20000
	time(k) = k * T;
	clock = k * T;

	v(k) = sign(sin(k*T));
    ytmp = PlantModel(yo, ut, clock, T);
	y(k) = ytmp(1);
    dy(k) = ytmp(2);

	vd = TD_ADRC(vo, v1, T, 10);

	zd = ESO_ADRC(zo, y(k), ut, T);

	e1(k) = vd(1) - zd(1);
	e2(k) = vd(2) - zd(2);
	u0(k) = kp *fal(e1(k), alfa01, delta0)+kd * fal(e2(k), alfa02, delta0);
	u(k) = u0(k)-zd(3)/133;

	v1 = v(k);
	vo = vd;
	zo = zd;

	ut = u(k);
    yo = ytmp;
end

figure(1);
plot(time, v, 'r', time, y, 'k:', 'linewidth', 2);
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

function z = ESO_ADRC(zo, y, uo, T)
    beta1 = 150; beta2 = 250; beta3 = 550;
    delta1 = 0.15; alfa1 = 0.5; alfa2 = 0.25;

	z = zeros(3, 1);
	e = zo(1) - y;
	z(1) = zo(1) + T * (z(2) - beta1 * e);
	z(2) = zo(2) + T * (z(3) - beta2 * fal(e, alfa1, delta1) + 133 * uo);
	z(3) = zo(3) - T * beta3 * fal(e, alfa2, delta1);
end

function dy = PlantModel(yo, ut, clock, T)
	dy = zeros(3, 1);
	f = -25 * yo(2) + 33 * sin(pi * clock);
    dy(1) = yo(1) + yo(2) * T;
	dy(2) = yo(2) + yo(3) * T;
	dy(3) = (f + 133 * ut) ;
end

