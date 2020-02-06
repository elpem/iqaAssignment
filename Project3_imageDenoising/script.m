clear;

iptsetpref('ImshowInitialMagnification','fit'); %parameter for using imshow

NOISE_VAR_ARRAY = [0.0001 0.001 0.01 0.1 1 10 100]; %variance of the generated gaussian white noise
NOISE_VAR = 0.01;

I_ref = {imread('BMP images/crowd.BMP'), imread('BMP images/bank.BMP')};
number_of_methods = 2;

number_of_images = size(I_ref,2);
y1=[];
y2=[];

for i=1:number_of_images
    y2=[];
    
    I_noise = imnoise(I_ref{i}, 'gaussian', 0, NOISE_VAR); %image, noise types, mean, variance
    
    I_den1 = uint8(wdenoise2(I_noise, 'DenoisingMethod','Sure', 'ThresholdRule', 'Hard'));              %, 'ThresholdRule', 'Hard'
    I_den2 = uint8(wdenoise2(I_noise, 'DenoisingMethod','UniversalThreshold', 'ThresholdRule', 'Hard'));%, 'ThresholdRule', 'Hard'
    y1 = [y1;Image_snr(I_ref{i}, I_noise) Image_snr(I_ref{i}, I_den1) Image_snr(I_ref{i}, I_den2)];
    
    I_list = [I_ref{i},I_noise;I_den1, I_den2];
%     figure
%     montage(I_list);
    
    for j=1:size(NOISE_VAR_ARRAY, 2)
        I_noise_2 = imnoise(I_ref{i}, 'gaussian', 0, NOISE_VAR_ARRAY(j));
        I_den1_2 = uint8(wdenoise2(I_noise_2, 'DenoisingMethod','Sure', 'ThresholdRule', 'Hard'));              %, 'ThresholdRule', 'Hard'
        I_den2_2 = uint8(wdenoise2(I_noise_2, 'DenoisingMethod','UniversalThreshold', 'ThresholdRule', 'Hard'));%, 'ThresholdRule', 'Hard'
        
        y2 = [y2; Image_snr(I_ref{i}, I_noise_2) Image_snr(I_ref{i}, I_den1_2) Image_snr(I_ref{i}, I_den2_2)];
        display(y2);
    end
    figure
    semilogx(NOISE_VAR_ARRAY, y2)
    ylabel('SNR','FontSize',14)
    xlabel('Noise Variance', 'FontSize',14);
    legend('noise', 'SURE', 'UniversalThreshold', 'FontSize',14);
    set(gca,'FontSize',14)
end

disp(y1)
x = categorical({'crowd' 'bank'});
figure
bar(x,y1)
legend('noise', 'SURE', 'UniversalThreshold', 'FontSize',14)
ylabel('SNR','FontSize',14)
xlabel('image', 'FontSize',14);
set(gca,'FontSize',14)


function[s]=Image_snr(i1, i2)
    i1 = single(i1);
    i2 = single(i2);
    s = 20*log10(norm(i1(:))/norm(i1(:)-i2(:)));
end
