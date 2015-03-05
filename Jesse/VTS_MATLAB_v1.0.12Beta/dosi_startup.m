function [ output_args ] = dosi_startup( input_args )
% startup - Add the required paths, load the assemblies & set default values (font, colors).
v = genpath(getFullPath('vts'));
addpath(v);

t = genpath(getFullPath('vts_tests'));
addpath(t);

h = genpath(getFullPath('html'));
addpath(h);

loadAssemblies();

