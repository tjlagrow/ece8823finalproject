%% Balanced K-means with gravity (BKMG)
%

clc; 
%K = 9; % define number of clusters
colcode = ["r.", "g.", "b.", "y.","c.", "m.", "k.","c.", "m.", "k.","b.", "y.","c.",]; % define cluster colors (must have at least K elements)
load Xsaved.mat
N = length(Xsaved);

%% process
for K = [2,4,6,7]

    %% test a mixture of Gaussians
    % X(:, 1:N/3) = (1.5.*randn(2, N/3) + [5; 3]); 
    % X(:, N/3+1:2*N/3) = (0.8.*randn(2, N/3) - [2; 2]);
    % X(:, 2*N/3+1:end) = randn(2, N/3);

    % initialize centroids according to same distribution as Xsaved
    C = (1.5.*randn(2, K) + [5; 3]) + (0.8.*randn(2, K) - [2; 2]) + randn(2, K);

    min_size_tol = 0.95; % tolerance on ratio between size of smallest cluster & target (N/K)
    max_size_tol = 1.05; % tolerance on ratio between size of smallest cluster & target (N/K)
    gravity = .2; % centroid movement parameter -- centroids will move towards largest cluster
    error_tol = 1e-3; % error tolerance
    error = 100*error_tol; % initialize error
    maxiter = 100; % max # of iterations

    alpha = 0; beta = 0.5; % params for modified l2 distance metric
    % note that for alpha > 0, clusters may be noncontiguous but size
    % constraint is tighter in general. I wasn't able to get this part working
    % while enforcing contiguous clusters

    %% Run on Oregon data
    % K = 6;
    % oregon_pop = oregon_information.homes(:, 1:2)';
    % N = length(oregon_pop);
    % X = oregon_pop;
    % Cidx = randperm(N);
    % C = X(:, Cidx(1:K));

    %% Use the same values of X for each experiment
    X = Xsaved;

    Ctrack = zeros(2, K, maxiter+1); % keep track of cluster updates
    xdistance = zeros(N, K); % keep track of distance from each data point to each centroid
    Csize = zeros(K, 1); % keep track of cluster size
    Csize(1) = inf; % to initialize stopping criteria
    assignments = zeros(N, 2); % data assignments: [X index, C index]
    error_tracker = zeros(maxiter, 1);
    error_array = zeros(2, K);
    t = 0;
    st = (1/K).*ones(1, K); % initialize modified l2 metric

    %% Main Algorithm
    while t <= maxiter && (min(Csize)/(N/K) < min_size_tol || ...
            max(Csize)/(N/K) > max_size_tol) && error > error_tol
        disp(t)
        t = t+1;
        Ctrack(:, :, t) = C;
        Csize = (N/K).*ones(K, 1); % keep track of cluster size
        for n = 1:N
            % calculate distance to each centroid
            for k = 1:K
                xdistance(n, k) = norm(X(:, n) - C(:, k) , 2)^2;
            end
            % calculate modified l2 distance to each centroid
            w = (Csize'.^alpha)./sum(Csize'.^alpha); % weights based on cluster cardinality
            stm1 = st;
            st = beta.*stm1 + (1-beta).*w;
            xdmod = st.*xdistance;
            if alpha == 0
                % if alpha is 0, just use the standard l2 distance
                xdmod = xdistance; 
            end
            % assign points to nearest centroids until cluster is full & keep track of cluster size
            assignments(n, 1) = n;
            [~, closestC] = min(xdmod(n, :), [], 2);
            assignments(n, 2) = closestC;
            if n == 1
                Csize = zeros(K, 1);
            end
            Csize(closestC) = Csize(closestC) + 1;
        end
        Ccompare = Csize;

            % recalculate cluster centroids
        for k = 1:K
            C(:, k) = mean(X(:, assignments(assignments(:, 2) == k, 1)), 2);
        end

        % Move data to smallest cluster
        % iterate over clusters, from smallest to largest, and reassign data
        % until all clusters are near the target cardinality
        for k = 1:K 
            chosen = k; % selected cluster
            % get distance from this cluster to all the points not assigned to this cluster
            Xcompare = [xdmod(assignments(:, 2) ~= chosen, :), ...
                assignments(assignments(:, 2) ~= chosen, 1)];
            % sort data by distance to current cluster
            Xsorted = sortrows(Xcompare, chosen, 'ascend');
            % steal data from other clusters until cardinality criteria are met
            n = 1;
           % TAKE 
            while Ccompare(chosen)/(N/K) < min_size_tol && n <= size(Xsorted, 1)
                % choose data to take
                Xtake = Xsorted(n, end); % get index of candidate X
                takecluster = assignments(Xtake, 2); % cluster we're taking from
                Ccompare(chosen) = Ccompare(chosen) + 1; % reassign
                Ccompare(takecluster) = Ccompare(takecluster) - 1;
                assignments(Xtake, 2) = chosen; 
                n = n+1;
            end
        end

        % Nudge cluster centroids towards largest & nudge largest centroid away from overall mean
        % move cluster centroids closer to the centroid of the
        % largest cluster, by an amount relative to the difference in cluster
        % size
        if t > 1
            error_array = Ctrack(:, :, t) - Ctrack(:, :, t-1); % if cluster centers don't change, stop
        end
        [minpop, Cmin] = min(Ccompare);
        [maxpop, Cmax] = max(Ccompare);
        error = 0;
        for k = 1:K
            error = max(error, norm(error_array(:, k), 2)^2);
            Cmove_dist = 1 - (Ccompare(k)/Ccompare(Cmax));
            C(:, k) = C(:, k) - gravity.*Cmove_dist.*(C(:, k) - C(:, Cmax));
        end
        if t == 1
            error = 100*error_tol;
        end
        % nudge largest centroid away from the mean of the other centroids
        C(:, Cmax) = C(:, Cmax) + gravity.*(1 - (N/K)/maxpop).*...
            (C(:, Cmax) - mean(C(:, [1:Cmax-1, Cmax+1:end]), 2));
        % nudge largest centroid away from the mean of the data in the
        % largest cluster
        C(:, Cmax) = C(:, Cmax) + gravity.*(1 - (N/K)/maxpop).*...
            (C(:, Cmax) - mean(X(:, assignments(:, 2) == Cmax), 2));
        error_tracker(t) = error;
    end

    Csize = Ccompare;
    Ctrack(:, :, t+1) = C;
    minratio = min(Csize)/(N/K); % ratio of smallest cluster size to target size
    maxratio = max(Csize)/(N/K); % ratio of largest cluster size to target size

    %% Plot assignments
    figure; hold on;
    for i = 1:N
        plot(X(1, i), X(2, i), colcode(assignments(i, 2)));
    end
    plot(C(1, :), C(2, :), 'kx'); 
    title(num2str(Csize')); 
    xlabel(['Ratio of smallest to target: ', num2str(minratio), ...
        ', Ratio of largest to target: ', num2str(maxratio)]);
    ylabel(['Gravity = ', num2str(gravity)]);
    ax = gca; axlims = [ax.XLim, ax.YLim];

    %% Plot cluster updates
        figure; hold on;
        for k = 1:K
            kplot1 = reshape(Ctrack(1, k, :), length(Ctrack(1, k, :)), 1);
            kplot2 = reshape(Ctrack(2, k, :), length(Ctrack(2, k, :)), 1);
            plot(kplot1, kplot2, colcode(k));
            plot(kplot1(1), kplot2(1), 'ko');
            plot(kplot1(min(t, maxiter+1)), kplot2(min(t, maxiter+1)), 'kx');
        end
        title(['centroid updates, gravity = ', num2str(gravity)]);
        ax = gca; ax.XLim = axlims(1:2); ax.YLim = axlims(3:4);
end


