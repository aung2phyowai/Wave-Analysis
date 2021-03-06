function [FD,HT,HTabs,HTangle] = BPnHilbert(data,bandpass)
%BPNHILBERT bandpasses input data according to bandpass and calculates the
%hilbert transform of the BPed data. 
%If there is only one output arg BPnHilbert will only bandpass
%   Usage: 
%   For just BP: FD = BPnHilbert(data,bandpass);
%   For BP+hilbert:  [FD,HT,HTabs,HTangle] = BPnHilbert(data,bandpass);
%   where FD (chXtrialXsample) is the filtered data, HT is the complex hilbert analytic,
%   HTabs is the complex magnitude of the analytic (the envelope) and HT
%   angle is the hilbert phase.


cutwidths=[2 2]; %cutwidths(1) to the right of bandpass(1), cutwidths(2) to the left of bandpass(2)
F=filterData(20000);
F.padding=true;
F.lowPassStopCutoff=bandpass(2)+cutwidths(2); %low-pass cutoff frequency
F.lowPassPassCutoff=bandpass(2);
F.highPassStopCutoff=bandpass(1)-cutwidths(1); %high-pass cutoff frequency
F.highPassPassCutoff=bandpass(1);
F=F.designBandPass;

FD=F.getFilteredData(data);

if nargout>1
    HT=zeros(size(FD));

    for i=1:size(FD,2)
        HT(:,i,:)=hilbert(squeeze(FD(:,i,:))').';
    end

    HTabs=abs(HT);
    HTangle=angle(HT);
end
end

