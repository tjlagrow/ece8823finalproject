function kmeans_alg(state_information,clusters,isPlotParty)
%KMEANS_ALG Summary of this function goes here
%   Detailed explanation goes here

X = state_information.homes(:,:,:);
colors = [[1 0 1]; [0 1 1]; [1 1 0]; [0 1 0]; [0 0 0];];
while (length(colors) < clusters)
    colors = [colors; rand(1,3)];
end

poolsize=4;
p = gcp('nocreate'); % If no pool, do not create new one.
if isempty(p)
    parpool(poolsize)
end

opts = statset('Display','final', 'UseParallel', true);
[idx,C] = kmeans(X,clusters,'Distance','cityblock',...
    'Replicates',40,'Options',opts);

l = [];
figure;
for clust = 1:clusters
    people_in_cluster = X(idx==clust,:);
    for i = 1:size(people_in_cluster,1)
        if isPlotParty == 1
            if people_in_cluster(i,3) == 1
                scatter(people_in_cluster(i,1),people_in_cluster(i,2),'MarkerEdgeColor',colors(clust,:),'MarkerFaceColor','r', 'LineWidth',1.5), hold on,
            else
                scatter(people_in_cluster(i,1),people_in_cluster(i,2),'MarkerEdgeColor',colors(clust,:),'MarkerFaceColor','b', 'LineWidth',1.5), hold on,
            end
            
        else
            scatter(people_in_cluster(i,1),people_in_cluster(i,2),'MarkerEdgeColor',colors(clust,:), 'LineWidth',1.5), hold on,
           
        end
    end
    %l = [l; ['Cluster ',num2str(clust)]];
    hold on
end
plot(C(:,1),C(:,2),'kx','MarkerSize',15,'LineWidth',3) 
%legend(l,'Location','NW'),
title('Cluster Assignments and Centroids'),
hold off

disp(['Percentage of Republicans in synthetic data: ', num2str(size(state_information.republicans)/(size(state_information.republicans) + size(state_information.democrats)))]);
cluster_percentages = [];
for i = 1:clusters
    people_in_cluster = X(idx==i,:);
    total_cluster_population = size(people_in_cluster,1);
    republican_count = nnz(people_in_cluster(:,3) == 1);
    cluster_percentages = [cluster_percentages; republican_count/total_cluster_population (republican_count/total_cluster_population)>.5];
    disp(['Percentage of Republicans using Kmeans for Cluster ', num2str(i),': ', num2str(cluster_percentages(i,1))]);
end


disp(['Thus, there will be ', num2str(nnz(cluster_percentages(:,2))), ' districts for Republican and ',  num2str(clusters-nnz(cluster_percentages(:,2))), ' districts for Democrat'])


end

