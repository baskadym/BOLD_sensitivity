

M = load('../im37_AP_mat.mat') ;

B0_mean = load_untouch_nii('B0_DDC_Tmean.nii') ;

B0_mean.img = padarray(B0_mean.img, [0 0 10],0,'both') ;
B0_mean.hdr.dime.dim(4) = size(B0_mean.img,3) ;
save_untouch_nii(B0_mean, 'B0_DDC_Tmean_pad.nii')

B0_mean_V = spm_vol('B0_DDC_Tmean_pad.nii') ;

 source2target_mat = B0_mean_V.mat\M.im37_AP_mat ;
 

 
 
 B0_rot = zeros(B0_mean_V.dim) ;
 data_dim_xy = B0_mean_V.dim(1:2);
    
    for slice = 1 : B0_mean_V.dim(3)
        B0_rot(:,:,slice) = spm_slice_vol(B0_mean_V, source2target_mat*spm_matrix([0 0 slice]), data_dim_xy, -7) ;
    end
    
     
    B0_rot(isnan(B0_rot)) = 0 ;
    B0_rot_V = B0_mean_V ;
    B0_rot_V.mat = M.im37_AP_mat ;
    B0_rot_V.fname = 'B0_DDC_Tmean_to_im37rot.nii';
    spm_write_vol(B0_rot_V, B0_rot);