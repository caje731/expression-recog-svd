function [eye_region_img, mouth_region_img] = showboxes(im, boxes, posemap)

% showboxes(im, boxes)
% Draw boxes on top of image.

%imagesc(im);
%hold on;
%axis image;
%axis off;
leftx   =5000;
rightx  =0;
topy   =5000;
bottomy  =0;
for b = boxes,
    %partsize = b.xy(1,3)-b.xy(1,1)+1;
    %tx = (min(b.xy(:,1)) + max(b.xy(:,3)))/2;
    %ty = min(b.xy(:,2)) - partsize/2;
    %text(tx,ty, num2str(posemap(b.c)),'fontsize',18,'color','c');
    for i = size(b.xy,1):-1:1;
        x1 = b.xy(i,1);
        y1 = b.xy(i,2);
        x2 = b.xy(i,3);
        y2 = b.xy(i,4);
     %  line([x1 x1 x2 x2 x1]', [y1 y2 y2 y1 y1]', 'color', 'b', 'linewidth', 1);
        leftx   = ceil(min(leftx,(x1+x2)/2));
        rightx  = ceil(max(rightx,(x1+x2)/2));
        topy    = ceil(min(topy,(y1+y2)/2));
        bottomy = ceil(max(bottomy,(y1+y2)/2));
        %plot((x1+x2)/2,(y1+y2)/2,'r.','markersize',15);
    end
end
%line([leftx leftx rightx rightx leftx]', [topy bottomy bottomy topy topy]', 'color', 'g', 'linewidth', 1);
face = imresize(im(topy:bottomy, leftx:rightx), [256 256]);
%figure(234), imshow(face);

% Pass the detected face to the feature detection module
[eye_region_img, mouth_region_img] = eye_mouth_detect(face,128,256);

%drawnow;
