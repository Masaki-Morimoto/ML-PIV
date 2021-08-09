function [U_int,V_int] = UVINTPL(xp_temp,yp_temp,U_temp,V_temp)

x = xp_temp;
y = yp_temp;
U = U_temp;
V = V_temp;

dx = 1;
dy = 1;

xceil = ceil(x);
xfloor = floor(x);
yceil = ceil(y);
yfloor = floor(y);

if x-xfloor==0 % if x is an integer
    xceil = x+1;
end
if y-yfloor==0 % if y is an integer
    yceil = y+1;
end

% Bilinear Interpolation
U_int = 1/(dx*dy) * ((xceil-x)*(yceil-y)*U(yfloor,xfloor)...
                     +(xceil-x)*(y-yfloor)*U(yceil,xfloor)...
                     +(x-xfloor)*(yceil-y)*U(yfloor,xceil)...
                     +(x-xfloor)*(y-yfloor)*U(yceil,xceil));

V_int = 1/(dx*dy) * ((xceil-x)*(yceil-y)*V(yfloor,xfloor)...
                     +(xceil-x)*(y-yfloor)*V(yceil,xfloor)...
                     +(x-xfloor)*(yceil-y)*V(yfloor,xceil)...
                     +(x-xfloor)*(y-yfloor)*V(yceil,xceil));
end
