function cities = generate_cities(radius, center, population, political_affiliation, state)
%GENERATE_CITY Summary of this function goes here
%   Detailed explanation goes here

cities = cell(size(radius, 1),1);
for i = 1:size(radius, 1)
    cities{i}.radius = radius(i);
    cities{i}.center = center(i,:);
    cities{i}.population = population(i)*(state.population);
    cities{i}.political_affiliation = ((rand(cities{i}.population,1) <= political_affiliation(i))+1)';

    A=randn(cities{i}.population,2); x=A(:,1)'; y=A(:,2)';
    cities{i}.homes = [round(cities{i}.radius*x + cities{i}.center(1)); ...
                       round(cities{i}.radius*y + cities{i}.center(2)); ...
                       cities{i}.political_affiliation]; 
end
end

