%{
script to help run all of the kmeans algorithms

%}

%% evaluate ground truth for baseline

[cluster_norm_ground_truth_smallerado, L1_ground_truth_smallerado, L2_ground_truth_smallerado] = evaluate_compactness(population_labels_ground_truth_smallerado, ground_truth_centers_smallerado);
[cluster_norm_ground_truth_largerado, L1_ground_truth_largerado, L2_ground_truth_largerado] = evaluate_compactness(population_labels_ground_truth_largerado, ground_truth_centers_largerado);

%% run kmeans on colorado

%%% toysylvania

clusters = 4; isPlot = 1; isDetails = 1;
[toysylvania_people_in_clusters, toysylvania_clusters_idx, toysylvania_cluster_centers] = ...
    standard_kmeans_alg(toysylvania_information,clusters,isPlot,isDetails);
                                 
[cluster_norm_standard_kmeans_toysylvania, L1_max_standard_kmeans_toysylvania, L2_max_standard_kmeans_toysylvania] = evaluate_compactness(toysylvania_people_in_clusters, toysylvania_cluster_centers);


%% newflormedium

clusters = 4; isPlot = 0; isDetails = 0;
[newflormedium_people_in_clusters, newflormedium_clusters_idx, newflormedium_cluster_centers] = ...
    standard_kmeans_alg(newflormedium_information,clusters,isPlot,isDetails);
                                 
[cluster_norm_standard_kmeans_newflormedium, L1_max_standard_kmeans_newflormedium, L2_max_standard_kmeans_newflormedium] = evaluate_compactness(newflormedium_people_in_clusters, newflormedium_cluster_centers);


%% smallerado

clusters = 7; isPlot = 0; isDetails = 0;
[smallerado_people_in_clusters, smallerado_clusters_idx, smallerado_cluster_centers] = ...
    standard_kmeans_alg(smallerado_information,clusters,isPlot,isDetails);
                                 
[cluster_norm_standard_kmeans_smallerado, L1_max_standard_kmeans_smallerado, L2_max_standard_kmeans_smallerado] = evaluate_compactness(smallerado_people_in_clusters, smallerado_cluster_centers);

%%% largerado

clusters = 7; isPlot = 0; isDetails = 0;
[largerado_people_in_clusters, largerado_clusters_idx, largerado_cluster_centers] = ...
    standard_kmeans_alg(largerado_information,clusters,isPlot,isDetails);
                                 
[cluster_norm_standard_kmeans_largerado, L1_max_standard_kmeans_largerado, L2_max_standard_kmeans_largerado] = evaluate_compactness(largerado_people_in_clusters, largerado_cluster_centers);



