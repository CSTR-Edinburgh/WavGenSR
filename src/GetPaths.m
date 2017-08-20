function paths = GetPaths

paths.unvSCP       = '../database/s_f_sh_filt.scp'; % Path to the scp file containing the list of unvoiced base-signals. Also, it can be: './database/only_white.scp'
paths.bsVoiWavMale = '../database/voiced/a_p0_1_short_96k_pitch_norm.wav';
paths.bsVoiWavFem  = '../database/voiced/val_a_p0_3_short_96k_pitch_norm.wav';
paths.unvUnvWavs   = {  '../database/unvoiced/sim_f_3_short_48k_filt', ...
                        '../database/unvoiced/sim_s_1_short_48k_filt', ...
                        '../database/unvoiced/sim_sh_1_short_48k_filt'   };

paths.sptkbin      = '../tools/SPTK-3.9/build/bin';
end