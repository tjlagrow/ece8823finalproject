%{
script_generate_synthetic_data.m

%}
rng('default');
% democrat = 2, republican = 1

state.population = 10000;

city_1.radius = 450;
city_1.center = [8000 4000];
city_1.population = 0.4*(state.population); % 30% of the total state population
city_1.political_affiliation = ((rand(city_1.population,1) <= 0.8)+1)'; % D: 80%, R: 20%

city_2.radius = 200;
city_2.center = [3500 3000];
city_2.population = 0.3*(state.population); % 20% of the total state population
city_2.political_affiliation = ((rand(city_2.population,1) <= 0.4)+1)'; % D: 40%, R: 60%

city_3.radius = 100;
city_3.center = [8000 8000];
city_3.population = 0.1*(state.population); % 10% of the total state population
city_3.political_affiliation = ((rand(city_3.population,1) <= 0.7)+1)'; % D: 70%, R: 30%

A=randn(city_1.population,2); x=A(:,1)'; y=A(:,2)';
city_1.homes = [round(city_1.radius*x + city_1.center(1)); ...
                round(city_1.radius*y + city_1.center(2)); ...
                city_1.political_affiliation]; 

A=randn(city_2.population,2); x=A(:,1)'; y=A(:,2)';
city_2.homes = [round(city_2.radius*x + city_2.center(1)); ...
                round(city_2.radius*y + city_2.center(2)); ...
                city_2.political_affiliation]; 

A=randn(city_3.population,2); x=A(:,1)'; y=A(:,2)';
city_3.homes = [round(city_3.radius*x + city_3.center(1)); ...
                round(city_3.radius*y + city_3.center(2)); ...
                city_3.political_affiliation];
                
state.homes = [city_1.homes(1,:)',city_1.homes(2,:)',city_1.homes(3,:)';
               city_2.homes(1,:)',city_2.homes(2,:)',city_2.homes(3,:)';
               city_3.homes(1,:)',city_3.homes(2,:)',city_3.homes(3,:)';];
           
state.homes_repeat = [];
for i = 1:size(state.homes, 1)
    current_home = state.homes(i,:);
    for j = 1:size(state.homes, 1)
        if i~=j && isequal(state.homes(j,1),current_home(1)) && isequal(state.homes(j,2),current_home(2))
            state.homes_repeat = [state.homes_repeat; j];
        end 
    end
end
a =1:size(state.homes);
a(state.homes_repeat) = [];
state.homes = state.homes(a,:,:);
             
                
Kansarkanutah = zeros(10000,10000,2);
for i = 1:size(state.homes,1)
    Kansarkanutah(state.homes(i,1),state.homes(i,2),1) = 1;
end


others.population = state.population-nnz(Kansarkanutah(:,:,1)); % 20% of the total state population
others.political_affiliation = ((rand(others.population,1) <= 0.5)+1)'; % D: 50%, R: 50%
[row, col] = find(Kansarkanutah(:,:,1)==0);
interm = randi([1 size(row,1)],others.population,1);
for i = 1:size(interm,1)
    Kansarkanutah(row(interm(i)), col(interm(i)),1) = 1;
    state.homes = [state.homes; row(interm(i)), col(interm(i)), others.political_affiliation(i)];
end  

for i = 1:size(state.homes,1)
    Kansarkanutah(state.homes(i,1),state.homes(i,2),2) = state.homes(i,3);
end

republicans = find(state.homes(:,3) == 1);
democrats = find(state.homes(:,3) == 2);

figure,
scatter(state.homes(republicans,1),state.homes(republicans,2),'r.'), hold on,
scatter(state.homes(democrats,1),state.homes(democrats,2),'b.'), hold on,
legend('republicans','democrats'),
xlim([0 10000]), ylim([0 10000]),
axis tight,

percent_of_democrats = size(democrats,1)/state.population;
percent_of_republican = size(republicans,1)/state.population;
disp(['percent of democrats: ',num2str(percent_of_democrats), ...
    ', percent of republicans: ',num2str(percent_of_republican)]);






