clear
clc

rng(1)

%% PARAMETERS

N = 6;
M = 6;
NUM_TESTS = 10;

FRAC  = 16;
SCALE = 2^FRAC;

%% OPEN FILES

fx  = fopen('x_input.mem','w');
fz  = fopen('z_input.mem','w');

fF  = fopen('F_input.mem','w');
fH  = fopen('H_input.mem','w');

fQ  = fopen('Q_input.mem','w');
fR  = fopen('R_input.mem','w');

fP  = fopen('P_input.mem','w');

fxp = fopen('x_pred.mem','w');
fpp = fopen('P_pred.mem','w');

fy  = fopen('y.mem','w');
fS  = fopen('S.mem','w');
fK  = fopen('K.mem','w');

fxg = fopen('x_golden.mem','w');
fPg = fopen('P_golden.mem','w');

%% LOOP THROUGH TESTS

for t = 1:NUM_TESTS

%% ========================
%% FIXED-POINT INPUTS (Q16.16)
%% ========================

x = int32(randi([-100 100],N,1) * SCALE);
z = int32(randi([-100 100],M,1) * SCALE);

F = int32(randi([-5 5],N,N) * SCALE);
H = int32(randi([-5 5],M,N) * SCALE);

Q = int32(randi([-2 2],N,N) * SCALE);
R = int32(randi([-2 2],M,M) * SCALE);

P = int32(randi([-10 10],N,N) * SCALE);

%% CONVERT TO DOUBLE FOR SAFE MATH

Fd = double(F);
Hd = double(H);
Pd = double(P);

xd = double(x);
zd = double(z);

Qd = double(Q);
Rd = double(R);

%% ========================
%% KALMAN STAGES (Q16.16)
%% ========================

% 1. State Prediction
x_pred = int32((Fd * xd) / SCALE);

% 2. Covariance Prediction
P_pred = int32((Fd * Pd * Fd') / SCALE + Qd);

% 3. Innovation
y = int32(zd - (Hd * double(x_pred)) / SCALE);

% 4. Innovation Covariance
S = int32((Hd * double(P_pred) * Hd') / SCALE + Rd);

% Prevent division by zero
for i = 1:N
    if S(i,i) == 0
        S(i,i) = SCALE;
    end
end

% 5. Kalman Gain (diagonal approximation)
K = zeros(N,N);

for i = 1:N
    for j = 1:N
        K(i,j) = int32(((double(P_pred(i,j)) * SCALE) / double(S(j,j))));
    end
end

% 6. State Update
x_new = int32(double(x_pred) + (double(K) * double(y)) / SCALE);

% 7. Covariance Update
I = eye(N) * SCALE;

P_new = int32((I - (double(K)*Hd)/SCALE) * double(P_pred) / SCALE);

%% ========================
%% WRITE INPUTS
%% ========================

write_vector(fx,x)
write_vector(fz,z)

write_matrix(fF,F)
write_matrix(fH,H)

write_matrix(fQ,Q)
write_matrix(fR,R)
write_matrix(fP,P)

%% ========================
%% WRITE STAGES
%% ========================

write_vector(fxp,x_pred)
write_matrix(fpp,P_pred)

write_vector(fy,y)
write_matrix(fS,S)

write_matrix(fK,K)

%% ========================
%% WRITE FINAL OUTPUTS
%% ========================

write_vector(fxg,x_new)
write_matrix(fPg,P_new)

end

%% CLOSE FILES

fclose('all');

disp('Q16.16 dataset generated successfully')

%% ========================
%% HELPER FUNCTIONS
%% ========================

function write_vector(fid,v)

for i=1:length(v)

val = typecast(int32(v(i)),'uint32');

fprintf(fid,'%08X\n',val);

end

end


function write_matrix(fid,m)

[r,c] = size(m);

for i=1:r
for j=1:c

val = typecast(int32(m(i,j)),'uint32');

fprintf(fid,'%08X\n',val);

end
end

end