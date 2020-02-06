for i=1:1 %25 different images
    name = sprintf('I%s',goodCount(i));
    Iref = imread(sprintf('TID/reference_images/%s.BMP',name));
    Iref = rgb2gray(Iref);
    Icurrent = imnoise(Iref,'salt & pepper', 0.02);
    test(Iref, Icurrent);
end

function [metric] = test(Iref, I)
%     IMAGE ENHANCEMENT
    %J1 = medfilt2(I, [4 2]);%full neighborhood
    nhood = [1 1 1 ;...
            1 1 1 ;...
            1 1 1];
    J1 = ReferenceMedianFiltering(I, nhood); %full neighborhood
    J1b = MyMedianFiltering(I,nhood);
    nhood = [1 0 1 ;...
            0 1 0 ;...
            1 0 1];
    J2 = ReferenceMedianFiltering(I, nhood); %X-shaped neighborhood
    J2b = MyMedianFiltering(I,nhood);
    nhood = [0 1 0;...
            1 1 1;...
            0 1 0];
    J3 = ReferenceMedianFiltering(I, nhood); %cross-shaped neighborhood
    J3b = MyMedianFiltering(I,nhood);
    nhood = [1 1 1 1 ;...
            1 1 1 1];
    J4 = ReferenceMedianFiltering(I, nhood); %4*2 full neighborhood
    J4b = MyMedianFiltering(I,nhood);

%     COMPARING
    metric(1) = immse(I, Iref);
    
    metric(2) = immse(J1, Iref);
    metric(3) = immse(J1b, Iref);
    
    metric(3) = immse(J2, Iref);
    metric(4) = immse(J2b, Iref);
    
    metric(4) = immse(J3, Iref);
    metric(5) = immse(J3b, Iref);
    
    metric(6) = immse(J4, Iref);
    metric(7) = immse(J4b, Iref);

%     SHOWING RESULTS
    figure
	imshowpair(Iref,I,'montage')
    title(sprintf('ImRef, AlteredImage(MSE = %f)',metric(1)));
    figure
	imshowpair(J1, J1b,'montage')
    title(sprintf('MediumFilteredImage FullWindow existingAlgo: MSE = %f, myAlgo: MSE= %f',metric(2), metric(3)));
    figure
	imshowpair(J2, J2b,'montage')
    title(sprintf('MediumFilteredImage X window existingAlgo: MSE = %f, myAlgo: MSE= %f',metric(3), metric(4)));
    figure
	imshowpair(J3, J3b,'montage')
    title(sprintf('MediumFilteredImage + window existingAlgo: MSE = %f, myAlgo: MSE= %f',metric(4), metric(5)));
    figure
	imshowpair(J4, J4b,'montage')
    title(sprintf('MediumFilteredImage 4x2 full existingAlgo: MSE = %f, myAlgo: MSE= %f',metric(6), metric(7)));
end

function [FI] = ReferenceMedianFiltering(I, w)
    FI = ordfilt2(I,ceil(nnz(w)/2),w);
end

function [FI] = MyMedianFiltering(Image, w)
    %My implementation of median filtering
    s = size(Image);
    I=s(1);
    J=s(2);
    w_size = size(w);
    w_height = w_size(1);
    w_width = w_size(2);
    FI(I,J)=0;
    FI=uint8(FI);
    
    for i=1:I
        for j=1:J
            FI(i,j)=0;
            a=[255 255 255 255 255 255 255 255 255];
            size_a=0;
%             fprintf('i:%f    j:%f\n',i,j);
            for k=1:w_height
                for l=1:w_width
                    if w(k,l)==1 && i-ceil(w_height/2)+k>0 && i-ceil(w_height/2)+k<=I && j-ceil(w_width/2)+l>0 && j-ceil(w_width/2)+l<=J
%                         fprintf('k:%f   l:%f   valueOf I: %f\n', k,l, Image(i-2+k, j-2+l));
                        a(size_a+1) = Image(i-ceil(w_height/2)+k, j-ceil(w_width/2)+l);
                        size_a = size_a+1;
                    end
                end
            end
%             fprintf('I: %f     J: %f      indiceA: %f\n', i, j, ceil(size_a/2));
            a = sort(a);
%             display(a);
            FI(i,j) = round(a(ceil(size_a/2)));
%             fprintf('median: %f  %f       coordonates  i: %f           j:%f\n\n', FI(i,j),a(1),i, j);
        end
    end
end

function [s] = goodCount(n)
	if n<10
        s=sprintf("0%d",n);
    else
        s=sprintf("%d",n);
	end
end