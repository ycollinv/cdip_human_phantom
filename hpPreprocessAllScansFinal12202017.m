clear all

%% Data localisation
%path_home        = getenv('HOME');
path_raw         = ['cdip_human_phantom/HP_raw'];
path_anat        = ['cdip_human_phantom/HpFinalt1AverageFINAL12192017'];
path_preprocess  = ['cdip_human_phantom/HpPreprocessFinal12202017';];

%% Files_in
subjects = { 'ssimon' };
sites = {'CHUM', 'CHUS' , 'CINQ' , 'IUGM' , 'ISMD' , 'MNI', 'EDM', 'RRI', 'SASK', 'SUN', 'TWH', 'UBC', 'VIC'};
nsess = [2     , 3      , 3      , 3      , 3      , 3    , 1    , 1    , 1     , 1    , 1    , 1    , 1    ];

%Session1
for nums = 1:length(subjects)
    for numsite = 1:length(sites)
        site = sites{numsite};
        subject = subjects{nums};

        %Anat
        files_in.(subject).anat = [path_anat filesep 'iteration3' filesep 'average_t1.mnc'];

        for numsess = 1:nsess(numsite)
            % Session 1
            session = [site 'sess' num2str(numsess)];
            fmrirun = dir([path_raw filesep site filesep site '_' num2str(numsess) filesep 'rest_1' filesep '*.*']);
            files_in.(subject).fmri.(session).rest1 = [path_raw filesep site filesep site '_' num2str(numsess) filesep 'rest_1' filesep fmrirun.name];

            if strcmp(site,'MNI') && (numsess==2)
                fmrirun = dir([path_raw filesep site filesep site '_' num2str(numsess) filesep 'rest_2' filesep '*.mnc']);
                files_in.(subject).fmri.(session).rest2 = [path_raw filesep site filesep site '_' num2str(numsess) filesep 'rest_2' filesep fmrirun.name];
            end
        end
    end
end

%% Building the optional inputs
opt.folder_out = path_preprocess;
opt.size_output = 'quality_control';


%%%%%%%%%%%%%%%%%%%%
%% Bricks options %%
%%%%%%%%%%%%%%%%%%%%

%% Slice timing
opt.slice_timing.type_scanner = '';
opt.slice_timing.type_acquisition = 'sequential ascending'; % Slice timing order (available options : 'manual', 'sequential ascending', 'sequential descending', 'interleaved ascending', 'interleaved descending')
opt.slice_timing.flag_center = false;
opt.slice_timing.delay_in_tr      = 0;                       % The delay in TR ("blank" time between two volumes)
opt.slice_timing.flag_skip = 0;

opt.slice_timing.suppress_vol = 3; %Remove the first three dummy scans. 

%% Center the functional volumes on the brain center-of-mass (true/false)

%% Motion correction (niak_brick_motion_correction)
%opt.motion_correction.suppress_vol = 3;             % Remove the first three dummy scans. Brick obsolete, doing this process in opt.supress_vol from niak_brick_slice_timing

%% Linear and non-linear fit of the anatomical image in the stereotaxic space (T1 Normalization)
opt.t1_preprocess.nu_correct.arg = '-distance 50'; % Parameter for non-uniformity correction. 200 is a suggested value for 1.5T images, 25 for 3T images. If you find that this stage did not work well, this parameter is usually critical to improve the results.
    % Tutorial suggests 200 for 1.5T images, 75 for 3T images.
    % help suggests 200 for 1.5T scan; 50 for 3T scan.

%% T1-T2 coregistration (niak_brick_anat2func)
opt.anat2func.init = 'identity'; % An initial guess of the transform. Possible values 'identity', 'center'. 'identity' is self-explanatory. The 'center' option usually does more harm than good. Use it only if you have very big misrealignement between the two images (say, 2 cm).

%% Temporal filetring (niak_brick_time_filter)
opt.time_filter.hp = 0.01; % Apply a high-pass filter at cut-off frequency 0.01Hz (slow time drifts)
opt.time_filter.lp = Inf; % Do not apply low-pass filter. Low-pass filter induce a big loss in degrees of freedom without sgnificantly improving the SNR.

%% Spatial smoothing (niak_brick_smooth_vol)
opt.bricks.smooth_vol.fwhm = 6; % Apply an isotropic 6 mm gaussin smoothing.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generation of the pipeline %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

opt.flag_test = 1;
[pipeline,opt] = niak_pipeline_fmri_preprocess(files_in,opt);

pipeline.slice_timing_ssimon_ISMDsess1_rest1.opt.type_acquisition = 'sequential descending';
pipeline.slice_timing_ssimon_ISMDsess2_rest1.opt.type_acquisition = 'sequential descending';
pipeline.slice_timing_ssimon_ISMDsess3_rest1.opt.type_acquisition = 'sequential descending';
pipeline.slice_timing_ssimon_IUGMsess1_rest1.opt.type_acquisition = 'interleaved ascending';
pipeline.slice_timing_ssimon_IUGMsess2_rest1.opt.type_acquisition = 'interleaved ascending';
pipeline.slice_timing_ssimon_IUGMsess3_rest1.opt.type_acquisition = 'interleaved ascending';
pipeline.slice_timing_ssimon_MNIsess1_rest1.opt.type_acquisition  = 'interleaved ascending';
pipeline.slice_timing_ssimon_MNIsess2_rest1.opt.type_acquisition  = 'interleaved ascending';
pipeline.slice_timing_ssimon_MNIsess2_rest2.opt.type_acquisition  = 'interleaved ascending';
pipeline.slice_timing_ssimon_MNIsess3_rest1.opt.type_acquisition  = 'interleaved ascending';
pipeline.slice_timing_ssimon_EDMsess1_rest1.opt.type_acquisition  = 'interleaved ascending';
pipeline.slice_timing_ssimon_RRIsess1_rest1.opt.type_acquisition  = 'interleaved ascending';
pipeline.slice_timing_ssimon_SASKsess1_rest1.opt.type_acquisition  = 'sequential descending';
pipeline.slice_timing_ssimon_SUNsess1_rest1.opt.type_acquisition  = 'interleaved ascending';
pipeline.slice_timing_ssimon_TWHsess1_rest1.opt.type_acquisition  = 'interleaved ascending';
pipeline.slice_timing_ssimon_UBCsess1_rest1.opt.type_acquisition  =  'interleaved ascending';
pipeline.slice_timing_ssimon_VICsess1_rest1.opt.type_acquisition  =  'interleaved ascending';
psom_run_pipeline(pipeline,opt.psom);

