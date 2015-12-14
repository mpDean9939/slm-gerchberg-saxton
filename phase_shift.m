% change A from -pi:pi to 0:2*pi
function B=phase_shift(A)

[m,n]=size(A);
AA=A(:);
k_pos=find(AA>0);
k_neg=find(AA<0);
AA(k_pos)=0;
AA(k_neg)=1;
B=A+reshape(AA,m,n)*2*pi;

end
