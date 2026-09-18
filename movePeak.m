function [peak_array,trough_array] = movePeak(winLen,velo_tar_valid)
winLen=61;
wincount = floor(length(velo_tar_valid)/winLen); % Calculate the total number of steps moved
range_end = 1;
is_findBePoint = 0;
is_findPkPoint = 0;
is_findFinPoint = 1;
is_findTrPoint = 0;
is_last_state=1;
begin_array = [];
peak_array = [];
finish_array = [];
trough_array = [];
velo_tar_rise=[];
velo_tar_fall=[];
figure;
plot(velo_tar_valid)
hold on;
for count = 1:wincount
    range_current = range_end : count * winLen ;
    is_zero = 0;
    is_rising_windows = 0;
    is_falling_windows = 0;
    is_max = 0;
    is_min = 0;
    % Calculate velocity passed through zero
    if min(velo_tar_valid(range_current))< 1.0e-3 && max(velo_tar_valid(range_current))>0
        is_zero = 1;
    end

    %Determine whether the speed inside the window is increasing or decreasing
    if velo_tar_valid(range_current(end))>velo_tar_valid(range_current(1))
        is_rising_windows = 1;
        is_falling_windows = 0;
        velo_tar_rise=[velo_tar_rise;[range_current(1),range_current(end)]];
        plot(range_current(1):range_current(end),velo_tar_valid(range_current(1):range_current(end)),'r',LineWidth=0.8)
    else
        is_rising_windows = 0;
        is_falling_windows = 1;
        velo_tar_fall=[velo_tar_fall;[range_current(1),range_current(end)]];
        plot(range_current(1):range_current(end),velo_tar_valid(range_current(1):range_current(end)),'g',Linewidth=0.8)
    end
    % if ~is_findBePoint && is_findFinPoint ...
    %        && is_rising_windows && (is_zero || isempty(begin_array) )
    %     is_findBePoint = 1;
    %     [po_begin_value,po_begin_index] = min(abs(velo_tar_valid(range_current)));
    %     begin_array = [begin_array;[po_begin_index+range_current(1),po_begin_value]];
    %     text(begin_array(end,1),begin_array(end,2),'be','color','r')
    %     is_findTrPoint = 0;
    % end
    % find point peak:The current stage is the falling windows, and the previous stage was the rising windows.
    if  is_falling_windows && is_last_state && ...
            (isempty(peak_array) || (velo_tar_rise(end,2) - peak_array(end,1) > 150))
        is_findPkPoint = 1;
        [peak_value,peak_index] = max(velo_tar_valid(velo_tar_rise(end,1):velo_tar_fall(end,2)));
        if (isempty(peak_array) || peak_value > 0.5*mean(peak_array(:,2)))
            peak_array = [peak_array;[peak_index+velo_tar_rise(end,1),peak_value]];
            plot(peak_array(end,1),peak_array(end,2),'o','color','b')
            text(peak_array(end,1)+30,peak_array(end,2),'pk','color','b')
            is_findBePoint = 0;

            if length(peak_array(:,1)) >= 2
                point_trough_between_peak_array = find(trough_array(:,1) >peak_array(end-1,1) ...
                    & trough_array(:,1) <peak_array(end,1));
                if length(point_trough_between_peak_array) >= 2
                    row_delete1=find(trough_array(point_trough_between_peak_array,2)>min(trough_array(point_trough_between_peak_array,2)));
                    trough_array(row_delete1+point_trough_between_peak_array(1)-1,:)=[];
                end
            end
        end
    end %find peak loop end
    % if is_findPkPoint && is_zero
    %     is_findFinPoint = 1;
    %     [po_finish_value,po_finish_index] = min(abs(velo_tar_valid(range_current)));
    %     finish_array = [finish_array;[po_finish_index+range_current(1),po_finish_value]];
    %     text(finish_array(end,1),finish_array(end,2),'fin','color','g')
    %     is_findPkPoint = 0;
    % end
    % find point Trough: The current stage is the rising windows, and the previous stage was the falling windows.
    if  is_rising_windows && ~is_last_state && velo_tar_rise(end,1) - peak_array(end,1) >=50
        is_findTrPoint = 1;
        [trough_value,trough_index] = min(velo_tar_valid(velo_tar_fall(end,1):velo_tar_rise(end,2)));
        if (isempty(peak_array) || trough_value<0.65*mean(peak_array(:,2))) ...
                &&(isempty(trough_array) || trough_value<mean(trough_array(:,2)) + 0.25 )
            trough_array = [trough_array;[trough_index+velo_tar_fall(end,1),trough_value]];
            plot(trough_array(end,1),trough_array(end,2),'x','color','k')
            text(trough_array(end,1)+30,trough_array(end,2),'Tr','color','k')
            is_findFinPoint = 0;
            if length(trough_array(:,1)) >= 2
                peaks_between_troughs = find(peak_array(:,1) > trough_array(end-1,1) ...
                    & peak_array(:,1) <trough_array(end,1));
                if length(peaks_between_troughs) >= 2
                    row_delete2=find(peak_array(peaks_between_troughs,2)>min(peak_array(peaks_between_troughs,2)));
                    peak_array(row_delete2+peaks_between_troughs-1,:)=[];
                end
            end
        end
    end %find trough loop end

    if is_rising_windows == 1
        is_last_state=1;
    elseif is_falling_windows == 1
        is_last_state=0;
    end

    range_end = count * winLen;
end %for loop end


end %function end
