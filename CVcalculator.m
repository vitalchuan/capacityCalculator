clc;clear;
% ʹ��˵��
filename = 'CV.csv';

% 1:���缫
% 0:˫�缫
threeOrTwoElectrode = 0;

output(1,:) = {"ɨ��v/s",	"�������A/g*V"	,"��ѹ����V",	"�������� (F/g)"};
fid = fopen(filename);
disp(sprintf('Processing %s ...',filename));
tline = fgetl(fid);
tline = fgetl(fid);
tline = fgetl(fid);
cellArr = split(tline,',');
sz = size(cellArr);
channelNumber = sz(1)/2;

%��ȡɨ��
strArr = string(cellArr);
for i = 1:channelNumber
    str1 = strArr(2*i-1);
    scan = split(str1);
    scanRate(i,1) = str2double(scan(end));
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
    fprintf("���ڼ���� %d ͨ�� ...\n",iChannel);
    j = 1;
    for i = 1:sz(1)
        if(strArr(i,2*iChannel - 1) ~= "--" && strArr(i,2*iChannel) ~= "--" && strArr(i,2*iChannel - 1) ~= "" && strArr(i,2*iChannel) ~= "")
            data(1,j) = str2double(strArr(i,2*iChannel-1));
            data(2,j) = str2double(strArr(i,2*iChannel));
            j = j + 1;
        end
    end
    %��ѹ����
    deltaV(iChannel) = max(data(1,:)) - min(data(1,:));

    %�������
    intege(iChannel) = trapz(data(1,:),data(2,:));
%     fprintf("��%dͨ���Ļ��������%.10f A/g*V \n",iChannel,intege(iChannel));
    
    if(threeOrTwoElectrode)
        ratio = 1;
    else 
        ratio = 4;
    end
    cap(iChannel) = ratio*intege(iChannel)/2/(deltaV(iChannel)*scanRate(iChannel));
    clear data;

%     fprintf("��%dͨ��������������%.10f F/g \n",iChannel,cap(iChannel));
end

for i = 1:channelNumber
   entry =  {scanRate(i),intege(i),deltaV(i),cap(i)};
   output(i+1,:) = entry;
end

fclose(fid);