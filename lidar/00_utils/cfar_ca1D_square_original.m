% 1D-CFAR修改建议
% 2021.05.11
% 按照距离减小阈值或者窗口大小，因为回波随距离变远，波峰变小，不好提取
function [Detect] = cfar_ca1D_square_original(Xcube,trainWin,guardLen,Pfa,wrapMode)
N = trainWin*2;
alpha = N*(Pfa^(-1/N)-1);
alpha_oneside = trainWin*(Pfa^(-1/trainWin)-1);
Xcube = Xcube.^2; 
Xcube = (Xcube-min(Xcube))/(max(Xcube)-min(Xcube)); % normalization
Xlength = length(Xcube);
biXcube = zeros(1,Xlength);
Detect = [];
numOfDet = 0;
if wrapMode == 0    %%% disabled warpped mode
    for i = 1:Xlength
        if i < trainWin+guardLen+1  %%% one-sided comparision for left section
            noise_estimate = sum(Xcube(i+guardLen+1:i+guardLen+trainWin))/trainWin;
%             noise_estimate = pow2db(noise_estimate);
            if Xcube(i) > alpha_oneside*noise_estimate
%             if Xcube(i) > noise_estimate+Pfa
                numOfDet = numOfDet + 1;
                Detect(1,numOfDet) = i; %%% index
                Detect(2,numOfDet) = Xcube(i);  %%% object power
                Detect(3,numOfDet) = noise_estimate;  %%% estimated noise
                biXcube(i) = 1;
            end
        elseif i < Xlength-trainWin-guardLen+1  %%% two-sided comparison for middle section
            noise_estimate = (sum(Xcube(i+guardLen+1:i+guardLen+trainWin)) ...
                + sum(Xcube(i-guardLen-trainWin:i-guardLen-1)))/N;
%             noise_estimate = pow2db(noise_estimate);
            if Xcube(i) > alpha_oneside*noise_estimate
%             if Xcube(i) > noise_estimate+Pfa
                numOfDet = numOfDet + 1;
                Detect(1,numOfDet) = i; %%% index
                Detect(2,numOfDet) = Xcube(i);  %%% object power
                Detect(3,numOfDet) = noise_estimate;  %%% estimated noise
                biXcube(i) = 1;
            end
        else     %%%  one-sided comparision for right section
            noise_estimate = sum(Xcube(i-guardLen-trainWin:i-guardLen-1))/trainWin;
%             noise_estimate = pow2db(noise_estimate);
            if Xcube(i) > alpha_oneside*noise_estimate
%             if Xcube(i) > noise_estimate+Pfa
                numOfDet = numOfDet + 1;
                Detect(1,numOfDet) = i; %%% index
                Detect(2,numOfDet) = Xcube(i);  %%% object power
                Detect(3,numOfDet) = noise_estimate;  %%% estimated noise
                biXcube(i) = 1;
            end
        end
    end
else       %%% enabled wrapped mode
    for i = 1:Xlength
        if i < trainWin+guardLen+1  %%% two-sided comparision for left section with wrap
            %%% discuss the wrap scenario
            if i <= guardLen
                noise_estimate = (sum(Xcube(i+guardLen+1:i+guardLen+trainWin))...
                    + sum(Xcube(Xlength+i-guardLen-trainWin:Xlength+i-guardLen-1)))/N;
            else 
                noise_estimate = (sum(Xcube(i+guardLen+1:i+guardLen+trainWin))...
                    + sum(Xcube(Xlength+i-guardLen-trainWin:Xlength))+sum(Xcube(1:i-1-guardLen)))/N;
            end
%             noise_estimate = pow2db(noise_estimate);
            if Xcube(i) > alpha_oneside*noise_estimate
%             if Xcube(i) > noise_estimate+Pfa
                numOfDet = numOfDet + 1;
                Detect(1,numOfDet) = i; %%% index
                Detect(2,numOfDet) = Xcube(i);  %%% object power
                Detect(3,numOfDet) = noise_estimate;  %%% estimated noise
                biXcube(i) = 1;
            end
            
        elseif i < Xlength-trainWin-guardLen+1  %%% two-sided comparison for middle section
            noise_estimate = (sum(Xcube(i+guardLen+1:i+guardLen+trainWin))...
                + sum(Xcube(i-guardLen-trainWin:i-guardLen-1)))/N;
%             noise_estimate = pow2db(noise_estimate);
            if Xcube(i) > alpha_oneside*noise_estimate
%             if Xcube(i) > noise_estimate+Pfa
                numOfDet = numOfDet + 1;
                Detect(1,numOfDet) = i; %%% index
                Detect(2,numOfDet) = Xcube(i);  %%% object power
                Detect(3,numOfDet) = noise_estimate;  %%% estimated noise
                biXcube(i) = 1;
            end
            
        else     %%%  two-sided comparision for right section with wrap
            if i >= Xlength-guardLen+1
                noise_estimate = (sum(Xcube(i-guardLen-trainWin:i-guardLen-1))...
                    + sum(Xcube(guardLen+i-Xlength+1:guardLen+i-Xlength+trainWin)))/N;
            else
                noise_estimate = (sum(Xcube(i-guardLen-trainWin:i-guardLen-1))...
                    + sum(Xcube(guardLen+i+1:Xlength))+sum(Xcube(1:trainWin-Xlength+i+guardLen)))/N;
            end
%             noise_estimate = pow2db(noise_estimate);
            if Xcube(i) > alpha_oneside*noise_estimate
%             if Xcube(i) > noise_estimate+Pfa
                numOfDet = numOfDet + 1;
                Detect(1,numOfDet) = i; %%% index
                Detect(2,numOfDet) = Xcube(i);  %%% object power
                Detect(3,numOfDet) = noise_estimate;  %%% estimated noise
                biXcube(i) = 1;
            end
        end
    end
end
biXcube(biXcube~=0 & biXcube~=1) = 0;
end