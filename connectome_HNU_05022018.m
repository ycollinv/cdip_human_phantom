clear all

%%Set fmri path
fmriPath = ['/project/6003287/DATA/HNU1/preproc_niak_20180502/fmri'];

%% Set the template
files_in.network = '/project/6003287/PROJECT/cdipFmri/cambridge/atlas/template_cambridge_basc_multiscale_sym_scale007.mnc';

%%Set the seeds
files_in.seeds = '/project/6003287/PROJECT/cdipFmri/cambridge/seeds/ccna_seeds_cambridge7.csv';

%%Subjects arrays, sessions array
subjects = {'0025427', '0025428', '0025429', '0025430', '0025431', '0025433', '0025434', '0025435', '0025436', '0025437', ...
	'0025438', '0025440', '0025441', '0025442', '0025444', '0025445', '0025446', '0025447', '0025448', '0025450', ...
	'0025451', '0025452', '0025453', '0025454', '0025455', '0025456'};
  
 sessions = {'session1', 'session2', 'session3', 'session4', 'session5', 'session6', 'session7', 'session8', 'session9', 'session10'};

%%Set the files
for ii = 1:length(subjects)
  subject = subjects{ii};
  files_in.fmri.(['s' subject '-1']).session1.rest1 = [fmriPath filesep 'fmri_' subject '_' (sessions{1}) '_rest.nii.gz'];
  files_in.fmri.(['s' subject '-2']).session1.rest1 = [fmriPath filesep 'fmri_' subject '_' (sessions{2}) '_rest.nii.gz'];
  files_in.fmri.(['s' subject '-3']).session1.rest1 = [fmriPath filesep 'fmri_' subject '_' (sessions{3}) '_rest.nii.gz'];
  files_in.fmri.(['s' subject '-4']).session1.rest1 = [fmriPath filesep 'fmri_' subject '_' (sessions{4}) '_rest.nii.gz'];
  files_in.fmri.(['s' subject '-5']).session1.rest1 = [fmriPath filesep 'fmri_' subject '_' (sessions{5}) '_rest.nii.gz'];
  files_in.fmri.(['s' subject '-6']).session1.rest1 = [fmriPath filesep 'fmri_' subject '_' (sessions{6}) '_rest.nii.gz'];
  files_in.fmri.(['s' subject '-7']).session1.rest1 = [fmriPath filesep 'fmri_' subject '_' (sessions{7}) '_rest.nii.gz'];
  files_in.fmri.(['s' subject '-8']).session1.rest1 = [fmriPath filesep 'fmri_' subject '_' (sessions{8}) '_rest.nii.gz'];
  files_in.fmri.(['s' subject '-9']).session1.rest1 = [fmriPath filesep 'fmri_' subject '_' (sessions{9}) '_rest.nii.gz'];
  files_in.fmri.(['s' subject '-10']).session1.rest1 = [fmriPath filesep 'fmri_' subject '_' (sessions{10}) '_rest.nii.gz'];
end

%% Options
opt.folder_out = '/project/6003287/PROJECT/cdipFmri/connectomeHNU_FINAL2-05032018'; % Where to store the results
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
