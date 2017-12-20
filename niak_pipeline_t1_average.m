function [pipeline,opt] = niak_pipeline_t1_average(in,opt)
% Average multiple T1 of one subject iteratively with linear registration. 
%
% SYNTAX: [PIPE,OPT] = NIAK_PIPELINE_T1_AVERAGE(IN,OPT)
%
% IN (cell of strings) each entry is a t1 scan in native space. All images need
%    to come from the same subject.
%
% OPT (structure) with the following fields:
%   FOLDER_OUT (string) the path where to store the results.
%   NB_ITER (integer, default 2) the number of iterations on the registration. 
%   PSOM (structure) options for PSOM. See PSOM_RUN_PIPELINE.
%   FLAG_VERBOSE (boolean, default true) if true, verbose on progress.
%   FLAG_TEST (boolean, default false) if the flag is true, the pipeline will
%     be generated but no processing will occur.
%
%   This pipeline needs the PSOM library to run.
%   http://psom.simexp-lab.org/
%
% Copyright (c) Pierre Bellec
% Centre de recherche de l'Institut universitaire de griatrie de Montral, 2017.
% Maintainer : pierre.bellec@criugm.qc.ca
% See licensing information in the code.
% Keywords : registration, MRI

% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.

%% Defaults

% Inputs
if ~iscellstr(in)
    error('IN needs to be a cell of string')
end

%% Options
if nargin < 2
    opt = struct;
end
opt = psom_struct_defaults ( opt , ...
    { 'folder_out' , 'nb_iter' , 'flag_test' , 'psom'   , 'flag_verbose' }, ...
    { NaN          , 2         , false       , struct() , true           });

opt.folder_out = niak_full_path(opt.folder_out);
opt.psom.path_logs = [opt.folder_out 'logs' filesep];

%% Turn the first image into a rough template
pipeline = struct;
[path_f,name_f,ext_f] = niak_fileparts(in{1});
folder_iter = [opt.folder_out 'iteration1' filesep];

%% Start by linear registration of the 1st image in MNI stereo space
clear jin jout jopt
jin.anat = in{1};
jin.template = 'mni_icbm152_nlin_asym_09a';
jout = struct;
jopt.flag_all = true;
jopt.folder_out =  [folder_iter 'template' filesep];
pipeline = psom_add_job(pipeline,'it1_template','niak_brick_t1_preprocess',jin,jout,jopt);
template = pipeline.it1_template.files_out.anat_nuc;

%% Bring back the mask into native space
clear jin jout jopt 
template_mask = [folder_iter 'template' filesep 'mask_native' ext_f];
jin.source = pipeline.it1_template.files_out.mask_stereolin;
jin.target = template;
jin.transformation = pipeline.it1_template.files_out.transformation_lin;
jout = template_mask;
jopt.interpolation = 'nearest_neighbour';
jopt.flag_invert_transf = true;
pipeline = psom_add_job(pipeline,'it1_template_mask','niak_brick_resample_vol',jin,jout,jopt);

for tt = 1:opt.nb_iter 
    folder_iter = sprintf('%siteration%i%s',opt.folder_out,tt,filesep);
    %% Register linearly each image to the template
    for ii = 1:length(in)
        clear jin jout jopt
        jin.t1 = in{ii};
        jin.template = template;
        jin.template_mask = template_mask;
        jout.transformation = [folder_iter sprintf('vol%i_nativet12stereolin.xfm',ii)];
        jout.t1_stereolin = [folder_iter sprintf('vol%i_nativet1%s',ii,ext_f)];
        jopt.arg = '-lsq9';
        pipeline = psom_add_job(pipeline,sprintf('it%i_register_vol%i',tt,ii),'niak_brick_anat2stereolin',jin,jout,jopt);
    end 
    
    %% Compute average
    clear jin jout jopt
    for ii = 1:length(in)     
        jin{ii} = pipeline.(sprintf('it%i_register_vol%i',tt,ii)).files_out.t1_stereolin;
    end
    jout = [folder_iter 'average_t1' ext_f];
    jopt.operation = ['vol = zeros(size(vol_in{1})); ' ...
                        'for ii = 1:length(vol_in); ' ...
                        '    vol = vol + vol_in{ii}; ' ...
                        'end; ' ...
                        'vol = vol / length(vol_in); ' ...
                        'hdr_func.file_name = files_out; ' ...
                        'niak_write_vol(hdr_func,vol);'];
    pipeline = psom_add_job(pipeline,sprintf('it%i_average',tt),'niak_brick_math_vol',jin,jout,jopt);  
   
    %% Update template
    template = pipeline.(sprintf('it%i_average',tt)).files_out;
end

%% 
if ~opt.flag_test
    psom_run_pipeline(pipeline,opt.psom);
end
