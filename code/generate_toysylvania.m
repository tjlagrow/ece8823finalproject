function [toysylvania, toysylvania_information] = generate_toysylvania(isRandomization,isPlot,isDisplay)
%{
script for generating the synthetic data for the proud state toysylvania
%}

if nargin < 1 
    isRandomization = 1;
end
if nargin < 2
    isPlot = 1;
end
if nargin < 3
    isDisplay = 1;
end

if isDisplay
    disp('Starting to generate Toysylvania')
end

% 1 for default repoducibility
if isRandomization == 1
    rng('default'); % for repoducibility
end

% republican = 1, democrat = 2
state_population = 1000;
state_size = [300,400];
city_radiuses = [40,10,50]';
city_centers = [[80 150]; ...
                [260 290]; ...
                [150 150]];
city_populations = [0.3,0.1,0.5]';
city_political_affiliations = [0.9,0.1,0.1]';
state_political_affiliations = 0.5;

[toysylvania, toysylvania_information] = generate_state(state_population, ...
                                                      state_size, ...
                                                      city_radiuses, ...
                                                      city_centers, ...
                                                      city_populations, ...
                                                      city_political_affiliations, ...
                                                      state_political_affiliations, ...
                                                      isDisplay);                  
                          
%%% Plot the state if isPlot is 1
if isPlot == 1
    figure,
    scatter(toysylvania_information.homes(toysylvania_information.republicans,1),toysylvania_information.homes(toysylvania_information.republicans,2),'r.'), hold on,
    scatter(toysylvania_information.homes(toysylvania_information.democrats,1),toysylvania_information.homes(toysylvania_information.democrats,2),'b.'), hold on,
    scatter(city_centers(:,1), city_centers(:,2), 150, 'g+'),
    legend('republicans','democrats','city center'), title('Toysylvania'), xlim([0 10000]), ylim([0 10000]), axis tight,
end

if isDisplay == 1
    disp(['Toysylvania: percent of democrats: ',num2str(size(toysylvania_information.democrats,1)/toysylvania_information.population), ', percent of republicans: ',num2str(size(toysylvania_information.republicans,1)/toysylvania_information.population)]);
end

end

