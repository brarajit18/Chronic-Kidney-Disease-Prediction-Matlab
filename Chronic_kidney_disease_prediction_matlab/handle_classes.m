function dat = handle_classes(raw)
uniques = unique(raw);
uniques
size_of_uniques = length(uniques);
idx = 0;
dat = zeros(1,length(raw));
for i = 1:size_of_uniques
    for j = 1:length(raw)
        if strcmp(raw(j),uniques(i))==1
            dat(j) = idx;
        end
    end
    idx = idx + 1;
end