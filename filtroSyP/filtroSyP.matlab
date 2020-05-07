clc, clear all, close all 

% Preparando la imagen
im = imread('lyla.jpg');
im_norm   = im2double(im);                          

% Se agrega ruido Gaussiano
im_ruido = imnoise(im_norm,'salt & pepper',0.1);

% Se transforma la imagen a una matriz 9x64k
in_red = ImVector(im_ruido);                                                  

% Transforma la imagen sin ruido a un vecor-fila: Target
im_norm(:,1)   = [];                                
im_norm(:,255) = []; 
im_norm(1,:)   = []; 
im_norm(255,:) = [];  
im_norm_t    = transpose(im_norm);
im_norm_fila = reshape(im_norm_t,[1,64516]);        
target       = im_norm_fila;

% Se crea la red con 5 neuronas en la capa oculta
net = feedforwardnet(5)
net.layers{1}.transferFcn = 'logsig';
net.layers{2}.transferFcn = 'purelin';

% Se definen caracteristicas de entrenamiento
net.performFcn = 'mse';
net.trainFcn = 'trainlm';
net.trainParam.epochs = 100;
net.trainParam.max_fail	= 100000;
net.trainParam.min_grad = 1e-11;
net.trainParam.time   = inf;
net.trainParam.mu_inc = 10;
net.trainParam.mu_dec = 0.1;
net.trainParam.mu = 0.01;

% Se Entrena la red
net     = train( net, in_red, target );             

% Se prueba la red con otras imagenes    
im       = imread('tigre.jpg');                                                                           
im       = rgb2gray(im);
im_norm  = im2double(im);
im_ruido = imnoise(im_norm,'salt & pepper',0.1);

% Se transforma la imagen a una matriz 9x64k
in_red   = ImVector(im_ruido);  

% Se ingresa a la Red
out_red = net(in_red);                              

% Se transforma vector-fila 1x64k a imagen 254x254
im_output   = reshape(out_red,[254,254]);           
im_output_t = transpose(im_output);  

% Calculo de la relacion Señal-Ruido de la imagen con ruido original
[peaksnr, snr] = psnr(im_ruido, im_norm);  
fprintf('\n Referencia SNR %0.4f \n', snr);
im_norm(:,1)   = []; 
im_norm(:,255) = []; 
im_norm(1,:)   = []; 
im_norm(255,:) = [];  
im_norm1 = im_norm;

% Calculo de la relacion Señal-Ruido de la imagen que filtró la red
[peaksnr, snr] = psnr(im_output_t, im_norm1);    
fprintf(' Filtrada   SNR %0.4f \n', snr);
figure,
subplot(1,3,1), imshow(im)
subplot(1,3,2), imshow(im_ruido)
subplot(1,3,3), imshow(im_output_t)
