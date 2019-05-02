%{
Pineline for final project ECE8823
%}

%% Step 1: Generate Synthetic Data

script_generate_data;

%% Step 2: Evaluate Ground True for Evaluation of Algorithms

script_generate_smallerado_ground_truth;
script_generate_largerado_ground_truth;

%% Step 3: Evaluate ground truth

script_evaluate_ground_truth;

%% Step 4: Standard kmeans

script_run_standard_kmeans;

%% Step 5: Warm Start kmeans

script_run_soft_start_kmeans;

%% Step 5: Warm Start with Compactness Regularization/s

script_run_soft_start_L1_min_kmeans;

script_run_soft_start_L2_min_kmeans;

