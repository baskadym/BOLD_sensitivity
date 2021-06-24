

root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19841222SGGL_201510291600_analysis/' ;
first_scan_nr = 12 ;
% nr_of_scans = 12 ;
smooth_para = 2 ;
TP = 168 ;

% if matlabpool('size') == 0 % checking to see if my pool is already open
%     matlabpool open 6
% end

% for k = 1: nr_of_scans

    data_dir = fullfile(root_dir, sprintf('DCwithGEFM_mag_%i',first_scan_nr+k-1)) ;
    mag_file = fullfile(data_dir, 'MagUnwarped.nii') ;
    mag_nii = load_nii(mag_file) ;
    
    for t=1:TP
        mag_nii.img(:,:,:,t) = smoothn(mag_nii.img(:,:,:,t), smooth_para) ;
    end
    mag_file = fullfile(data_dir, 'smooth_MagUnwarped.nii') ;
    save_nii(mag_nii, mag_file) ;
% end
% 
% matlabpool close