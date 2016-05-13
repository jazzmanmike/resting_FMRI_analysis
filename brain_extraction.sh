#!/bin/sh

#   brain_extraction.sh
#
#   usage: brain_extraction.sh mprage.nii.gz tumour_mask.nii.gz
#
#   NB: file names must be as above and need to have FSL setup.
#  
#   Adapted from optiBet by the MontiLab
#
#   Michael Hart, University of Cambridge, 05/12/2014.

echo 'optimally extract brain then core out using MNI mask back in native space'

#1. First perform a rough BET
bet mprage.nii.gz mprage_bet.nii.gz -B -f 0.1 # occassionally consider altering -g value; note also makes mask

#2. Register crude mprage_BET to MNI space
flirt -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -in mprage_bet.nii.gz -inweight tumour_mask.nii.gz -omat bet2mni.mat

#3. Invert the above transform to go from MNI to native space
convert_xfm -omat mni2bet.mat -inverse bet2mni.mat

#4. Register MNI brain mask to native space with above transform

flirt -ref mprage_bet.nii.gz -in ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -init mni2bet.mat -applyxfm -out native_MNI_mask

#5. Binarise native space mask
fslmaths native_MNI_mask.nii.gz -bin native_MNI_mask.nii.gz

#6. Extract non-brain in native space
fslmaths mprage.nii.gz -mas native_MNI_mask.nii.gz mprage_brain.nii.gz

#7. One final round of 'relaxed' BET
bet mprage_brain.nii.gz mprage_brain.nii.gz -f 0.1

#8. Now perform cleanup
rm mprage_bet.nii.gz bet2mni.mat mni2bet.mat native_MNI_mask.nii.gz mprage_bet_mask.nii.gz

echo 'all done - now display brain extracted mprage'

slices mprage.nii.gz mprage_brain.nii.gz # check stripped is better than brain

fslview mprage.nii.gz mprage_stripped.nii.gz -l "Red-Yellow" -t 0.6 mprage_brain.nii.gz -l "Red-Yellow" -t 0.6 &

echo ' '
