%{ 
script to show the ground truth used to justify the efficicy of our methods

This script uses largerado as the exam
%}

isPlot = 0;

%% init

%[largerado, largerado_information] = generate_largerado(isRandomization,isPlot);

im  = imread('colorado_stencil_ds_10.png');
%figure, imshow(im)
%niftiwrite(im, 'colorado_stencil_ds_10'); % in case you want to save

%% Loading in the annotations from ITK-Snap
% Unfortunately, there is a maximum of 6 labels in the program so I had to
% split up the annotation into 2 files

ground_truth_image = niftiread('colorado_stencil_ds_10.nii');
annotations_1_6 = niftiread('colorado_stencil_ds_10_annotations_1_6.nii');
annotations_7 = niftiread('colorado_stencil_ds_10_annotations_7.nii');
labels = cell(length(unique(annotations_1_6(:,:,1))),1);
for i = 1:length(labels)
    if i == 7
        labels{i} = imfill(double(annotations_7(:,:,2)==1));
    else
        labels{i} = imfill(double(annotations_1_6(:,:,1)==i));
    end
end

if isPlot == 1
    figure, 
    subplot(3,3,1), imshow(ground_truth_image), title('Colorado Districts')
    for i = 1:7
        subplot(3,3,i+1), imagesc(labels{i}), title(['District ', num2str(i)]), axis tight,
    end
end
%% upsample annotations to make same size as generated data

ground_truth_image_upscale = imresize(ground_truth_image, 10);
disp('finished upscaling with ground truth image');
for i = 1:7
    labels_upscale{i} = imresize(labels{i}, 10)>0.1;
    disp(['finished upscaling annotation ', num2str(i)]);
end

population_labels_ground_truth_largerado = cell(7,1);
for j = 1:7
    anno = fliplr(rot90(labels_upscale{j},2));
    for i = 1:length(largerado_information.homes(:,1))
        if anno(largerado_information.homes(i,2), largerado_information.homes(i,1)) == 1
            population_labels_ground_truth_largerado{j} = [population_labels_ground_truth_largerado{j}; largerado_information.homes(i,1), largerado_information.homes(i,2), largerado_information.homes(i,3)];
        end
    end
end


%% Generate Colorado
%%% everything is upsidedown!!! be warned...
ground_truth_centers_largerado = [];
for i = 1:7
    ground_truth_centers_largerado = [ground_truth_centers_largerado; round(mean(population_labels_ground_truth_largerado{i}(:,1))) round(mean(population_labels_ground_truth_largerado{i}(:,2)))];
end

if isPlot == 1
    figure,
    imshow(fliplr(rot90(ground_truth_image_upscale,2))), hold on,
    scatter(largerado_information.homes(largerado_information.republicans,1),largerado_information.homes(largerado_information.republicans,2),'r.'), hold on,
    scatter(largerado_information.homes(largerado_information.democrats,1),largerado_information.homes(largerado_information.democrats,2),'b.'), hold on,
    plot(ground_truth_centers_largerado(:,1),ground_truth_centers_largerado(:,2),'c+','MarkerSize',8,'LineWidth',3),
    xlim([0 size(ground_truth_image_upscale,2)]), ylim([0 size(ground_truth_image_upscale,1)]), set(gca,'XDir','reverse'), axis off, 
    legend('republicans','democrats','ground truth district centers'), title('Smallerado'), camroll(180),
    disp(['Smallerado: percent of democrats: ',num2str(size(largerado_information.democrats,1)/largerado_information.population), ', percent of republicans: ',num2str(size(largerado_information.republicans,1)/largerado_information.population)]);


    %%%

    figure,
    subplot(181),
    imshow(fliplr(rot90(ground_truth_image_upscale,2))), hold on,
    scatter(largerado_information.homes(largerado_information.republicans,1),largerado_information.homes(largerado_information.republicans,2),'r.'), hold on,
    scatter(largerado_information.homes(largerado_information.democrats,1),largerado_information.homes(largerado_information.democrats,2),'b.'), hold on,
    xlim([0 size(ground_truth_image_upscale,2)]), ylim([0 size(ground_truth_image_upscale,1)]), set(gca,'XDir','reverse'), axis off, title('All Colorado'),
    camroll(180),

    for i = 1:7
        subplot(1,8,i+1), 
        imshow(fliplr(rot90(ground_truth_image_upscale,2))), hold on,
        if ~isempty(population_labels_ground_truth_largerado{i})
            scatter(population_labels_ground_truth_largerado{i}(:,1), population_labels_ground_truth_largerado{i}(:,2),'g.'), hold on,
            plot(ground_truth_centers_largerado(i,1),ground_truth_centers_largerado(i,2),'c+','MarkerSize',8,'LineWidth',3), hold on,
            xlim([0 size(ground_truth_image_upscale,2)]), ylim([0 size(ground_truth_image_upscale,1)]), set(gca,'XDir','reverse'), 
            camroll(180),
        end
        title(['District ', num2str(i)]), axis tight,
    end

end

