% calculates effective echo time from GEFM with the EPI parameters

% root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19841222SGGL_201510291600_analysis/GEFM_conjdiff_prelude_2_4/fm_conj-diff_prelude/' ;
root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19530122RNHF2_201502171000_analysis/GEFM_conjdiff_prelude_59_61/fm_conj-diff_prelude/';
% root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19621112CRSC_201506220930_analysis/GEFM_conjdiff_prelude_56_58/fm_conj-diff_prelude/';
% root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19850511RMBD_201506290930_analysis/GEFM_conjdiff_prelude_54_56/fm_conj-diff_prelude/';
% root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19560318BLBL_201501201000_analysis/GEFM_conjdiff_prelude_55_57/fm_conj-diff_prelude/';
% root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19801205JHGE_201505110930_analysis/GEFM_conjdiff_prelude_54_56/fm_conj-diff_prelude/';
% root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19780509MCAT_201506010930_analysis/GEFM_conjdiff_prelude_54_56/fm_conj-diff_prelude/';
% root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19600115AIKC_201507060930_analysis/GEFM_conjdiff_prelude_72_74/fm_conj-diff_prelude/';
% root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19561220SEGN_201508030930_analysis/GEFM_conjdiff_prelude_58_60/fm_conj-diff_prelude/';
% root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19820512TMSL_201509140930_analysis/GEFM_conjdiff_prelude_51_53/fm_conj-diff_prelude/';
% root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19690423AIMS_201509210930_analysis/GEFM_conjdiff_prelude_75_77/fm_conj-diff_prelude/';
% root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19801228SECT_201509280930_analysis/GEFM_conjdiff_prelude_51_53/fm_conj-diff_prelude/';

% root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19920214GEGY_201603241700_analysis/GEFM_conjdiff_prelude_4_6/' ;

GEFM_name = 'fieldmap.nii' ;
% nifti_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19920214GEGY_201603241700/nifti/' ;

% nifti_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19841222SGGL_201510291600/nifti/' ;
nifti_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19530122RNHF2_201502171000/nifti/' ;
% nifti_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19621112CRSC_201506220930/nifti/' ;
% nifti_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19850511RMBD_201506290930/nifti/' ;
% nifti_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19560318BLBL_201501201000/nifti/' ;
% nifti_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19801205JHGE_201505110930/nifti/' ;
% nifti_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19780509MCAT_201506010930/nifti/' ;
% nifti_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19600115AIKC_201507060930/nifti/' ;
% nifti_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19561220SEGN_201508030930/nifti/' ;
% nifti_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19820512TMSL_201509140930/nifti/' ;
% nifti_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19690423AIMS_201509210930/nifti/' ;
% nifti_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19801228SECT_201509280930/nifti/' ;

% nifti_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/p_20150611_201506111900/nifti/' ;

EPI_scan_nr =  63;
Tesp = 0.00078 ; % echo spacing in EPI in sec
iPAT = 2 ;
PE_dir = 1 ; % 1 for PA and -1 for AP
TE_max = 0.038 ; %0.047 ; %0.072 ; % maximum TE allowed, above which type II loses occur (signal goes out of the acquired k-space), calculate as: nr_of_lines_acquired*GrappaFactor


TE = str2double(search_text_header_func(fullfile(nifti_dir, num2str(EPI_scan_nr),'text_header.txt'),'alTE[0]'))/10^6 ;

Tesp = Tesp/iPat ;

GEFM_file = fullfile(root_dir,GEFM_name) ;
GEFM_nii = load_nii(GEFM_file) ;
[Gy,~,~] = gradient(PE_dir*GEFM_nii.img/2/pi) ; % in gradient function x is swaped with y, i.e. the gradient in the PE-direction is in x-direction


Gy_nii = make_nii(Gy, GEFM_nii.hdr.dime.pixdim(2:4)) ;
Gy_file = fullfile(root_dir, 'GradY_GEFM.nii') ;
save_nii(Gy_nii, Gy_file) ;

output_dir = root_dir ;
% GEFM_nii.img(isnan(GEFM_nii.img))=0 ;

Gy_bw_nii = Gy_nii ;
% Gy_bw_nii = VSMbasedUnwarping3(GEFM_nii,nifti_dir, EPI_scan_nr, Gy_nii, output_dir) ; % back-warped to the EPI space


my = size(Gy_bw_nii.img,2) ;
TE_mat = repmat(TE, size(Gy_bw_nii.img)) ;
my_mat = repmat(1/my, size(Gy_bw_nii.img)) ;
TEloc = TE_mat + (-Gy_bw_nii.img*TE*Tesp./(my_mat+Gy_bw_nii.img.*Tesp)) ;

% flagging of the values with type II signal loss
TEloc(TEloc<0) = -1000 ; 
TEloc(TEloc>TE_max) = -1000 ;

TE_flags = zeros(size(TEloc)) ;
TE_flags(TEloc==-1000) = 1 ;

%saving local TE
TEloc_nii = make_nii(TEloc, GEFM_nii.hdr.dime.pixdim(2:4)) ;
TEloc_file = fullfile(root_dir, 'TE_local.nii') ;
save_nii(TEloc_nii, TEloc_file) ;

TE_flags_nii = make_nii(TE_flags, GEFM_nii.hdr.dime.pixdim(2:4)) ;
TE_flags_file = fullfile(root_dir, 'TE_flags.nii') ;
save_nii(TE_flags_nii, TE_flags_file) ;









