clear, close all, clc;

chenfangfang_autismtraits_init_param;
input_dir = fullfile(g.base_dir, g.raw_folder);
output_dir = fullfile(g.base_dir, g.postica_output_folder);
[input_fn, id] = get_fileinfo(input_dir, g.file_ext);
output_fn = fullfile(g.base_dir, g.postica_output_folder, strcat(id, '_postica.set'));
if ~exist(fullfile(g.base_dir, g.postica_output_folder), 'dir')
    mkdir(fullfile(g.base_dir, g.postica_output_folder));
end

for i = 1:numel(id)
    
    fprintf('dataset %i/%i: %s\n', i, numel(id), id{i});
    if exist(output_fn{i}, 'file')
        warning('files alrealy exist!');
        continue;
    end
    EEG = import_data(input_dir, input_fn{i});
    mat = parload(fullfile(g.base_dir, g.ica_output_folder, strcat(id{i}, '_ica.mat')));
    EEG = preproc_postica(EEG, g, mat.bk);
    parsaveset(EEG, output_fn{i});
    
end
