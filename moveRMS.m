function [valid_range,winLen] = moveRMS(data,category)
% 
t = data(:,1);
if category=="deadlift"
    a_f = data(:,4);
elseif category=="bench"
    a_f = data(:,5);
else
    a_f = data(:,2);
end
fs = 1 / mean(diff(t));          % Sampling Frequency


% Calculate moving RMS
winLen = round(0.3 * fs);        % 0.3-second window
if mod(winLen,2)==0
    winLen = winLen+1; 
end
rmsEnv = sqrt(movmean(a_f.^2, winLen));   % Moving RMS

% Plot RMS to pick a threshold
% figure;
% plot(t, rmsEnv);
% xlabel('time (s)'); ylabel('RMS Acceleration');
% title('Sliding RMS Energy');

% Set the threshold (can be adjusted based on the graph, or automatically chosen, for example using the median plus a few standard deviations)
% thresh = median(rmsEnv) + 5*std(rmsEnv);   % 
thresh = median(rmsEnv) + 1.3*std(rmsEnv);  
% thresh = 0.02;   % If the scale is known, set it manually

% Find the indexes that exceed the threshold
active = rmsEnv > thresh;

% Remove brief shakes: must last at least minDur seconds
minDur = 0.25;                       % Shortest effective action duration
minSamples = round(minDur * fs);
active2 = bwareaopen(active, minSamples);  
% figure;
% hold on
% plot(active2,'r','marker','o')
% plot(active,'b')

% Extract main action interval

d = diff([0 active2(:)' 0]);
starts = find(d==1);
ends = find(d==-1)-1;
if ~isempty(starts)
    validStart = starts(1);
    validEnd = ends(end);
else
    error('No valid action segments detected');
end

% Clipping Signal
t_valid = t(validStart:validEnd);
a_valid = a_f(validStart:validEnd);
valid_range=(validStart:validEnd).';
%  integrate the valid segment to get the speed.
v0 = 0;
velocity = v0 + cumtrapz(t, a_f);
velocity_valid = v0 + cumtrapz(t_valid, a_valid);

% plot results
figure;
subplot(2,1,1);
plot(t, a_f); hold on;
plot(t_valid, a_valid, 'r', 'LineWidth',1.5);
legend('Original filtered signal', 'valid action segment');
xlabel('time (s)'); ylabel('acceleration');
title('Signal Segmentation');

subplot(2,1,2);
plot(t, velocity); hold on;
plot(t_valid, velocity_valid, 'r', 'LineWidth',1.5);
xlabel('time (s)'); ylabel('velocity');
title('The velocity gained from the effective motion segment');