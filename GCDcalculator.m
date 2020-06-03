clc;clear;
% ʹ��˵��
filename = 'GCD.csv';

% 1:���缫
% 0:˫�缫
threeOrTwoElectrode = 0;

fid = fopen(filename);
disp(sprintf('Processing %s ...',filename));

output = {"��ʼʱ��(S)","����ʱ��(S)","�����ܶ�(A/g)","�ŵ�ʱ��(S)","��ѹ����(V)","��������(F/g)"};
tline = fgetl(fid);
tline = fgetl(fid);
cellArr = split(tline,',');
strArr = string(cellArr);
sz = size(cellArr);
channelNumber = sz(1) / 2;

%��ȡ��������
for i = 1:channelNumber
   str = strArr(2*i);
   str1 = split(str,'A');
   currentDensity(i) = str2double(str1(1));
end

% �������ݵ��ַ���
fprintf("���ڶ������� ...\n");
i = 1;
tline = fgetl(fid);
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
    cap(iChannel) = ratio * currentDensity(iChannel) * deltaSecond(iChannel) / deltaV(iChannel);
    
    clear data;
end

for i = 1:channelNumber
   entry =  {startSecond(i),endSecond(i),currentDensity(i),deltaSecond(i),deltaV(i),cap(i)};
   output(i+1,:) = entry;
end
fclose(fid);