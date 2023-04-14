clc; clear all;

NACA_profile = 4410;

T = mod(NACA_profile, 100);
P = (mod(NACA_profile, 1000) - T)/100;
M = (NACA_profile-100*P-T)/1000;

M = M/100;
P = P/10;
T = T/100;

num_points = 100;

x = linspace(0, 1,  num_points);
x_low = x(x<P);
x_high = x(x>=P);

%% Camber line
y_c_low = (M/P^2) * (2*P*x_low - x_low.^2);
y_c_high = (M/(1-P)^2) * (1 - 2*P + 2*P*x_high - x_high.^2);

y_c = [y_c_low, y_c_high];

%% Derivatives
dyc_dx_low = (2*M/P^2) * (P-x_low);
dyc_dx_high = (2*M/(1-P)^2) * (P-x_high);

dyc_dx = [dyc_dx_low, dyc_dx_high];
theta = atan(dyc_dx);


%% Thickness
a0 = 0.2969;
a1 = -0.1260;
a2 = -0.3516;
a3 = 0.2843;
a4 = -0.1015;

y_t = 5*T*(a0*x.^0.5 + a1*x + a2*x.^2 + a3*x.^3 + a4*x.^4);

%% Coordinates
x_u = x - y_t.*sin(theta);
y_u = y_c + y_t.*cos(theta);
x_l = x + y_t.*sin(theta);
y_l = y_c - y_t.*cos(theta);

%% Plots
figure('Name', "NACA "+int2str(NACA_profile))
hold on;
plot(x, y_c, "b");
plot(x_u, y_u, "k");
plot(x_l, y_l, "k");
xlim([0 1]);
ylim([-0.5 0.5]);

%% Dat
dat_profile = [x_u x_l; y_u y_l]';

