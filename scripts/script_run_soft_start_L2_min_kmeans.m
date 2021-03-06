%{
script for helping evaluate soft start kmeans with L2 compactness reg

%}

%% Increase the compactness by minimizing the L2 distance intracluster

%%% toysylvania
clusters = 4; numReplicates = 10; isPlot = 0; isDetails = 0;
[toysylvania_people_in_clusters_soft_L2, toysylvania_clusters_idx_soft_L2, toysylvania_cluster_centers_soft_L2] = ...
    soft_start_L2_min_kmeans(toysylvania_information,clusters,numReplicates,isPlot,isDetails);                       
[cluster_norm_soft_start_L2_min_kmeans_toysylvania, ...
    L1_max_soft_start_L2_min_kmeans_toysylvania, ...
    L2_max_soft_start_L2_min_kmeans_toysylvania] = evaluate_compactness(...
                                            toysylvania_people_in_clusters_soft_L2, ...
                                            toysylvania_cluster_centers_soft_L2);
                                        
%%% newflormedium
clusters = 5; numReplicates = 10; isPlot = 0; isDetails = 0;
[newflormedium_people_in_clusters_soft_L2, newflormedium_clusters_idx_soft_L2, newflormedium_cluster_centers_soft_L2] = ...
    soft_start_L2_min_kmeans(newflormedium_information,clusters,numReplicates,isPlot,isDetails);                       
[cluster_norm_soft_start_L2_min_kmeans_newflormedium, ...
    L1_max_soft_start_L2_min_kmeans_newflormedium, ...
    L2_max_soft_start_L2_min_kmeans_newflormedium] = evaluate_compactness(...
                                            newflormedium_people_in_clusters_soft_L2, ...
                                            newflormedium_cluster_centers_soft_L2);
                                        
%%% smallerado
clusters = 7; numReplicates = 10; isPlot = 0; isDetails = 0;
[smallerado_people_in_clusters_soft_L2, smallerado_clusters_idx_soft_L2, smallerado_cluster_centers_soft_L2] = ...
    soft_start_L2_min_kmeans(smallerado_information,clusters,numReplicates,isPlot,isDetails);                       
[cluster_norm_soft_start_L2_min_kmeans_smallerado, ...
    L1_max_soft_start_L2_min_kmeans_smallerado, ...
    L2_max_soft_start_L2_min_kmeans_smallerado] = evaluate_compactness(...
                                            smallerado_people_in_clusters_soft_L2, ...
                                            smallerado_cluster_centers_soft_L2);

%%% largerado
clusters = 7; numReplicates = 10; isPlot = 1; isDetails = 0;
[largerado_people_in_clusters_soft_L2, largerado_clusters_idx_soft_L2, largerado_cluster_centers_soft_L2] = ...
    soft_start_L2_min_kmeans(largerado_information,clusters,numReplicates,isPlot,isDetails);                       
[cluster_norm_soft_start_L2_min_kmeans_largerado, ...
    L1_max_soft_start_L2_min_kmeans_largerado, ...
    L2_max_soft_start_L2_min_kmeans_largerado] = evaluate_compactness(...
                                            largerado_people_in_clusters_soft_L2, ...
                                            largerado_cluster_centers_soft_L2);



