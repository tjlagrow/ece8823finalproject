%{
Pineline for final project ECE8823
%}

%% Step 1: Generate Synthetic Data

script_generate_data;

%% Step 2: Evaluate Ground True for Evaluation of Algorithms

script_generate_smallerado_ground_truth;
script_generate_largerado_ground_truth;

%% Step 3: Standard kmeans

script_run_kmeans_alg;

%% Step 4: Warm Start kmeans

%% more...