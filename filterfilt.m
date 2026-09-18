function [data_filt] = filterfilt(data,f_low,f_high)
fs = 1 / mean(diff(data(:,1)));   % Sampling Frequency

order = 4;
f_filt=[f_low, f_high]/(fs/2);
if ~isempty(f_low) & ~isempty(f_high)
    filter = 'bandpass'; 
elseif isempty(f_low) & ~isempty(f_high)
    filter = 'low'; 
elseif ~isempty(f_low) & isempty(f_high)
    filter = 'high'; 
elseif isempty(f_low) & isempty(f_high)
    1;
end
[b, a] = butter(order,f_filt , filter);
data_filt(:,1) = data(:,1);
data_filt(:,2) = filtfilt(b, a, data(:,2));
data_filt(:,3) = filtfilt(b, a, data(:,3));
data_filt(:,4) = filtfilt(b, a, data(:,4));
data_filt(:,5) = filtfilt(b, a, data(:,5));
end