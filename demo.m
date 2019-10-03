% clear old vairables
clear all;
close all;
clc;

% load data, please change it for your image
filename='data/Img4.png';
[filepath,name,ext]=fileparts(filename);
im=im2double(imread([filepath,'/',name,ext]));

% Estimate reflectance and illumination layers using our model
addpath(genpath('Third_codes'));
[S,R]=L2LpRetinex(im);

% Show results
hsv=rgb2hsv(im);
figure(1);
subplot(2,2,3);imshow(S);title('Illumination (Gray)');
hsv(:,:,3) = R;
subplot(2,2,4);imshow(hsv2rgb(hsv),[]);title('Reflectance');
reflectance=hsv2rgb(hsv);
subplot(2,2,1);imshow(im);title('Input');

% Enhanced images
gamma=2.2;
hsv=rgb2hsv(im);
I_gamma=S.^(1/gamma);
S_gamma=R .* I_gamma;
hsv(:,:,3)=S_gamma;
enhance = hsv2rgb(hsv);
subplot(2,2,2);imshow(enhance);title('Enhanced image');

% % If you want to save results, please uncomment the following code
% outputDir='output/';
% imwrite(im,[outputDir sprintf('%s.png',name)]);
% imwrite(S,[outputDir sprintf('%s-s.png',name)]);
% imwrite(enhance,[outputDir sprintf('%s-e.png',name)]);
% imwrite(reflectance,[outputDir sprintf('%s-r.png',name)]);
