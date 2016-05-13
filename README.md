# resting_FMRI_analysis

How to get started with resting state functional MRI analysis on patients with brain tumours

Designed to be the ideal place to start i.e. straightforward to use, takes advantage of open source software, minimal computational requirements i.e. one can run this quickly with FSL & AFNI on a laptop.

If you wish to expand on this try ANTS for the newest code (in ants_tumour_analysis repository)

Does:

Brain extraction:                                                 brain_extraction.sh
Registration (structural, functional, tumour mask) to MNI space:  registration.sh
Makes a seed (for seed connectivity analysis):                    make_seed.sh
Makes a quick tumour mask:                                        tumour_mask.sh

NB: the aim of this is to allow automatic running of small batches, therefore all code runs as scripts which means you have to check files have the correct names
