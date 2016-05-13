#!/bin/sh

#   tumour_mask.sh
#  
#   usage: tumour_mask.sh mprage.nii.gz xstart xstop ystart ystop zstart zstop
#
# Michael Hart, University of Cambridge, 05/12/2014.

echo ' '
echo "Input image: ${1}"
echo "ROI coordinates: x ${2} ${3} y ${4} ${5} z ${6} ${7}"
fslmaths ${1} -roi $2 $3 $4 $5 $6 $7 0 1 tumour_mask.nii.gz
fslmaths tumour_mask.nii.gz -binv tumour_mask.nii.gz -odt float
fslview mprage.nii.gz tumour_mask.nii.gz -l “Red-Yellow” -t 0.6 &
