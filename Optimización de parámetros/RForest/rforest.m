function [TrainingAccuracy, TestingAccuracy,rOut] = rforest(train_data, test_data, leaf, ntrees)

paroptions = statset('UseParallel',false);
fboot=1;
surrogate='on';
disp('Training the tree bagger')
In = train_data(:,2:7);
Out = train_data(:,1);
tic
b = TreeBagger(...
        ntrees,...
        In,Out,... 
        'Method','regression',...
        'oobvarimp','on',...
        'surrogate',surrogate,...
        'minleaf',leaf,...
        'FBoot',fboot,...
        'Options',paroptions...
        );
toc
x=Out;
y2=predict(b, In);
% calculate the training data correlation coefficient
cct=corrcoef(x,y2);
cct=cct(2,1);

yT = train_data(:,1);
TrainingAccuracy = sqrt(mse(y2 - yT));


%--------------------------------------------------------------------------
% Estimate Output using tree bagger
disp('Estimate Output using tree bagger')
In = test_data(:,2:7);
x=test_data(:,1);

y=predict(b, In);
TestingAccuracy = sqrt(mse(y - x));
name='Bagged Decision Trees Model';
toc

%--------------------------------------------------------------------------
% calculate the training data correlation coefficient
cct=corrcoef(x,y);
cct=cct(2,1);
rOut = cct;
%--------------------------------------------------------------------------
% Create a scatter Diagram
disp('Create a scatter Diagram')

% plot the 1:1 line
plot(x,x,'LineWidth',3);

hold on
scatter(x,y,'filled');
hold off
grid on
close(all)

% set(gca,'FontSize',18)
% xlabel('Actual','FontSize',25)
% ylabel('Estimated','FontSize',25)
% title(['Training Random Forest, R=' num2str(cct,2)],'FontSize',30)
% predX = linspace(min(x),max(x),10)';
% mpgQuartiles = quantilePredict(x,y,'Quantile',[0.25,0.5,0.75]);
% figure;
% plot(x,y,'o');
% hold on
% plot(predX,mpgMean);
% plot(predX,mpgQuartiles);
% ylabel('Fuel economy');
% xlabel('Engine displacement');
% legend('Data','Mean Response','First quartile','Median','Third quartile');
    
end