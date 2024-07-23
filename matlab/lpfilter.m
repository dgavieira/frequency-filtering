% UNIVERSIDADE FEDERAL DO AMAZONAS
% FACULDADE DE TECNOLOGIA
% GPRP&O - GRUPO DE PESQUISA EM RECONHECIMENTO DE PADRÕES E OTIMIZAÇÃO
% PGENE523 - PROCESSAMENTO DIGITAL DE IMAGENS
% PROJETO 9 - Frequency Domain Spatial Filtering
% ARQUIVO - lpfilter.m
% AUTOR - Diego Giovanni de Alcântara Vieira
%--------------------------------------------------------------------------
% Helper function to create Butterworth filter
function H = lpfilter(type, M, N, D0, n)
    % Create Butterworth lowpass filter
    % Inputs:
    %   type - filter type ('btw' for Butterworth)
    %   M, N - filter size
    %   D0 - cutoff frequency
    %   n - filter order

    [U, V] = dftuv(M, N);
    D = sqrt(U.^2 + V.^2);

    if strcmp(type, 'btw')
        H = 1 ./ (1 + (D ./ D0).^(2*n));
    else
        error('Unknown filter type.');
    end
end