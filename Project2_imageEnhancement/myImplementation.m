Iref = imread('TID/reference_images/I01.BMP');
Iref = rgb2gray(Iref);
I = imnoise(Iref,'salt & pepper', 0.02);
nhood = [0 1 0;...
            1 1 1;...
            1 1 1];
FilteredI = MyMedianFiltering(I, nhood); 

figure
imshowpair(Iref,I,'montage')
title('Original Image           Altered Image');
figure
imshowpair(I,FilteredI,'montage')
title('Altered Image            Filtered Image');

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