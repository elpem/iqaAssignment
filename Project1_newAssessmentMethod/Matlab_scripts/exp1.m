%This script was used to perform the first experiment, in part II.B of the
%assignment.

%IMPORT IMAGES AND GATHER ERROR INFORMATIONS
Iref = imread('BMP images/hat.BMP');

errBlure = sol(imread('BMP images/hatblure.BMP'),Iref);
errScratch = sol(imread('BMP images/hatscratch.BMP'),Iref);
errComp = sol(imread('BMP images/hatjpeg.BMP'),Iref);

%ORDER RESULTS
x = categorical({' no process' 'derivative' 'highpass filter' 'DFT'});

%NB. we use some coefficients here to bring forward DFT and raw error
%values, in order to have more visual results.
y1=[errBlure(1) errScratch(1) errComp(1)]*5;
y2=[errBlure(2) errScratch(2) errComp(2)];
y3=[errBlure(3) errScratch(3) errComp(3)];
y4=[errBlure(4) errScratch(4) errComp(4)]*1000;
y=[y1;y2;y3;y4];

%SHOW RESULTS
figure
bar(x,y)
legend('blur', 'scratch', 'compressed', 'FontSize',14)
ylabel('MSE','FontSize',14)
xlabel('process', 'FontSize',14)
title('MSE depending the type of image dafault and the kind of process used');


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