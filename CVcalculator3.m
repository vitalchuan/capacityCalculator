clc;clear;
% 20200603 �����˸���ѭ�����Լ������
% 20200603������ �ļ�����ķ�ʽ Ϊimportdata()
% filename = '100mv-1.5v-2000.csv';
filename = '0-2-50-cv.xlsx';
% filename = 'cvDataFile/100mv-1.5v-2000.xlsx';

% filename = '3drop-2000-8(1).csv';
% 1:���缫
% 0:˫�缫
threeOrTwoElectrode = 0;

m=1;

file = importdata(filename);
disp(sprintf('Processing %s ...',filename));

output = ["ѭ������","����(F/g)"];

if(threeOrTwoElectrode)
    ratio = 1;
else 
    ratio = 4;
end
%��ȡ��������
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
    fprintf("���ڼ����%d��ѭ�� ...\n",iCycle);
    integr(iCycle) = trapz(data((iCycle-1)*xNum + 1:xNum*iCycle,1), data((iCycle-1)*xNum + 1:xNum*iCycle,2));
    cap(iCycle) = ratio * integr(iCycle)/2/(deltaE * scanRate)/m;
end
for iCycle = 1:numel(integr)
    output(iCycle+1,:) = [iCycle, cap(iCycle)];
    outputData(iCycle,:) = [iCycle,cap(iCycle)];
end
xlswrite("cvResult.xlsx",output);
fprintf("������ɣ���鿴output/outputData����\n");

