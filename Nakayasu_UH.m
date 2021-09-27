% Nakayasu Unit Hydrograph
L=50;% Basin Length
A=1250;% Watershed Area
tr=2; % Target Time
R0=10;% effective rainfall (1cm=10mm)
% tg: retention time
if(L<15),    tg=0.2*(L)^0.7;
else,    tg=0.4+0.058*L;
end
tk=0.47*(A*L)^0.25;
tp=0.8*tr+tg;
%Qp=maximum flow
Qp=0.2778*(R0*A)/(0.3*tp+tk);

% Increasing Mode
tup=0:0.1:tp;ntup=length(tup);
Q=Qp*(tup/tp).^2.4;
% Decreasing Mode1
t_03=tp+tk;
ts1=tp:0.1:t_03;
Q_D1=Qp*(0.3).^((ts1-tp)/tk);
% Decreasing Mode2
t_009=tp+2.5*tk;
ts2=t_03:0.1:t_009;
Q_D2=Qp*(0.3).^((ts2-tp+0.5*tk)/(1.5*tk));
% Decreasing Mode3
t_0027=tp+4.5*tk;
ts3=t_009:0.1:t_0027;
Q_D3=Qp*(0.3).^((ts3-tp+1.5*tk)/(2*tk));


Qall=[Q,Q_D1,Q_D2,Q_D3];
Tall=[tup,ts1,ts2,ts3];

plot(Tall,Qall,'LineWidth',2);set(gca,'FontSize',14)
xlabel('t(hrs)','FontSize',14);
ylabel('Q (m^3/sec)','FontSize',14);

