function [I] = F_intensity(xp,yp,I0,dp,n,nx,ny)

%------------Set background image-----------(DO NOT USE 'whitebg'%
I = zeros(ny,nx); % rows:ny column:nx
I(:,:) = 0;       % color of the background image 0(black)-1(white)
%------------------------------------------------------------------%

%-----------------------------------------------------------------%
%           Calculate the intensity of each particle              %
%-----------------------------------------------------------------%
cArea = 5; % calculation area
for i=1:n  % summation in number of particles
    for xi=1:nx
        if xi <= xp(i,1)-cArea
            continue
        elseif xi >= xp(i,1)+cArea
            continue
        else
            for yi=1:ny
                if yi <= yp(i,1)-cArea
                    continue
                elseif yi >= yp(i,1)+cArea
                    continue
                else
                    I(yi,xi) = I(yi,xi) + ...
                        I0(i,1)*exp(-((xi-xp(i,1))^2+(yi-yp(i,1))^2)...
                        /(dp/2)^2); % Gaussian dist.
                end
            end
        end
    end
end
I = flipud(I);
%=================================================================%
end