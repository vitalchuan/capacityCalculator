clc;clear;
% 20200603 增加了根据循环测试计算电容
% 20200603更新了 文件读入的方式 为importdata()
% 20200611修正了 deltaTime的计算
% filename = '3drop-2000-8(1).csv';
filename = 'gcd-0.1A-g-0-2.xlsx';

% 1:三电极
% 0:双电极
threeOrTwoElectrode = 0;

m=1;

if(threeOrTwoElectrode)
    ratio = 1;
else 
    ratio = 4;
end

output = ["放电次数","放电时间(s)","电容(F/g)"];
file = importdata(filename);
disp(sprintf('Processing %s ...',filename));

data = file.data;
textdata = file.textdata;
data = file.data;
sizeData = size(data);
sizeTestData = size(textdata);
isDecreasing = 0;
cycles = 0;
endIndex = [0];

for i=1:size(textdata,1)
    strs = split(textdata(i));
    charArr = char(textdata(i));
    if numel(charArr) <=14
        continue;
    end
    if charArr(1:14) == 'Anodic Current'
        current = str2double(strs(end));
    end
    if charArr(1:6) == 'High E'
        highE = str2double(strs(end));
    end
    if charArr(1:5) == 'Low E'
        lowE = str2double(strs(end));
    end
end

deltaE = highE -lowE;


%计算循环次数,并保存每次循环终点
for i = 2 : sizeData(1)
    if isDecreasing
        if data(i-1,2) < data(i,2) && data(i-1,2) < 0.01
            cycles = cycles + 1;
            isDecreasing = 0;
            endIndex(numel(endIndex)+1) = i-1;
        end
    else
        if(data(i-1,2) > data(i,2))
            isDecreasing = 1;
        end
    end
end

endIndex(numel(endIndex)+1) = sizeData(1);
cycles = cycles + 1;

for iCycle = 1:cycles
    dataI = data(endIndex(iCycle)+1:endIndex(iCycle+1),:);
    deltaTime(iCycle) = data(endIndex(iCycle+1),1) - data(endIndex(iCycle)+1,1);
    cap(iCycle) = ratio * current * deltaTime(iCycle)/deltaE/m;
    
    output(iCycle+1,:) = [iCycle,deltaTime(iCycle), cap(iCycle)];
    outputData(iCycle,:) = [iCycle,deltaTime(iCycle),cap(iCycle)];
end


