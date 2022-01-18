% calculates a map of loacal echo times from GE field map and EPI sequence parameters
% according to analytical Eq. (1) from N. Chen et al. NeuroImage 31 (2006) 609? 622
% code written by Barbara Dymerska
% used for BOLD sensitivity estimation in our study:
% Dymerska, Barbara, et al.
% "The Impact of Echo Time Shifts and Temporal Signal Fluctuations on BOLD Sensitivity
% in Presurgical Planning at 7 T." Investigative radiology 54.6 (2019): 340-348.
% last modified: 24.06.2021

% modified by Nadine Graedel Nov 2021: modifications to nifti read/write
% and TE_min/TE_max calculation
% January 2022 - BKD - rotation to EPI space added 

%%%%%%%%%%% USER PARAMETERS %%%%%%%%%%%

%---- For 2 seg
root_dir = '/home/bdymerska/Documents/data/7T/2021/M700302_analysis/QSM/'; % this is also where the local TE maps will be saved
GEFM_name = 'B0.nii'; % unwrapped gradient echo fieldmap in Hz

% EPI parameters - 1331 early PF
% EPI_file = '~/Documents/data/7T/2021/M700302_analysis/nc_epi3d_v2q_1331_earlyPF_TE17p7_TR43_0p8mm_PAT4x2_PF68_0007/f2022-01-06_10-05-102625-00001-00001-1.nii';
% Tesp = 0.00122; % the effective echo spacing in EPI in sec
% iPAT = 8 ; % acceleration factor in phase encoding direction
% pF_late = 1 ; % partial fourier last bit of k-space
% pF_early = 6/8 ; % partial fourier first bit of k-space
% PE_dir = 1 ; % 1 for Posterior-Anterior and -1 for Anterior-Posterior
% TE = 0.01770 + 0.0015/2 ; % the effective echo time in seconds set as sequence parameter
% my = 240 ; % matrix size in phase encoding direction

% EPI parameters - 121 late PF
EPI_file = '~/Documents/data/7T/2021/M700302_analysis/nc_epi3d_v2r_121_latePF_NavOff_TE22p58_TR37_0006/f2022-01-06_10-05-101532-00001-00001-1.nii';
Tesp = 0.00122; % the effective echo spacing in EPI in sec
iPAT = 8 ; % acceleration factor in phase encoding direction
pF_late = 6/8 ; % partial fourier last bit of k-space
pF_early = 1 ; % partial fourier first bit of k-space
PE_dir = -1 ; % 1 for Posterior-Anterior and -1 for Anterior-Posterior
TE = 0.02258 ; % the effective echo time in seconds set as sequence parameter
my = 240 ; % matrix size in phase encoding direction

flag_voxels_out = 'yes' ; % select 'yes' or 'no', if 'yes' flags voxels with signal which will go out of k-space in EPI with value -1000

%%%%%%%%%%% END OF USER PARAMETERS %%%%%%%%%%%
output_dir = root_dir ;


disp('calculating the effective echo spacing') ;
Tesp = Tesp/iPAT ;

disp('calculating maximum TE allowed, above which type II loses occur (signal goes out of the acquired k-space)') ;
TE_max = TE + my*(pF_late-1/2)*Tesp;   
TE_min = TE - my*(pF_early-1/2)*Tesp; 
% NNG: in the original script this was TE_max = my*pF*Tesp; and TE_min = 0
% this assumes that the readout starts immediately at t = 0, the new
% version takes into account the time it takes for excitation, navigators
% and any fill time. 


disp('loading and reslicing field map to match EPI space (e.g. for oblique slices)')
GEFM_file = fullfile(root_dir,GEFM_name) ;
GEFM_spm = nifti(GEFM_file);
GEFM_V = spm_vol(GEFM_file);
data_dim = size(GEFM_spm.dat) ;   
EPI_spm = nifti(EPI_file) ;

    GE2EPI_mat = GEFM_spm.mat\EPI_spm.mat ;
    GEFMrot = zeros(data_dim) ;
    data_dim_xy = data_dim(1:2);
    
    for slice = 1 : data_dim(3)
        GEFMrot(:,:,slice) = spm_slice_vol(GEFM_V, GE2EPI_mat*spm_matrix([0 0 slice]), data_dim_xy, -7) ;
    end

disp('calculating B0 gradient in EPI PE1-direction')
[G_pe1,~,~] = gradient(PE_dir*GEFMrot) ;
Gy_file = fullfile(root_dir, 'GradPE1_GEFM.nii') ;
createNifti(G_pe1, Gy_file, GEFM_spm.mat);

disp('calculating local effective TE') ;
TE_mat = repmat(TE, size(G_pe1)) ;
my_mat = repmat(1/my, size(G_pe1)) ;
TEloc = TE_mat + (-G_pe1*TE*Tesp./(my_mat+G_pe1.*Tesp)) ;

if strcmp(flag_voxels_out,'yes')
    disp('flagging of the values with type II signal loss (flag = -1000)') ;
    TEloc(TEloc<TE_min) = -1000 ;
    TEloc(TEloc>TE_max) = -1000 ;
    
    TE_flags = zeros(size(TEloc)) ;
    TE_flags(TEloc==-1000) = 1 ;
    
    disp('saving flag mask') ;
    TE_flags_file = fullfile(root_dir, 'TE_flags.nii') ;
    createNifti(TE_flags, TE_flags_file, EPI_spm.mat);
end

TEloc_file = fullfile(root_dir, 'TE_local.nii') ;
createNifti(TEloc, TEloc_file, EPI_spm.mat);

% NNG - save shift in local TE in ms
disp('saving local TE different to nominal') ;
TEloc_file = fullfile(root_dir, 'TE_local_diff_ms.nii') ;
createNifti((TEloc-TE)*1000, TEloc_file, EPI_spm.mat);






