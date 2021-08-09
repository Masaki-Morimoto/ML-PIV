function [I,xp,yp,I0] = F_make_API(nx,ny,nz,sigma,dp,n)

% Intensity of each pixels

xp = zeros(n,1);
yp = zeros(n,1);
zp = zeros(n,1);
I0 = zeros(n,1);

%-----------------------------------------------------------------%
%                  Set random location of particles               %
%-----------------------------------------------------------------%
for i=1:n % summation in number of particles
    xp(i,1) = rand*nx; % 0-nx random
    yp(i,1) = rand*ny; % 0-ny random
    zp(i,1) = rand*nz; % 0-nz random
    I0(i,1) = 0.06*exp(-zp(i,1)^2/sigma^2); % maximum intensity
end
for i=1:n
    while xp(i)<1
        xp(i) = rand*nx;
    end
end
for i=1:n
    while yp(i)<1
        yp(i) = rand*ny;
    end
end
% xp and yp are random nubers between 1-nx,1-ny
%=================================================================%

[I] = F_intensity(xp,yp,I0,dp,n,nx,ny);

end
