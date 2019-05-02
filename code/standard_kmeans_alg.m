function [people_struct,idx,C] = standard_kmeans_alg(state_information,clusters,isPlot,isDetails)
%KMEANS_ALG Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3 
    isPlot = 1;
end
if nargin < 4
    isDetails = 1;
end

X = state_information.homes;
colors = [[1 0 1]; [0 1 1]; [1 1 0]; [0 1 0]; [0 0 0];];
while (length(colors) < clusters)
    colors = [colors; rand(1,3)];
end

poolsize=4;
p = gcp('nocreate'); % If no pool, do not create new one.
if isempty(p)
    parpool(poolsize)
end

if isDetails == 1
    opts = statset('Display','final', 'UseParallel', true);
else
    opts = statset('Display','off', 'UseParallel', true);

end

[idx,C] = kmeans(X,clusters,'Distance','cityblock',...
                 'Replicates',10,'Options',opts,'MaxIter',1000);

people_struct = cell(clusters,1);
for i = 1:clusters
    p = X(idx==i,:);
    people_struct{i} = p;
end


%% Plotting

if isPlot == 1
    figure;
    for clust = 1:clusters
        people_in_cluster = X(idx==clust,:);
        for i = 1:size(people_in_cluster,1)
            scatter(people_in_cluster(i,1),people_in_cluster(i,2),'MarkerEdgeColor',colors(clust,:), 'LineWidth',1), hold on,
        end
        hold on
    end
    plot(C(:,1),C(:,2),'kx','MarkerSize',15,'LineWidth',3),
    xlim([1 state_information.size(1)]), ylim([1 state_information.size(2)]),
    title('Cluster Assignments and Centroids'),
end

if isDetails == 1
    disp(['Percentage of Republicans in synthetic data: ', num2str(size(state_information.republicans)/(size(state_information.republicans) + size(state_information.democrats)))]);
    cluster_percentages = [];
    people_in_cluster_struct = cell(clusters,1);
    for i = 1:clusters
        people_in_cluster = X(idx==i,:);
        people_in_cluster_struct{i} = people_in_cluster;
        total_cluster_population = size(people_in_cluster,1);
        republican_count = nnz(people_in_cluster(:,3) == 1);
        cluster_percentages = [cluster_percentages; republican_count/total_cluster_population (republican_count/total_cluster_population)>.5];
        disp(['Percentage of Republicans using Kmeans for Cluster ', num2str(i),': ', num2str(cluster_percentages(i,1))]);
    end
    disp(['Thus, there will be ', num2str(nnz(cluster_percentages(:,2))), ' districts for Republican and ',  num2str(clusters-nnz(cluster_percentages(:,2))), ' districts for Democrat'])
end

end

