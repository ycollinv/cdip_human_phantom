clear all
%Correlation map template


list_rmap = {'cdip_human_phantom/connectomeTestOnly-12202017/rmap_seeds/rmap_CHUM2_VIS.mnc',   
             'cdip_human_phantom/connectomeTestOnly-12202017/rmap_seeds/rmap_CHUS3_VIS.mnc',
             'cdip_human_phantom/connectomeTestOnly-12202017/rmap_seeds/rmap_CINQ3_VIS.mnc',
             'cdip_human_phantom/connectomeTestOnly-12202017/rmap_seeds/rmap_UBC1_VIS.mnc',            
             'cdip_human_phantom/connectomeTestOnly-12202017/rmap_seeds/rmap_IUGM3_VIS.mnc',
             'cdip_human_phantom/connectomeTestOnly-12202017/rmap_seeds/rmap_ISMD3_VIS.mnc',
             'cdip_human_phantom/connectomeTestOnly-12202017/rmap_seeds/rmap_MNI3_VIS.mnc',
             'cdip_human_phantom/connectomeTestOnly-12202017/rmap_seeds/rmap_EDM1_VIS.mnc',
             'cdip_human_phantom/connectomeTestOnly-12202017/rmap_seeds/rmap_RRI1_VIS.mnc',
             'cdip_human_phantom/connectomeTestOnly-12202017/rmap_seeds/rmap_SASK1_VIS.mnc',
             'cdip_human_phantom/connectomeTestOnly-12202017/rmap_seeds/rmap_SUN1_VIS.mnc',
             'cdip_human_phantom/connectomeTestOnly-12202017/rmap_seeds/rmap_TWH1_VIS.mnc',
             'cdip_human_phantom/connectomeTestOnly-12202017/rmap_seeds/rmap_VIC1_VIS.mnc'};
             
mask = 'cdip_human_phantom/HpPreprocessFinal12202017/quality_control/group_coregistration/func_mask_group_stereonl.mnc';

      %Read mnc files    
      for ii = 1:length(list_rmap)
        %file_name = list_rmap{ii};
        [hdr,vol{ii}] = niak_read_vol(list_rmap{ii});
      end 

  %Read binary mask
  [hdr,vol_mask] = niak_read_vol(mask);


  %Extract t series
  for ii = 1:length(list_rmap)
    sites{ii} = niak_vol2tseries(vol{ii}, vol_mask);
  end

  %Correlation matrix generation
  matrix = []; 
  for ii = 1:length(list_rmap)
      for uu = 1:length(list_rmap)
            matrix(uu,ii) = corr(sites{uu},sites{ii});
      end
  end

  %Generate plot 
  opt.color_map = 'jet';
  niak_visu_matrix(matrix,opt)

  %%%Correlation means calculations

  final = [];
  for ii =1:length(list_rmap)
      vector_ii = matrix(ii,(ii+1):end);
      final = [final,vector_ii];
  end
  meanall = mean(final)
  stdall = std(final)

  final = [];
  for ii =1:4
      vector_ii = matrix(ii,(ii+1):end);
      final = [final,vector_ii];
  end
  meanphilips = mean(final)
  stdphilips = std(final)

  final = [];
  for ii =5:11
      vector_ii = matrix(ii,(ii+1):end);
      final = [final,vector_ii];
  end
  meansiemens = mean(final)
  stdsiemens = std(final)

  final = [];
  for ii =12:13
       vector_ii = matrix(ii,(ii+1):end);
       final = [final,vector_ii];
  end
  meanGE = mean(final)
  stdGE = std(final)
  
  final = [];
  for ii =1:4
      vector_ii = matrix(ii,5:11);
      final = [final,vector_ii];
  end
  meanPhilipsVSSiemens = mean(final)
  stdPhilipsVSSiemens = std(final)
  
  final = [];
  for ii =1:4
      vector_ii = matrix(ii,12:13);
      final = [final,vector_ii];
  end
  meanPhilipsVSGE = mean(final)
  stdPhilipsVSGE = std(final)
  
  final = [];
  for ii =5:11
      vector_ii = matrix(ii,12:13);
      final = [final,vector_ii];
  end
  meanGEVSSiemens = mean(final)
  stdGEVSSiemens = std(final)

