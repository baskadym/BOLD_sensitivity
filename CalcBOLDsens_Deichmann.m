
root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19870526BRSR_201507201800_analysis/BOLDsensitivity/';
mag_scan_nrs = [83 84 85 86 87 88 89 90 91 92 93 94 95] ;
TEs= [33 31 29 27 25 23 22 21 19 17 15 13 11] ;

roi_nii = load_nii(fullfile(root_dir,'ROI.nii'));

% mag_mean=zeros(size(mag_scan_nrs,2),1) ;
for k = 1: size(mag_scan_nrs,2)
    mag_nii = load_nii(fullfile(root_dir, sprintf('mc_Image_%i.nii',mag_scan_nrs(k)))) ;
    mag = double(mag_nii.img) ;
    mag(roi_nii.img==0)=NaN ;
    mag_mean(k) = nanmean(vector(mag));
end


BS = mag_mean.*TEs ;
BS_norm = BS/max(BS) ;

figure
plot(fliplr(TEs),fliplr(BS_norm))
xrange(0;1.1)
title('normalise BOLD sensitivity')
