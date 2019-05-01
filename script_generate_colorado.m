%{
script_generate_colorado.m

%}
rng default

% state_population, 
% state_size, 
% city_radiuses, 
% city_centers,
% city_populations, 
% city_political_affiliations, 
% state_political_affiliations


%% information on colorado

% colorado is 380 miles long by 280 miles wide (2006400 ft by 1478400 ft)
% (http://www.netstate.com/states/geography/co_geography.htm)
% an average house size in colorado is 2412 sqft (which is 49.1 by 49.1)
% (https://www.9news.com/article/money/business/see-how-denvers-average-home-size-compares-to-other-major-cities/73-600483388)
% Thus,
% Colorado normalized to average house is: 40864 pixels by 30110 pixels
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

%% Defining city centers of colorado

w = 40864;
h = 30110;

test = zeros(h, w);

figure, 
imshow(test), hold on,
plot(round(w*0.5647), round(h*0.6416), 'ro', 'LineWidth', 4), hold on, % Denver
plot(round(w*0.5961), round(h*0.4545), 'bo', 'LineWidth', 4), hold on, % Colorado Springs
plot(round(w*0.5863), round(h*0.6338), 'go', 'LineWidth', 4), hold on, % Aurora
plot(round(w*0.5490), round(h*0.7974), 'co', 'LineWidth', 4), hold on, % Fort Collins
plot(round(w*0.3922), round(h*0.7013), 'mo', 'LineWidth', 4), hold on, % Lakewood
plot(round(w*0.5608), round(h*0.6779), 'yo', 'LineWidth', 4), hold on, % Thornton
plot(round(w*0.6157), round(h*0.3403), 'r*', 'LineWidth', 4), hold on, % Pueblo
plot(round(w*0.5667), round(h*0.7299), 'c*', 'LineWidth', 4), hold on, % Arvada
plot(round(w*0.3529), round(h*0.8312), 'g*', 'LineWidth', 4), hold on, % Westminster
plot(round(w*0.6020), round(h*0.5662), 'm*', 'LineWidth', 4), hold on, % Centennial

%%
tStart = tic;

state_population = 5029;%196;
state_size = [40864,30110];
city_radiuses = [645,521,360,410,613,270,291,210,256,197]';
city_centers = [[round(w*0.5647), round(h*0.6416)]; ...
                [round(w*0.5961), round(h*0.4545)]; ...
                [round(w*0.5863), round(h*0.6338)]; ...
                [round(w*0.5490), round(h*0.7974)]; ...
                [round(w*0.3922), round(h*0.7013)]; ...
                [round(w*0.5608), round(h*0.6779)]; ...
                [round(w*0.6157), round(h*0.3403)]; ...
                [round(w*0.5667), round(h*0.7299)]; ...
                [round(w*0.3529), round(h*0.8312)]; ...
                [round(w*0.6020), round(h*0.5662)]];
city_populations = [0.2193, 0.1828, 0.1646, 0.1286, 0.1284, 0.0236, 0.0212, 0.0212, 0.0211 0.0200]';
city_political_affiliations = [0.25, 0.68, 0.47, 0.56, 0.52, 0.41, 0.33, 0.48, 0.48, 0.5]';
state_political_affiliations = 0.51;

[colorado, colorado_information] = generate_state(state_population, ...
                                                  state_size, ...
                                                  city_radiuses, ...
                                                  city_centers, ...
                                                  city_populations, ...
                                                  city_political_affiliations, ...
                                                  state_political_affiliations);
                                     
figure,
scatter(colorado_information.homes(colorado_information.republicans,1),colorado_information.homes(colorado_information.republicans,2),'r.'), hold on,
scatter(colorado_information.homes(colorado_information.democrats,1),colorado_information.homes(colorado_information.democrats,2),'b.'), hold on,
legend('republicans','democrats'), title('Colorado'), xlim([0 10000]), ylim([0 10000]), axis tight,
axis on,
disp(['Colorado: percent of democrats: ',num2str(size(colorado_information.democrats,1)/colorado_information.population), ', percent of republicans: ',num2str(size(colorado_information.republicans,1)/colorado_information.population)]);

                                      
tEnd = toc(tStart);
disp(['time to gen colorado: ', num2str(tEnd), ' secs'])
%% run kmeans on colorado

tStart = tic;

clusters = 7; isPlotParty = 0;
kmeans_alg(colorado_information,clusters,isPlotParty);
                                 
tEnd = toc(tStart);
disp(['time to produce kmeans and graph on colorado: ', num2str(tEnd/60), ' mins'])


