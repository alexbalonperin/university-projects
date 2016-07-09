
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%                                                                         %  
%   DOCUMENT INFORMATIONS:                                                %
%                                                                         %
%   author : Alexandre Balon-Perin                                        %
%   date : 18/10/2010                                                     %
%   last modification : 18/10/2010                                        %
%   course : Learning Dynamics                                            %
%   assignment 1                                                          %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initialize program
clear all;
close all;
clc;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %  
%                                                                         %   
%                       6-ARMED BANDIT PROBLEM                            %  
%                                                                         % 
%                                                                         %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   Specifications:
%
%   - Non associative
%   - Evaluation Feedback
%   - each choice is called a play a_t
%   - reward r_t (after each play)
%   - E{r_t| a_t} = QaS(a_t)
%   - Objective: maximize the reward in a long term

global Qa_star nbActions iterations;

iterations = 1000;
nbActions = 3;

%initial value of Qa_i 
Qa_1 = -10;
Qa_2 = -10;
Qa_3 = -10;
 
% Qa_1 = 10;
% Qa_2 = 10;
% Qa_3 = 10;

%vector of action value estimates
Qa = [Qa_1 Qa_2 Qa_3 Qa_4 Qa_5 Qa_6];

%noise according to a normal probability distribution 
%ATTENTION : variance 1
%
% lim (k_a --> infinity) Qa = QaS
%

QaS_2 = 2.10;
QaS_4 = 0.90;
QaS_6 = -2.70;

%vector of action value
Qa_star = [QaS_2 QaS_4 QaS_6];

% x = 1:1:6;
% y = randn(10000,1);
% hist(Qa_star,x)

%vector of reward
rewardVector = zeros(1,nbActions);

%start chrono
tic

%initialization of reward
for j= 1: nbActions
    rewardVector(j) = normrnd(Qa_star(j),1);
    Qa(j) = Qa(j) + rewardVector(j);
end

simulation3(Qa);

%stop and display chrono
toc






