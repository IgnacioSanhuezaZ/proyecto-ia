%
% Copyright (c) 2015, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "LICENSE" file for license terms.
%
% Project Code: YPEA114
% Project Title: Implementation of Artificial Bee Colony in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: Mostapha Kalami Heris (Member of Yarpiz Team)
% Modified by: Ignacio Sanhueza Z.
% 
% Cite as:
% Mostapha Kalami Heris, Artificial Bee Colony in MATLAB (URL: https://yarpiz.com/297/ypea114-artificial-bee-colony), Yarpiz, 2015.
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

clc;
clear;
close all;

%% Problem Definition
addpath('../')
% CostFunction = @(x) Sphere(x);        % Cost Function
% error_colector(2, 'BMW', 'BM25', 'Gov2', 5, 'bp')
CostFunction = @(x, y, z, w, v, s) error_colector(x, y, z, w, v, s);    % Cost Function
% invalid conf: (2, 'WAND', 'TDIF', 'Gov2', 5, 'bp')
%               
nVar = 6;             % Number of Decision Variables

%Opciones de evaluación

tipoVCOptions = [2, 10, 5, 3, 2];
metodo = 'bp';
strScore = 'BM25';

amplitud = 1000;

VarSize = gpuArray([1 nVar]);   % Decision Variables Matrix Size

% VarMin = -10;         % Decision Variables Lower Bound
%VarMin = 0;         % Decision Variables Lower Bound
% VarMax = 10;         % Decision Variables Upper Bound
%VarMax = 1;         % Decision Variables Upper Bound

%% ABC Settings

MaxIt = 10;              % Maximum Number of Iterations

nPop = 100;               % Population Size (Colony Size)

nOnlooker = nPop;         % Number of Onlooker Bees

L = round(0.6*nVar*nPop); % Abandonment Limit Parameter (Trial Limit)

a = 1;                    % Acceleration Coefficient Upper Bound

%% Initialization

% Empty Bee Structure
empty_bee.tipoVCOption = [];
empty_bee.strAlgoritmo = [];
empty_bee.strScore = [];
empty_bee.strDataWeb = [];
empty_bee.hLayers = [];
empty_bee.metodo = [];
empty_bee.Cost = [];

% Initialize Population Array
pop = repmat(empty_bee, nPop, 1);

% Initialize Best Solution Ever Found
BestSol.Cost = inf;

% Create Initial Population
for i = 1:nPop
    % pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    temp = mod(floor(rand() * amplitud ), 5) + 1; 
    if temp == 1
        tipoVCOption = 2;
    elseif temp == 2
        tipoVCOption = 10;
    elseif temp == 3
        tipoVCOption = 5;
    elseif temp == 4
        tipoVCOption = 3;
    end
    temp = mod(floor(rand() * amplitud), 2) + 1;
    if temp == 1
        strAlgoritmo = 'BMW';
    elseif temp == 2
        strAlgoritmo = 'WAND';
    end
%    strAlgoritmo = 'BMW';
    temp = mod(floor(rand() * amplitud), 2) + 1;
    if temp == 1
        strDataWeb = 'Gov2';
    elseif temp == 2
        strDataWeb = 'CW';
    end
%     strDataWeb = 'Gov2';
%     temp = mod(floor(rand("single") * amplitud), 2) + 1;
%     if temp == 1
%         strScore = 'TFIDF';
%     elseif temp == 2
%         strScore = 'BM25';
%     end
%     temp = mod(floor(rand("single") * amplitud), 7) + 1;
%     if temp == 1
%         metodo = 'elm';
%     elseif temp == 2
%         metodo = 'bp';
%     elseif temp == 3
%         metodo = 'rforest';
%     elseif temp == 4
%         metodo = 'mRegresion';
%     elseif temp == 5
%         metodo = 'svm';
%     elseif temp == 6
%         metodo = 'rnolineal';
%     elseif temp == 7
%         metodo = 'rlineal';
%     end
    hLayers = abs(floor(mod(floor(rand() * amplitud), 50) + 1));
    if hLayers == 0
        hLayers = 1;
    end
    pop(i).tipoVCOption = tipoVCOption;
    pop(i).strAlgoritmo = strAlgoritmo;
    pop(i).strScore = strScore;
    pop(i).strDataWeb = strDataWeb;
    pop(i).hLayers = hLayers;
    pop(i).metodo = metodo;
    % pop(i).Cost = CostFunction(pop(i).Position);
    tipoVCOption
    disp(['strAlgoritmo = ' strAlgoritmo])
    disp(['strScore = ' strScore])
    disp(['strDataWeb = ' strDataWeb])
    hLayers
    disp(['metodo = ' metodo])
    pop(i).Cost = error_colector(tipoVCOption, strAlgoritmo, strScore, strDataWeb, hLayers, metodo);
    if pop(i).Cost <= BestSol.Cost
        BestSol = pop(i);
    end
end

% Abandonment Counter
C = zeros(nPop, 1);

% Array to Hold Best Cost Values
BestCost = zeros(MaxIt, 1);

%% ABC Main Loop

for it = 1:MaxIt
    
    % Recruited Bees
    for i = 1:nPop
        
        % Choose k randomly, not equal to i
        K = [1:i-1 i+1:nPop];
        k = K(randi([1 numel(K)]));
        
        % modifica amplitud que representa qué tan grande es el número
        % aleatorio generado
        amplitud = amplitud * unifrnd(0, 2, 1);
        
        % Define Acceleration Coeff.
        temp = mod(floor(rand("single") * amplitud ), 5) + 1; 
        if temp == 1
            tipoVCOption = 2;
        elseif temp == 2
            tipoVCOption = 10;
        elseif temp == 3
            tipoVCOption = 5;
        elseif temp == 4
            tipoVCOption = 3;
        end
        temp = mod(floor(rand("single") * amplitud), 2) + 1;
        if temp == 1
            strAlgoritmo = 'BMW';
        elseif temp == 2
            strAlgoritmo = 'WAND';
        end
    %    strAlgoritmo = 'BMW';
        temp = mod(floor(rand("single") * amplitud), 2) + 1;
        if temp == 1
            strDataWeb = 'Gov2';
        elseif temp == 2
            strDataWeb = 'CW';
        end
    %     strDataWeb = 'Gov2';
    %     temp = mod(floor(rand("single") * amplitud), 2) + 1;
    %     if temp == 1
    %         strScore = 'TFIDF';
    %     elseif temp == 2
    %         strScore = 'BM25';
    %     end
    %     temp = mod(floor(rand("single") * amplitud), 7) + 1;
    %     if temp == 1
    %         metodo = 'elm';
    %     elseif temp == 2
    %         metodo = 'bp';
    %     elseif temp == 3
    %         metodo = 'rforest';
    %     elseif temp == 4
    %         metodo = 'mRegresion';
    %     elseif temp == 5
    %         metodo = 'svm';
    %     elseif temp == 6
    %         metodo = 'rnolineal';
    %     elseif temp == 7
    %         metodo = 'rlineal';
    %     end
        
        hLayers = abs(floor(mod(floor(rand() * amplitud), 50) + 1));
        if hLayers == 0
            hLayers = 1;
        end
        % New Bee Position
        newbee.tipoVCOption = tipoVCOption;
        newbee.strAlgoritmo = strAlgoritmo;
        newbee.strScore = strScore;
        newbee.strDataWeb = strDataWeb;
        newbee.hLayers = hLayers;
        newbee.metodo = metodo;

        % Evaluation
        % newbee.Cost = CostFunction(newbee.Position);
        newbee.Cost = CostFunction(tipoVCOption, strAlgoritmo, strScore, strDataWeb, hLayers, metodo);
        
        % Comparision
        if newbee.Cost <= pop(i).Cost
            pop(i) = newbee;
        else
            C(i) = C(i)+1;
        end
        
    end
    
    % Calculate Fitness Values and Selection Probabilities
    F = zeros(nPop, 1);
    MeanCost = mean([pop.Cost]);
    for i = 1:nPop
        F(i) = exp(-pop(i).Cost/MeanCost); % Convert Cost to Fitness
    end
    P = F/sum(F);
    
    % Onlooker Bees
    for m = 1:nOnlooker
        
        % Select Source Site
        i = RouletteWheelSelection(P);
        
        % Choose k randomly, not equal to i
        K = [1:i-1 i+1:nPop];
        k = K(randi([1 numel(K)]));
        
        % modifica amplitud que representa qué tan grande es el número
        % aleatorio generado
        amplitud = amplitud * unifrnd(0, 2, 1);
        
        % Define Acceleration Coeff.
        temp = mod(floor(rand("single") * amplitud ), 5) + 1; 
        if temp == 1
            tipoVCOption = 2;
        elseif temp == 2
            tipoVCOption = 10;
        elseif temp == 3
            tipoVCOption = 5;
        elseif temp == 4
            tipoVCOption = 3;
        end
        
        temp = mod(floor(rand("single") * amplitud ), 5) + 1; 
        if temp == 1
            tipoVCOption = 2;
        elseif temp == 2
            tipoVCOption = 10;
        elseif temp == 3
            tipoVCOption = 5;
        elseif temp == 4
            tipoVCOption = 3;
        end
        temp = mod(floor(rand("single") * amplitud), 2) + 1;
        if temp == 1
            strAlgoritmo = 'BMW';
        elseif temp == 2
            strAlgoritmo = 'WAND';
        end
    %    strAlgoritmo = 'BMW';
        temp = mod(floor(rand("single") * amplitud), 2) + 1;
        if temp == 1
            strDataWeb = 'Gov2';
        elseif temp == 2
            strDataWeb = 'CW';
        end
    %     strDataWeb = 'Gov2';
    %     temp = mod(floor(rand("single") * amplitud), 2) + 1;
    %     if temp == 1
    %         strScore = 'TFIDF';
    %     elseif temp == 2
    %         strScore = 'BM25';
    %     end
    %     temp = mod(floor(rand("single") * amplitud), 7) + 1;
    %     if temp == 1
    %         metodo = 'elm';
    %     elseif temp == 2
    %         metodo = 'bp';
    %     elseif temp == 3
    %         metodo = 'rforest';
    %     elseif temp == 4
    %         metodo = 'mRegresion';
    %     elseif temp == 5
    %         metodo = 'svm';
    %     elseif temp == 6
    %         metodo = 'rnolineal';
    %     elseif temp == 7
    %         metodo = 'rlineal';
    %     end
        
        hLayers = abs(floor(mod(floor(rand() * amplitud), 50) + 1));
        if hLayers == 0
            hLayers = 1;
        end
        % New Bee Position
        newbee.tipoVCOption = tipoVCOption;
        newbee.strAlgoritmo = strAlgoritmo;
        newbee.strScore = strScore;
        newbee.strDataWeb = strDataWeb;
        newbee.hLayers = hLayers;
        newbee.metodo = metodo;
        
        % Evaluation
        % newbee.Cost = CostFunction(newbee.Position);
        newbee.Cost = CostFunction(tipoVCOption, strAlgoritmo, strScore, strDataWeb, hLayers, metodo);
        
        % Comparision
        if newbee.Cost <= pop(i).Cost
            pop(i) = newbee;
        else
            C(i) = C(i) + 1;
        end
        
    end
    
    % Scout Bees
    for i = 1:nPop
        if C(i) >= L
            temp = mod(floor(rand("single") * amplitud ), 5) + 1; 
            if temp == 1
                tipoVCOption = 2;
            elseif temp == 2
                tipoVCOption = 10;
            elseif temp == 3
                tipoVCOption = 5;
            elseif temp == 4
                tipoVCOption = 3;
            end
            temp = mod(floor(rand("single") * amplitud), 2) + 1;
            if temp == 1
                strAlgoritmo = 'BMW';
            elseif temp == 2
                strAlgoritmo = 'WAND';
            end
        %    strAlgoritmo = 'BMW';
            temp = mod(floor(rand("single") * amplitud), 2) + 1;
            if temp == 1
                strDataWeb = 'Gov2';
            elseif temp == 2
                strDataWeb = 'CW';
            end
        %     strDataWeb = 'Gov2';
        %     temp = mod(floor(rand("single") * amplitud), 2) + 1;
        %     if temp == 1
        %         strScore = 'TFIDF';
        %     elseif temp == 2
        %         strScore = 'BM25';
        %     end
        %     temp = mod(floor(rand("single") * amplitud), 7) + 1;
        %     if temp == 1
        %         metodo = 'elm';
        %     elseif temp == 2
        %         metodo = 'bp';
        %     elseif temp == 3
        %         metodo = 'rforest';
        %     elseif temp == 4
        %         metodo = 'mRegresion';
        %     elseif temp == 5
        %         metodo = 'svm';
        %     elseif temp == 6
        %         metodo = 'rnolineal';
        %     elseif temp == 7
        %         metodo = 'rlineal';
        %     end
            
            hLayers = abs(floor(mod(floor(rand() * amplitud), 50) + 1));
            if hLayers == 0
                hLayers = 1;
            end
            pop(i).tipoVCOption = tipoVCOption;
            pop(i).strAlgoritmo = strAlgoritmo;
            pop(i).strScore = strScore;
            pop(i).strDataWeb = strDataWeb;
            pop(i).hLayers = hLayers;
            pop(i).metodo = metodo;
            % pop(i).Cost = CostFunction(pop(i).Position);
            pop(i).Cost = CostFunction(tipoVCOption, strAlgoritmo, strScore, strDataWeb, hLayers, metodo);
            C(i) = 0;
        end
    end
    
    % Update Best Solution Ever Found
    for i = 1:nPop
        if pop(i).Cost <= BestSol.Cost
            BestSol = pop(i);
        end
    end
    
    % Store Best Cost Ever Found
    BestCost(it) = BestSol.Cost;
    
    % Display Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' BestCost(it)]);
    tipoVCOption
    disp(['strAlgoritmo = ' strAlgoritmo])
    disp(['strScore = ' strScore])
    disp(['strDataWeb = ' strDataWeb])
    hLayers
    disp(['metodo = ' metodo])
    
end
    
%% Results

% Display Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' BestCost(it)]);
    tipoVCOption
    disp(['strAlgoritmo = ' strAlgoritmo])
    disp(['strScore = ' strScore])
    disp(['strDataWeb = ' strDataWeb])
    hLayers
    disp(['metodo = ' metodo])
