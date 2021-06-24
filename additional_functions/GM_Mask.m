gm_file = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19841222SGGL_201510291600_analysis/nifti/3/c1Image_TE3.nii' ;
thresh = 0.4 ;


gm_nii = load_nii(gm_file) ;

gm_nii.img(gm_nii.img<thresh) = 0 ;
gm_nii.img(gm_nii.img>=thresh) = 1 ;

[dir, name,~] = fileparts(gm_file) ;
gm_mask_file = fullfile(dir, 'gm_mask.nii') ;
% gm_mask_file = fullfile(dir, 'mask.nii') ;
save_nii(gm_nii, gm_mask_file) ;