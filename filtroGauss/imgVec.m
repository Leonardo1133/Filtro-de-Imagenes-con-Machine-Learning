% Transforma imagen 255x255 a matriz 9x64k para entrada a la red
function[in_rna] = ImVector(im_ruido)
a = 0;
b = 0;
for i = 2:255   
    for j = 2:255
        b = im_ruido(i-1:i+1,j-1:j+1);         % extrae un pixel y sus vecinos 3x3
        T = transpose(b);                      % transpone la porcion 3x3
        M = reshape(T,[],1);                   % forma un vector columna con T, quedando M = 9x1     
        if a == 0
            in_rna = M;
        end      
        if a > 0
            in_rna = horzcat(in_rna,M);        % concatena en una matriz c/vector p/ingresar a la red
        end       
        a = a + 1;        
    end
end 
a = 0; 
T = 0; 
M = 0; 
ans = 0;
end
