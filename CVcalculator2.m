clc;clear;
% 使用说明
filename = '0-2-50-cv.csv';

% 1:三电极
% 0:双电极
threeOrTwoElectrode = 0;

scanRateRow = 12;
dataRow = 28;


output(1,:) = ["扫速v/s",	"积分面积A*V"	,"电压窗口V",	"电容 (F)"];
fid = fopen(filename);
disp(sprintf('Processing %s ...',filename));
% tline = fgetl(fid);
% tline = fgetl(fid);
% tline = fgetl(fid);
% cellArr = split(tline,',');
% sz = size(cellArr);

%通道数为1
channelNumber = 1;

%获取扫速
for i = 1:scanRateRow
    tline = fgetl(fid);
end
cellArr = split(tline);
scanRate(1) = str2double(string(cellArr(end)));

% 获取数据
for i = 1:(dataRow - scanRateRow);
    tline = fgetl(fid);
end

i = 1;
tline = fgetl(fid);
while(tline ~= -1)
    cellArr = split(tline,',');
    cells(i,:) = cellArr;
    tline = fgetl(fid);
    i = i + 1;
end
strArr = string(cells);
sz = size(strArr);
for iChannel = 1:channelNumber
    fprintf("正在计算第 %d 通道 ...\n",iChannel);
    j = 1;
    for i = 1:sz(1)
        if(strArr(i,2*iChannel - 1) ~= "--" && strArr(i,2*iChannel) ~= "--" && strArr(i,2*iChannel - 1) ~= "" && strArr(i,2*iChannel) ~= "")
            data(1,j) = str2double(strArr(i,2*iChannel-1));
            data(2,j) = str2double(strArr(i,2*iChannel));
            j = j + 1;
        end
    end
    %电压窗口
    deltaV(iChannel) = max(data(1,:)) - min(data(1,:));

    %积分面积
    intege(iChannel) = trapz(data(1,:),data(2,:));
%     fprintf("第%d通道的积分面积是%.10f A/g*V \n",iChannel,intege(iChannel));
    
    if(threeOrTwoElectrode)
        ratio = 1;
    else 
        ratio = 4;
    end
    cap(iChannel) = ratio*intege(iChannel)/2/(deltaV(iChannel)*scanRate(iChannel));
    clear data;

%     fprintf("第%d通道的质量电容是%.10f F/g \n",iChannel,cap(iChannel));
end

for i = 1:channelNumber
   entry =  [scanRate(i),intege(i),deltaV(i),cap(i)];
   output(i+1,:) = entry;
end
xlswrite("CVresult.xlsx",output);

fclose(fid);
fprintf("complete successfully\n");