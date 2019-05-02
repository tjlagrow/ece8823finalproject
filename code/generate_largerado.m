function [largerado, largerado_information] = generate_largerado(isRandomization,isPlot)
%{
script_generate_colorado.m

%}
disp('Starting to generate Largerado')

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

%% information on colorado

% colorado is 380 miles long by 280 miles wide (2006400 ft by 1478400 ft)
% (http://www.netstate.com/states/geography/co_geography.htm)
% an average house size in colorado is 2412 sqft (which is 49.1 by 49.1)
% (https://www.9news.com/article/money/business/see-how-denvers-average-home-size-compares-to-other-major-cities/73-600483388)
% Thus,
% Colorado normalized to average house is: 40860 pixels by 30110 pixels
% 
% Colorado population: 5029196 (2010)
% (https://factfinder.census.gov/faces/nav/jsf/pages/community_facts.xhtml?src=bkmk)
% 
% Top 10 cities in colorado (2010): 
% City: population, Democrat/Republican, radius(normalized to pixels)
% Denver: 600158, 0.75/0.25, 645
% Colorado Springs: 416427, 0.32/0.68, 521
% Aurora: 325078, 0.53/0.47, 360
% Fort Collins: 143986, 0.44/0.56, 410
% Lakewood: 142980, 0.48/0.52, 613
% Thornton: 118772, 0.59/0.41, 270 
% Pueblo: 106595, 0.67/0.33, 291
% Arvada: 106433, 0.52/0.48, 210
% Westminster: 106114, 0.52/0.48, 256, 
% Centennial: 100377 0.5/0.5, 197
% Total of rest: 2862276 (~0.56 of population), 0.49/0.51
% (https://www.sos.state.co.us/pubs/elections/VoterRegNumbers/2010VoterRegNumbers.html)
% (https://www.worldatlas.com/articles/the-largest-cities-in-colorado.html)


%%
% since this is LARGERADO each data point represents 50 houses (round(5029196/50))
% (this essentially takes into account neighborhoods or close residents
% that share the same political view)
state_population = 100584;
state_size = [40860,30110];
city_radiuses = [645,521,490,410,613,270,291,210,256,197]';
city_centers = [[round(state_size(1)*0.5647), round(state_size(2)*0.6416)]; ...
                [round(state_size(1)*0.5961), round(state_size(2)*0.4545)]; ...
                [round(state_size(1)*0.6063), round(state_size(2)*0.6738)]; ...
                [round(state_size(1)*0.5490), round(state_size(2)*0.7974)]; ...
                [round(state_size(1)*0.3922), round(state_size(2)*0.7013)]; ...
                [round(state_size(1)*0.5608), round(state_size(2)*0.6879)]; ...
                [round(state_size(1)*0.6157), round(state_size(2)*0.3403)]; ...
                [round(state_size(1)*0.5667), round(state_size(2)*0.7299)]; ...
                [round(state_size(1)*0.3529), round(state_size(2)*0.8312)]; ...
                [round(state_size(1)*0.6020), round(state_size(2)*0.5662)]];
city_populations = [0.1593, 0.1228, 0.1046, 0.0686, 0.0684, 0.0636, 0.0612, 0.0612, 0.0611 0.0600]';
city_political_affiliations = [0.75, 0.32, 0.53, 0.44, 0.48, 0.59, 0.67, 0.52, 0.52, 0.5]';
state_political_affiliations = 0.49;

[largerado, largerado_information] = generate_state(state_population, ...
                                                  state_size, ...
                                                  city_radiuses, ...
                                                  city_centers, ...
                                                  city_populations, ...
                                                  city_political_affiliations, ...
                                                  state_political_affiliations);

%% plot
if isPlot == 1
    figure,
    scatter(largerado_information.homes(largerado_information.republicans,1),largerado_information.homes(largerado_information.republicans,2),'r.'), hold on,
    scatter(largerado_information.homes(largerado_information.democrats,1),largerado_information.homes(largerado_information.democrats,2),'b.'), hold on,

    %%% Defining city centers of colorado
    city_names = {'Denver', 'Colorado Springs', 'Aurora', 'Fort Collins', 'Lakewood', 'Thornton', 'Pueblo', 'Arvada', 'Westminster', 'Centennial'};
    scatter(city_centers(:,1), city_centers(:,2), 50, 'g*'),
    xlim([1 state_size(1)]),
    ylim([1 state_size(2)]),
    text(city_centers(:,1),city_centers(:,2),city_names,'VerticalAlignment','bottom','HorizontalAlignment','left','FontSize',12),

    legend('republicans','democrats','city centers'), 
    title('Largerado'), 
    disp(['Largerado: percent of democrats: ',num2str(size(largerado_information.democrats,1)/largerado_information.population), ', percent of republicans: ',num2str(size(largerado_information.republicans,1)/largerado_information.population)]);

end



end

