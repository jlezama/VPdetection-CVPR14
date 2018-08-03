function draw_lines(lines1, lines2, params);
% draws two groups of line segments

H = params.H;
W = params.W;

LW = 1.5;

hfig = figure();
hold on
for i=1:size(lines1,1)
   l = lines1(i,:);
    plot([l(1) l(3)], H - [l(2) l(4)],'LineWidth',LW);
end

for i=1:size(lines2,1)
   l = lines2(i,:);
    plot([l(1) l(3)], H - [l(2) l(4)],'r','LineWidth',LW);
end

axis([0 W 0 H])
axis off
axis equal
print(hfig,'-depsc', '-r300', sprintf('%s/lines', params.folder_out));



%% draw in empty image
blue = zeros(H,W);
red = zeros(H,W);

for i=1:length(lines1)
    lt = lines1(i,:);
    try
        l = drawline([lt(2), lt(1)],[lt(4) lt(3)],[H W 3]);
        blue(l)=1;
    end
end
for i=1:length(lines2)
    lt = lines2(i,:);
    try
        l = drawline([lt(2), lt(1)],[lt(4) lt(3)],[H W 3]);
        red(l)=1;
    end
end


% make lines fatter
se = strel('disk',1);
blue=logical(imdilate(blue,se));
red=logical(imdilate(red,se));


img2 = zeros(H,W,3);
%img2(:,:,1) = red;
img2(:,:,1) = logical(red+blue);
img2(:,:,2) = blue;
img2(:,:,3) = blue;
img2 = uint8(img2)*255;
img2 = 255-img2;

red2 = img2(:,:,1);
green2 = img2(:,:,2);
blue2 = img2(:,:,3);

z = find(red);

red2(z)=255;
green2(z)=0;
blue2(z)=0;

img2 (:,:,1)=red2;
img2 (:,:,2)=blue2;
img2 (:,:,3)=green2;


imwrite(img2,sprintf('%s/lines.png',params.folder_out));
