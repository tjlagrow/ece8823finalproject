%{
script_generate_synthetic_data.m

%}
rng('default'); % for repoducibility
% republican = 1, democrat = 2

% state_population, 
% state_size, 
% city_radiuses, 
% city_centers,
% city_populations, 
% city_political_affiliations, 
% state_political_affiliations
[utah, utah_information] = generate_state(10000, ...
                                          [15000,10000], ...
                                          [450,200,100]', ...
                                          [[8000 4000]; ...
                                           [3500 3000]; ...
                                           [8000 8000]], ...
                                          [0.5,0.1,0.1]', ...
                                          [0.8,0.4,0.7]', ...
                                          0.5);
                  
[kansas, kansas_information] = generate_state(6000, ...
                                              [8000,7000], ...
                                              [350,150]', ...
                                              [[6000 3000]; ...
                                               [4000 3000];], ...
                                              [0.6,0.1]', ...
                                              [0.8,0.3]', ...
                                              0.2);
                  
[oregon, oregon_information] = generate_state(18000, ...
                                              [20000,15000], ...
                                              [700,450,200,100]', ...
                                              [[10000 4000]; ...
                                               [6000 13000]; ...
                                               [17000 10000]; ...
                                               [3000 4000]], ...
                                              [0.5,0.3,0.1,0.05]', ...
                                              [0.9,0.7,0.3,0.2]', ...
                                              0.1);                  
[toy, toy_information] = generate_state(500, ...
                                        [1000,1000], ...
                                        [100]', ...
                                        [[300 600];], ...
                                        [0.8]', ...
                                        [0.9]', ...
                                        0.1);                  

                                          
%%%
figure,
scatter(utah_information.homes(utah_information.republicans,1),utah_information.homes(utah_information.republicans,2),'r.'), hold on,
scatter(utah_information.homes(utah_information.democrats,1),utah_information.homes(utah_information.democrats,2),'b.'), hold on,
legend('republicans','democrats'), title('Utah'), xlim([0 10000]), ylim([0 10000]), axis tight,
disp(['Utah: percent of democrats: ',num2str(size(utah_information.democrats,1)/utah_information.population), ', percent of republicans: ',num2str(size(utah_information.republicans,1)/utah_information.population)]);

figure,
scatter(kansas_information.homes(kansas_information.republicans,1),kansas_information.homes(kansas_information.republicans,2),'r.'), hold on,
scatter(kansas_information.homes(kansas_information.democrats,1),kansas_information.homes(kansas_information.democrats,2),'b.'), hold on,
legend('republicans','democrats'), title('Kansas'), xlim([0 10000]), ylim([0 10000]), axis tight,
disp(['Kansas: percent of democrats: ',num2str(size(kansas_information.democrats,1)/kansas_information.population), ', percent of republicans: ',num2str(size(kansas_information.republicans,1)/kansas_information.population)]);

figure,
scatter(oregon_information.homes(oregon_information.republicans,1),oregon_information.homes(oregon_information.republicans,2),'r.'), hold on,
scatter(oregon_information.homes(oregon_information.democrats,1),oregon_information.homes(oregon_information.democrats,2),'b.'), hold on,
legend('republicans','democrats'), title('Oregon'), xlim([0 10000]), ylim([0 10000]), axis tight,
disp(['Oregon: percent of democrats: ',num2str(size(oregon_information.democrats,1)/oregon_information.population), ', percent of republicans: ',num2str(size(oregon_information.republicans,1)/oregon_information.population)]);

figure,
scatter(toy_information.homes(toy_information.republicans,1),toy_information.homes(toy_information.republicans,2),'r.'), hold on,
scatter(toy_information.homes(toy_information.democrats,1),toy_information.homes(toy_information.democrats,2),'b.'), hold on,
legend('republicans','democrats'), title('Toy'), xlim([0 10000]), ylim([0 10000]), axis tight,
disp(['Toy: percent of democrats: ',num2str(size(toy_information.democrats,1)/toy_information.population), ', percent of republicans: ',num2str(size(toy_information.republicans,1)/toy_information.population)]);



