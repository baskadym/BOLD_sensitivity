% Calculated mean time course over all gray matter voxels in the brain.
% For Breath Hold activation map analysis.


% 
% root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19890417PUSH_201501140900_analysis/nifti/' ;
% GM_file = fullfile(root_dir,'58/c1meanstc_Image.nii') ;
% EPI_file = fullfile(root_dir,'60/coreg_mc_stc_Image.nii') ;
% % resp_file = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19890417PUSH_201501140900/RespPara/BH/Resplog_20150114_105022.resp' ;
% % resp_file = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19890417PUSH_201501140900/RespPara/BH/Resplog_20150114_105431.resp' ;
% resp_file = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19890417PUSH_201501140900/RespPara/BH/Resplog_20150114_105847.resp' ;
% slices=16:33;


% root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19851211LRPL_201509171600_analysis/nifti/' ;
% GM_file = fullfile(root_dir,'111/c1meanstc_Image_bet.nii') ;
% EPI_file = fullfile(root_dir,'113/coreg_mc_stc_Image.nii') ;
% % resp_file = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19851211LRPL_201509171600/RespPara/Resplog_20150917_171854.resp' ;
% % resp_file = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19851211LRPL_201509171600/RespPara/Resplog_20150917_172317.resp' ;
% % resp_file = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19851211LRPL_201509171600/RespPara/Resplog_20150917_172725.resp' ;
% slices=1:33;

root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19841222SGGL_201509211500_analysis/nifti/' ;
GM_file = fullfile(root_dir,'7/c1meanstc_Image.nii') ;
EPI_file = fullfile(root_dir,'7/coreg_mc_stc_Image.nii') ;
resp_file = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19841222SGGL_201509211500/RespPara/Resplog_20150921_151447.resp' ;
% resp_file = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19841222SGGL_201509211500/RespPara/Resplog_20150921_152013.resp' ;
% resp_file = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19841222SGGL_201509211500/RespPara/Resplog_20150921_152419.resp' ;
slices=1:33;


GM_thresh = 0.5 ;




GM_nii = load_nii(GM_file) ;

GM_nii.img(GM_nii.img<GM_thresh) = 0 ;
GM_nii.img(GM_nii.img>GM_thresh) = 1 ;

GM_mask_file = fullfile(root_dir, 'GM_mask.nii') ;
save_nii(GM_nii, GM_mask_file) ;

EPI_nii = load_nii(EPI_file) ;

TP = size(EPI_nii.img,4) ;

EPI_GM = single(EPI_nii.img).*repmat(GM_nii.img, [1 1 1 TP]) ;


EPI_meanS = zeros(TP,1) ;
for t=1:TP
    
    [~,~,~,EPI_vector] = find3(EPI_GM(:,:,slices,t)) ;
    EPI_meanS(t) = mean(EPI_vector) ;
end
%%

txt_string = textread(resp_file, '%s','delimiter', '\n', 'bufsize', 80000);
resp = str2num(char(txt_string(1))) ;
resp_smooth = smoothn(resp(5:(size(resp,2)-1)),10) ;

x_uprange = 0.02*size(resp_smooth,2) ;
x = 0.02:0.02:x_uprange;
figure
subplot(2,1,1)
plot(x, resp_smooth(1:size(x,2)))
title('Respiration belt data') ;


x2 = (2:2:2*TP)' ;
subplot(2,1,2)
plot(x2, EPI_meanS)
title('Mean S in GM') 
