function auc = calc_auc(x)
% calculate precision recall
%close all


errors = x(:);

errors =sort(errors);

errors(errors>.25)=.25;

prec = [errors; 0.25];
rec = [1:length(errors) length(errors)]./(length(errors));



auc = trapz(prec, rec)/0.25;

PLOT=0;
if PLOT
figure, plot(prec,rec,'.-')

title(sprintf('AUC: %2.4f', auc*100))
disp(sprintf('AUC: %2.4f', auc*100))

grid on
end
