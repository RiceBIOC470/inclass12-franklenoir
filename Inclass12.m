%Inclass 12. 
%Walter Frank Lenoir

% Continue with the set of images you used for inclass 11, the same time 
% point (t = 30)

reader1 = bfGetReader('011917-wntDose-esi017-RI_f0016.tif');
iplane = reader1.getIndex(1-1,1-1,30-1)+1;
img1 = bfGetPlane(reader1,iplane);
iplane = reader1.getIndex(1-1,2-1,30-1)+1;
img2 = bfGetPlane(reader1,iplane);
imshow(img2)
%img2 has the cell nuclei

% 1. Use the channel that marks the cell nuclei. Produce an appropriately
% smoothed image with the background subtracted. 
img2_sm = imfilter(img2,fspecial('gaussian',4,2));
img2_bg = imopen(img2_sm,strel('disk',100));
img2_smbg = imsubtract(img2_sm,img2_bg);
imshow(imadjust(img2_smbg));

% 2. threshold this image to get a mask that marks the cell nuclei. 

img2_mask = img2_smbg > 100;
imshow(img2_mask)

% 3. Use any morphological operations you like to improve this mask (i.e.
% no holes in nuclei, no tiny fragments etc.)

img2_maskmorph = imopen(img2_mask,strel('disk',9));
imshow(img2_maskmorph);

% 4. Use the mask together with the images to find the mean intensity for
% each cell nucleus in each of the two channels. Make a plot where each data point 
% represents one nucleus and these two values are plotted against each other

measurements = regionprops( img2_maskmorph,img1, 'MeanIntensity');
measurements2 = regionprops( img2_maskmorph,img2, 'MeanIntensity');

mes1 = struct2dataset(measurements);
mes2 = struct2dataset(measurements2);
plot(mes1,mes2,'o'); 
xlabel('Img1 Mean Intensity');
ylabel('Img2 Mean Intensity');

%Overall Img2 has higher intensity at nuclease positions compared to img1 (expected)