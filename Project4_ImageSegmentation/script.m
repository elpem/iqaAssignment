iptsetpref('ImshowInitialMagnification','fit'); %parameter for using imshow
clear;

im = imread('images/leo.jpg');
im = imrotate(im,-90);
image_array = {};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Step 1: color filtering
mask1 = CreateMask1(im);
mask2 = CreateMask2(im);
mask3 = CreateMask3(im);

mask = xor(mask3,xor(mask1, mask2));

image_array{1}=im;
image_array{2}=mask1;
image_array{3}=mask2;
image_array{4}=mask3;
image_array{5}=mask;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Step 2: edge detection
im_edges = edge(rgb2gray(im), 'log', 0.025);%0.01
im_edges2 = imclose(im_edges, strel('disk',10));
im_edges2= imerode(im_edges2, strel('disk',12));
im_edges2 = imdilate(im_edges2, strel('rectangle',[50,250]));
im_edges2 = imclose(im_edges2, strel('disk',50));

mask = and(mask,not(im_edges2));

image_array{6}=im_edges;
image_array{7}=im_edges2;
image_array{7}=mask;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Morphological filtering
mask = imerode(mask, strel('disk',5));
mask = imclose(mask, strel('rectangle',[100 30]));
mask = imerode(mask, strel('disk',5));
mask = imopen(mask, strel('disk',15));

%fork in detouring here, to test differnet methods.
mask5 = imerode(mask, strel('rectangle',[50 30]));
mask5 = imdilate(mask5, strel('disk', 10));
mask5 = imdilate(mask5, strel('rectangle',[50 30]));

%detouring 2(for region growing)
mask = imerode(mask, strel('rectangle',[70 50]));
mask = imdilate(mask, strel('disk', 10));

image_array{8}=mask;
image_array{9}=mask5;
%%%%%  mask display  %%%%%
% im3 = im;
% im3(mask ~= 0) = mask(mask ~= 0);
% figure
% imshow(im3);

mask = regionGrowing(im, mask, 5, 5, 10, 15);
mask5 = regionGrowing(im, mask5, 5, 5, 1, 3);

%%%%%  mask display  %%%%%
% im3 = im;
% im3(mask ~= 0) = mask(mask ~= 0);
% figure
% imshow(im3);

image_array{10}=mask;
image_array{11}=mask5;

mask = imclose(mask,strel('disk',5));
mask = imdilate(mask,strel('disk',15));
mask = imerode(mask,strel('disk',15));
mask = imdilate(mask,strel('disk',30));
mask = imerode(mask,strel('disk',30));

mask5 = imdilate(mask5,strel('disk',15));
mask5 = imerode(mask5,strel('disk',15));
mask5 = imdilate(mask5,strel('disk',15));
mask5 = imerode(mask5,strel('disk',15));
mask5 = imclose(mask5,strel('disk',3));

image_array{12}=mask;
image_array{13}=mask5;

image_array{14}=getFinalImage(im, mask);
image_array{15}=getFinalImage(im, mask5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DISPLAY

%%%%%  full process montage  %%%%%
figure
montage(image_array, 'BackgroundColor', 'white', 'BorderSize', [5 5]);

%%%%%%%%%%%%%%Show masks
% for i=1:15 %1:15
%    figure
%    imshow(image_array{i}); 
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   FUNCTIONS   %%%%%%%%%%%%%%%%%%%%%%%%%%


%Region Growing
function [mask] = regionGrowing(im, mask, w_height, w_width, threshold, pass_nb)
    height = size(im,1);
    width = size(im,2);
    mask4=false(4032, 1960);

    for a=1:pass_nb
        for i=10:height-10    %1:height
            for j=10:width-10   %j=1:width
                if mask(i,j)==1
                    for k=-floor(w_height/2):floor(w_height/2)
                        for l=-floor(w_width/2):floor(w_width/2)
                            if k~=0 && l~=0 && mask(i+k,j+l)==0
                                if isSimilar(im(i,j,:), im(i+k,j+l,:), threshold) == 1
                                    mask4(i+k, j+l) =1;
                                end
                            end
                        end
                    end
                end
            end
        end
        mask = or(mask,mask4);
        nb=0;
    end
    %%%%%  mask display  %%%%%
%     im4 = im;
%     im4(mask ~= 0) = mask(mask ~= 0);
%     figure
%     imshow(im4);
end

function [im] = getFinalImage(im, mask)
    for i=1:size(im,1)
        for j=1:size(im,2)
            if mask(i,j)==0
                im(i,j,:)=0;
            end
        end
    end
end


function [similar] = isSimilar(px1, px2, threshold)
    similar = 0;
    m=1;
    dif = abs(px1(1) - px2(1));

    while dif<threshold
        dif = abs(px1(m) - px2(m));
        if m==3
            similar = 1;
            break
        end
        m = m+1;
    end
end










