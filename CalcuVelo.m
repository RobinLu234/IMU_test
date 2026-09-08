function data_velo = CalcuVelo(data_acc)
    veloX = 0 + cumtrapz(data_acc(:,1), data_acc(:,2));
    veloY = 0 + cumtrapz(data_acc(:,1), data_acc(:,3));
    veloZ= 0 + cumtrapz(data_acc(:,1), data_acc(:,4));
    veloAbs = 0 + cumtrapz(data_acc(:,1), data_acc(:,5));
    data_velo=[];
    data_velo(:,1) = data_acc(:,1);
    data_velo(:,2) = veloX;
    data_velo(:,3) = veloY;
    data_velo(:,4) = veloZ;
    data_velo(:,5) = veloAbs;
end