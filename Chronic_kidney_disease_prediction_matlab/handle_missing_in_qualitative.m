function dat = handle_missing_in_qualitative(raw)
dat = [];
for i = 1:length(raw)
    val = raw(i);
    if iscell(val)
        val = cell2mat(val);
    end
    if isnan(val)
        dat{i} = 'other';
    else
        dat{i} = val;
    end
end