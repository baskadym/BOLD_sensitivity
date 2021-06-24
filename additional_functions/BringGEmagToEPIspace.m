% fm_file = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19801228SECT_201509280930_analysis/GEFM_conjdiff_prelude_51_53/fm_conj-diff_prelude/fieldmap.nii' ;
% nifti_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19801228SECT_201509280930/nifti/' ;
% epi_scan_nr = 55 ;
% output_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19801228SECT_201509280930_analysis/nifti/52/' ;

fm_file = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19900813KREK_201510011500_analysis/DCwithMarques_dB0_mag_69_TPs_1_4/GEFM_final.nii' ;
nifti_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19900813KREK_201510011500/nifti/' ;
epi_scan_nr = 69 ;
output_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19900813KREK_201510011500_analysis/nifti/56/' ;


fm_nii = load_nii(fm_file) ;

mag_file = fullfile(output_dir, 'Image_TE2.nii') ;
mag_nii = load_nii(mag_file) ;

fm_nii.img = smoothn(fm_nii.img,1) ;

VSMbasedUnwarping3(fm_nii,nifti_dir, epi_scan_nr, mag_nii, output_dir) ;

cd(output_dir)
unix('mv MagUnwarped.nii Image_TE2_fw.nii') ;