#!/bin/sh

#   registration.sh
#
#   usage: registration.sh mprage_brain.nii.gz tumour_mask.nii.gz epi.nii.gz
#
# Michael Hart, University of Cambridge, 05/12/2014


#1. Affine registration of mprage_brain to MNI
flirt -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz -in mprage_brain.nii.gz -out mprage_MNI.nii.gz -inweight tumour_mask.nii.gz -omat struct2standard.mat

#2. Makes spherical tumour mask in MNI space
flirt -ref mprage_MNI.nii.gz -in tumour_mask.nii.gz -applyxfm -init struct2standard.mat -out tumour_mask_MNI.nii.gz

#3. Now register epi to mprage in native space
flirt -ref mprage_brain.nii.gz -in epi.nii.gz -dof 6 -omat func2struct.mat

#4. Concatenate transforms from epi to MNI space
convert_xfm -omat func2standard -concat struct2standard.mat funct2struct.mat

#5. Apply the concatenated transforms to all 3D EPI volumes
flirt -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz -in epi.nii.gz -applyxfm -init func2standard.mat -out epi_MNI

#6. Quality control steps
slices ${FSLDIR}/data/standard/MNI152_T1_2mm_brain -s 2 mprage_MNI.nii.gz # mprage to MNI

slices mprage_MNI.nii.gz -s 2 epi_MNI.nii.gz # mprage & epi in

fslview ${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz mprage_MNI.nii.gz epi_MNI.nii.gz -l "Red-Yellow" -t 0.6 &

echo 'all done'

