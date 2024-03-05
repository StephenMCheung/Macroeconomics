function [ys,params,check] = MyModel_steadystate(ys,exo,M_,options_)

NumberOfParameters = M_.param_nbr;
for ii = 1:NumberOfParameters
  paramname = M_.param_names{ii};
  eval([ paramname ' = M_.params(' int2str(ii) ');']);
end

check = 0;

K = (alph/(1/bet - (1-del)))^(1/(1-alph)); 
Y = K^(alph); 
II = del * K; 
C = Y - II; 
a = 0; 
W = (1-alph) * K^(alph); 
RR = alph * K^(alph-1); 
r = (1/bet) - 1;
k = log(K);
y = log(Y);
I = log(II);
c = log(C);
w = log(W);
R = log(RR);


params=NaN(NumberOfParameters,1);
for iter = 1:length(M_.params) %update parameters set in the file
  eval([ 'params(' num2str(iter) ') = ' M_.param_names{iter} ';' ])
end

NumberOfEndogenousVariables = M_.orig_endo_nbr; %auxiliary variables are set automatically
for ii = 1:NumberOfEndogenousVariables
  varname = M_.endo_names{ii};
  eval(['ys(' int2str(ii) ') = ' varname ';']);
end


end