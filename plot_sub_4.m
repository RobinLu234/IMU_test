function plot_sub_4(file_name_nosuf,data,title_list)
    time = data(:,1);
    X = data(:,2);
    Y = data(:,3);
    Z = data(:,4);
    Abs = data(:,5);
    figure('Name',file_name_nosuf);
    sgtitle(title_list(1), 'FontSize', 14, 'FontWeight', 'bold');
    subplot(4, 1, 1);
    plot(X,'r');
    ylabel(title_list(2), 'FontSize', 10, 'FontWeight', 'bold')
    subplot(4, 1, 2);
    plot(Y,'b');
    ylabel(title_list(3), 'FontSize', 10, 'FontWeight', 'bold')
    subplot(4, 1, 3);
    plot(Z,'g');
    ylabel(title_list(4), 'FontSize', 10, 'FontWeight', 'bold')
    subplot(4, 1, 4);
    plot(Abs,'k');
    ylabel(title_list(5), 'FontSize', 10, 'FontWeight', 'bold')


end
