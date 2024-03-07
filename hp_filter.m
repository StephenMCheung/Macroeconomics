function [ytrend,ycycle] = hp_filter(y,lambda)
%A simple code for implementing the HP filter
%y should be a column vector with T>=4 since the entries in LAMBDA is hard
%coded.

%y should be a column vector or matrix with #rows>=4, otherwise a error
%issue by Matlab will appear in Command window.

%number of rows
T = size(y,1);
if T < 4
    error('rows of series must great than 3');
end

%initialization of the coefficient matrix
mLAMBDA = zeros(T,T);

%the first 2 and lat 2 rows of LAMBDA is Hard Coded
mLAMBDA(1,1) = 1 + lambda;
mLAMBDA(1,2) = -2*lambda;
mLAMBDA(1,3) = lambda;
mLAMBDA(2,1) = -2*lambda;
mLAMBDA(2,2) = 1 + 5*lambda;
mLAMBDA(2,3) = -4*lambda;
mLAMBDA(2,4) = lambda;

for ii = 3:T-2
    mLAMBDA(ii,ii) = 1 + 6*lambda;
    mLAMBDA(ii,ii+1) = -4*lambda;
    mLAMBDA(ii,ii+2) = lambda;
    mLAMBDA(ii,ii-1) = -4*lambda;
    mLAMBDA(ii,ii-2) = lambda;
end

mLAMBDA(T,T) = 1 + lambda;
mLAMBDA(T,T-1) = -2*lambda;
mLAMBDA(T,T-2) = lambda;
mLAMBDA(T-1,T) = -2*lambda;
mLAMBDA(T-1,T-1) = 1 + 5*lambda;
mLAMBDA(T-1,T-2) = -4*lambda;
mLAMBDA(T-1,T-3) = lambda;

ytrend = mLAMBDA\y;

ycycle = y - ytrend;