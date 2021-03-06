classdef param
    
    properties (Constant = true)  
        numADCSamples=256;
        numADCSamples_vel=256;
        numChirpsPerFrame = 96;
        numCirpsPerFrame_vel1 = 128;
        numCirpsPerFrame_vel2 = 128;
        RX_num = 4;
        TX_num = 3;
        
        c = 3e8;
        digOutSampleRate = 12500;
        freqSlopeConst = 94.27;
        digOutSampleRate_vel = 4652;
        freqSlopeConst_vel = 6.66;
        
        startFreqConst = 77;
        startFreqConst_vel = 76;
        adcStartTimeConst = 3;
        idleTimeConst = 20;
        rampEndTime = 26.52;
        adcStartTimeConst_vel = 4.8;
        
        MAX_NUM_DET_PER_RANGE_GATE = 3;
        CFARTHRESHOLD_N_BIT_FRAC = 8;
        guardLen_doppler = 8;
        winLen_doppler = 8;
        thresholdScale_doppler = 8;
        guardLen_range = 2;
        winLen_range = 4;
        thresholdScale_range = 30;
        cfartype = 'so';
        angleBin_num = 64;
        
        MRR_CHIRP_IDLETIME_1 = 0;
        MRR_PROFILE_IDLETIME = 10;
        MRR_idleTimeConst_1 = param.MRR_CHIRP_IDLETIME_1 + param.MRR_PROFILE_IDLETIME;
        MRR_CHIRP_IDLETIME_2 = 13;
        MRR_idleTimeConst_2 = param.MRR_CHIRP_IDLETIME_2 + param.MRR_PROFILE_IDLETIME;
        MRR_rampEndTime = 60.03009458;
        MaxVelVirNum = param.RX_num;
        MRR_CHIRP_PERIOD_1 = param.MRR_idleTimeConst_1 + param.MRR_rampEndTime;
        MRR_CHIRP_PERIOD_2 = param.MRR_idleTimeConst_2 + param.MRR_rampEndTime;
        PROFILE_MRR_LAMBDA_MILLIMETER = (param.c / 1e6) / param.startFreqConst_vel;
        velResolutionFastChirp = ((1000/param.MRR_CHIRP_PERIOD_1)/param.numCirpsPerFrame_vel1)*(param.PROFILE_MRR_LAMBDA_MILLIMETER/2);
        
        MAX_VEL_ENH_NUM_NYQUIST = 2;
        MAX_VEL_IMPROVEMENT_ASSOCIATION_THRESH_DB = 3;
        maxVelAssocThresh = ( 1 * 2^(param.CFARTHRESHOLD_N_BIT_FRAC) * param.RX_num * param.MAX_VEL_IMPROVEMENT_ASSOCIATION_THRESH_DB) / 6;
        N_HYPOTHESIS = (2 * (param.MAX_VEL_ENH_NUM_NYQUIST - 1)) + 1;
        maxUnambiguousVel = param.velResolutionFastChirp * param.numCirpsPerFrame_vel1 / 2;
        VelResolutionSlowChirp = ((1000/param.MRR_CHIRP_PERIOD_2)/param.numCirpsPerFrame_vel2)*(param.PROFILE_MRR_LAMBDA_MILLIMETER/2);
        invVelResolutionSlowChirp = 1 / param.VelResolutionSlowChirp;
        MAX_VEL_IMPROVEMENT_NUM_SPREAD = 1;
        
        xyzOutputQFormat = 7;
        maxNumObj2DRaw = 200;
        rangeResolution = ((param.c / 1e6) * param.digOutSampleRate_vel)/ (2000 * param.freqSlopeConst_vel * param.numADCSamples_vel);
        MIN_RANGE_OFFSET_METERS = 0.075;
        
    end
    
    methods
    end
    
end