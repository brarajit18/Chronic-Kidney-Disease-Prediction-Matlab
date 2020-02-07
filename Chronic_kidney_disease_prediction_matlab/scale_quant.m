function dat = scale_quant(raw);
%MinMaxScaler
% scale to 0 to 1 scale
dat = raw - min(raw);
dat = dat/max(dat);