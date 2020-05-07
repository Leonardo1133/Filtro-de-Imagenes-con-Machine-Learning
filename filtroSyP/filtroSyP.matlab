%%-----------------------------------------------%%
%%---------------||TRAIN||-----------------------%%
%%-----------------------------------------------%%

clc, clear all, close all 

%----------------PRE-PROCESAMIENTO----------------%
im = imread('lyla.jpg');                            % AGREGANDO RUIDO A LA IMAGEN
% im = rgb2gray(im);                                     
im_norm   = im2double(im);                          % se mapea la imagen a valores entre 0 y 1
im_ruido = imnoise(im_norm,'salt & pepper',0.1);
in_red = ImVector(im_ruido);                        % transforma la imagen a un vector 9x64k                           
im_norm(:,1)   = [];                                % preparando el target
im_norm(:,255) = []; 
im_norm(1,:)   = []; 
im_norm(255,:) = [];  
im_norm_t    = transpose(im_norm);
im_norm_fila = reshape(im_norm_t,[1,64516]);        % creamos un vector fila 1x64516
target       = im_norm_fila;


%-------------Procesamiento-----------------------%
net = feedforwardnet(5)
net.performFcn = 'mse';
net.trainFcn = 'trainlm';
net.trainParam.epochs = 100;
net.layers{1}.transferFcn = 'logsig';
net.layers{2}.transferFcn = 'purelin';
net.trainParam.max_fail	= 100000;
net.trainParam.min_grad = 1e-11;
net.trainParam.time   = inf;
net.trainParam.mu_inc = 10;
net.trainParam.mu_dec = 0.1;
net.trainParam.mu = 0.01;
net     = train( net, in_red, target );             % Train
out_red = sim( net, in_red );                       % Simulacion


%-------------Post-Procesamiento------------------%
im_output = reshape(out_red,[254,254]);             % transforma la salida de RED (vector fila) en imagen de 254x254
im_output_t = transpose(im_output);                 % traspone la matriz xq la fc anterior compone los vectores rotados
figure,                                             % muestra imagenes 
subplot(1,3,1), imshow(im)
subplot(1,3,2), imshow(im_ruido)
subplot(1,3,3), imshow(im_output_t)


%%-----------------------------------------------%%
%%---------------||Filtrar Imagenes||------------%%
%%-----------------------------------------------%%

%------------PRE-Procesamiento---------------------%
%im       = imread('rana.jpg');     
im       = imread('tigre.jpg');                           
%im       = imread('verde.jpg');                           
%im       = imread('perro.jpg');                                                 
im       = rgb2gray(im);
im_norm  = im2double(im);
im_ruido = imnoise(im_norm,'salt & pepper',0.1);
in_red   = ImVector(im_ruido);  

%------------Procesamiento-------------------------%
out_red = net(in_red);                              %RED Procesando la im

%------------Post-Procesamiento--------------------%
im_output   = reshape(out_red,[254,254]);            %transforma la salida de RNA (vector fila) en imagen de 254x254
im_output_t = transpose(im_output);  
[peaksnr, snr] = psnr(im_ruido, im_norm);  
fprintf('\n Referencia SNR %0.4f \n', snr);
im_norm(:,1)   = []; 
im_norm(:,255) = []; 
im_norm(1,:)   = []; 
im_norm(255,:) = [];  
im_norm1 = im_norm;
[peaksnr, snr] = psnr(im_output_t, im_norm1);    
fprintf(' Filtrada   SNR %0.4f \n', snr);
figure,
subplot(1,3,1), imshow(im)
subplot(1,3,2), imshow(im_ruido)
subplot(1,3,3), imshow(im_output_t)



%%-----------------------------------------------%%
%%---------------||Filtrar Imagenes||------------%%
%%-----------------------------------------------%%

%------------PRE-Procesamiento---------------------%
%im       = imread('rana.jpg');     
%im       = imread('tigre.jpg');                           
%im       = imread('verde.jpg');                           
im       = imread('perro.jpg');                                                 
im       = rgb2gray(im);
im_norm  = im2double(im);
im_ruido = imnoise(im_norm,'salt & pepper',0.1);
in_red   = ImVector(im_ruido);  

%------------Procesamiento-------------------------%
out_red = net(in_red);                              %RED Procesando la im

%------------Post-Procesamiento--------------------%
im_output   = reshape(out_red,[254,254]);            %transforma la salida de RNA (vector fila) en imagen de 254x254
im_output_t = transpose(im_output);  
[peaksnr, snr] = psnr(im_ruido, im_norm);  
fprintf('\n Referencia SNR %0.4f \n', snr);
im_norm(:,1)   = []; 
im_norm(:,255) = []; 
im_norm(1,:)   = []; 
im_norm(255,:) = [];  
im_norm1 = im_norm;
[peaksnr, snr] = psnr(im_output_t, im_norm1);    
fprintf(' Filtrada   SNR %0.4f \n', snr);
figure,
subplot(1,3,1), imshow(im)
subplot(1,3,2), imshow(im_ruido)
subplot(1,3,3), imshow(im_output_t)