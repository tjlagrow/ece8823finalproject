function [state, state_infomation] = generate_state(state_population, state_size, city_radiuses, city_centers, city_populations, city_political_affiliations, state_political_affiliations)
%GENERATE_STATE Summary of this function goes here
%   Detailed explanation goes here
state_infomation.population = state_population;
state_infomation.size = state_size;
state_infomation.city_centers = city_centers;

%%% radius, center, population, political_affiliation, state 
cities = generate_cities(city_radiuses, city_centers, city_populations, city_political_affiliations, state_infomation);

% compiling all home locations
state_infomation.homes = [];
for i = 1:size(cities,1)
state_infomation.homes = [state_infomation.homes; ...
               cities{i}.homes(1,:)',cities{i}.homes(2,:)',cities{i}.homes(3,:)';];
end

disp(['finished compiling all home locations'])

% take out any houses that are in the middle of two cities
state_infomation.homes_repeat = [];
for i = 1:size(state_infomation.homes, 1)
    current_home = state_infomation.homes(i,:);
    % remove homes outside of bourder
    if current_home(1)<=0 || current_home(2)<=0 || ...
       current_home(1)>=state_infomation.size(1) || current_home(2)>=state_infomation.size(2) 
        state_infomation.homes_repeat = [state_infomation.homes_repeat; i];
    end
    % removing repeats
    %{
    for j = 1:size(state_infomation.homes, 1)
        if i~=j && ...
           isequal(state_infomation.homes(j,1),current_home(1)) ...
           && isequal(state_infomation.homes(j,2),current_home(2))
            state_infomation.homes_repeat = [state_infomation.homes_repeat; j];
        end            
    end
    %}
end
% remove homes outside the state
a =1:size(state_infomation.homes);
a(unique(state_infomation.homes_repeat)) = [];
state_infomation.homes = state_infomation.homes(a,:,:);
% remove homes that double from several cities
[~,idx,~] = unique(state_infomation.homes(:,1:2), 'rows');
state_infomation.homes = state_infomation.homes(idx,:,:);
disp(['finished replacing all repeated homes'])

             
% generate matix of the state                
state = zeros(state_infomation.size(1),state_infomation.size(2),2);
for i = 1:size(state_infomation.homes,1)
    state(state_infomation.homes(i,1),state_infomation.homes(i,2),1) = 1;
end
disp(['finished generate matix of the state'])


% add in remaining population not around the cities
others.population = state_infomation.population-nnz(state(:,:,1)); 
others.political_affiliation = ((rand(others.population,1) <= state_political_affiliations)+1)';
[row, col] = find(state(:,:,1)==0);
interm = randi([1 size(row,1)],others.population,1);
others.homes = zeros(size(interm,1), 3);
for i = 1:size(interm,1)
    state(row(interm(i)), col(interm(i)),1) = 1;
    others.homes(i,:) = [row(interm(i)), col(interm(i)), others.political_affiliation(i)];
end 
state_infomation.homes = [state_infomation.homes; others.homes];
disp(['finished adding in remaining population not around the cities'])


% add in everyone's political affiliation 
for i = 1:size(state_infomation.homes,1)
    state(state_infomation.homes(i,1),state_infomation.homes(i,2),2) = state_infomation.homes(i,3);
end
disp(['finished adding in everyone`s political affiliation'])


% assign 
state_infomation.republicans = find(state_infomation.homes(:,3) == 1);
state_infomation.democrats = find(state_infomation.homes(:,3) == 2);

end

