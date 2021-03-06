% 仅仅进行第三次fft操作，生成fft-cube
% 
%
function [ azimuthOut, elevOut ] = AOA2_v1_6( dopplerOut, TX_num, RX_num, numADCSamples, dopplerBin_num, angleBin_num, MAX_VEL_ENH_PROCESSING)
    azimuthOut = zeros(numADCSamples, angleBin_num, dopplerBin_num);
    L = 360;
    azimuthOut_music = zeros(numADCSamples,L , dopplerBin_num);
    elevOut = zeros(numADCSamples, angleBin_num, dopplerBin_num);
     for r = 1: numADCSamples
         
         for c = 1: dopplerBin_num
             if c >= dopplerBin_num/2 && c <= dopplerBin_num/2+2
                continue;
             end
             if TX_num == 3

                 Temp1 = zeros(1, angleBin_num);
                 Temp2 = zeros(1, angleBin_num);

                 Temp3 = reshape(dopplerOut(r, c, :, :), [1, TX_num * RX_num]);
                 Temp3 = RxPhaseBiasCompensation(Temp3, TX_num, RX_num, MAX_VEL_ENH_PROCESSING);
                 Temp3 = dopplerCompensation(Temp3, c, TX_num, RX_num, dopplerBin_num, MAX_VEL_ENH_PROCESSING);
                 Temp1(1: ((TX_num - 1) * RX_num)) = Temp3(1: ((TX_num - 1) * RX_num)); % 8个值
                 Temp2(1: RX_num) = Temp3((((TX_num - 1) * RX_num) + 1): (TX_num * RX_num)); % 4个值
                 %% 加窗
                 angleWin = hanning(angleBin_num);  % 32个chirp
                 angleWin = angleWin(1: (angleBin_num / 2));
                 angleWinLen               = length(angleWin);
                 angleWindowCoeffVec       = ones(angleBin_num, 1);
                 angleWindowCoeffVec(1:angleWinLen) = angleWin;
                 angleWindowCoeffVec(angleBin_num-angleWinLen+1:angleBin_num) = angleWindowCoeffVec(angleWinLen:-1:1);
                 angleWin = angleWindowCoeffVec;
                 Temp1 = bsxfun(@times, Temp1, angleWin.');
%                  
%% music算法
                 azimuthOut(r, :, c) = fftshift(fft(Temp1));
%                  azimuthOut_music(r, :, c) = musicAlg(Temp1,L);
                 elevOut(r, :, c) = fftshift(fft(Temp2));
             else

                 Temp1 = zeros(1, angleBin_num);
                 Temp1(1: TX_num * RX_num) = reshape(dopplerOut(r, c, :, :), [1, TX_num * RX_num]);
                 Temp1(1: (TX_num * RX_num)) = RxPhaseBiasCompensation(Temp1(1: (TX_num * RX_num)), TX_num, RX_num, MAX_VEL_ENH_PROCESSING);
                 Temp1 = dopplerCompensation(Temp1, c, TX_num, RX_num, dopplerBin_num, MAX_VEL_ENH_PROCESSING);
%% music 算法
                 azimuthOut(r, :, c) = fftshift(fft(Temp1));
%                  azimuthOut_music(r, :, c) = musicAlg(Temp1,L);

             end
         
         end

     end
end