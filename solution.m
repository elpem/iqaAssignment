
%IMPORT
Iref = imread('BMP images/hat.BMP');
I = [imread('BMP images/hatblure.BMP') imread('BMP images/hatscratch.BMP') imread('BMP images/hatjpeg.BMP')];

sol(imread('BMP images/hatscratch.BMP'),Iref);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%   OUR IQA METHOD   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The coefficient are respectively applied for:
%Row(no Process), Derivative, High pass filter, DFT
coef = [1; 1/2; 1/2; 1000]; %neutral
%coef = [-5/2; 0; 0; 1000]; %highlights blur error
%coef = [-2; 1/2; 1/2; 0]; %highlights compressing error
%coef = [1; 0; -1/16; 0]; %highlights scratch error

finalDetailedScore = [0 0 0 0; 0 0 0 0; 0 0 0 0];
finalScore = [0 0 0]

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

figure
bar(x,finalDetailedScore, 'stacked')
legend('raw', 'deriv', 'highpass', 'DFT', 'FontSize',14)
ylabel('MSE','FontSize',14)
xlabel('type', 'FontSize',14);
set(gca,'FontSize',14)

figure
bar(x,finalScore)
ylabel('MSE','FontSize',14)
xlabel('type', 'FontSize',14);
set(gca,'FontSize',14)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%   EXPERIMENT PART II.B   %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% errBlure = sol(imread('BMP images/hatblure.BMP'),Iref);
% errScratch = sol(imread('BMP images/hatscratch.BMP'),Iref);
% errComp = sol(imread('BMP images/hatjpeg.BMP'),Iref);
% 
% 
% x1 = categorical({' no process' 'derivative' 'highpass filter' 'DFT'});
% 
% y1=[errBlure(1) errScratch(1) errComp(1)]*5;
% y2=[errBlure(2) errScratch(2) errComp(2)];
% y3=[errBlure(3) errScratch(3) errComp(3)];
% y4=[errBlure(4) errScratch(4) errComp(4)]*1000;
% y5=[y1;y2;y3;y4];
% 
% figure
% bar(x1,y5,1)
% legend('blur', 'scratch', 'compressed', 'FontSize',14)
% ylabel('MSE','FontSize',14)
% xlabel('process', 'FontSize',14);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ELEMENTARY BRICKS PROCESSING
function [err] = sol(I, Iref)
    %PROCESSING
    %process 1: derivative
    [Gxref,Gyref] = imgradientxy(Iref);
    [Gx,Gy] = imgradientxy(I);
    
    %process 2: highpass filter
    m=[-1 -2 -1; -2 12 -2; -1 -2 -1]*1; %HIGHPASS FILTER
    %m=[1 1 1; 1 1 1; 1 1 1]*1/2500; %LOWPASS FILTER
    Iref_f = imfilter(Iref, m);
    I_f = imfilter(I, m);

    %process 3: dft
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