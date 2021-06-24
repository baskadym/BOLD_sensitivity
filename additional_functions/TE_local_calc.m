% calculates effective echo time from GE field map and the EPI parameters
% according to analytical Eq. (1) from N. Chen et al. NeuroImage 31 (2006) 609? 622
% written by Barbara Dymerska
% last modified: 31.10.2016

%%%%%%%%%%% USER PARAMETERS %%%%%%%%%%%

% root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19841222SGGL_201510291600_analysis/GEFM_conjdiff_prelude_6_8/fm_conj-diff_prelude' ;
% GEFM_name = 'fieldmap.nii' ; % field map in rad*Hz
% 
% 
% % EPI parameters
% Tesp = 0.00078; % the effective echo spacing in EPI in sec
% iPAT = 2 ; % in-plane acceleration factor
% PE_dir = -1 ; % 1 for Posterior-Anterior and -1 for Anterior-Posterior
% pF = 0.75 ; % partial fourier
% TE = 0.022 ; % the effective echo time in seconds set as sequence parameter

root_dir = '' ;
GEFM_name = 'dB0_TE4_2.nii' ; % field map in rad*Hz
% 
% 
% % EPI parameters
Tesp = 0.00039*2; % the effective echo spacing in EPI in sec
iPAT = 2 ; % in-plane acceleration factor
PE_dir = 1 ; % 1 for Posterior-Anterior and -1 for Anterior-Posterior
pF = 6/8 ; % partial fourier
TE = 0.022 ; % the effective echo time in seconds set as sequence parameter



%%%%%%%%%%% END OF USER PARAMETERS %%%%%%%%%%%

disp('loading GE field map') ;
GEFM_file = fullfile(root_dir,GEFM_name) ;
GEFM_nii = load_nii(GEFM_file) ;
[Gy,~,~] = gradient(PE_dir*GEFM_nii.img/2/pi) ; % in gradient function x is swaped with y, i.e. the gradient in the PE-direction is in x-direction


Gy_nii = make_nii(Gy, GEFM_nii.hdr.dime.pixdim(2:4)) ;
Gy_file = fullfile(root_dir, 'GradY_GEFM.nii') ;
save_nii(Gy_nii, Gy_file) ;

output_dir = root_dir ;
GEFM_nii.img(isnan(GEFM_nii.img))=0 ;

Gy_bw_nii = Gy_nii ;


% here it is assumed that the matrix size in PE-direction is the same for field map as for EPI
my = size(Gy_bw_nii.img,2) ;

disp('calculating the effective echo spacing') ;
Tesp = Tesp/iPAT ;

disp('calculating maximum TE allowed, above which type II loses occur (signal goes out of the acquired k-space)') ;
TE_max = ceil(my*pF*Tesp) ; 

disp('calculating local effective TE') ;
TE_mat = repmat(TE, size(Gy_bw_nii.img)) ;
my_mat = repmat(1/my, size(Gy_bw_nii.img)) ;
TEloc = TE_mat + (-Gy_bw_nii.img*TE*Tesp./(my_mat+Gy_bw_nii.img.*Tesp)) ;

disp('flagging of the values with type II signal loss (flag = -1000)') ;
TEloc(TEloc<0) = -1000 ; 
TEloc(TEloc>TE_max) = -1000 ;

TE_flags = zeros(size(TEloc)) ;
TE_flags(TEloc==-1000) = 1 ;

disp('saving local TE') ;
TEloc_nii = make_nii(TEloc, GEFM_nii.hdr.dime.pixdim(2:4)) ;
TEloc_file = fullfile(root_dir, 'TE_local.nii') ;
save_nii(TEloc_nii, TEloc_file) ;

disp('saving flag mask') ;
TE_flags_nii = make_nii(TE_flags, GEFM_nii.hdr.dime.pixdim(2:4)) ;
TE_flags_file = fullfile(root_dir, 'TE_flags.nii') ;
save_nii(TE_flags_nii, TE_flags_file) ;









