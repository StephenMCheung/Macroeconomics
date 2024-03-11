%This file replicates CEE2005 (without implementing the lag expectations everywhere).
%Roberto Croce, Ohio State University
%Columbus, Ohio
%April 2009

%a * indicates that the variable was present in the 13 variable system from the paper

var 
pi   %inflation                                                              *
s    %real marginal cost																													 
qbar %transaction money / m1																								 *
q    %real transaction money
r    %nominal interest rate                                                  *
m    %total money supply / m2                                                *
mu   %money growth rate
psi  %marginal utility of consumption                                        * 
c    %consumption                                                            *
wbar %wage 
w    %real wage
p_ki %marginal product of capital in marginal utility terms                  *
l    %labor                                                                  *
h    %habit                                                                  *
kbar %capital stock																													 *
k    %capital services                  																		 *
i    %capital investment                                                     * 
y    %output
u    %capacity utilization
rk   %return to capital

; 




varexo eR;

parameters 
R 			%steady state nominal ir 
beta		%discount rate
alph		%labor share of production
delt		%capital depreciation rate 
b_w			%simplifying parameter 
xi_p    %price stickiness
xi_w		%wage stickiness 
lam_w   %household labor market power
mubar   %steady state money growth rate
mbar    %steady state m2 
qbar_ss %steady state m1 
wbar_ss %steady state wage
lbar    %steady state labor supply
b       %habit parameter 1
chi     %habit parameter 2
sig_c   %simplies labor supply decision Euler
sig_a   %relates capacity utilization to return on capital
sig_q   %relates cash holding and the interest rate
mc      %steady state marginal cost (1/markup) 
K_Y     %steady state capital-ouput ratio
K_H     %steady state capital-labor ratio
Y_H     %steady state output-labor ratio 
C_Y     %steady state consumption output ratio 
rho_r   %interest rate smooting policy parameter 
rho_pi  %taylor rule inflation response
rho_y   %taylor rule output response
X       %reciprocal of the elasticity of investment wrt current price of installed capital
;


%------------------------------------------------------------------------------------------%
%                                 PARAMETERS                                               % 
%------------------------------------------------------------------------------------------%

%1)PREFERENCES
%(intertemporal elasticity of sub. in C = 1)
b =0.63;                  % degree of habit persistence
beta = 1.03^(-1/4);       % subjective discount factor
R = 1/beta;               % steady state nominal rate
psi0 =1;                  % marginal disutility of hours
chi = 0.0;                % habit parameter 2

%2)TECHNOLOGY
alph = 0.36;              % share of capital
delt = 0.025;            % depreciation rate

%3)CALVO PARAMETERS
xi_w = 0.70;              %on wages
xi_p = 0.50;              %on prices

%4)INDEXATION
lam_w =1.05;              %household labor market power           
lam_f =1.45;              %firm market power

%5)ELASTICITIES OF SUBSTITUTIONS
eta      = 6;           % price-elasticity of demand for a differianted good
mc  = (eta-1)/eta;      % marginal cost

%6) OTHER CALIBRATIONS
lbar = 1;                                  % steady state labor supplied by households
sig_a = 0.01;                              %
mubar = 1.017;                             % steady state money growth rate, calibrated post ww2
qbar_ss = mubar*(1-0.36/(beta*(1-alph)));  % steady state M1
mbar = (1/0.44)*qbar_ss;                      % steady state M2
sig_q = 9.966;
X = (1/0.28);
%------------------------------------------------------------------------------------------%
%                          STEADY STATE RATIOS and VALUES                                  % 
%------------------------------------------------------------------------------------------%

%underscore denotes a ratio
%2)ENDOGENOUS VALUES
rk_bar = (1/beta-1+delt);                                                         %steady state capital rental rate
K_H    = mc^(1/(alph*(1-alph)))*(rk_bar/alph)^(1/(alph-1));                       %capital-labor ratio
Y_H    = (K_H)^alph;                                                              %output-labor ratio
K_Y    = K_H/Y_H;                                                                 %capital-output ratio                
C_Y    = 1-delt*K_Y;                                                              %consumption_output ratio
I_Y    = delt*K_Y;       																											    %investment over output
//wbar_ss   = (1-alph)/alph*(K_H)*rk_bar;                                                      
wbar_ss = mc^(1/(1-alph))*(1-alph)*alph^(alph/(1-alph))*rk_bar^(alph/(alph-1))/R; %steady state wage
                                                                               
%------------------------------------------------------------------------------------------%
%                           Simplifying Parameters                                         %
%------------------------------------------------------------------------------------------%

b_w = (2*lam_w - 1)/((1-xi_w)*(1-beta*xi_w)); 

sig_c = (1-chi)/(1-chi-b)*(1-beta*chi)/(1-beta*chi-beta*b);




%------------------------------------------------------------------------------------------%
%                                MONETARY RULE                                             % 
%------------------------------------------------------------------------------------------%
rho_pi = 1.5;                     % monetary rule parameter (on inflation)
rho_y  = 0.5;                     % monetary rule parameter (on output) 
rho_r  = 0.8;                     % monetary rule parameter (on lagged interest rate)




model(linear);
%inflation Euler
pi = (1/(1+beta))*pi(-1) + (beta/(1+beta))*pi(+1) + ((1-beta*xi_p)*(1-xi_p)/((1+beta)*xi_p))*s;

%money demand
q = (-1/sig_q)*(R/(R-1)*r + psi);

%household labor decision
0=w(-1) - ((b_w*(1+beta*xi_w^2)-lam_w)/(b_w*xi_w))*w + beta*w(+1) + (beta*(pi(+1) - pi)
				 - (pi - pi(-1))) + ((1-lam_w)/(b_w*xi_w))*(psi-l);

%household borrowing/lending Euler
psi(+1) + r(+1) - pi(+1) - psi = 0;

%def of capacity utilization
u = k(-1) - kbar(-1);

%return on capital
rk = w + r + l - k;

%household consumption Euler
0 = -p_ki - psi + psi(+1) + (1-beta*(1-delt))*(rk(+1)) + beta*(1-delt)*p_ki(+1);
                                           
(1/beta - (1-delt))*(K_Y/C_Y)*u + c + delt*(K_Y/C_Y)*i = (alph/C_Y)*k + ((1-alph)/C_Y)*l;

%loan market clearing
mubar*mbar*(mu + m) - qbar_ss*q - wbar_ss*lbar*(w + l)=0;

%money growth relationship to the inflation rate
m - m(-1) - mu(-1) + pi= 0;

%habit formation
h - chi*h(-1) - (1-chi)*c(-1) = 0;

-beta*chi*psi(+1) + sig_c*(c - h*b/(1-chi)) - (b+chi)*beta*sig_c*(c(+1) - h(+1)*b/(1-chi)) + psi=0;

p_ki = X*(i - i(-1) - beta*(i(+1)-i));

kbar = (1-delt)*kbar(-1) + delt*i;

u -(1/sig_a)*rk = 0;

r = (1-rho_r)*(rho_pi*pi(-1) + rho_y*y(-1)) +rho_r*r(-1) - eR;

s = alph*rk + (1-alph)*(w + r);

y = alph*k(-1) + (1-alph)*l; 

qbar = q + pi;

wbar = w + pi;
   

end;

steady;
check;

shocks;
var eR; stderr 0.6;
end;

stoch_simul(order=1,irf=20);

