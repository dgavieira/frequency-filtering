% UNIVERSIDADE FEDERAL DO AMAZONAS
% FACULDADE DE TECNOLOGIA
% GPRP&O - GRUPO DE PESQUISA EM RECONHECIMENTO DE PADRÕES E OTIMIZAÇÃO
% PGENE523 - PROCESSAMENTO DIGITAL DE IMAGENS
% PROJETO 9 - Frequency Domain Spatial Filtering
% ARQUIVO - test.m
% AUTOR - Diego Giovanni de Alcântara Vieira
%--------------------------------------------------------------------------
% Part (c)
% Read the chest X-ray image
chestXray = imread('chestXray.tif');
chestXray_gray = im2double(im2gray(chestXray)); % Use im2gray instead of rgb2gray

% Apply high emphasis filter
a = 0.5;
b = 1.5;
H = highEnphasisFilt(a, b, chestXray_gray, 'btw', true);

% Obtain Fourier transform and centralize it
F_chestXray = fftshift(fft2(chestXray_gray));

% Apply the filter in frequency domain
F_filtered = F_chestXray .* H;
filtered_image = real(ifft2(ifftshift(F_filtered)));

% Show and save spectrum before and after filtering
figure;
imshow(log(1 + abs(F_chestXray)), []);
title('Spectrum Before Filtering');
imwrite(log(1 + abs(F_chestXray)), 'chestXray_Spectrum_Before_Filtering.png');

figure;
imshow(log(1 + abs(F_filtered)), []);
title('Spectrum After Filtering');
imwrite(log(1 + abs(F_filtered)), 'chestXray_Spectrum_After_Filtering.png');

% Perform histogram equalization
filtered_image_eq = histeq(filtered_image);

% Show and save the result
figure;
imshow(filtered_image, []);
title('Filtered Image');
imwrite(filtered_image, 'chestXray_Filtered_Image.png');

figure;
imshow(filtered_image_eq, []);
title('Histogram Equalized Image');
imwrite(filtered_image_eq, 'chestXray_Histogram_Equalized_Image.png');

