function  FFTSpec(timeArray,dataArray)
    %% x
    dt = mean(diff(timeArray));
    % dt = mean(diff(accX_row));
    fs = 1 / dt;
    % 去除直流分量（均值）
    x = dataArray;
    Nx = length(x);               % 信号长度
    Yx = fft(x);                  % 快速傅里叶变换
    P2x = abs(Yx/Nx);               % 双边频谱
    P1x = P2x(1:floor(Nx/2+1));            % 单边频谱
    P1x(2:end-1) = 2*P1x(2:end-1); % 除了直流分量外，幅值加倍
    fx(:,1) = fs*(0:floor(Nx/2))/Nx;          % 频率轴（单边）
    % 绘制幅度谱
    figure;
    plot(fx, P1x);
    xlabel('频率 (Hz)');
    ylabel('幅度');
    title('X单边幅度谱');
    grid on;
end