function [newflormedium, newflormedium_information] = generate_newflormedium(isRandomization,isPlot)
%{
script for generating the synthetic data for the nobel land of  New FlorMedium
%}

disp('Starting to generate New Flormedium')

if nargin < 1 
    isRandomization = 1;
end
if nargin < 2
    isPlot = 1;
end

% 1 for default repoducibility
if isRandomization == 1
    rng('default'); % for repoducibility
end

% republican = 1, democrat = 2
state_population = 10000;
state_size = [3000,4000];
city_radiuses = [400,50,500,700,300,50]';
city_centers = [[1000 1000]; ...
                [2000 300]; ...
                [3200 1300]; ...
                [1500 2500]; ...
                [2300 2100]; ...
                [200 3700]];
city_populations = [0.3,0.1,0.1,0.2,0.2,0.05]';
city_political_affiliations = [0.6,0.3,0.4,0.1,0.9,0.1]';
state_political_affiliations = 0.5;

[newflormedium, newflormedium_information] = generate_state(state_population, ...
                                                      state_size, ...
                                                      city_radiuses, ...
                                                      city_centers, ...
                                                      city_populations, ...
                                                      city_political_affiliations, ...
                                                      state_political_affiliations);                  
                          
%%% Plot the state if isPlot is 1
if isPlot == 1
    figure,
    scatter(newflormedium_information.homes(newflormedium_information.republicans,1),newflormedium_information.homes(newflormedium_information.republicans,2),'r.'), hold on,
    scatter(newflormedium_information.homes(newflormedium_information.democrats,1),newflormedium_information.homes(newflormedium_information.democrats,2),'b.'), hold on,
    scatter(city_centers(:,1), city_centers(:,2), 50, 'kx'),
    legend('republicans','democrats','city center'), title('New Flormedium'), xlim([0 10000]), ylim([0 10000]), axis tight,
end

disp(['New Flormedium: percent of democrats: ',num2str(size(newflormedium_information.democrats,1)/newflormedium_information.population), ', percent of republicans: ',num2str(size(newflormedium_information.republicans,1)/newflormedium_information.population)]);

end

