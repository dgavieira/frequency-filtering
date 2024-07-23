% UNIVERSIDADE FEDERAL DO AMAZONAS
% FACULDADE DE TECNOLOGIA
% GPRP&O - GRUPO DE PESQUISA EM RECONHECIMENTO DE PADRÕES E OTIMIZAÇÃO
% PGENE523 - PROCESSAMENTO DIGITAL DE IMAGENS
% PROJETO 9 - Frequency Domain Spatial Filtering
% ARQUIVO - highEnpashisFilt.m
% AUTOR - Diego Giovanni de Alcântara Vieira
%--------------------------------------------------------------------------
function H = highEnphasisFilt(a, b, f, type, show)
    % Create a High Emphasis Filter
    % Inputs:
    %   a - offset
    %   b - multiplier
    %   f - image
    %   type - filter type (same as lpfilt function)
    %   show - boolean, if true show the filter plotting

    % Define Butterworth filter parameters
    D0 = 50;  % Cutoff frequency
    n = 2;    % Filter order

    % Create Lowpass Butterworth filter
    lpf = lpfilter(type, size(f, 1), size(f, 2), D0, n);

    % High Emphasis Filter
    H = a + b * (1 - lpf);

    % Show and save the filter if show is true
    if show
        figure;
        mesh(H);
        title('3D High Emphasis Filter Visualization');
        saveas(gcf, 'High_Emphasis_Filter_Visualization_3D.png');
        figure;
        imshow(H, []);
        title('2D High Emphasis Filter Visualization');
        imwrite(H, 'High_Emphasis_Filter_Visualization_2D.png');
    end
end