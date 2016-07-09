
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Created by Alexandre Balon-Perin
%   Date: 12.10.2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
%       MAIN
%%%%%%%%%%%%%%%%%%%%

clf;
clear;
clc;
close all;
format long;


classifier = Classifier();
classifier.training;
classifier.classify;    