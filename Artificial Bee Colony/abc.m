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

% CostFunction = @(x) Sphere(x);        % Cost Function
CostFunction = @(x, y) in_function(x, y);    % Cost Function

nVar = 5;             % Number of Decision Variables

[ReferencePoints, Solution] = rand_points(nVar); % parametros por defecto
Solution

VarSize = gpuArray([1 nVar]);   % Decision Variables Matrix Size

% VarMin = -10;         % Decision Variables Lower Bound
VarMin = -1;         % Decision Variables Lower Bound
% VarMax = 10;         % Decision Variables Upper Bound
VarMax = 1;         % Decision Variables Upper Bound

%% ABC Settings

MaxIt = nVar*3;              % Maximum Number of Iterations

nPop = 100;               % Population Size (Colony Size)

nOnlooker = nPop;         % Number of Onlooker Bees

L = round(0.6*nVar*nPop); % Abandonment Limit Parameter (Trial Limit)

a = 1;                    % Acceleration Coefficient Upper Bound

%% Initialization

% Empty Bee Structure
empty_bee.Position = [];
empty_bee.Cost = [];

% Initialize Population Array
pop = repmat(empty_bee, nPop, 1);

% Initialize Best Solution Ever Found
BestSol.Cost = inf;

% Create Initial Population
for i = 1:nPop
    x = rand*100;
    % pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    pop(i).Position = gpuArray(unifrnd(VarMin, VarMax, VarSize)./10);
    % pop(i).Cost = CostFunction(pop(i).Position);
    pop(i).Cost = CostFunction(pop(i).Position, ReferencePoints);
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
        
        % Define Acceleration Coeff.
        phi = a*unifrnd(-10, +10, VarSize);
        
        % New Bee Position
        newbee.Position = gpuArray(pop(i).Position+phi.*(pop(i).Position-pop(k).Position));
        
        % Apply Bounds
        newbee.Position = gpuArray(max(newbee.Position, VarMin));
        newbee.Position = gpuArray(min(newbee.Position, VarMax));

        % Evaluation
        % newbee.Cost = CostFunction(newbee.Position);
        newbee.Cost = CostFunction(newbee.Position, ReferencePoints);
        
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
        
        % Define Acceleration Coeff.
        phi = a*unifrnd(-10, +10, VarSize);
        
        % New Bee Position
        newbee.Position = gpuArray(pop(i).Position+phi.*(pop(i).Position-pop(k).Position));
        
        % Apply Bounds
        newbee.Position = gpuArray(max(newbee.Position, VarMin));
        newbee.Position = gpuArray(min(newbee.Position, VarMax));
        
        % Evaluation
        % newbee.Cost = CostFunction(newbee.Position);
        newbee.Cost = CostFunction(newbee.Position, ReferencePoints);
        
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
            % pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
            pop(i).Position = gpuArray(unifrnd(VarMin, VarMax, VarSize)./10);
            % pop(i).Cost = CostFunction(pop(i).Position);
            pop(i).Cost = CostFunction(pop(i).Position, ReferencePoints);
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
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    disp([ '             Best Sol = ' num2str(gather(BestSol.Position))])
    
end
    
%% Results

disp(['Real Solution = ' num2str(reshape(Solution, [1, nVar]))])
polynom = BestSol.Position;
figure;
%plot(BestCost, 'LineWidth', 2);
%plot(gather(ReferencePoints, '.'))
%hold all;
%plot(ReferencePoints(:, 1), ReferencePoints(:, 2), '.');
plot(polyval(BestSol.Position, [VarMin:0.01:VarMax]));
%semilogy(BestCost, 'LineWidth', 2);
xlabel('X');
ylabel('Y');
%xlabel('Iteration');
%ylabel('Best Cost');
grid on;
