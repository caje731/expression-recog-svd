% Module for extraction of eyes and mouth from an image
function [eye_region_img, mouth_region_img] = eye_mouth_detect(face,scale_rows,scale_cols)

[p q] = size(face);

del = q/3;
eye_region_img   = imresize(face(1: ceil(del+del/6), 1:p), [scale_rows scale_cols]);
mouth_region_img = imresize(face((ceil(q-del-del/3)): ceil(q-del+del/3), 1:p),[scale_rows scale_cols]);


%figure(98), imshow(eye_region_img), title('Eyes with brows');
%figure(989), imshow(mouth_region_img), title('Mouth');

end
