function dat = label_qualitative(raw)
uniques = unique(raw);
size_of_uniques = length(uniques);
idx = 1;
dat = zeros(1,length(raw));
for i = 1:size_of_uniques
    for j = 1:length(raw)
        if strcmp(raw(j),uniques(i))
            dat(j) = idx;
        end
    end
    idx = idx + 1;
end