%{
script to help run soft start kmeans

%}


%% Soft Start with city centers as starting points

%%% toysylvania
clusters = 4; numReplicates = 10; isPlot = 0; isDetails = 1;
[toysylvania_people_in_clusters_soft, toysylvania_clusters_idx_soft, toysylvania_cluster_centers_soft] = ...
    soft_start_kmeans(toysylvania_information,clusters,numReplicates,isPlot,isDetails);                       
[cluster_norm_soft_start_kmeans_toysylvania, ...
    L1_max_soft_start_kmeans_toysylvania, ...
    L2_max_soft_start_kmeans_toysylvania] = evaluate_compactness(...
                                            toysylvania_people_in_clusters_soft, ...
                                            toysylvania_cluster_centers_soft);
                                                                             
%%% newflormedium
clusters = 5; numReplicates = 10; isPlot = 0; isDetails = 1;
[newflormedium_people_in_clusters_soft, newflormedium_clusters_idx_soft, newflormedium_cluster_centers_soft] = ...
    soft_start_kmeans(newflormedium_information,clusters,numReplicates,isPlot,isDetails);                       
[cluster_norm_soft_start_kmeans_newflormedium, ...
    L1_max_soft_start_kmeans_newflormedium, ...
    L2_max_soft_start_kmeans_newflormedium] = evaluate_compactness(...
                                            newflormedium_people_in_clusters_soft, ...
                                            newflormedium_cluster_centers_soft);
                                                                               
%%% smallerado
clusters = 7; numReplicates = 10; isPlot = 0; isDetails = 1;
[smallerado_people_in_clusters_soft, smallerado_clusters_idx_soft, smallerado_cluster_centers_soft] = ...
    soft_start_kmeans(smallerado_information,clusters,numReplicates,isPlot,isDetails);                       
[cluster_norm_soft_start_kmeans_smallerado, ...
    L1_max_soft_start_kmeans_smallerado, ...
    L2_max_soft_start_kmeans_smallerado] = evaluate_compactness(...
                                            smallerado_people_in_clusters_soft, ...
                                            smallerado_cluster_centers_soft);
                                                                             
%%% largerado
clusters = 7; numReplicates = 10; isPlot = 1; isDetails = 1; 
[largerado_people_in_clusters_soft, largerado_clusters_idx_soft, largerado_cluster_centers_soft] = ...
    soft_start_kmeans(largerado_information,clusters,numReplicates,isPlot,isDetails);                       
[cluster_norm_soft_start_kmeans_largerado, ...
    L1_max_soft_start_kmeans_largerado, ...
    L2_max_soft_start_kmeans_largerado] = evaluate_compactness(...
                                            largerado_people_in_clusters_soft, ...
                                            largerado_cluster_centers_soft);
