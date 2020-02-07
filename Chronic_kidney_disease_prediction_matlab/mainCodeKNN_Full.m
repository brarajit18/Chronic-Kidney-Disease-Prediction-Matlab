% clc
% clear all
%% Load the dataset
[num, txt, raw]=xlsread('kidney_disease.csv');
rawDat = raw(2:end,:);
%% Index of classes/labels column
classIdx = 26;
%% List of Categorical Variables
listCategory = [7, 8, 9, 10, 20, 21, 22, 23, 24, 25];
%% List of Quantitative variables
listQuant = [2, 3, 4, 5, 6, 11, 12, 13, 14, 15, 16, 17, 18, 19];
%% Process Qualitatives (Categoricals)
% Handle missing in qualitatives
datCategory = [];
for i = 1:length(listCategory)
    temp = rawDat(:,listCategory(i));
    res = handle_missing_in_qualitative(temp);
    res2 = label_qualitative(res);
    dummies = create_dummies(res2);
    if i == 1
        datCategory = dummies;
    else
        datCategory(:,end+1:size(datCategory,2)+size(dummies,2)) = dummies;
    end
end
%% Process Quantitatives
datQuant = [];
for i = 1:length(listQuant)
    temp = rawDat(:,listQuant(i));
    if iscell(temp)
        temp = cell2mat(temp);
    end
    test = isnan(temp);
    res = handle_missing_in_quantitative(temp);
    res2 = scale_quant(res);
    datQuant(:,i)=res2;
end
%% Obtain categorical variables
classes = rawDat(:,classIdx);
classes = handle_classes(classes);
%% Combine both databases quantitative and qualitative (categorical)
finalMat = [datQuant datCategory classes'];

%% Main Code for Classifier
    % Shuffle Matrix
    ix = randperm(size(finalMat,1));
    shuffleFinalMat=finalMat(ix,:);
    % Divide the training data and testing data
        % prepare training data
        x_train = shuffleFinalMat(1:300,1:end-1);
        y_train = shuffleFinalMat(1:300,end);
        % prepare testing data
        x_test = shuffleFinalMat(301:400,1:end-1);
        y_test = shuffleFinalMat(301:400,end);
    % Apply Classifier
        % train and test data
        tic
        noOfNeighbors = 5;
        result = knnClassifier(x_test, x_train, y_train, noOfNeighbors);
        toc
        % Result Analysis
        correct = 0;
        correctNot = 0;
        for i = 1:length(result)
            if result(i)==y_test(i)
                correct=correct+1;
            else
                correctNot=correctNot+1;
            end
        end
        % Accuracy Percentage
        accuracy = ( correct / length(result) ) * 100;
        error = ( correctNot / length(result) ) * 100;
        % Show Results
        disp('Accuracy Percentage: ');
        disp(accuracy);
        disp('Error Percentage: ');
        disp(error);
        
        % Result Analysis
        % 0 for ckd
        % 1 for not ckd
        TP = 0;
        TN = 0;
        FP = 0;
        FN = 0;
        for i = 1:length(result)
            if result(i)==y_test(i) && y_test(i)==0 
                TP = TP + 1;
            elseif result(i)==y_test(i) && y_test(i)==1
                TN = TN + 1;
            elseif result(i)~=y_test(i) && y_test(i)==0 
                FP = FP + 1;
            elseif result(i)~=y_test(i) && y_test(i)==1 
                FN = FN + 1;
            else
                correctNot=correctNot+1;
            end
        end
        % Accuracy Percentage
        precision = (TP / (TP + FP)) * 100;
        recall = (TP / (TP + FN)) * 100;
        f1err = 2 * ( (precision * recall) / (precision + recall) );
        accuracy = ( (TP + TN) / (TP + TN + FP + FN) ) * 100;
        error = ( correctNot / length(result) ) * 100;
        % Show Results
        disp('');
        disp('Statistical Parameters:')
        disp('Accuracy Percentage: ');
        disp(accuracy);
        disp('Precision: ');
        disp(precision);
        disp('Recall: ');
        disp(recall);
        disp('F1 Error: ');
        disp(f1err);
        