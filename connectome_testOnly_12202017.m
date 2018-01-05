clear all

%% Set the template
files_in.network = 'cdip_human_phantom/cambridge/atlas/template_cambridge_basc_multiscale_sym_scale007.mnc';

%%Set the seeds
files_in.seeds = 'cdip_human_phantom/cambridge/seeds/ccna_seeds_cambridge7.csv';

%%Set files_in
%files_in.fmri.CHUM1.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_CHUMsess1_rest1.mnc';
files_in.fmri.CHUM2.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_CHUMsess2_rest1.mnc';
%files_in.fmri.CHUS1.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_CHUSsess1_rest1.mnc';
%files_in.fmri.CHUS2.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_CHUSsess2_rest1.mnc';
files_in.fmri.CHUS3.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_CHUSsess3_rest1.mnc';
%files_in.fmri.CINQ1.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_CINQsess1_rest1.mnc';
%files_in.fmri.CINQ2.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_CINQsess2_rest1.mnc';
files_in.fmri.CINQ3.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_CINQsess3_rest1.mnc';
%files_in.fmri.ISMD1.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_ISMDsess1_rest1.mnc';
%files_in.fmri.ISMD2.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_ISMDsess2_rest1.mnc';
files_in.fmri.ISMD3.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_ISMDsess3_rest1.mnc';
%files_in.fmri.IUGM1.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_IUGMsess1_rest1.mnc';
%files_in.fmri.IUGM2.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_IUGMsess2_rest1.mnc';
files_in.fmri.IUGM3.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_IUGMsess3_rest1.mnc';
%files_in.fmri.MNI1.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_MNIsess1_rest1.mnc';
%files_in.fmri.MNI2.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_MNIsess2_rest1.mnc';
%files_in.fmri.MNI25.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_MNIsess2_rest2.mnc';
files_in.fmri.MNI3.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_MNIsess3_rest1.mnc';
files_in.fmri.EDM1.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_EDMsess1_rest1.mnc'; 
files_in.fmri.RRI1.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_RRIsess1_rest1.mnc';
files_in.fmri.SASK1.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_SASKsess1_rest1.mnc';
files_in.fmri.SUN1.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_SUNsess1_rest1.mnc';
files_in.fmri.TWH1.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_TWHsess1_rest1.mnc';
files_in.fmri.UBC1.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_UBCsess1_rest1.mnc';
files_in.fmri.VIC1.session1.run1 = 'cdip_human_phantom/HpPreprocessFinal12202017/fmri/fmri_ssimon_VICsess1_rest1.mnc';

%% Options
opt.folder_out = 'cdip_human_phantom/connectomeTestOnly-12202017'; % Where to store the results
opt.connectome.type = 'R'; % The type of connectome. See "help niak_brick_connectome" for more info.
% 'S': covariance;
%'R': correlation;
%'Z': Fisher transform of the correlation;
%'U': concentration;
%'P': partial correlation.
opt.connectome.thresh.type = 'sparsity_pos'; % The type of treshold used to binarize the connectome. See "help niak_brick_connectome" for more info.
% 'sparsity': keep a proportion of the largest connection (in absolute value);
% 'sparsity_pos' keep a proportion of the largest connection (positive only)
% 'cut_off' a cut-off on connectivity (in absolute value)
% 'cut_off_pos' a cut-off on connectivity (only positive)
opt.connectome.thresh.param = 0.2; % the parameter of the thresholding. The actual definition depends of THRESH.TYPE:
% 'sparsity' (scalar, default 0.2) percentage of connections
% 'sparsity_pos' (scalar, default 0.2) percentage of connections
% 'cut_off' (scalar, default 0.25) the cut-off
% 'cut_off_pos' (scalar, default 0.25) the cut-off
opt.report_rmap.avg.limits = [0 0.70]; %min max for avg maps
opt.report_rmap.ind.limits = [0 0.70]; %min max for ind maps
opt.report_rmap.avg.thresh = [0.40]; %everything under that value becomes transparent in avg maps
opt.report_rmap.ind.thresh = [0.40]; %everything under that value becomes transparent in ind maps

%%%%%%%%%%%%
%% Run the pipeline
%%%%%%%%%%%%
opt.flag_test = false; % Put this flag to true to just generate the pipeline without running it. Otherwise the region growing will start.
%opt.psom.max_queued = 10; % Uncomment and change this parameter to set the number of parallel threads used to run the pipeline
[pipeline,opt] = niak_pipeline_connectome(files_in,opt);
