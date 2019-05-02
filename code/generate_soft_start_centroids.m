function [centers] = generate_soft_start_centroids(state_information, clusters, numReplicates)

centers = zeros(clusters, 2, numReplicates);
for j = 1:numReplicates
    if size(state_information.city_centers, 1) >= clusters
        data = 1:size(state_information.city_centers, 1);
        starting_centers_idx = datasample(data, clusters, 'Replace', false); 
        starting_centers = state_information.city_centers(starting_centers_idx,:);
        centers(:,:,j) = starting_centers;
    else
        starting_centers = state_information.city_centers;
        d = clusters - size(state_information.city_centers, 1);
        for i = 1:d
            starting_centers = [starting_centers; randi(state_information.size(1),1) randi(state_information.size(2),1)];
        end
        centers(:,:,j) = starting_centers;
    end
end

end

