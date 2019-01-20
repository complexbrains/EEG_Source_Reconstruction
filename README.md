# EEG_Source_Reconstruction


Source reconstruction in EEG requires some certain steps to be completed, before the estimation of the sources. If you have your structural data of each of your subjects, or if you will use template anatomical data, then the first thing you need to do is to extract the cortical segmentation from a T1 MRI.

I used BrainSuit and Freesurfer. BrainSuite is easy to implement and run, however, the number of scouts you obtain is limited to 66 unless you would like to define your own scouts. You can also define your customized scouts in BrainSuite, however, it requires careful handling, [here](http://brainsuite.org/video-tutorials/custom-atlas/) is the tutorial of it. 

Freesurfer gives you more flexibility for the choices of surface-based atlases, ranging from Brodmann, Destrieux, Desikan-Killiany,  Mindboggle. If you want to use Freesurfer, the commands you simply start Freesurfer to run in your system terminal (after you install Freesurfer) to get the surface extraction going are listed below. You can either use dicom or nifti files at the start, however, you will need to convert them to .mgz format for Freesurfer to work on them.

- First, check whether you have Freesurfer installed on your system via typing the first command to your terminal and if so use the second command to load Freesurfer.

      module avail
      module load Freesurfer

- If your shell environment is C shell (csh) or enhanced C shell (tcsh) then you should start defining the folder where the Freesurfer and your structural data file sits. If you use setenv (setting environmental variables) command, you will not need to source and set the variables each time you open the terminal. You can also do that editing the binary files for each different shell types manually. SUBJECTS_DIR folder is where you subject files are stored. You can either keep all the subject files in one folder or in separate folders.

      setenv FREESURFER_HOME /.../local/freesurfer
      setenv SUBJECTS_DIR /.../data/freesurfer/subject1/structural
      source /.../local/freesurfer/FreeSurferEnv.csh


- If your shell is Bourn shell (bash) then use the following commands to set your Freesurfer and data files

      export FREESURFER_HOME=/.../local/freesurfer
      export SUBJECTS_DIR=/.../data/freesurfer/subject1/structural
      source $FREESURFER_HOME/FreeSurferEnv.sh

- Now it is time to convert your **dicom** structural file to **.mgz** format. For that you will give the only the first structural image on the ordered list then the command will pick all the rest of the structural dicom files to process. Subject Id is arbitrary, but it should be meaningful since the below command will create a folder named with that Id and put all the converted output files into that folder. The first line for running a single subjects data, the second line is to run multiple subjects reconstruction in the specified order.

      recon-all -i /data/freesurfer/subject1/structural/subject1_structural_1.dcm -autorecon1 -subjid <subjectID>
      recon-all -i /data/freesurfer/subject1/structural/subject1_structural_1.dcm -i /data/freesurfer/subject2/structural/subject2_structural_1.dcm-autorecon1 -subjid < the name of the output folder>


- If your data is in **nifti** format, then you can convert your nifti files to .mgz format via **mri_convert** command. 

      mri_convert --in_type nii --out_type mgz --input_volume /data/freesurfer/subject1/structural/subject1_structural_1.nii --      output_volume $SUBJECTS_DIR/01.mgz

-If you want to visualize the resulting .mgz file use the below command please. 

      tkmedit <subjectID> <subject1.mgz>

- And now you are good to run the construction. The parcellation process contains many steps, but don't worry, we already have **recon-all** batched script to help us to run all those steps smoothly and even realizing it. You can find more about those steps from [this very page](http://surfer.nmr.mgh.harvard.edu/fswiki/ReconAllDevTable). The only thing you need to do is to feed the parameters and run it. However, you can still modify the code to remove the steps you think they are unnecessary for your own purpose. Depending on the processing steps, the whole pipeline will take some time depending on the processor of your pc of course, but estimated time might be a day per person on average.

      recon-all -all -subjid <subject_id>
      
 - If you want to convert the resulting .mgz files to nifti format for further use, then please use the below command. Here the parameter **--out_orientation RAS** is to flip your structural files to match with your functionals. In source reconstruction step this might not carry importance but if you will use this segmentation later in your fMRI analysis it is better to use this parameter while you convert between files. 
 
       mri_convert --out_orientation RAS  -rt nearest --reslice_like <reference.nii or reference.nii.gz> <subject1_output.mgz> <subject1_output.nii>



- So voila, you got the segmentation done and dusted for you! The list and the content of the output files could be found [here](https://surfer.nmr.mgh.harvard.edu/fswiki/ReconAllOutputFiles). Mainly the ones you might be interested in could be listed as 

      - /mri/aseg.mgz: subcortical segmentation volume
      - /mri/wm.mgz: white matter mask
      - /mri/brainmask.mgz: skull-stripped volume
      - /surf/?h.white: white surface between white matter and gray matter (where ?h stands for lh or rh)
      - /surf/?h.pial: pial surface between gray matter and CSF (where * stands for sub-<participant_label>_ses-<session_label>) 

[source](http://www.clinica.run/doc/Pipelines/T1_FreeSurfer/)

Brainstorm will pick the whole output folder when you define the anatomy for your subject. More updates on this topic will come soon... 



