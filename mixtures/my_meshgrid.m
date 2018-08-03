function [xx,yy,zz] = my_meshgrid(x,y,z)

  
        %xrow = x; % Make sure x is a full row vector.
        %ycol = y';   % Make sure y is a full column vector.
        xx = x(ones(size(y')),:);
       % yy = y(:,ones(size(x)))';
       yy = y(ones(size(x)),:)';

%         xrow = x(:).'; % Make sure x is a full row vector.
%         ycol = y(:);   % Make sure y is a full column vector.
%         xx = xrow(ones(size(ycol)),:);
%         yy = ycol(:,ones(size(xrow)));
%         
