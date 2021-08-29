% calculates a map of loacal echo times from GE field map and EPI sequence parameters
% according to analytical Eq. (1) from N. Chen et al. NeuroImage 31 (2006) 609? 622
% code written by Barbara Dymerska
% used for BOLD sensitivity estimation in our study:
% Dymerska, Barbara, et al.
% "The Impact of Echo Time Shifts and Temporal Signal Fluctuations on BOLD Sensitivity
% in Presurgical Planning at 7 T." Investigative radiology 54.6 (2019): 340-348.
% last modified: 24.06.2021

%%%%%%%%%%% USER PARAMETERS %%%%%%%%%%%

root_dir = '' ; % this is also where the local TE maps will be saved
GEFM_name = 'wB0.nii' ; % unwrapped gradient echo fieldmap in Hz
PE_dir_dim = 1 ; % which coordinate (1st, 2nd or 3rd?) from the reference data will be the PE-direction in the EPI target data?

% EPI parameters
Tesp = 0.0012; % the effective echo spacing in EPI in sec
iPAT = 8 ; % acceleration factor in phase encoding direction
PE_dir = -1 ; % 1 for Posterior-Anterior and -1 for Anterior-Posterior
pF = 1 ; % partial fourier, set to 1 if first part of k-space is not acquired, set to true value if last part of k-space is not acquired
TE = 0.0177 ; % the effective echo time in seconds set as sequence parameter
my = 200 ; % matrix size in phase encodng direction


flag_voxels_out = 'no' ; % select 'yes' or 'no', if 'yes' flags voxels with signal which will go out of k-space in EPI with value -1000

%%%%%%%%%%% END OF USER PARAMETERS %%%%%%%%%%%

disp('loading GE field map') ;
GEFM_file = fullfile(root_dir,GEFM_name) ;
GEFM_V = spm_vol(GEFM_file) ;
GEFM = GEFM_V.private.dat(:,:,:) ;
GEFM(isnan(GEFM)) = 0 ;

if PE_dir_dim == 1
    [G_PE,~,~] = gradient(PE_dir*GEFM) ; % in gradient function x is swaped with y, i.e. the gradient in the PE-direction is in x-direction
elseif PE_dir_dim == 2
    [~,G_PE,~] = gradient(PE_dir*GEFM) ; % in gradient function x is swaped with y, i.e. the gradient in the PE-direction is in x-direction
elseif PE_dir_dim == 3
    [~,~,G_PE] = gradient(PE_dir*GEFM) ; % in gradient function x is swaped with y, i.e. the gradient in the PE-direction is in x-direction
else
    error('PE_dir_dim must be 1 or 2 or 3')
end


GEFM_V.descrip = 'Gradient in PE-direction' ;
if PE_dir == 1
    GEFM_V.fname = fullfile(root_dir, 'GradY_GEFM_PA.nii') ;
elseif PE_dir == -1
    GEFM_V.fname = fullfile(root_dir, 'GradY_GEFM_AP.nii') ;
end
G_PE(isnan(G_PE)) = 0 ;
spm_write_vol(GEFM_V, G_PE) ;

output_dir = root_dir ;


disp('calculating the effective echo spacing') ;
Tesp = Tesp/iPAT ;

disp('calculating maximum TE allowed, above which type II loses occur (signal goes out of the acquired k-space)') ;
TE_max = my*pF*Tesp ;

disp('calculating local effective TE') ;
TE_mat = repmat(TE, size(G_PE)) ;
my_mat = repmat(1/my, size(G_PE)) ;
TEloc = TE_mat + (-G_PE*TE*Tesp./(my_mat+G_PE.*Tesp)) ;

if strcmp(flag_voxels_out,'yes')
    disp('flagging of the values with type II signal loss (flag = -1000)') ;
    TEloc(TEloc<0) = -1000 ;
    TEloc(TEloc>TE_max) = -1000 ;
    
    TE_flags = zeros(size(TEloc)) ;
    TE_flags(TEloc==-1000) = 1 ;
    
    disp('saving flag mask') ;
    
    GEFM_V.descrip = 'Mask for voxels for which signal will fall outside the k-space acquisition window' ;
    if PE_dir == 1
        GEFM_V.fname = fullfile(root_dir, 'TE_flags_PA.nii') ;
    elseif PE_dir == -1
        GEFM_V.fname = fullfile(root_dir, 'TE_flags_AP.nii') ;
    end
    spm_write_vol(GEFM_V, TE_flags) ;
end

disp('saving local TE') ;
GEFM_V.descrip = 'Map of local effective echo time' ;
if PE_dir == 1
    GEFM_V.fname = fullfile(root_dir, 'TE_local_PA.nii') ;
elseif PE_dir == -1
    GEFM_V.fname = fullfile(root_dir, 'TE_local_AP.nii') ;
end
spm_write_vol(GEFM_V, TEloc) ;











