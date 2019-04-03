clear all;
close all;

Size=30;
CodeL=2;

MinX(1)=-2.048;
MaxX(1)=2.048;
MinX(2)=-2.048;
MaxX(2)=2.048;

G=50;
F=0.6;
cr=0.9;
for i=1:1:CodeL
    P(:,i)=MinX(i)+(MaxX(i)-MinX(i))*rand(Size,1);
end

BestS=P(1,:);
for i=2:Size
    if (Rosenbrock(P(i,1),P(i,2))>Rosenbrock(BestS(1),BestS(2)))
        BestS=P(i,:);
    end
end

fi = Rosenbrock(BestS(1),BestS(2))

for kg=1:1:G
    time(kg)=kg;
    for i=1:Size
        r1=1;r2=1;r3=1;
        while(r1==r2||r1==r3||r2==r3||r1==i||r2==i||r3==i)
            r1=ceil(Size*rand(1));
            r2=ceil(Size*rand(1));
            r3=ceil(Size*rand(1));
        end
        
        h(i,:)=P(r1,:)+F*(P(r2,:)-P(r3,:));
        
        for j=1:CodeL
            if h(i,j)<MinX(j)
                h(i,j)=MinX(j);
            elseif h(i,j)>MaxX(j)
                h(i,j)=MaxX(j);
            end
        end
        
        for j=1:1:CodeL
            tempr=rand(1);
            if(tempr<cr)
                v(i,j)=h(i,j);
            else
                v(i,j)=P(i,j);
            end
        end
        
        if(Rosenbrock(v(i,1),v(i,2))>Rosenbrock(P(i,1),P(i,2)))
            P(i,:)=v(i,:);
        end
        
        if(Rosenbrock(P(i,1),P(i,2))>fi)
           fi = Rosenbrock(P(i,1),P(i,2));
           BestS=P(i,:);
        end   
    end
    Best_f(kg)=Rosenbrock(BestS(1),BestS(2));
end
BestS
Best_f(kg)
figure(1);
plot(time,Best_f(time),'k','linewidth',2);

function J=Rosenbrock(x1,x2)
    J=100*(x1^2-x2)^2+(1-x1)^2;
end

