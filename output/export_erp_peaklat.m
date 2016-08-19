%% script for exporting peak amplitude
chan_label = {'Fz'}; %channel labels of interest
time_range = [200, 300]; % time range of erp component
output_dir = ''; % output directory
comp_tag = 'FRN';
comp_direction = 'negative';
group_str = 'cn';

%% compute erp
subj = STUDY.subject;
var = STUDY.design(1).variable(1).value;
[STUDY, erp_data, erp_times] = std_erpplot(STUDY, ALLEEG, ...
                                           'channels', chan_label, ...
                                           'noplot', 'on', ...
                                           'averagechan', 'on');
% time index
t = dsearchn(erp_times', time_range');
% prepare output name
time_str = strcat('t', strrep(num2str(time_range), '  ', '-'));
chan_str = cellstrcat(chan_label, '-');

fname_p = strcat(group_str, '_', comp_tag, '_peak_', chan_str, '_', time_str, '.csv');
fname_pl = strcat(group_str, '_', comp_tag, '_latency_', chan_str, '_', time_str, '.csv');

fname_full_p = fullfile(output_dir, fname_p);
fname_full_pl = fullfile(output_dir, fname_pl)

header = strcat('subject,', cellstrcat(var, ','), '\n');

fid_p = fopen(fname_full_p, 'w');
fid_pl = fopen(fname_full_pl, 'w');

fprintf(fid_p, header);
fprintf(fid_pl, header);

samples = t(1):t(2);

for i_s = 1:numel(subj)
    fprintf(fid_p, [subj{i_s}, ',']);
    fprintf(fid_pl, [subj{i_s}, ',']);
    erp_str_p = [];
    erp_str_pl = [];
    for i_v = 1:numel(var)
        erp_tmp = erp_data{i_v}(t(1):t(2), i_s);
        switch comp_direction
          case 'positive'
            p = max(erp_tmp);
          case 'negative'
            p = min(erp_tmp);
        end
        pl = erp_times(samples(erp_tmp==p));
        erp_str_p = [erp_str_p, cell(num2str(p))];
        erp_str_pl = [erp_str_pl, cell(num2str(pl))];
    end % within var end
        fprintf(fid_p, strcat(cellstrcat(erp_str_p, ','), '\n'));
        fprintf(fid_pl, strcat(cellstrcat(erp_str_pl, ','), '\n'));
end % subj loop end
    fclose(fid_p);
    fclose(fid_pl);
