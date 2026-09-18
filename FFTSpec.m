function  FFTSpec(timeArray,dataArray)
    %% x
    dt = mean(diff(timeArray));
    % dt = mean(diff(accX_row));
    fs = 1 / dt;
    % Remove DC component (mean)
    x = dataArray;
    Nx = length(x);                         % Signal Length
    Yx = fft(x);                            % Fast Fourier transform
    P2x = abs(Yx/Nx);                       % bilateral spectrum
    P1x = P2x(1:floor(Nx/2+1));             % Single-sided spectrum
    P1x(2:end-1) = 2*P1x(2:end-1);          % the amplitude is doubled
    fx(:,1) = fs*(0:floor(Nx/2))/Nx;        % Frequency Axis (Single-Sided)
    % Plot the amplitude spectrum
    figure;
    plot(fx, P1x);
    xlabel('Frequency (Hz)');
    ylabel('range');
    title('X unilateral amplitude spectrum');
    grid on;
end