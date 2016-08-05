addpath('selective_search')
addpath('imdb')
addpath('utils')
addpath('selective_search/SelectiveSearchCodeIJCV')
addpath('selective_search/SelectiveSearchCodeIJCV/Dependencies')

imdb = imdb_from_voc ('/home/etoropov/datasets/VOCdevkit', 'val', 'flickrlogoBin_spxl_ups');

% debugging with a fraction of imdb
perc = 1;

boxes = selective_search_boxes_batch(imdb, [], perc);

%path = '/home/etoropov/src/py-faster-rcnn/data/selective_search_data/voc_2007_test.mat';
path = '/home/etoropov/src/py-faster-rcnn/data/selective_search_data/flickrlogoBin_spxl_ups_val.mat';
if exist(path, 'file')
  delete (path);
end
save(path, 'boxes');
