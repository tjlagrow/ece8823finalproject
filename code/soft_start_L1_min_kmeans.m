function [people_struct,idx,C] = soft_start_L1_min_kmeans(state_information,clusters,numReplicates,isPlot,isDetails)
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

%% generate the soft start

[starting_centers] = generate_soft_start_centroids(state_information, clusters, numReplicates);

%% run kmeans

opts = statset('Display','off', 'UseParallel', true);
compactness_struct = cell(numReplicates, 1);
for n = 1:numReplicates
    [idx,C] = kmeans(X(:,1:2),clusters,'Distance','cityblock', 'Start', starting_centers(:,:,n), ...
                     'Options',opts,'MaxIter',1000);

    people_struct = cell(clusters,1);
    for i = 1:clusters
        p = X(idx==i,:);
        people_struct{i} = p;
    end

    [~,L1,~] = evaluate_compactness(people_struct,C);
    compactness_struct{n}.L1 = L1;
    compactness_struct{n}.people_struct = people_struct;
    compactness_struct{n}.C = C;
    compactness_struct{n}.idx = idx;
end

clear L1_min;
L1_min.L1 = Inf;
for i = 1:numReplicates
    if compactness_struct{i}.L1 < L1_min.L1
        L1_min = compactness_struct{i};
    end
end

idx = L1_min.idx;
C = L1_min.C;
people_struct = L1_min.people_struct;
                                        
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


