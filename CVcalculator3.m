clc;clear;
% 20200603 增加了根据循环测试计算电容
% 20200603更新了 文件读入的方式 为importdata()
% filename = '100mv-1.5v-2000.csv';
filename = '0-2-50-cv.xlsx';
% filename = 'cvDataFile/100mv-1.5v-2000.xlsx';

% filename = '3drop-2000-8(1).csv';
% 1:三电极
% 0:双电极
threeOrTwoElectrode = 0;

m=1;

file = importdata(filename);
disp(sprintf('Processing %s ...',filename));

output = ["循环次数","电容(F/g)"];

if(threeOrTwoElectrode)
    ratio = 1;
else 
    ratio = 4;
end
%获取测量条件
textdata = string(file.textdata(:,1));
data = file.data;
sz = size(textdata);

for i = 1:sz(1)
    strs = split(textdata(i));
    charArr = char(textdata(i));
    if numel(charArr) <=9
        continue;
    end
    if charArr(1:6) == 'High E'
        highE = str2double(strs(end));
    end
    if charArr(1:5) == 'Low E'
        lowE = str2double(strs(end));
    end
    if charArr(1:9) == 'Scan Rate'
        scanRate = str2double(strs(end));
    end
    if charArr(1:9) == 'Segment ='
        segment = str2double(strs(end));
    end
    if charArr(1:9) == 'Sample In'
        intervalE = str2double(strs(end));
    end
end
deltaE = highE - lowE;
xNum = 2 * deltaE / intervalE;
for iCycle = 1:segment/2
    fprintf("正在计算第%d个循环 ...\n",iCycle);
    integr(iCycle) = trapz(data((iCycle-1)*xNum + 1:xNum*iCycle,1), data((iCycle-1)*xNum + 1:xNum*iCycle,2));
    cap(iCycle) = ratio * integr(iCycle)/2/(deltaE * scanRate)/m;
end
for iCycle = 1:numel(integr)
    output(iCycle+1,:) = [iCycle, cap(iCycle)];
    outputData(iCycle,:) = [iCycle,cap(iCycle)];
end
xlswrite("cvResult.xlsx",output);
fprintf("计算完成，请查看output/outputData变量\n");

