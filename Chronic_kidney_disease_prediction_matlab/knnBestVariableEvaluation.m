function [x_tr, x_ts, selection] = knnBestVariableEvaluation(x_train,y_train,x_test,y_test,trackPerf,thresh);
accuracy = [];
x_tr = [];
x_ts = [];
global x_testS x_trainS lowerLimit upperLimit colId itx accuracy
selection = [];
sid = 1;
for i = 1:size(trackPerf,1)
    itx = i;
    if trackPerf(i,2)==0
        lowerLimit = trackPerf(i,3);
        upperLimit = trackPerf(i,4);
        x_testS = x_test(:,lowerLimit:upperLimit);
        x_trainS = x_train(:,lowerLimit:upperLimit);
    elseif trackPerf(i,2)==1
        colId = trackPerf(i,3);
        x_testS = x_test(:,colId);
        x_trainS = x_train(:,colId);
    end
    % train and test data
    noOfNeighbors = 10;
    result = knnClassifier(x_testS, x_trainS, y_train, noOfNeighbors);
    % Result Analysis
    correct = 0;
    correctNot = 0;
    for ix = 1:length(result)
        if result(ix)==y_test(ix)
    correct=correct+1;
        else
    correctNot=correctNot+1;
        end
    end
    % Accuracy Percentage
    accuracy(i,1) = i;
    accuracy(i,2) = ( correct / length(result) ) * 100;
    % shortlist the variables (features) above certain threshold
    if accuracy(i,2)>thresh
        if isempty(x_tr)
            x_tr = x_trainS;
            x_ts = x_testS;
        else
            startPoint = size(x_tr,2)+1;
            stopPoint = size(x_tr,2) + size(x_trainS,2);
            x_tr(:,startPoint:stopPoint) = x_trainS;
            x_ts(:,startPoint:stopPoint) = x_testS;
        end
        selection(sid) = i;
        sid = sid + 1;
    end
end
return