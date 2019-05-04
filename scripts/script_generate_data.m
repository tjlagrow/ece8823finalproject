%{
script for generating the synthetic data used in this project
%}


[toysylvania, toysylvania_information] = generate_toysylvania(1,1,1);
[newflormedium, newflormedium_information] = generate_newflormedium(1,1,1);
[smallerado, smallerado_information, city_centers_smallerado] = generate_smallerado(1,1,1);
[largerado, largerado_information, city_centers_largerado] = generate_largerado(1,1,1);

