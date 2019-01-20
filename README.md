# EEG_Source_Reconstruction


Source reconstruction in EEG requires some certain steps to be completed, before the estimation of the sources. If you have your structural data of each of your subjects, or if you will use template anatomical data, then the first thing you need to do is to extract the cortical segmentation from a T1 MRI

I used BrainSuit and Freesurfer. BrainSuite is easy to implement and run, however the number of scout you obtain is limited to 66 unless you would like to define your own scouts. You can also define your customized scouts in BrainSuite, however it requires a careful handling, [here](http://brainsuite.org/video-tutorials/custom-atlas/) is the tutorial of it. 

Freesurfer gives you more flexibilty for the choices of surface-based atlases, ranging from Brodmann, Destrieux, Desikan-Killiany,  Mindboggle. If you want to use Freesurfer, the commands you simply start Freesurfer to run in your system terminal (after you install Freesurfer) to get the surface extraction going are listed below. You can either use dicom or nifti files at the start, however you will need to convert them to .mgz format for Freesurfer to work on them.

- First check whether you have Freesurfer installed on your system with the first command and if so use the second command to load Freesurfer

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

- Now it is time to convert your dicom structural file to .mgz format. For that you will give the only the first structural image on the ordered list then the command will pick all the rest of the structural dicom files to process. Subject Id is arbitrary, but it should be meaningful since the below command will create a folder named with that Id and put all the converted output files into that folder. First line for running a single subjects data, the second line is to run multuple subjects reconstruction in specified order. 

      recon-all -i /data/freesurfer/subject1/structural/subject1_structural_1.dcm -autorecon1 -subjid 1
      recon-all -i /data/freesurfer/subject1/structural/subject1_structural_1.dcm -i /data/freesurfer/subject2/structural/subject2_structural_1.dcm-autorecon1 -subjid < the name of the output folder>


- If your data is in nifti format, then you can convert your nifti files to .mgz format via mri_convert command.

      mri_convert --in_type nii --out_type mgz --input_volume /data/freesurfer/subject1/structural/subject1_structural_1.nii --      output_volume $SUBJECTS_DIR/01.mgz

- And now you are good to go to run the construction. It will take some time depending on the processor of your pc of course, but estimated time might be a day per person in average.

      recon-all -all -subjid <subject_id>

So you are good! Then Brainstorm will pick the whole output folder when you define the anatomy for your subject. More updates on this topic will come soon... 



