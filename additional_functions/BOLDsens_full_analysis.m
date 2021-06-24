% BOLD sensitivity, full analysis
% maps of: S, tSNR, TE_local, S*TE_local and tSNR*TE_local are created


root_dir = '/net/mri.meduniwien.ac.at/projects/radiology/fmri/data/bdymerska/7T/19890417PUSH_201501140900' ;

RS_scan = 57 ; % magnitude combined
GE_scan = 53 ; % magnitude uncombined



output_root = sprint('%s_analysis', root_dir) ;
output_nifti = fullfile(output_root,'nifti') ;


if ~exist(output_root, 'dir')
    mkdir(output_root)
end

if  ~exist(output_nifti, 'dir')
    mkdir(output_nifti)
end

input_nifti = fullfile(root_dir,'nifti') ;