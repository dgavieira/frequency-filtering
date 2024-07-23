% UNIVERSIDADE FEDERAL DO AMAZONAS
% FACULDADE DE TECNOLOGIA
% GPRP&O - GRUPO DE PESQUISA EM RECONHECIMENTO DE PADRÕES E OTIMIZAÇÃO
% PGENE523 - PROCESSAMENTO DIGITAL DE IMAGENS
% PROJETO 9 - Frequency Domain Spatial Filtering
% ARQUIVO - main.m
% AUTOR - Diego Giovanni de Alcântara Vieira
%--------------------------------------------------------------------------
% Part (a)
% Read the image
image = imread('woman.tif');
image_gray = im2double(im2gray(image)); % Use im2gray instead of rgb2gray

% Obtain Fourier transform and centralize it
F = fftshift(fft2(image_gray));

% Centralized Fourier spectrum
figure;
imshow(log(1 + abs(F)), []);
title('Centralized Fourier Spectrum');
imwrite(log(1 + abs(F)), 'woman_Centralized_Fourier_Spectrum.png');

% Define Butterworth filter parameters
D0 = 50;  % Cutoff frequency
n = 2;    % Filter order

% Apply Lowpass Butterworth filter
lpf = lpfilter('btw', size(image_gray, 1), size(image_gray, 2), D0, n);
F_lpf = F .* lpf;
image_lpf = real(ifft2(ifftshift(F_lpf)));

% Apply Highpass Butterworth filter
hpf = 1 - lpf;
F_hpf = F .* hpf;
image_hpf = real(ifft2(ifftshift(F_hpf)));

% Plot and save final images
figure;
imshow(image_lpf, []);
title('Lowpass Filtered Image');
imwrite(image_lpf, 'woman_Lowpass_Filtered_Image.png');

figure;
imshow(image_hpf, []);
title('Highpass Filtered Image');
imwrite(image_hpf, 'woman_Highpass_Filtered_Image.png');

% 2D and 3D visualization of filters
figure;
mesh(lpf);
title('3D Lowpass Butterworth Filter');
saveas(gcf, 'woman_3D_Lowpass_Butterworth_Filter.png');

figure;
imshow(lpf, []);
title('2D Lowpass Butterworth Filter');
imwrite(lpf, 'woman_2D_Lowpass_Butterworth_Filter.png');

figure;
mesh(hpf);
title('3D Highpass Butterworth Filter');
saveas(gcf, 'woman_3D_Highpass_Butterworth_Filter.png');

figure;
imshow(hpf, []);
title('2D Highpass Butterworth Filter');
imwrite(hpf, 'woman_2D_Highpass_Butterworth_Filter.png');
