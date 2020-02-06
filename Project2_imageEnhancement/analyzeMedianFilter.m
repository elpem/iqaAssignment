%N.B. in this test, we use the pre implemented median filtering solution
%because our solution is too slow.

MSE(17,4)=0;

for i=1:25 %25 images
    name = sprintf('I%s',goodCount(i));
    Iref = imread(sprintf('TID/reference_images/%s.BMP',name));
    Iref = rgb2gray(Iref);
    
    for j=1:17 %17 effects
        for k=1:4 %4 effect strengths
            dname = sprintf("%s_%s_%d",name, goodCount(j), k);
            Icurrent = imread(sprintf('TID/distorted_images/%s.BMP', dname));
            Icurrent = rgb2gray(Icurrent);
            
            MSE(j,:) = MSE(j,:) + test(Iref, Icurrent);
        end
        fprintf("please wait: %f \n",(((k-1)+4*(j-1)+17*4*(i-1))/1700))
    end
end

%SHOW RESULTS
MSE = MSE/1700;
x = categorical({'Additive Gaussian noise' 
    'Additive noise in color components'
    'Spatially correlated noise' 
    'Masked noise' 
    'High frequency noise' 
    'Impulse noise' 
    'Quantization noise' 
    'Gaussian blur' 
    'Image denoising'
    'JPEG compression' 
    'JPEG2000 compression' 
    'JPEG transmission errors' 
    'JPEG2000 transmission errors' 
    'Non eccentricity pattern noise' 
    'Local block-wise distortions of different intensity' 
    'Mean shift (intensity shift)'
    'Contrast change'});

% SHOW MSE MEANS
figure
bar(x,MSE,1)
legend('no filter', 'full', 'X', 'cross', 'FontSize',14)
ylabel('MSE','FontSize',14)
xlabel('AlterationType', 'FontSize',14);

function [metric] = test(Iref, I)
%     IMAGE ENHANCEMENT
    nhood = [1 1 1;...
            1 1 1;...
            1 1 1];
    J1 = ReferenceMedianFiltering(I, nhood); %full neighborhood
    
    nhood = [1 0 1;...
            0 1 0;...
            1 0 1];
    J2 = ReferenceMedianFiltering(I, nhood); %X-shaped neighborhood
    
    nhood = [0 1 0;...
            1 1 1;...
            0 1 0];
    J3 = ReferenceMedianFiltering(I, nhood); %cross-shaped neighborhood

%     COMPARING
    metric(1) = immse(I, Iref);
    metric(2) = immse(J1, Iref);   
    metric(3) = immse(J2, Iref);
    metric(4) = immse(J3, Iref);
end

function [FI] = ReferenceMedianFiltering(I, w)
    FI = ordfilt2(I,ceil(nnz(w)/2),w);
end

function [s] = goodCount(n)
	if n<10
        s=sprintf("0%d",n);
    else
        s=sprintf("%d",n);
	end
end