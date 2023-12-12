% calculates a map of local echo times from GE field map and EPI sequence parameters
% according to analytical Eq. (1) from N. Chen et al. NeuroImage 31 (2006) 609? 622
%
% code written by Barbara Dymerska 
% code reviewed by Nadine Graedel
%
% If used please cite both:
% N. Chen et al. NeuroImage 31 (2006) 609-622
% B. Dymerska et al. Investigative Radiology 54.6 (2019): 340-348.

%%%%%%%%%%% USER PARAMETERS %%%%%%%%%%%

root_dir = '/your/root/dir/'; % this is also where the local TE maps will be saved
GEFM_name = 'B0.nii'; % unwrapped gradient echo fieldmap in Hz


% EPI parameters:
EPI_file = '/path/to/your/EPI/file/image.nii';
Tesp = 0.00122; % the effective echo spacing in EPI in sec
iPAT = 4 ; % total acceleration factor in phase encoding direction
pF_late = 6/8 ; % partial fourier last bit of k-space
pF_early = 1 ; % partial fourier first bit of k-space
PE_dir = -1 ; % 1 for Posterior-Anterior and -1 for Anterior-Posterior
TE = 0.02258 ; % the effective echo time in seconds set as sequence parameter
my = 240 ; % matrix size in phase encoding direction

flag_voxels_out = 'yes' ; % select 'yes' or 'no', if 'yes' flags voxels with signal which will go out of k-space in EPI with value -1000

%%%%%%%%%%% END OF USER PARAMETERS %%%%%%%%%%%
output_dir = root_dir ;


disp('calculating the effective echo spacing') ;
Tesp = Tesp/iPAT ;

disp('calculating maximum/minimum TE allowed, above which type II loses occur (signal goes out of the acquired k-space)') ;
% we take into account the time it takes for excitation, navigators and any fill time. 
TE_max = TE + my*(pF_late-1/2)*Tesp;   
TE_min = TE - my*(pF_early-1/2)*Tesp; 


disp('loading and reslicing field map to match EPI space (e.g. for oblique slices)')
GEFM_file = fullfile(root_dir,GEFM_name) ;
GEFM_spm = nifti(GEFM_file);
GEFM_V = spm_vol(GEFM_file);
data_dim = size(GEFM_spm.dat) ;   
EPI_spm = nifti(EPI_file) ;

    GE2EPI_mat = GEFM_spm.mat\EPI_spm.mat ;
    GEFMrot = zeros(data_dim) ;
    data_dim_xy = data_dim(1:2);
    
    for slice = 1 : data_dim(3)
        GEFMrot(:,:,slice) = spm_slice_vol(GEFM_V, GE2EPI_mat*spm_matrix([0 0 slice]), data_dim_xy, -7) ;
    end

disp('calculating B0 gradient in EPI PE1-direction')
[G_pe1,~,~] = gradient(PE_dir*GEFMrot) ;
Gy_file = fullfile(root_dir, 'GradPE1_GEFM.nii') ;
createNifti(G_pe1, Gy_file, GEFM_spm.mat);

disp('calculating local effective TE') ;
TE_mat = repmat(TE, size(G_pe1)) ;
my_mat = repmat(1/my, size(G_pe1)) ;
TEloc = TE_mat + (-G_pe1*TE*Tesp./(my_mat+G_pe1.*Tesp)) ;

if strcmp(flag_voxels_out,'yes')
    disp('flagging of the values with type II signal loss (flag = -1000)') ;
    TEloc(TEloc<TE_min) = -1000 ;
    TEloc(TEloc>TE_max) = -1000 ;
    
    TE_flags = zeros(size(TEloc)) ;
    TE_flags(TEloc==-1000) = 1 ;
    
    disp('saving flag mask') ;
    TE_flags_file = fullfile(root_dir, 'TE_flags.nii') ;
    createNifti(TE_flags, TE_flags_file, EPI_spm.mat);
end

TEloc_file = fullfile(root_dir, 'TE_local.nii') ;
createNifti(TEloc, TEloc_file, EPI_spm.mat);

disp('saving local TE different to nominal') ;
TEloc_file = fullfile(root_dir, 'TE_local_diff_ms.nii') ;
createNifti((TEloc-TE)*1000, TEloc_file, EPI_spm.mat);

