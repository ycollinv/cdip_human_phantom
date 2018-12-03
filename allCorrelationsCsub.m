clear all
%Correlation map template
file_id = fopen(['AllCorrelationList-06182018.txt'], 'w');
networks = {'DMN', 'VIS', 'SAL', 'CER', 'LIM', 'FPN', 'MOT'};
rmapPath = 'cdip_human_phantom/connectivityMaps';

sessions = {'CHUM1', 'CHUM2', 'CHUS1', 'CHUS2', 'CHUS3', 'CINQ1', 'CINQ2', 'CINQ3', 'UBC1', 'ISMD1', 'ISMD2', 'ISMD3', ...
	'IUGM1', 'IUGM2', 'IUGM3', 'MNI1', 'MNI2', 'MNI3', 'MNI4', 'EDM1', 'RRI1', 'SASK1', 'SUN1', 'TWH1', 'VIC1'};


for i = 1:1
  network = networks{i};
  list_rmap = {[rmapPath filesep 'connectomeTestRetest-12202017/rmap_seeds/rmap_CHUM1_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestRetest-12202017/rmap_seeds/rmap_CHUM2_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestRetest-12202017/rmap_seeds/rmap_CHUS1_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestRetest-12202017/rmap_seeds/rmap_CHUS2_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestRetest-12202017/rmap_seeds/rmap_CHUS3_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestRetest-12202017/rmap_seeds/rmap_CINQ1_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestRetest-12202017/rmap_seeds/rmap_CINQ2_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestRetest-12202017/rmap_seeds/rmap_CINQ3_' (network) '.mnc'],
			         [rmapPath filesep 'connectomeTestOnly-12202017/rmap_seeds/rmap_UBC1_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestRetest-12202017/rmap_seeds/rmap_ISMD1_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestRetest-12202017/rmap_seeds/rmap_ISMD2_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestRetest-12202017/rmap_seeds/rmap_ISMD3_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestRetest-12202017/rmap_seeds/rmap_IUGM1_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestRetest-12202017/rmap_seeds/rmap_IUGM2_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestRetest-12202017/rmap_seeds/rmap_IUGM3_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestRetest-12202017/rmap_seeds/rmap_MNI1_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestRetest-12202017/rmap_seeds/rmap_MNI2_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestRetest-12202017/rmap_seeds/rmap_MNI25_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestRetest-12202017/rmap_seeds/rmap_MNI3_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestOnly-12202017/rmap_seeds/rmap_EDM1_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestOnly-12202017/rmap_seeds/rmap_RRI1_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestOnly-12202017/rmap_seeds/rmap_SASK1_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestOnly-12202017/rmap_seeds/rmap_SUN1_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestOnly-12202017/rmap_seeds/rmap_TWH1_' (network) '.mnc'],
               [rmapPath filesep 'connectomeTestOnly-12202017/rmap_seeds/rmap_VIC1_' (network) '.mnc']};
             
                            
  mask = 'cdip_human_phantom/ssimonMasks/ssimonAllScansMaskGroup.nii.gz';

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



	for s1 = 1:(length(sessions)-1)
			session1 = sessions{s1};
		for s2 = 2:(length(sessions))
			session2 = sessions{s2};
			if s2 > s1
				formatSpec = '%s	%s vs %s : %4.2f \n';
				fprintf(file_id, formatSpec, network, session1, session2, matrix(s1,s2));
			end
		end
	end
end
fclose(file_id);
