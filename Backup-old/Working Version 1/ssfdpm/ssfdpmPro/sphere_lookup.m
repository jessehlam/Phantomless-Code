%lookup function to determine the sphere coefficients
%
%input is the base name of the sphere file such as 
%
%return is the coefficients for that sphere
%
%BYH 8/06

function sphere_coeff=sphere_lookup(file)


if (~isempty(strfind(file,'rc01')) || ~isempty(strfind(file,'RC01')))
    disp('SELECTING "rc01" sphere')
    sphere_coeff = [-1.62090E-08 6.63870E-05 7.7305e-01];
elseif (~isempty(strfind(file,'rc02')) || ~isempty(strfind(file,'RC02')))
    disp('SELECTING "rc02" sphere')
    sphere_coeff = [6.0939e-09 3.491e-05 .78195];
elseif (~isempty(strfind(file,'rc03')) || ~isempty(strfind(file,'RC03')))
    disp('SELECTING "rc03" sphere')
    sphere_coeff = [2.6973e-09 4.0095e-05 .78126];
elseif (~isempty(strfind(file,'rc04')) || ~isempty(strfind(file,'RC04')))
    disp('SELECTING "rc04" sphere')
    sphere_coeff = [-3.05694e-08 8.83416e-005 .76283];
elseif (~isempty(strfind(file,'rc05')) || ~isempty(strfind(file,'RC05')))
    disp('SELECTING "rc05" sphere')
    sphere_coeff = [2.0979e-08 1.2434e-005 .7881];
elseif (~isempty(strfind(file,'rc06')) || ~isempty(strfind(file,'RC06')))
    disp('SELECTING "rc06" sphere')
    sphere_coeff = [-4.9417e-08 1.1616e-004 .7558];
    %sphere_coeff = [.7558 1.161e-004 -4.9417e-08];
elseif (~isempty(strfind(file,'rc09')) || ~isempty(strfind(file,'RC09')))
    disp('SELECTING "rc09" sphere')
    sphere_coeff = [-3.1536e-08 1.7011e-004 .5038];
elseif (~isempty(strfind(file,'rc10')) || ~isempty(strfind(file,'RC10')))
    disp('SELECTING "rc10" sphere')
    sphere_coeff = [-4.9417e-08 1.1616e-004 .7558];
elseif (~isempty(strfind(file,'sc01')) || ~isempty(strfind(file,'SC01')))
    disp('SELECTING "sc01" sphere')
    sphere_coeff = [-6.66667E-07 9.90200E-01];
elseif (~isempty(strfind(file,'sc02')) || ~isempty(strfind(file,'SC02')))
    disp('SELECTING "sc02" sphere')
    sphere_coeff = [1.4804e-7 -3.977e-4 1.612];
elseif (~isempty(strfind(file,'rc20a')) || ~isempty(strfind(file,'RC20A')))
    disp('SELECTING "rc20a" sphere')
    sphere_coeff = [2.6626e-08 5.9859e-05 .15995];
elseif (~isempty(strfind(file,'rc40a')) || ~isempty(strfind(file,'RC40A')))
    disp('SELECTING "rc40a" sphere')
    sphere_coeff = [-1.3953e-08 1.7450e-04 .31676];  
elseif (~isempty(strfind(file,'rc20b')) || ~isempty(strfind(file,'RC20B')))
    disp('SELECTING "rc20b" sphere')
    sphere_coeff = [-7.4604e-09 9.4205e-05 .1399];
elseif (~isempty(strfind(file,'rc20c')) || ~isempty(strfind(file,'RC20C')))
    disp('SELECTING "rc20c" sphere')
    sphere_coeff = [-6.2981e-09 8.8772e-05 .1549];
else
    disp('WARNING: Sphere not recognized, setting spec.polySphere=[]');
    sphere_coeff=[];
end