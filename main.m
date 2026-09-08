clear;
clc;
close all;

folder = "**\data";
file_list = dir(fullfile(folder,'*.xls'));
all_data=[];
actions={'bench','deadlift', 'row', 'squat'};
n=3;
for i = n:length(file_list)
    n=n+1;
    % full file path
    file_name = file_list(i).name;
    file_path = fullfile(file_list(i).folder, file_name);
    [file_name_nosuf, ~] = strtok(file_name, '.');
    action_word = strtok(file_name_nosuf,'-');
    action_word = string(lower(action_word));
    idx = find(strcmp(action_word, actions));
    if ~isempty(idx)
        category = actions{idx};  % 或 actions(idx) 如果是 string
    else
        category = 'unknown';     % 未匹配
    end
    % read data
    warning('off', 'MATLAB:table:ModifiedAndSavedVarnames');
    data_acc_row = table2array(readtable(file_path));

    % print progress
    fprintf('read file number %d : %s\n', i, file_name_nosuf);
    % plot row acc
    time_row = data_acc_row(:,1);
    accX_row = data_acc_row(:,2);
    accY_row = data_acc_row(:,3);
    accZ_row = data_acc_row(:,4);
    accAbs_row = data_acc_row(:,5);
    title_list_accrow={'acc-row','accX','accY','accZ','accAbs'};
    plot_sub_4(file_name_nosuf,data_acc_row,title_list_accrow);
    clear title_list_accrow;

    % calculate velocity and plot
    data_velo_row = CalcuVelo(data_acc_row);
    title_list_velodetrend={'velo-row','veloX','veloY','veloZ','veloAbs'};
    plot_sub_4(file_name_nosuf,data_velo_row,title_list_velodetrend);
    clear title_list_velodetrend;

    % Filtering_detrend
    data_acc_filter_detrend=[];
    data_acc_filter_detrend(:,1) = data_acc_row(:,1);
    data_acc_filter_detrend(:,2) = detrend(accX_row);
    data_acc_filter_detrend(:,3) = detrend(accY_row);
    data_acc_filter_detrend(:,4) = detrend(accZ_row);
    data_acc_filter_detrend(:,5) = detrend(accAbs_row);
    title_list_accdetrend={'acc-detrend','accX','accY','accZ','accAbs'};
    plot_sub_4(file_name_nosuf,data_acc_filter_detrend,title_list_accdetrend);
    clear title_list_accdetrend;
    data_velo_filter_detrend = CalcuVelo(data_acc_filter_detrend);
    title_list_velodetrend={'velo-filter-detrend','veloX','veloY','veloZ','veloAbs'};
    plot_sub_4(file_name_nosuf,data_velo_filter_detrend,title_list_velodetrend);
    clear title_list_velodetrend;

    % Filtering_demean
    data_acc_filter_demean=[];
    data_acc_filter_demean(:,1) = data_acc_row(:,1);
    data_acc_filter_demean(:,2) = accX_row-mean(accX_row);
    data_acc_filter_demean(:,3) = accY_row-mean(accY_row);
    data_acc_filter_demean(:,4) = accZ_row-mean(accZ_row);
    data_acc_filter_demean(:,5) = accAbs_row-mean(accAbs_row);

    title_list_accdemean={'acc-demean','accX','accY','accZ','accAbs'};
    plot_sub_4(file_name_nosuf,data_acc_filter_detrend,title_list_accdemean);
    clear title_list_accdemean;
    data_velo_filter_detrend = CalcuVelo(data_acc_filter_demean);
    title_list_velodemean={'velo-filter-demean','veloX','veloY','veloZ','veloAbs'};
    plot_sub_4(file_name_nosuf,data_velo_filter_detrend,title_list_velodemean);
    clear title_list_velodemean;

    % Plot the FFT magnitude spectrum
    FFTSpec(data_acc_filter_demean(:,1),data_acc_filter_demean(:,2))
    FFTSpec(data_acc_filter_demean(:,1),data_acc_filter_demean(:,4))

    % Plot the power spectral density
    pwelchSpec(data_acc_filter_demean(:,1),data_acc_filter_demean(:,2))
    pwelchSpec(data_acc_filter_demean(:,1),data_acc_filter_demean(:,4))

    %filtfilt
    f_low =0.1;      % High-pass filter, remove low-frequency drift
    f_high = 10;       % Low-pass cutoff, removing high-frequency noise (5~10 Hz)
    % [data_acc_filtfilt] = filterfilt(data_acc_filter_demean,f_low,f_high);
    data_acc_filtfilt = filterfilt(data_acc_filter_detrend,f_low,f_high);
    title_list_acc_filtfilt={'acc-filtfilt','accX','accY','accZ','accAbs'};
    plot_sub_4(file_name_nosuf,data_acc_filtfilt,title_list_acc_filtfilt);
    clear title_list_acc_filtfilt;
    data_velo_filtfilt = CalcuVelo(data_acc_filtfilt);
    title_list_velofiltfilt={'velo-filtfilt','veloX','veloY','veloZ','veloAbs'};
    plot_sub_4(file_name_nosuf,data_velo_filtfilt,title_list_velofiltfilt);
    clear title_list_velofiltfilt;
    
    %
    moveRMS(data_acc_filtfilt,category)
    % close all figure
    close all;
end