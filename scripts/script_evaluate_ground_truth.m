%{
script to help evaluate the ground truth

%}

%% evaluate ground truth for baseline

[cluster_norm_ground_truth_smallerado, L1_ground_truth_smallerado, L2_ground_truth_smallerado] = evaluate_compactness(population_labels_ground_truth_smallerado, ground_truth_centers_smallerado);
[cluster_norm_ground_truth_largerado, L1_ground_truth_largerado, L2_ground_truth_largerado] = evaluate_compactness(population_labels_ground_truth_largerado, ground_truth_centers_largerado);
