clc;clear;
% 使用说明
filename = '0-2-50-cv.csv';
fid = fopen(filename);

tline = fgetl(fid);
i= 1;
while(1)
    if(numel(tline) ~= 0)
        if(tline == -1) break;end
        cells = split(tline,',');
        strArr(i,:) = string(cells);
        i = i + 1;
    end
    tline = fgetl(fid);
end
fclose(fid);