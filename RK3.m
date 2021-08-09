function [x_nPLUS1, y_nPLUS1] ...
    = RK3(xp_temp,yp_temp,U_itpl,V_itpl,U_temp,V_temp,nx,ny,gpf)

% Runge-Kutta (3rd order)

x_n = xp_temp;
y_n = yp_temp;
U_n = U_itpl;
V_n = V_itpl;
U = U_temp;
V = V_temp;

gamma1 = 8/15;
gamma2 = 5/12;
gamma3 = 3/4;
zeta2 = -17/60;
zeta3 = -5/12;

for f=1
    %----------------------1st STEP (n+8/15)------------------------%
    x_1stSTEP = x_n + gamma1*gpf*U_n;
    y_1stSTEP = y_n + gamma1*gpf*V_n;
    if y_1stSTEP<1 || y_1stSTEP>ny || x_1stSTEP>nx || x_1stSTEP<1
        x_nPLUS1 = x_1stSTEP;
        y_nPLUS1 = y_1stSTEP;
        break
    else
    [U_1stSTEP,V_1stSTEP] = UVINTPL(x_1stSTEP,y_1stSTEP,U,V);
    end
    %---------------------------------------------------------------%

    %-----------------------2nd STEP (n+2/3)------------------------%
    x_2ndSTEP = x_1stSTEP + gamma2*gpf*U_1stSTEP + zeta2*gpf*U_n;
    y_2ndSTEP = y_1stSTEP + gamma2*gpf*V_1stSTEP + zeta2*gpf*V_n;
    if y_2ndSTEP<1 || y_2ndSTEP>ny || x_2ndSTEP>nx || x_2ndSTEP<1
        x_nPLUS1 = x_2ndSTEP;
        y_nPLUS1 = y_2ndSTEP;
        break
    else
    [U_2ndSTEP,V_2ndSTEP] = UVINTPL(x_2ndSTEP,y_1stSTEP,U,V);
    end
    %---------------------------------------------------------------%

    %-----------------------Final STEP (n+1)------------------------%
    x_nPLUS1 = x_2ndSTEP + gamma3*gpf*U_2ndSTEP + zeta3*gpf*U_1stSTEP;
    y_nPLUS1 = y_2ndSTEP + gamma3*gpf*V_2ndSTEP + zeta3*gpf*V_1stSTEP;
    %---------------------------------------------------------------%
end
end