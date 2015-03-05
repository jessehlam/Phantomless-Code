function fit = interpR (X, Y, ZZ, XX, YY)

xlength = length(X);
xxlength = length(XX);
ylength = length(Y);
yylength = length(YY);

if X(1) > XX(1)
    for aa = length(X):-1:1
        X(aa+1) = X(aa);
        ZZ(:,aa+1) = ZZ(:,aa);
    end
    X(1) = XX(1);
end

if X(xlength) < XX(xxlength)
    X(xlength+1) = XX(xxlength);
    ZZ(:,xlength+1) = ZZ(:,xlength);
end

if Y(1) > YY(1)
    for aa = length(Y):-1:1
        Y(aa+1) = Y(aa);
        ZZ(aa+1,:) = ZZ(aa,:);
    end
    Y(1) = YY(1);
end

if Y(ylength) < YY(yylength)
    Y(ylength+1) = YY(yylength);
    ZZ(ylength+1,:) = ZZ(ylength,:);
end

fit = interp2(X, Y, ZZ, XX, YY); 
    