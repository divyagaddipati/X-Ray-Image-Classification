function [pc nonmax] = phase_congruency(I)

I = im2double(I);

rect = [10 15 40 40];
[J,rect] = SRAD(I,20,0.3,rect); % Noise removal 

[x y] = size(J);
% Padding to resize the image to 512x512 
if rem(y,2) == 0
    J = padarray(J,[0,(512-y)/2],'both');
else
    J = padarray(J,[0,floor((512-y)/2)],'pre');
    J = padarray(J,[0,ceil((512-y)/2)],'post');
end
    
if rem(x,2) == 0
    J = padarray(J,[(512-x)/2,0],'both');
else
    J = padarray(J,[floor((512-x)/2),0],'pre');
    J = padarray(J,[ceil((512-x)/2),0],'post');
end

J = imadjust(J,stretchlim(J)); % Histogram adjustment such that 1% of data is saturated at low and high intensities of I.

im = edge(J,'canny');

[pc1 orient] = phasecong(J);
[pc2 orient] = phasecong(im);

pc = pc1 .* pc2;
nonmax = nonmaxsup(pc, orient, 1.5); % Non-maximal suppression
end
