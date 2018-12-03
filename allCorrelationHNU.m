clear all
%Correlation map template
networks = {'DMN', 'VIS', 'SAL', 'CER', 'LIM', 'FPN', 'MOT'};
rmapPath = '/mnt/data_sq/cisl/ycollinv/HpProject/connectivityMaps/HNURmaps/';

%%Subjects arrays, sessions array
subjects = {'0025427', '0025428', '0025429', '0025430', '0025431', '0025433', '0025434', '0025435', '0025436', '0025437', ...
	'0025438', '0025440', '0025441', '0025442', '0025444', '0025445', '0025446', '0025447', '0025448', '0025450', ...
	'0025451', '0025452', '0025453', '0025454', '0025455', '0025456'};
	

sessions = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10'};
mask = 'cdip_human_phantom/ssimonMasks/ssimonAllScansMaskGroup.nii.gz';

for i = 1:length(networks)
  ii = 0;
  network = networks{i};
  for s = 1:length(subjects)
    subject = subjects{s};
    for sess = 1:length(sessions)
      session = sessions{sess};
	    listeRmap{++ii} = [rmapPath 'rmap_s' (subject) '-' (session) '_' (network) '.nii.gz'];
    end
  end
                  

	%Read mnc files    
	for ii = 1:length(listeRmap)
	  %file_name = list_rmap{ii};
	  [hdr,vol{ii}] = niak_read_vol(listeRmap{ii});
	end 

	%Read binary mask
	[hdr,vol_mask] = niak_read_vol(mask);


	%Extract t series
	for ii = 1:length(listeRmap)
	  sites{ii} = niak_vol2tseries(vol{ii}, vol_mask);
	end

	%Correlation matrix generation
	matrix = []; 
	for ii = 1:length(listeRmap)
		for uu = 1:length(listeRmap)
			  matrix(uu,ii) = corr(sites{uu},sites{ii});
		end
	end
  fileName = sprintf('HNU-%s-06182018.csv', network);
  csvwrite(fileName, matrix);
end  

