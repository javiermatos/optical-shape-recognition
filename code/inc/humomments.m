function mHu = humomments(Region)
% Invariantsmomente nach Hu, SHA0024
% Hu, M-K.: "Visual Pattern Recognition by Moment Invariants", 
% IRE Trans. Info. Theory  IT-8:179-187: 1962. 
% D.Mery, TU-Berlin, 11.07.00
% D.Mery, DCC-UC, April 2008

[Ireg,Jreg] = find(Region==1); % Pixel of the region
A   = length(Ireg);
I0  = ones(A,1);
J0  = ones(A,1);
i_m = mean(Ireg);
j_m = mean(Jreg);
I1 = Ireg - i_m*ones(A,1);
J1 = Jreg - j_m*ones(A,1);
I2 = I1.*I1;
J2 = J1.*J1;
I3 = I2.*I1;
J3 = J2.*J1;
% Zentralmomente
u00 = A; %u00 = m00 = (I0'*J0);
u002 = u00*u00;
u0025 = u00^2.5;
%u0015 = u00^1.5;
n02 = (I0'*J2)/u002;
n20 = (I2'*J0)/u002;
n11 = (I1'*J1)/u002;
n12 = (I1'*J2)/u0025;
n21 = (I2'*J1)/u0025;
n03 = (I0'*J3)/u0025;
n30 = (I3'*J0)/u0025;

mHu1 = n20+n02; 
mHu2 = (n20-n02)^2 + 4*n11^2;
mHu3 = (n30-3*n12)^2+(3*n21-n03)^2; 
mHu4 = (n30+n12)^2+(n21+n03)^2; 
mHu5 = (n30-3*n12)*(n30+n12)*((n30+n12)^2 - 3*(n21+n03)^2) + (3*n21-n03)*(n21+n03)*(3*(n30+n12)^2 - (n21+n03)^2);
mHu6 = (n20-n02)*((n30+n12)^2 - (n21+n03)^2) + 4*n11*(n30+n12)*(n21+n03);
mHu7 = (3*n21-n03)*(n30+n12)*((n30+n12)^2 - 3*(n21+n03)^2) - (n30-3*n12)*(n21+n03)*(3*(n30+n12)^2 - (n21+n03)^2);

mHu = [mHu1 mHu2 mHu3 mHu4 mHu5 mHu6 mHu7];
