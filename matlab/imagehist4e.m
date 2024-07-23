% UNIVERSIDADE FEDERAL DO AMAZONAS
% FACULDADE DE TECNOLOGIA
% GPRP&O - GRUPO DE PESQUISA EM RECONHECIMENTO DE PADRÕES E OTIMIZAÇÃO
% PGENE523 - PROCESSAMENTO DIGITAL DE IMAGENS
% PROJETO 5 - Histogram
% ARQUIVO - imagehist4e.m
% AUTOR - Diego Giovanni de Alcântara Vieira
%--------------------------------------------------------------------------
function g = imagehist4e(f, mode)
    % Verifica se argumento 'mode' é passado, caso contrário, configura
    % histograma normalizado
    if nargin < 2
        mode = 'n';
    end
    
    % Inicializa o histograma
    histograma = zeros(1, 256);
    
    % Calcula o histograma
    [linhas, colunas] = size(f);
    for i = 1:linhas
        for j = 1:colunas
            % Indice de variaveis do MATLAB começa a partir de 1
            intensidade = f(i, j) + 1;  
            histograma(intensidade) = histograma(intensidade) + 1;
        end
    end
   
    % Normaliza o histograma se mode = 'n'
    if mode == 'n'
        total_pixels = linhas * colunas;
        g = histograma / total_pixels;
        g = g(:)';

    elseif mode == 'u'
        g = histograma;
        % Converte o histograma para um vetor linha
        g = g(:)';
        % Normalize the x-axis to [0, 1]
        normalized_x = linspace(0, 1, 256);
        
        % Plot the histogram using a stem plot
        figure;
        stem(normalized_x, g, 'Marker', 'none');
        title('Histogram of Image');
        xlabel('Normalized Intensity Level');
        ylabel('Frequency');
        
        max_frequency = max(g);
        ylim([0, max_frequency]);  % Set y-axis limits
        
        xlim([0, 1]);  % Limit x-axis range to [0, 1]
        grid on;
        
        % Plota o histograma
        figure;
        stem(0:255, g, 'Marker', 'none');
        title('Histogram of Image');
        xlabel('Intensity Level');
        ylabel('Frequency');
        xlim([0, 255]);
        grid on;
    else
        error('Modo inválido. Use ''n'' para histograma normalizado ou ''u'' para não-normalizado')
    end
   
    
end
