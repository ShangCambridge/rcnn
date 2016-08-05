function boxes = selective_search_boxes_batch(imdb, width, perc)
% boxes = selective_search_boxes_batch(imdb)

NumWorkers = 20;
%taskPool = gcp();
myCluster = parcluster('local'); 
myCluster.NumWorkers = NumWorkers; 
taskPool = parpool (myCluster, NumWorkers)
fprintf ('Have %d workers.\n', NumWorkers);

% init limits for each worker
start_ids = zeros(NumWorkers,1);
end_ids   = zeros(NumWorkers,1);
for i = 1 : NumWorkers
  start_ids(i) = int32(length(imdb.image_ids) * perc / NumWorkers * (i - 1)) + 1;
  end_ids(i)   = int32(length(imdb.image_ids) * perc / NumWorkers * i);
end

% start each worker
for i = 1 : NumWorkers
  fprintf('Starting workerId %d with range [%d %d].\n', i, start_ids(i), end_ids(i));
  f(i) = parfeval (taskPool, @op_selective_search_boxes, 1, ...
                     start_ids(i), end_ids(i), imdb, width);
end

% wait for each worker
boxes = {};
for i = 1 : NumWorkers
  [completedIdx, worker_boxes] = fetchNext(f);
  fprintf('Completed workerId %d.\n', completedIdx);
  assert (length(worker_boxes) == end_ids(completedIdx) - start_ids(completedIdx) + 1);
  for j = 1 : length(worker_boxes)
    boxes{start_ids(completedIdx) + j-1} = worker_boxes{j};
  end
end

delete(gcp('nocreate'))

