%单神经元自适应控制
clear all;
close all;

function k = No_Supervised_Heb_Learning(ko, u1, x)
    baseP = 0.40;
    baseI = 0.35;
    baseD = 0.40;
    
    k = zeros(4, 1);
    k(1) = ko(1) + baseP * u1 * x(1);
    k(2) = ko(2) + baseI * u1 * x(2);
    k(3) = ko(3) + baseD * u1 * x(3);
    k(4) = 0.06;
end

function k = Supervised_Delta_Learning(ko, u1, e)
    baseP = 0.40;
    baseI = 0.35;
    baseD = 0.40;
    
    k = zeros(4, 1);
    k(1) = ko(1) + baseP * u1 * e;
    k(2) = ko(2) + baseI * u1 * e;
    k(3) = ko(3) + baseD * u1 * e;
    k(4) = 0.12;
end

function k = Supervised_Heb_Learning(ko, u1, e, x)
    baseP = 0.40;
    baseI = 0.35;
    baseD = 0.40;
    
    k = zeros(4, 1);
    k(1) = ko(1) + baseP * e * u1 * x(1);
    k(2) = ko(2) + baseI * e * u1 * x(2);
    k(3) = ko(3) + baseD * e * u1 * x(3);
    k(4) = 0.12;
end

function k = Improved_Heb_Learning(ko, u1, e, eo, x)
    baseP = 0.40;
    baseI = 0.35;
    baseD = 0.40;
    
    k = zeros(4, 1);
    k(1) = ko(1) + baseP * (2 * e  - eo) * u1 * x(1);
    k(2) = ko(2) + baseI * (2 * e  - eo) * u1 * x(2);
    k(3) = ko(3) + baseD * (2 * e  - eo) * u1 * x(3);
    k(4) = 0.12;
end