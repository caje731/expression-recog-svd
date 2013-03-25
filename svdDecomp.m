function [U] = svdDecomp(fileName, N,posemap,model)
%fileName = 'trainingset.txt'?

fid = fopen(fileName);
%S = zeros(65536, N);
U = zeros(65536, N);

for i=1:N
    face = fgetl(fid);
    fi = imread(face);
    %subplot(ceil(sqrt(N)),ceil(sqrt(N)),i);
    fprintf(1,'%s.\n',face);
    %figure(1);
    %imshow(fi);
    %clf; imagesc(fi); axis image; axis off; drawnow;
    [eye_region_img  mouth_region_img] = get_regions(fi, model, posemap);
    fi = cat(1,eye_region_img,mouth_region_img);
        
    % Matlab's svd strangely breaks with a nomem exception, so using my own svd
    [fi,~,~] = jacobi_svd(double(fi));
    fi =reshape(fi,65536,1);
    %S(:,i) = fi;
    U(:,i) = fi;
end
%fbar = (mean(S'))';

%figure(2);
%imshow(reshape(uint8(fbar),256, 256));
%title('Mean of Training Set');

%A = S-fbar*ones(1, N);
%[U,~,~] = jacobi_svd(A);

clear A S;
return;


   
