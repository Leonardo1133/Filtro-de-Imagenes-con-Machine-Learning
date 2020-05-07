function [ in_rna ] = ImVector( im_ruido )
%transforma imagen con ruido a matriz 9x64k para entrada a la red
a = 0;
b = 0;
for i = 2:255
    
    for j = 2:255
        b = im_ruido(i-1:i+1,j-1:j+1);         % extrae un pixel y sus vecinos 3x3
        T = transpose(b);                      % o T = ans'  %transpone la porcion 3x3 , muy necesario xq la prox fc vectoriza columnas y yo quiero filas x el algoritmo de wan
        M = reshape(T,[],1);                   % forma un vector columna con 3x3 quedando 9x1
        
        if a == 0
            in_rna = M;
        end
        
        if a > 0
            in_rna = horzcat(in_rna,M);      %concatena en una matriz c/vector p/ingresar a la rna
        end
        
        a = a + 1; 
        
    end
end 
a = 0; 
T = 0; 
M = 0; 
ans = 0;

end
