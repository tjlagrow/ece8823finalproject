function [cluster_norm_away_from_mean_ground_truth, L1_max, L2_max] = evaluate_compactness(population_labels, ground_truth_centers)
%{
script to help evaluate compactness

%}

%% Distances from Centers

custer_euclidean_score = [];
for i = 1:length(population_labels)
    number_of_points = size(population_labels{i},1);
    center_array = ones(number_of_points, 2);
    center_array = [center_array(:,1)*ground_truth_centers(i,1) center_array(:,2)*ground_truth_centers(i,2)];
    city_block_distance = round(sum(abs(center_array(:,1)-population_labels{i}(:,1))) + sum(abs(center_array(:,2)-population_labels{i}(:,2))));
    euclidean_distance = round(sqrt(sum((center_array(:,1)-population_labels{i}(:,1)).^2 + (center_array(:,2)-population_labels{i}(:,2)).^2)));
    custer_euclidean_score = [custer_euclidean_score; city_block_distance, euclidean_distance];
end

cluster_norm_away_from_mean_ground_truth = ...
    [abs(mean(custer_euclidean_score(:,1))-custer_euclidean_score(:,1))/max(abs(mean(custer_euclidean_score(:,1))-custer_euclidean_score(:,1))) ...
     abs(mean(custer_euclidean_score(:,2))-custer_euclidean_score(:,2))/max(abs(mean(custer_euclidean_score(:,2))-custer_euclidean_score(:,2)))];
 
norms = sum(cluster_norm_away_from_mean_ground_truth);
L1_max = norms(1);
L2_max = norms(2);
end

