function  Reff=Ref_n_lookup_v2(n);    %Modified by David Cuccia on 20060921

Reff_file = load('Reff_n1.txt');

Reff = interp1(Reff_file(1,:),Reff_file(2,:),n,'pchip');