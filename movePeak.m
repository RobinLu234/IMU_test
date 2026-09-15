function [point_begin_array,point_peak_array,point_finish_array] = movePeak(winLen,velo_tar_valid)
wincount = floor(length(velo_tar_valid)/winLen);
range_end = 1;
flag_findBePoint = 0;
flag_findPkPoint = 0;
flag_findFinPoint = 1;
flag_findTrPoint = 0;
flag_last_state=1;
point_begin_array = [];
point_peak_array = [];
point_finish_array = [];
point_trough_array = [];
velo_tar_rise=[];
velo_tar_fall=[];
figure;
plot(velo_tar_valid)
hold on;
for count = 1:wincount
    range_current = range_end : count * winLen ;
    flag_zero = 0;
    flag_rise = 0;
    flag_fall = 0;
    flag_max = 0;
    flag_min = 0;

    if min(velo_tar_valid(range_current))< 1.0e-3 && max(velo_tar_valid(range_current))>0
        flag_zero = 1;
    end
    if velo_tar_valid(range_current(end))>velo_tar_valid(range_current(1))
        flag_rise = 1;
        flag_fall = 0;
        velo_tar_rise=[velo_tar_rise;[range_current(1),range_current(end)]];
        plot([range_current(1),range_current(end)],[velo_tar_valid(range_current(1)),velo_tar_valid(range_current(end))],'r',LineWidth=0.8)
    else 
        flag_rise = 0;
        flag_fall = 1;
        velo_tar_fall=[velo_tar_fall;[range_current(1),range_current(end)]];
        plot([range_current(1),range_current(end)],[velo_tar_valid(range_current(1)),velo_tar_valid(range_current(end))],'g',Linewidth=0.8)
        
    end
    if ~flag_findBePoint && flag_findFinPoint ...
           && flag_rise && (flag_zero || isempty(point_begin_array) )
        flag_findBePoint = 1;
        [po_begin_value,po_begin_index] = min(abs(velo_tar_valid(range_current)));
        point_begin_array = [point_begin_array;[po_begin_index+range_current(1),po_begin_value]];
        text(point_begin_array(end,1),point_begin_array(end,2),'be','color','r')
        flag_findFinPoint = 0;
    end
    if  flag_fall && flag_last_state && ...
            (isempty(point_peak_array) || (velo_tar_rise(end,2) - point_peak_array(end,1) > 150))
        flag_findPkPoint = 1;
        [po_peak_value,po_peak_index] = max(velo_tar_valid(velo_tar_rise(end,1):velo_tar_fall(end,2)));
        point_peak_array = [point_peak_array;[po_peak_index+velo_tar_rise(end,1),po_peak_value]];
        text(point_peak_array(end,1),point_peak_array(end,2),'pk','color','b')
        flag_findBePoint = 0;
    end
    if flag_findPkPoint && flag_zero 
        flag_findFinPoint = 1;
        [po_finish_value,po_finish_index] = min(abs(velo_tar_valid(range_current)));
        point_finish_array = [point_finish_array;[po_finish_index+range_current(1),po_finish_value]];
        text(point_finish_array(end,1),point_finish_array(end,2),'fin','color','g')
        flag_findPkPoint = 0;
    end
    if  flag_rise && ~flag_last_state && velo_tar_rise(end,1) - point_peak_array(end,1) >=60
        flag_findTrPoint = 1;
        [po_trough_value,po_trough_index] = min(velo_tar_valid(velo_tar_fall(end,1):velo_tar_rise(end,2)));
        point_trough_array = [point_trough_array;[po_trough_index+velo_tar_rise(end,1),po_trough_value]];
        text(point_trough_array(end,1),point_trough_array(end,2),'Tr','color','k')
        flag_findBePoint = 0;
    end
    if flag_rise == 1
        flag_last_state=1;
    elseif flag_fall == 1
        flag_last_state=0;
    end
    
    if length(point_trough_array)==7
        1;
    end
    range_end = count * winLen + 1;
end


end