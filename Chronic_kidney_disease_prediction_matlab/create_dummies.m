function dat = create_dummies(raw)
uniques = unique(raw);
dat = zeros(length(raw),length(uniques));
for i = 1:length(raw);
    dat(i,raw(i)) = 1;
end
% remove last column (to take on dummy variable trap)
dat = dat(:,1:end-1);