%% script for exporting averaged amplitude 平均波幅

base_dir = 'E:\Data\mabin';
output_folder = 'output_erp';
chan_labels = {'Pz'}; % or {'Pz', 'P1', 'P2'} 多个点
time_range = [400 1000];  % 波幅时间（ms）范围
component_label = 'LPP'; % 成分名称

% Code begins
output_dir = fullfile(base_dir, output_folder);
mkdir_p(output_dir);

subj = to_col_vector(STUDY.subject);

[STUDY, erp_data, erp_times] = ...
    std_erpplot(STUDY, ALLEEG, ...
                'channels', chan_labels, ...
                'noplot', 'on', ...
                'averagechan', 'on');

var1 = to_row_vector(STUDY.design(1).variable(1).value);
var2 = to_row_vector(STUDY.design(1).variable(2).value);
vars = cellstr_join(var1, var2, '_');
erp_data = erp_data(:); 

amps = zeros(length(subj), length(vars));
for i = 1:length(vars)  % loop through the group
    amps(:,i) = pick_amplitude(erp_data{i}, erp_times, time_range);
end

 % prepare to write
    hdr = [{'subj'},vars];
    amps_to_write = [hdr; [subj, num2cellstr(amps)]];
    
    fname_amps = sprintf('amp-%s_%s_t%i-%i.csv', ...
                         component_label,...
                         str_join(chan_labels, '-'),...
                         time_range(1),...
                         time_range(2));
    
    % write
    cell2csv(fullfile(output_dir, fname_amps), amps_to_write, ','); 