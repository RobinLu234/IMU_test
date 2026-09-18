function  pwelchSpec(timeArray,dataArray)
    %% x
    fs = 1 / mean(diff(timeArray));   % Sampling Frequency
    [pxx, f] = pwelch(dataArray, [], [], [], fs);
    pxx_db = 10*log10(pxx);
    
    figure;
    plot(f, pxx_db);
    xlabel('Frequency (Hz)');
    ylabel('Power Spectral Density (dB/Hz)');
    title('Acceleration Power Spectral Density');
    grid on;
end