 
clear all

%% Data localisation
path_raw       = 'data/ccna/cdip_porban/ccna_20160201_mnc/';
path_preprocess     = 'data/porban_preprocess_1.0.0/';


%% Files_in
sites  = {'CHUS','CINQ','UNF','MNI'};

  %%averaged t1 file
  fmrirun = dir([path_raw filesep site filesep site '_1' filesep 'anat' filesep '*.mnc']);
  anat = [path_raw filesep site filesep site '_1' filesep 'anat' filesep fmrirun.name];
    
  %%fmri files
for s = 1:length(sites)
    site = sites{s};
    
    %session1
    fmrirun = dir([path_raw filesep site filesep site '_1' filesep 'rest' filesep '*.mnc']);
    fmri.session1.run1 = [path_raw filesep site filesep site '_1' filesep 'rest' filesep fmrirun.name];
    
    %session2
    fmrirun = dir([path_raw filesep site filesep site '_2' filesep 'rest' filesep '*.mnc']);
    fmri.session2.run1 = [path_raw filesep site filesep site '_2' filesep 'rest' filesep fmrirun.name];
    
    if s == 4 % MNI
        
    %session3
    fmrirun = dir([path_raw filesep site filesep site '_3' filesep 'rest4' filesep '*.mnc']);
    fmri.session3.run1 = [path_raw filesep site filesep site '_3' filesep 'rest4' filesep fmrirun.name]; 
    
    fmrirun = dir([path_raw filesep site filesep site '_3' filesep 'rest45' filesep '*.mnc']);
    fmri.session3.run2 = [path_raw filesep site filesep site '_3' filesep 'rest45' filesep fmrirun.name]; 
    
    fmrirun = dir([path_raw filesep site filesep site '_3' filesep 'rest5' filesep '*.mnc']);
    fmri.session3.run3 = [path_raw filesep site filesep site '_3' filesep 'rest5' filesep fmrirun.name]; 
    end
    
    files_in.(site).anat = anat;
    files_in.(site).fmri = fmri;
end
        
    
%% Building the optional inputs
opt.folder_out = path_preprocess; 
opt.size_output = 'quality_control';


%%%%%%%%%%%%%%%%%%%%
%% Bricks options %%
%%%%%%%%%%%%%%%%%%%%

%% Slice timing
opt.slice_timing.type_acquisition = 'sequential ascending'; % Slice timing order (available options : 'manual', 'sequential ascending', 'sequential descending', 'interleaved ascending', 'interleaved descending')
    % Do I have to change the acquisition type depending on the scanner?
opt.slice_timing.type_scanner     = 'Siemens';               % Scanner manufacturer. Only the value 'Siemens' will actually have an impact, which has different conventions for interleaved acquisitions.
    % What is the impact? Do I have to exclude all the non-Siemens scanners from this option?
opt.slice_timing.delay_in_tr      = 0;                       % The delay in TR ("blank" time between two volumes)
opt.slice_timing.flag_skip = 1;

%% Center the functional volumes on the brain center-of-mass (true/false)
% opt.slice_timing.flag_center = false;

%% Motion correction (niak_brick_motion_correction)
% opt.motion_correction.suppress_vol = 0;             % Remove the first three dummy scans

    % SESSION_REF
    % (string, default first session) name of the session of reference. 
    % By default, it is the first field found in FILES_IN. Use the
    % session corresponding to the acqusition of the T1 scan.

%% Linear and non-linear fit of the anatomical image in the stereotaxic space (T1 Normalization)
opt.t1_preprocess.nu_correct.arg = '-distance 50'; % Parameter for non-uniformity correction. 200 is a suggested value for 1.5T images, 25 for 3T images. If you find that this stage did not work well, this parameter is usually critical to improve the results.
    % Tutorial suggests 200 for 1.5T images, 75 for 3T images.
    % help suggests 200 for 1.5T scan; 50 for 3T scan. 

%% T1-T2 coregistration (niak_brick_anat2func)
opt.anat2func.init = 'identity'; % An initial guess of the transform. Possible values 'identity', 'center'. 'identity' is self-explanatory. The 'center' option usually does more harm than good. Use it only if you have very big misrealignement between the two images (say, 2 cm).

%% Temporal filetring (niak_brick_time_filter)
opt.time_filter.hp = 0.01; % Apply a high-pass filter at cut-off frequency 0.01Hz (slow time drifts)
opt.time_filter.lp = Inf; % Do not apply low-pass filter. Low-pass filter induce a big loss in degrees of freedom without sgnificantly improving the SNR.
    % It still seems to be common practice to filter out frequency above 0.08 Hz is the resting-state community, but this is not the default parameter in NIAK.
    %% Remove slow time drifts (true/false)
    % opt.regress_confounds.flag_slow = true;
    %% Remove high frequencies (true/false)
    % opt.regress_confounds.flag_high = false;

%% Correction of physiological noise (niak_pipeline_corsica)
opt.corsica.sica.nb_comp = 60;
opt.corsica.component_supp.threshold = 0.15;
    % Why ON here? 

%% Resampling in the stereotaxic space (niak_brick_resample_vol)
%opt.resample_vol.interpolation       = 'tricubic'; % The resampling scheme. The most accurate is 'sinc' but it is awfully slow
opt.resample_vol.voxel_size          = [3 3 3];    % The voxel size to use in the stereotaxic space

%% Spatial smoothing (niak_brick_smooth_vol)
opt.bricks.smooth_vol.fwhm = 6; % Apply an isotropic 6 mm gaussin smoothing.

%% Region growing
opt.region_growing.flag_skip = 1; % Turn on/off the region growing
% opt.template_fmri = '/home/cdansereau/svn/niak/trunk/template/roi_aal.mnc.gz';

%% Scrubbing
% opt.regress_confounds.flag_scrubbing = false;  
% The threshold on frame displacement for scrubbing 
%opt.regress_confounds.thre_fd = 0.5;
    %Most neuroimaging software will not handle these changes properly. In particular, if NIAK is used to preprocess dataset before a GLM analysis in another software package such as FSL or fMRIstat, it is important to skip scrubbing.

%%%%%Options not in this script but present in the tutorial:
    %%% Motion parameters
    %% Apply regression of motion parameters (true/false) 
        % opt.regress_confounds.flag_motion_params = true; DEFAULT FALSE
        %% Reduce the dimensionality of motion parameters with PCA (true/false)
        % opt.regress_confounds.flag_pca_motion = true; DEFAULT TRUE
        %% How much variance of motion parameters (with squares) to retain
        % opt.regress_confounds.pct_var_explained = 0.95; DEFAULT 0.95

    %%% White matter & ventricular signals
        %% Apply average white matter signal regression (true/false)         
        %opt.regress_confounds.flag_wm = true; DEFAULT TRUE
        %% Apply average ventricle signal regression (true/false)         
        %opt.regress_confounds.flag_vent = true; DEFAULT TRUE
        %% Apply anat COMPCOR (white matter+ventricles, true/false) (We recommend not using FLAG_WM and FLAG_VENT together with FLAG_COMPCOR)
        % opt.regress_confounds.flag_compcor = false; DEFAULT FALSE

    %%% Global signal
        %% Apply global signal regression (true/false)         
        % opt.regress_confounds.flag_gsc = true; DEFAULT TRUE


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generation of the pipeline %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

opt.flag_test = 0;
% opt.psom.max_queued = 10; 
% opt.granularity = 'subject';
    % 'max' : break down all operations as separate jobs, if possible
    % 'cleanup' : group together clean-up jobs for each subject
    % 'subject' : bundle all jobs associated with a specific subject  

[pipeline,opt] = niak_pipeline_fmri_preprocess(files_in,opt);

    % The steps of the pipeline for each individual subjects are the following:
    %       1.  Slice timing correction
    %           See NIAK_BRICK_SLICE_TIMING and OPT.SLICE_TIMING
    %       2.  Motion estimation (within- and between-run for each label).
    %           See NIAK_PIPELINE_MOTION and OPT.MOTION
    %       3.  Quality control for motion correction.
    %           See NIAK_BRICK_QC_MOTION_CORRECTION and
    %           OPT.QC_MOTION_CORRECTION
    %       4.  Linear and non-linear spatial normalization of the anatomical 
    %           image (and many more anatomical stuff such as brain masking and
    %           CSF/GM/WM classification)
    %           See NIAK_BRICK_T1_PREPROCESS and OPT.T1_PREPROCESS
    %           See NIAK_BRICK_PVE and OPT.PVE
    %       5.  Coregistration of the anatomical volume with the target volume of 
    %           the motion estimation
    %           See NIAK_BRICK_ANAT2FUNC and OPT.ANAT2FUNC
    %       6.  Concatenation of the T2-to-T1 and T1-to-stereotaxic-nl
    %           transformations.
    %           See NIAK_BRICK_CONCAT_TRANSF, no option there.
    %       7.  Resampling of the functional data in the stereotaxic space.
    %           See NIAK_BRICK_RESAMPLE_VOL and OPT.RESAMPLE_VOL
    %       8.  Quality control for 7 (includes generation of average image and mask,
    %           as well as metrics of coregistration between runs for motion).
    %           See NIAK_BRICK_QC_COREGISTER
    %       9.  Estimation of a temporal model of slow time drifts.
    %           See NIAK_BRICK_TIME_FILTER
    %      10.  Generation of confounds (slow time drifts, motion parameters, 
    %           WM average, COMPCOR, global signal) preceeded by scrubbing of time frames 
    %           with an excessive motion.
    %           See NIAK_BRICK_BUILD_CONFOUNDS and OPT.BUILD_CONFOUNDS. 
    %      11.  Regression of confounds (slow time drifts, motion parameters, 
    %           WM average, COMPCOR, global signal) preceeded by scrubbing of time frames 
    %           with an excessive motion.
    %           See NIAK_BRICK_REGRESS_CONFOUNDS and OPT.REGRESS_CONFOUNDS
    %      12.  Spatial smoothing.
    %           See NIAK_BRICK_SMOOTH_VOL and OPT.SMOOTH_VOL
    %
    % In addition the following jobs are performed at the group level:
    %       1.  Group quality control for motion correction.
    %           See NIAK_BRICK_QC_MOTION_CORRECTION_GROUP and 
    %           OPT.QC_MOTION_CORRECTION_GROUP
    %       2.  Group quality control for coregistration of T1 images in
    %           stereotaxic space
    %           See NIAK_BRICK_QC_COREGISTER
    %       3.  Group quality control for coregistration of fMRI in stereotaxic
    %           space.