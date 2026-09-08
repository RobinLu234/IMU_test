function  pwelchSpec(timeArray,dataArray)
    %% x
    fs = 1 / mean(diff(timeArray));   % 采样频率，你的数据约 61.44 Hz
    [pxx, f] = pwelch(dataArray, [], [], [], fs);
    pxx_db = 10*log10(pxx);
    
    figure;
    plot(f, pxx_db);
    xlabel('频率 (Hz)');
    ylabel('功率谱密度 (dB/Hz)');
    title('加速度功率谱密度');
    grid on;
end