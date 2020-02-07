cclc
clear all
%% Load the dataset
[num, txt, raw]=xlsread('kidney_disease.csv');
return
%% Performing a column selection
smallData = raw(2:end,[2 3 7 23 26]);
%% Check for missing values
% in column 1
oneMissVals = isnan(cell2mat(smallData(:,1)));
countOneMissVals = numel ( oneMissVals(oneMissVals==1) );
% in column 2
twoMissVals = isnan(cell2mat(smallData(:,2)));
countTwoMissVals = numel ( twoMissVals(twoMissVals==1) );
% in column 3
colThree = smallData(:,3);
threeMissVals=[];
for i = 1:length(colThree)
    str1 = colThree(i);
    if iscell(str1)
        str2 = cell2mat(str1);
    else
        str2 = str1;
    end
    res=isnan(str2);
    if length(res)>1
        res2 = sum(res);
    else
        res2 = res
    end
    if res2 >= 1
        threeMissVals(i)=1;
    else
        threeMissVals(i)=0;
    end
end

% in column 4
colFour = smallData(:,4);
fourMissVals=[];
for i = 1:length(colFour)
    str1 = colFour(i);
    if iscell(str1)
        str2 = cell2mat(str1);
    else
        str2 = str1;
    end
    res=isnan(str2);
    if length(res)>1
        res2 = sum(res);
    else
        res2 = res
    end
    if res2 >= 1
        fourMissVals(i)=1;
    else
        fourMissVals(i)=0;
    end
end

% in column 5
colFive = smallData(:,5);
countFiveMissVals=0;
for i = 1:length(colFive)
    str1 = colFive(i);
    if iscell(str1)
        str2 = cell2mat(str1);
    else
        str2 = str1;
    end
    res=isnan(str2);
    if length(res)>1
        res2 = sum(res);
    else
        res2 = res
    end
    if res2 >= 1
        countFiveMissVals=countFiveMissVals+1;
    end
end


%% Resolve the issue of missing values
% column 1
one=cell2mat(smallData(:,1));
oneMissVals = isnan(one);
meanVal = sum( (one(oneMissVals ~= 1)) ) / numel(one);
for i = 1: length(one)
    if oneMissVals(i) == 1
        smallData(i,1)={meanVal};
    end
end

% column 2
two=cell2mat(smallData(:,2));
twoMissVals = isnan(two);
meanVal = sum( (two(twoMissVals ~= 1)) ) / numel(two);
for i = 1: length(two)
    if twoMissVals(i) == 1
        smallData(i,2)={meanVal};
    end
end

% column 2
for i = 1: length(threeMissVals)
    if threeMissVals(i) == 1
        smallData(i,3)={'other'};
    end
end

% column 2
for i = 1: length(fourMissVals)
    if fourMissVals(i) == 1
        smallData(i,4)={'other'};
    end
end


%% Final step of pre-processing (Restructuring the matrix)
finalMat = smallData(:,1:2);
if iscell(finalMat)
    finalMat=cell2mat(finalMat);
end
for i=1:size(smallData,1)
    % convert column 3 to numeric categories from string categories
    col3 = smallData(i,3);
    if iscell(col3)
        col3=cell2mat(col3);
    end
    if strcmp(col3,'other')
        finalMat(i,3)=1;
    elseif strcmp(col3,'normal');
        finalMat(i,3)=2;
    elseif strcmp(col3,'abnormal');
        finalMat(i,3)=3;
    else
        finalMat(i,3)=4;
    end
    
    % convert column 4 to numeric categories from string categories
    col4 = smallData(i,4);
    if iscell(col4)
        col4=cell2mat(col4);
    end
    if strcmp(col4,'other')
        finalMat(i,4)=1;
    elseif strcmp(col4,'good');
        finalMat(i,4)=2;
    elseif strcmp(col4,'poor');
        finalMat(i,4)=3;
    else
        finalMat(i,4)=4;
    end
    
    % convert column 5 to numeric categories from string categories
    col5 = smallData(i,5);
    if iscell(col5)
        col5=cell2mat(col5);
    end
    if strcmp(col5,'ckd')
        finalMat(i,5)=1;
    elseif strcmp(col5,'notckd');
        finalMat(i,5)=0;
    end
end



%% Shuffle Matrix
ix = randperm(size(finalMat,1));
shuffleFinalMat=finalMat(ix,:);

%% Divide the training data and testing data
% prepare training data
x_train = shuffleFinalMat(1:300,1:4);
y_train = shuffleFinalMat(1:300,5);
% prepare testing data
x_test = shuffleFinalMat(301:400,1:4);
y_test = shuffleFinalMat(301:400,5);


%% Apply SVM
% train and test data
tic
noOfNeighbors = 5;
result = knnClassifier(x_test, x_train, y_train, noOfNeighbors);
toc

%% Result Analysis
correct = 0;
correctNot = 0;
for i = 1:length(result)
    if result(i)==y_test(i)
        correct=correct+1;
    else
        correctNot=correctNot+1;
    end
end

%% Accuracy Percentage
accuracy = ( correct / length(result) ) * 100;
error = ( correctNot / length(result) ) * 100;

%% Show Results
disp('Accuracy Percentage: ');
disp(accuracy);
disp('Error Percentage: ');
disp(error);