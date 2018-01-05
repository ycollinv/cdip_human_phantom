clear all

%%Data
%path_home    = getenv('HOME');
path_raw     = ['cdip_human_phantom/HP_raw'];
path_out     = ['cdip_human_phantom/HpFinalt1AverageFINAL12192017'];

%%T1 files 
sites  = {'CHUM', 'EDM', 'RRI', 'SASK', 'SUN', 'TWH', 'VIC', 'CHUS' , 'CINQ' , 'IUGM' , 'ISMD' , 'MNI'};

for s = 1:length(sites) 
    site = sites {s};
    
    %Sessions 1
    mrirun = dir([path_raw filesep site filesep site '_1' filesep 'anat' filesep '*.mnc']);
    in{s} = [path_raw filesep site filesep site '_1' filesep 'anat' filesep mrirun.name];
end


    %Sessions 2 CHUM
    mrirun = dir([path_raw filesep 'CHUM' filesep 'CHUM_2' filesep 'anat' filesep '*.mnc']);
    in{13} = [path_raw filesep 'CHUM' filesep 'CHUM_2' filesep 'anat' filesep mrirun.name];


for s = 8:length(sites)
    site = sites {s};
  
    %Sessions 2 Rest
    mrirun = dir([path_raw filesep site filesep site '_2' filesep 'anat' filesep '*.mnc']);
    in{s+6} = [path_raw filesep site filesep site '_2' filesep 'anat' filesep mrirun.name];
end

for s = 8:length(sites)
    site = sites {s};
    %Sessions 3
    mrirun = dir([path_raw filesep site filesep site '_3' filesep 'anat' filesep '*.mnc']);
    in{s+11} = [path_raw filesep site filesep site '_3' filesep 'anat' filesep mrirun.name];
end

%% Building the optional inputs
opt.folder_out = path_out; 

%%Iterations (Already 2 by default)
opt.nb_iter = 3; 

%%Running the pipeline
%opt.flag_test = 0;
pipe = niak_pipeline_t1_average(in,opt);


