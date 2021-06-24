% function NormalizeToMaxValue(root_dir, mask_name, data_name)


root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19841222SGGL_201510291600_analysis/BOLDsens/' ;
mask_file = fullfile(root_dir,'mask.nii') ;
data_file = fullfile(root_dir, 'tSNR_RS_PA.nii') ;
% data_file = fullfile(root_dir, 'MeanSignal_RS_AP.nii') ;


mask_nii = load_nii(mask_file) ;
data_nii = load_nii(data_file) ;

data_mean = nanmean(vector(data_nii.img(mask_nii.img==1))) ;
% data_mean = 0.022 ;

data_norm = single(data_nii.img)/data_mean ;
data_norm_nii = make_nii(data_norm, data_nii.hdr.dime.pixdim(2:4)) ;
[~, name, ~] = fileparts(data_file) ;
data_norm_file = fullfile(root_dir, sprintf('%s_norm.nii',name)) ;
save_nii(data_norm_nii, data_norm_file) ;

