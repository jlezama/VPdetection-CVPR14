function K = my_kron(A,B)
%KRON   Kronecker tensor product.
%   KRON(X,Y) is the Kronecker tensor product of X and Y.
%   The result is a large matrix formed by taking all possible
%   products between the elements of X and those of Y. For
%   example, if X is 2 by 3, then KRON(X,Y) is
%
%      [ X(1,1)*Y  X(1,2)*Y  X(1,3)*Y
%        X(2,1)*Y  X(2,2)*Y  X(2,3)*Y ]
%
%   If either X or Y is sparse, only nonzero elements are multiplied
%   in the computation, and the result is sparse.
%
%   Class support for inputs X,Y:
%      float: double, single

%   Thanks Paul Fackler and Jordan Rosenthal for previous versions.
%   Copyright 1984-2011 The MathWorks, Inc. 
%   $Revision: 5.17.4.5 $ $Date: 2011/12/16 16:33:50 $



[ma,na] = size(A);
[mb,nb] = size(B);


   % Both inputs full, result is full.
%fprintf('ma: %i, mb: %i, na: %i, nb:%i\n',ma, mb, na, nb)
   [ia,ib] = my_meshgrid(1:ma,1:mb);
   [ja,jb] = my_meshgrid(1:na,1:nb);
   K = A(ia,ja).*B(ib,jb);

