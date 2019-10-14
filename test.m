% load('BMP images/baboon.BPM');
Iref = imread('BMP images/hat.BMP');
I = imread('BMP images/hatjpeg.BMP');
% imshow(I)
% figure
% imhist(I);

% I2 = histeq(I);
% figure
% imshow(I2);


% figure
% imshow(I);

%ORIENTATION
% figure
% imshow(I');

%FILTER HIGHPASS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m=[-1 -2 -1; -2 12 -2; -1 -2 -1]*1; %HIGHPASS FILTER
%m=[1,1,1;1,1,1;1,1,1]*1/16; %LOWPASS FILTER
Iref_f = imfilter(Iref, m);
I_f = imfilter(I, m);
figure
imshowpair(Iref_f,I_f,'montage')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%DFT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Iref_dft = fftshift(fft2(Iref));
% Iref_dft = log(1+abs(Iref_dft));
% I_dft = fftshift(fft2(I));
% I_dft = log(1+abs(I_dft));
% 
% figure
% imshowpair(Iref,I,'montage')
% figure
% imshowpair(Iref_dft,I_dft,'montage')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% COLOR/GRAY SCALE PLAY ON
% Iinv = 255-I;
% fprintf("PSNR I/I : %f\n",psnr(I, I));
% fprintf("PSNR I/Iinv : %f\n",psnr(I, Iinv));
% figure
% imshow(Iinv);
% figure
% imshow(2*I);
% figure
% imshow(I.*I);

%DERIVATIVE
%   k  = [0.030320  0.249724  0.439911  0.249724  0.030320];
%   d  = [0.104550  0.292315  0.000000 -0.292315 -0.104550];
%   d2 = [0.232905  0.002668 -0.471147  0.002668  0.232905];

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   k  = [ 0.004711  0.069321  0.245410  0.361117  0.245410  0.069321  0.004711];
%   d  = [ 0.018708  0.125376  0.193091  0.000000 -0.193091 -0.125376 -0.018708];
%   d2 = [ 0.055336  0.137778 -0.056554 -0.273118 -0.056554  0.137778  0.055336]; 
%   Iu = conv2(d,k,I,'same');  % derivative vertically (wrt Y)
%   Iv = conv2(k,d,I,'same');  % derivative horizontally (wrt X)
%   Irefu = conv2(d,k,Iref,'same');  % derivative vertically (wrt Y)
%   Irefv = conv2(k,d,Iref,'same');  % derivative horizontally (wrt X)
%   
%   figure
%   imshowpair(Iref,I,'montage')
%   figure
%   imshowpair(Irefu,Iu,'montage')
%   figure
%   imshowpair(Irefv,Iv,'montage')
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
% M = [1,-3,3,-1; -1,4,-5,2; 0,1,0,-1; 0,0,2,0]*0.5;
% u = [0.125;0.25;0.5;1];
% up = [0.75;1;1;0];
% d = up'*M;
% k = u'*M;
% Iu = conv2(conv(d,k),conv(k,k),I,'same');  % vertical derivative (wrt Y)
% Iv = conv2(conv(k,k),conv(d,k),I,'same');  % horizontal derivative (wrt X)
% figure
% imshow(I);
% figure
% imshow(Iu);
% figure
% imshow(Iv);

% [Gx,Gy] = imgradientxy(I);
% imshowpair(Gx,Gy,'montage')
% title('Directional Gradients Gx and Gy, Using Sobel Method')

%DEFORMATION
% figure
% imshow(I);
% B=uint8(zeros(size(I*2)));
% for i=1:size(I,1)
%     for j=1:size(I,2)
%         B(i,j*2,:)=I(i,j,:);
%     end
% end
% figure
% imshow(B);

%TRESHOLD
% figure
% imshow(I);
% B=uint8(zeros(size(I)));
% for i=1:size(I,1)
%     for j=1:size(I,2)
%         if I(i,j,:)>125
%             B(i,j,:)=255;
%         end
%     end
% end
% figure
% imshow(B);
        
  