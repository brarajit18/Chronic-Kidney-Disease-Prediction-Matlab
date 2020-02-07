function dat = handle_missing_in_quantitative(inpmat)
checkNAN=isnan(inpmat);
raw = inpmat;
raw(checkNAN==1)=0;
mVal = mean(raw);
raw(checkNAN==1)=mVal;
dat = raw;