clc;clear;
filename = 'gcd-0.1A-g-0-2.csv';

% 1:���缫
% 0:˫�缫
threeOrTwoElectrode = 0;

m = 1;

currentRow = 8;
dataRow = 21;
fid = fopen(filename);
fprintf('Processing %s ...\n',filename);
output = ["��ʼʱ��(S)","����ʱ��(S)","����(A)","�ŵ�ʱ��(S)","��ѹ����(V)","����(F)"];
channelNumber = 1;

%��ȡ����
for i = 1:currentRow
   tline = fgetl(fid); 
end
a = string(split(tline));
current(1) = str2double(a(end));

% �������ݵ��ַ���
fprintf("���ڶ������� ...\n");

for i = 1:(dataRow - currentRow)
    tline = fgetl(fid);
end

i = 1;
while(tline ~= -1)
    str = string(split(tline,','));
    strs(i,:) = str;
    i = i + 1;
    tline = fgetl(fid);
end

sz = size(strs);

for iChannel = 1:channelNumber
    fprintf("���ڼ���� %d ͨ�� ...\n",iChannel);
    j = 1;
    for i = 1:sz(1)
        if(strs(i,2*iChannel-1) ~= "--" && strs(i,2*iChannel) ~= "--" && strs(i,2*iChannel-1)~="" && strs(i,2*iChannel)~="")
            data(1,j) = str2double(strs(i,2*iChannel-1));
            data(2,j) = str2double(strs(i,2*iChannel));
            j = j + 1;
        end
    end
    
    [a, startIndex] = max(data(2,:));
    startSecond(iChannel) = data(1,startIndex);
    endSecond(iChannel) = max(data(1,:));
    deltaV(iChannel) = max(data(2,:)) - min(data(2,:));
    
    deltaSecond(iChannel) = endSecond(iChannel) - startSecond(iChannel);
    if(threeOrTwoElectrode)
        ratio = 1;
    else
        ratio = 4;
    end
    cap(iChannel) = ratio * current(iChannel) * deltaSecond(iChannel) / deltaV(iChannel);
    
    clear data;
end

for i = 1:channelNumber
   entry =  [startSecond(i),endSecond(i),current(i),deltaSecond(i),deltaV(i),cap(i)];
   output(i+1,:) = entry;
end
xlswrite("GCDresult.xlsx",output);
fclose(fid);
fprintf("complete successfully\n");