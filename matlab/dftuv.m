% UNIVERSIDADE FEDERAL DO AMAZONAS
% FACULDADE DE TECNOLOGIA
% GPRP&O - GRUPO DE PESQUISA EM RECONHECIMENTO DE PADRÕES E OTIMIZAÇÃO
% PGENE523 - PROCESSAMENTO DIGITAL DE IMAGENS
% PROJETO 9 - Frequency Domain Spatial Filtering
% ARQUIVO - dftuv.m
% AUTOR - Diego Giovanni de Alcântara Vieira
%--------------------------------------------------------------------------
% Helper function to create frequency domain grid
function [U, V] = dftuv(M, N)
    % Create meshgrid of frequencies
    u = 0:(M-1);
    v = 0:(N-1);

    idx = find(u > M/2);
    u(idx) = u(idx) - M;

    idy = find(v > N/2);
    v(idy) = v(idy) - N;

    [V, U] = meshgrid(v, u);
end