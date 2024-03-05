// Example mod file to solve DSGE model
// Created by Thomas Drechsel, University of Maryland
// ECON 747, 2021
// Need to fill parts marked with < >

// Variables block 
var <list variable names here>;
varexo <list names of exogenous shocks here>;

// Parameters block
parameters <list parameter names here>;

<assign parameter values here>
<e.g. alpha = 0.36;>

// Model block
model;

<list equations here>
<(-1) is predetermined>
<(+1) is expectation>

end;

// Steady state block

<Option 1: let Dynare calculate the steady state>
initval;
<list initial values for all variables here>
end;

<Option 2: create m-file with same name as mod file + "_steadystate">
steady;
check;

// Shocks block
shocks;
var <shock name here>; stderr <parameter for standard deviations here>;
end;

// Solution block 
stoch_simul(order=1,IRF=20) ;