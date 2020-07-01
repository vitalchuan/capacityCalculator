clc;clear;
% 使用说明
filename = 'cv-2.csv';

% 1:三电极
% 0:双电极
threeOrTwoElectrode = 0;

highERow = 9;
lowERow = 10;
scanRateRow = 12;
segmentRow = 13;
intervalERow = 14;
dataRow = 28;

if(threeOrTwoElectrode)
        ratio = 1;
    else 
        ratio = 4;
end
output(1,:) = {"循环次数", "扫速v/s",	"积分面积A*V"	,"电压窗口V",	"电容 (F)"};
fid = fopen(filename);
disp(sprintf('Processing %s ...',filename));

channelNumber = 1;

% 获取电压窗口
for i = 1:highERow
    tline = fgetl(fid);
end
cellArr = split(tline);
highE = str2double(string(cellArr(end)));

for i = 1:(lowERow-highERow)
    tline = fgetl(fid);
end
cellArr = split(tline);
lowE = str2double(string(cellArr(end)));

deltaE = highE - lowE;

for i = 1:(scanRateRow - lowERow)
    tline = fgetl(fid);
end
cellArr = split(tline);
scanRate = str2double(string(cellArr(end)))

for i = 1:(segmentRow - scanRateRow)
    tline = fgetl(fid);
end
cellArr = split(tline);
segment = str2double(string(cellArr(end)))

for i = 1:(intervalERow - segmentRow)
    tline = fgetl(fid);
end
cellArr = split(tline);
intervalE = str2double(string(cellArr(end)))


% 获取测量的电压电流
for i = 1:(dataRow - intervalERow);
    tline = fgetl(fid);
end

i = 1;
while(tline ~= -1)
    cellArr = split(tline,',');
    cells(i,:) = cellArr;
    tline = fgetl(fid);
    i = i + 1;
end
strArr = string(cells);
sz = size(strArr);
x = deltaE / intervalE;

for iCycle = 1:segment/2
    fprintf("正在计算第%d个循环 ...\n",iCycle);
    for i = ((2*deltaE / intervalE)*(iCycle-1)+1):((2*deltaE / intervalE)*iCycle)
        data(1,i) = str2double(strArr(i,1));
        data(2,i) = str2double(strArr(i,2));
    end
    intege = trapz(data(1,:),data(2,:));
    
    capacity(iCycle) = ratio*intege/2/(deltaE*scanRate)
    
    output(iCycle+1,:) = {iCycle, scanRate,intege,deltaE,capacity(iCycle)};
    clear data;
end
fclose(fid);
fprintf("complete successfully\n");