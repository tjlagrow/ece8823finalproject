function evaluate_clusters_of_soft_L1(clusters_to_evaluate,number_of_rand_initalization,toysylvania_information,newflormedium_information,isPlot,isDisplay,numReplicates)
%EVALUATE_CLUSTERS_OF_SOFT_L1 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 5
    isPlot = 1;
end
if nargin < 6
    isDisplay = 1;
end
if nargin < 7
    numReplicates = 3;
end

toysylvania_L1_compact = [];
newflormedium_L1_compact = [];
for j = 1:number_of_rand_initalization
    [toysylvania, toysylvania_information] = generate_toysylvania(0,0,0);
    [newflormedium, newflormedium_information] = generate_newflormedium(0,0,0);
    toysylvania_L1 = [];
    newflormedium_L1 = [];
    
    for i = 1:length(clusters_to_evaluate)
        clusters = clusters_to_evaluate(i);

        %%% toysylvania
        isP = 0; isDetails = 0;
        [toysylvania_people_in_clusters_soft_L1, toysylvania_clusters_idx_soft_L1, toysylvania_cluster_centers_soft_L1] = ...
            soft_start_L1_min_kmeans(toysylvania_information,clusters,numReplicates,isP,isDetails);                       
        [~, L1_max_soft_start_L1_min_kmeans_toysylvania, ~] = evaluate_compactness(...
                                                    toysylvania_people_in_clusters_soft_L1, ...
                                                    toysylvania_cluster_centers_soft_L1);

        toysylvania_L1 = [toysylvania_L1; L1_max_soft_start_L1_min_kmeans_toysylvania];

        %%% newflormedium
        isP = 0; isDetails = 0;
        [newflormedium_people_in_clusters_soft_L1, newflormedium_clusters_idx_soft_L1, newflormedium_cluster_centers_soft_L1] = ...
            soft_start_L1_min_kmeans(newflormedium_information,clusters,numReplicates,isP,isDetails);                       
        [~, L1_max_soft_start_L1_min_kmeans_newflormedium, ~] = evaluate_compactness(...
                                                    newflormedium_people_in_clusters_soft_L1, ...
                                                    newflormedium_cluster_centers_soft_L1);

        newflormedium_L1 = [newflormedium_L1; L1_max_soft_start_L1_min_kmeans_newflormedium];

    end
    toysylvania_L1_compact = [toysylvania_L1_compact; toysylvania_L1'];
    newflormedium_L1_compact = [newflormedium_L1_compact; newflormedium_L1'];
    if isDisplay
        disp(['finished with rand initialization: ', num2str(j), '/', num2str(number_of_rand_initalization)]);
    end
end

if isPlot
    figure,
    subplot(121),
    boxplot(toysylvania_L1_compact, clusters_to_evaluate), hold on,
    plot(clusters_to_evaluate, mean(toysylvania_L1_compact, 1), 'mo--'), hold on,
    xlabel('number of clusters'), ylabel('compactness score'), ylim([0 10]), hold on, vline(size(toysylvania_information.city_centers,1), 'r')
    title('Toysylvania, Soft Start with L1 Minimization'),

    subplot(122),
    boxplot(newflormedium_L1_compact, clusters_to_evaluate), hold on,
    plot(clusters_to_evaluate, mean(newflormedium_L1_compact, 1), 'mo--'), hold on,
    xlabel('number of clusters'), ylabel('compactness score'), ylim([0 10]), hold on, vline(size(newflormedium_information.city_centers,1), 'r')
    title('New Flormedium, Soft Start with L1 Minimization'),
end

end

