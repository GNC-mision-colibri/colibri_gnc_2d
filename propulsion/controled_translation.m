%% SIMULATIONS
H = 375000;
R = 6.3781*10^6 + H;
M = 5.972*10^(24);
G = 6.67408*10^(-11);
w_orb = sqrt(M*G/(R^3));
Amin = 0.01;
rho = 2.64*10^(-12);
Fp0 = rho*Amin*(R*w_orb)^2;

open_system('nonlinear_ss_control_reg.slx');
set_param('nonlinear_ss_control_reg', 'StopTime', '1500');

% Fp
ax1 = subplot(3,1,1);
hold (ax1, 'on')
% r
ax2 = subplot(3,1,2);
hold (ax2, 'on')
% theta
ax3 = subplot(3,1,3);
hold (ax3, 'on')

% cambie esto porque nos interesa ver los angulos para la toma de decisiones
%deje el 0.04 para probar rapido, tambien podrias hacer un arreglo con N angulos
% tipo 0, 0.02, 0.04, 0.2, 0.5, 1.7, 2, 2.5, 3 o algo asi e iteras sobre
% ella, y asi no hay que esperar tanto tiempo a que acabe
angles = [0 0.2 0.5 1 2 3 6];
for i= 1:1:length(angles)
    value = angles(i);
    % aqui ya lo estoy metiendo en radianes
    set_param('nonlinear_ss_control_reg/theta_e','Value',num2str(value*pi/180));
    e = sim('nonlinear_ss_control_reg.slx');
    
    % sacamos los datos de la estructura que regresa la simulacion
    time = e.tout(:,1);
    Fp = e.data.data(:,1);
    dtheta = e.data.data(:,8);
    dr = e.data.data(:,10);
    
    % el color debe ser diferente para todos, no se si este ajuste lo haga
    % notorio. Si no puedes tratar de generarlo aleatoriamente
    plot(ax1,time,Fp,'Color',1/255*[value*100,104,87])
    plot(ax2,time,dr,'Color',1/255*[value*100,104,87])
    plot(ax3,time,dtheta,'Color',1/255*[value*100,104,87],'DisplayName',join(['e=',num2str(value),'?']))
    
    disp(100*Fp(length(Fp))/Fp0)
    
end

plot(ax2,time,zeros(length(time),1),'--')
plot(ax3,time,zeros(length(time),1),'--')

title(ax1,'Controlled propulsion with LEO drag')
ylabel(ax1, 'Fp [N]')
xlabel(ax1, 'time [s]')
ylabel(ax2, 'dr [m]')
xlabel(ax2, 'time [s]')
ylabel(ax3, 'dtheta [rad]')
xlabel(ax3, 'time [s]')

legend

hold (ax1, 'off')
hold (ax2, 'off')
hold (ax3, 'off')