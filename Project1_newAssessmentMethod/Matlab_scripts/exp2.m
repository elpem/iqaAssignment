%This script was used to perform the second experiment of our assssignment.
%It was use in part IV.C of the assignment

%DEFINE COEFFICIENTS
% All those coeffiecient vectors were chosen by hand to highlight different
% image alteration types.
% The coefficients are respectively applied for:
% [Row(no Process), Derivative, High pass filter, DFT]
coef = [1; 1/2; 1/2; 1000];     %neutral
%coef = [-5/2; 0; 0; 1000];     %highlights blur error
%coef = [-2; 1/2; 1/2; 0];      %highlights compressing error
%coef = [1; 0; -1/16; 0];       %highlights scratch error

%IMPORT IMAGES
Iref = imread('BMP images/hat.BMP');
I = [imread('BMP images/hatblure.BMP') imread('BMP images/hatscratch.BMP') imread('BMP images/hatjpeg.BMP')];

finalDetailedScore = [0 0 0 0; 0 0 0 0; 0 0 0 0];
finalScore = [0 0 0];

%COMPUTE ERRORS
for i = 1:3
    infBound = (i-1)*size(Iref,1)+1;
    supBound = (i)*size(Iref,1);
    %imshow(I(:,infBound:supBound));
    rawErr = sol(I(:,infBound:supBound),Iref);
    for j = 1:4
        finalDetailedScore(i,j) = rawErr(j)*coef(j);
    end
    finalScore(i) = rawErr*coef;
end
x = categorical({'blur' 'scratch' 'compressed'});

%SHOW RESULTS
figure(1)
bar(x,finalDetailedScore, 'stacked')
legend('raw', 'deriv', 'highpass', 'DFT', 'FontSize',14)
ylabel('MSE','FontSize',14)
xlabel('type', 'FontSize',14)
title('MSE depending on image alteration type, with a given coefficient set with detailed proportion of each process linked error')
set(gca,'FontSize',14);

figure(2)
bar(x,finalScore)
ylabel('MSE','FontSize',14)
xlabel('type', 'FontSize',14)
title('MSE depending on image alteration type, with a given coefficient set')
set(gca,'FontSize',14);

%ELEMENTARY BRICKS PROCESSING
function [err] = sol(I, Iref)
    %PROCESSING
    %process 1: derivative
    [Gxref,Gyref] = imgradientxy(Iref);
    [Gx,Gy] = imgradientxy(I);
    
    %process 2: highpass filter
    %The filter has been visualy chosen to highlight as much defaults as
    %possible.
    m=[-1 -2 -1; -2 12 -2; -1 -2 -1]*1; %HIGHPASS FILTER
    Iref_f = imfilter(Iref, m);
    I_f = imfilter(I, m);

    %process 3: dft
    %The dft is computed in order to be normalized and be able to highlight
    %some defaults.
    Iref_dft = fftshift(fft2(Iref));
    Iref_dft = log(1+abs(Iref_dft));
    I_dft = fftshift(fft2(I));
    I_dft = log(1+abs(I_dft));

    %COMPARING: MSE
    errRef = immse(I, Iref);
    err_deriv = immse(Gx, Gxref);
    err_f = immse(I_f, Iref_f);
    err_dft = immse(I_dft, Iref_dft);

    %RESULT
    err=[errRef err_deriv err_f err_dft];
end