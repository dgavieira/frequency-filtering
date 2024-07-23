% UNIVERSIDADE FEDERAL DO AMAZONAS
% FACULDADE DE TECNOLOGIA
% GPRP&O - GRUPO DE PESQUISA EM RECONHECIMENTO DE PADRÕES E OTIMIZAÇÃO
% PGENE523 - PROCESSAMENTO DIGITAL DE IMAGENS
% PROJETO 5 - Histogram
% ARQUIVO - histEqual4e.m
% AUTOR - Diego Giovanni de Alcântara Vieira
%--------------------------------------------------------------------------

function g = histEqual4e(f)
    % verifica se a imagem possui 8 bits
    if ~isa(f, 'uint8')
        error('Imagem de entrada deve ser de 8 bits');
    end

    % Calcula o histograma da imagem de entrada
    histograma = imagehist4e(f, 'u');

    % Calcula a função de distribuição acumulada
    cdf = cumsum(histograma) / numel(f);

    % Calcula a função de mapeamento
    T = uint8(255 * cdf);

    % Aplica a funao de mapeamento a imagem
    g = T(double(f) + 1);
    g = uint8(g);

end