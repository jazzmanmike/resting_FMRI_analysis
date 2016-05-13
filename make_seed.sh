#!/bin/sh

#  make_seed.sh
#  
#  usage: make_seed.sh mprage.nii.gz 10 11 12 my_mask
#
# Michael Hart, University of Cambridge, 22/12/2014.

echo " "
echo "Input image: ${1}" # runs in input directory normally
echo "ROI co-ordinates: ${2} ${3} ${4}" # co-ordinates are in voxels (non-negative) and not MNI (or Talairach)
echo "ROI size: 10mm" # not an optional argument
echo "mask name is: ${5}"
echo " "
fslmaths ${1} -mul 0 -add 1 -roi $2 1 $3 1 $4 1 0 1 pre_mask # multiply to empty and add 1 to binarise in template space
fslmaths pre_mask -kernel sphere 10 -fmean $6 -odt float
rm pre_mask.nii.gz
echo "Done! The output file is ${5}"
fslview ${1} ${6}.nii.gz -l "Red-Yellow"
