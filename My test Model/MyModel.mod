var y I k a c w R r;

varexo e;

parameters alph bet del rho sig sA;

bet = 0.99; 
alph = 1/3; 
sig = 1; 
sA = 0.01; 
rho = 0.9; 
del = 0.025;

model;

exp(c)^(-sig) = bet*exp(c(+1))^(-sig)*(alph*exp(a(+1))*exp(k)^(alph-1)+(1-del));
exp(y) = exp(a)*exp(k(-1))^alph;
exp(k) = exp(a) * exp(k(-1))^(alph) - exp(c) + (1-del) * exp(k(-1));
a = rho * a(-1) + sA * e;
exp(y) = exp(c) + exp(I);
exp(c)^(-sig) = bet * exp(c(+1))^(-sig) * (1+r);
exp(R) = alph * exp(a) * exp(k(-1))^(alph-1);
exp(w) = (1-alph) * exp(a) * exp(k(-1))^(alph);

end;

steady;

check;

shocks;
var e = sA^2;
end;

stoch_simul(order=1,irf=20) ;