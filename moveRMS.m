function moveRMS(data,category)
% 假设 data 为 N×2 矩阵，第一列时间 t，第二列加速度 a
t = data(:,1);
if category=="deadlift"
    a_f = data(:,4);
else
    a_f = data(:,1);
end
fs = 1 / mean(diff(t));          % 采样频率


% 计算移动 RMS
winLen = round(0.3 * fs);        % 0.3秒窗口
if mod(winLen,2)==0
    winLen = winLen+1; 
end
rmsEnv = sqrt(movmean(a_f.^2, winLen));   % 移动均方根

% 绘制 RMS 以选择阈值
figure;
plot(t, rmsEnv);
xlabel('时间 (s)'); ylabel('RMS 加速度');
title('滑动 RMS 能量');

% 设定阈值（可根据图形调整，或自动选取，例如使用中位数+若干标准差）
% thresh = median(rmsEnv) + 5*std(rmsEnv);   % 自动阈值，也可手动指定
thresh = median(rmsEnv) + 1.3*std(rmsEnv);  
% thresh = 0.02;   % 如果已知尺度，手动设置

% 找到超过阈值的索引
active = rmsEnv > thresh;

% 去除短暂抖动：要求至少持续 minDur 秒
minDur = 0.25;                       % 最短有效动作持续时间
minSamples = round(minDur * fs);
active2 = bwareaopen(active, minSamples);  % 需要 Image Processing Toolbox，或用下面的方法
figure;
hold on
plot(active2,'r','marker','o')
plot(active,'b')
% 如果没有 Image Processing Toolbox，手动实现：
% active = active(:)';
% d = diff([0 active 0]);
% startIdx = find(d==1);
% endIdx = find(d==-1)-1;
% durations = endIdx - startIdx + 1;
% valid = durations >= minSamples;
% startIdx = startIdx(valid);
% endIdx = endIdx(valid);
% active = zeros(size(active));
% for k = 1:length(startIdx)
%     active(startIdx(k):endIdx(k)) = 1;
% end

% 提取主要动作区间（选取最长的一段或合并靠近的段）
% 这里简单选取最长的连续有效段
d = diff([0 active2(:)' 0]);
starts = find(d==1);
ends = find(d==-1)-1;
if ~isempty(starts)
    % [~, idx] = max(ends - starts + 1);   % 最长段
    % validStart = starts(idx);
    % validEnd = ends(idx);
    validStart = starts(1);
    validEnd = ends(end);
else
    error('未检测到有效动作段');
end

% 裁剪信号
t_valid = t(validStart:validEnd);
a_valid = a_f(validStart:validEnd);

% 此时可以对有效段进行积分得到速度
v0 = 0;
velocity_valid = v0 + cumtrapz(t_valid, a_valid);

% 绘制结果
figure;
subplot(2,1,1);
plot(t, a_f); hold on;
plot(t_valid, a_valid, 'r', 'LineWidth',1.5);
legend('原始滤波信号','有效动作段');
xlabel('时间 (s)'); ylabel('加速度');
title('信号分段');

subplot(2,1,2);
plot(t_valid, velocity_valid);
xlabel('时间 (s)'); ylabel('速度');
title('有效动作段积分得到的速度');