%----------------------------------------------------------%
% Making artificial particle images for PIV image modeling %
%----------------------------------------------------------%

% function files
%   - F_intensity.m
%   - F_make_API.m
%   - RK3.m
%   - UVINTPL.m


% required data and image
%
%   - numerical velocity data {u,v}
%       - "veloctiy_U-%04d.csv"
%       - "veloctiy_V-%04d.csv"
%
%   - reference experimental image for histogram matching
%       - "reference_experimental-image.png"


% MADE:2019/11/15, LAST REVISED:2021/8/9
% contact : masaki.morimoto@kflab.jp

%%
clear
close all
disp('code started')
%% Load DNS data

numfiles = 500;                  % No. of files to import
y_num=140; x_num=140; z_num=160; % DNS data size

U_temp = zeros(x_num, y_num, z_num);
V_temp = zeros(x_num, y_num, z_num);

U = zeros(y_num, x_num, z_num, numfiles);
V = zeros(y_num, x_num, z_num, numfiles);

%-----------------------DATA LOAD-----------------------%
for l = 1:numfiles
    currentCSV_u = sprintf('veloctiy_U-%04d.csv',l);
    A = load(currentCSV_u);
    U_temp(:,:,:) = reshape(A,x_num,y_num,z_num);
    U(:,:,:,l) = permute(U_temp,[2,1,3]);
    disp(l);
end
disp('DNS-U loaded')
for l = 1:numfiles
    currentCSV_v = sprintf('velocity_V-%04d.csv',l);
    B = load(currentCSV_v);
    V_temp(:,:,:) = reshape(B,x_num,y_num,z_num);
    V(:,:,:,l) = permute(V_temp,[2,1,3]);
    disp(l);
end
disp('DNS-V loaded')
clearvars A B U_temp V_temp
%-------------------------------------------------------%

%% Parameters of API
gpf = 1;
nx = x_num; % pixel
ny = y_num; % pixel
nz = 17;    % pixel

% configurations
sigma = 1;   % 2*sigma = thickness of the laser-sheet (pixel)
dp = 2;      % diameter of the particle (pixel)
n = 7*nx*ny; % No. of particles

%% Make aritificial particle images

NUM = 0;
disp('before for loop')
for zz=1:20
    for k=1:numfiles
        [I_temp,xp_now,yp_now,I0_now] ...
            = F_make_API(nx,ny,nz,sigma,dp,n); % "F_make_API.m" make initial API
        %-----------------------------------%
        % set initial location of particles %
        %-----------------------------------%
        xp_new = zeros(n,2);
        yp_new = zeros(n,2);
        zp_new = zeros(n,2);
        I0_new = zeros(n,2);
        for i=1:n
            % insert initial random location to 1st column
            xp_new(i,1) = xp_now(i); 
            yp_new(i,1) = yp_now(i);
            I0_new(i,1) = I0_now(i);
        end
        
        for i=1:n
            %------------------------------------------------------------%
            %                         MAIN STEP                          %
            %------------------------------------------------------------%


            %-----substitute current x,y,U and V to temporal values------%
            xp_temp = xp_new(i,1);
            yp_temp = yp_new(i,1);
            U_temp = U(:,:,zz,k);
            V_temp = V(:,:,zz,k);
            %------------------------------------------------------------%


            %----------------------calculate U,V at (x_n,y_n)----------------------%
            [U_itpl,V_itpl] ...
                = UVINTPL(xp_temp,yp_temp,U_temp,V_temp); % "UVINTPL.m"
            %----------------------------------------------------------------------%


            %--------calculate UV at (x_n+1,y_n+1) by 3rd order Runge-Kutta--------%
            [xp_nextSTEP, yp_nextSTEP] ...
                = RK3(xp_temp,yp_temp,U_itpl,V_itpl,U_temp,V_temp,nx,ny,gpf) % "RK3.m"
            %----------------------------------------------------------------------%


            %---------------------------set next position--------------------------%
            xp_new(i,2) = xp_nextSTEP; % to dimension of CS
            yp_new(i,2) = yp_nextSTEP;
            zp_new(i,2) = zp_new(i,1); % location in z direction is fixed
            I0_new(i,2) = I0_new(i,1);
            %----------------------------------------------------------------------%


            %---move partciles at the inlet of the image which exceed the region---%
             if xp_new(i,2) > x_num
                 xp_new(i,2)=1;
                 yp_new(i,2)=rand*ny;
                 zp_new(i,2)=rand*nz;
             end
            %----------------------------------------------------------------------%
         end

        xp_next = xp_new(:,2);
        yp_next = yp_new(:,2);
        I0_next = I0_new(:,2);
        [I_tPLUS1] = F_intensity(xp_next,yp_next,I0_next,dp,n,nx,ny);

        %-----------------match histogram using 'imhistmatch'-----------------%
        Ref = imread('reference_experimental-image.png');
        Ref_grayscale = rgb2gray(Ref); % rgb to grayscale image

        I_temp_AM = imhistmatch(I_temp, Ref_grayscale); % histogram matching
        I_tPLUS1_AM = imhistmatch(I_tPLUS1, Ref_grayscale); % histogram matching
        %---------------------------------------------------------------------%

        % summation of two particle images
        I_WE_temp = zeros(y_num, x_num);
        I_WE_temp = I_temp_AM+I_tPLUS1_AM;
        
        %-------------------------show each API-------------------------------%
        fig1 = figure('visible','off');
        imshow(I_temp_AM)
        axis equal

        fig2 = figure('visible','off');
        imshow(I_tPLUS1_AM)
        axis equal
        %----------------------------------------------------------%
        
        %--------------Save summed up API as CSV file--------------%
        currentFigCSV = sprintf('API-%05d.csv',NUM+k);
        csvwrite(currentFigCSV,I_WE_temp)
        %----------------------------------------------------------%
        disp(NUM+k)
    end
    NUM = NUM+500;
end
disp('end of the calculation')
