function nii_mat2nii (matnames)
%Convert NiiStat Mat files to NIfTI images for viewing
% matname = (optional) filename to convert
%
%Example
% nii_mat2nii; %use GUI
% nii_mat2nii('vx.mat');
% nii_mat2nii(strvcat('LM1001.mat','P051.mat'))

if ~exist('matnames','var') %no files specified
   [A,Apth] = uigetfile({'*.mat;';'*.*'},'Select first image','MultiSelect', 'on'); 
   matnames = strcat(Apth,char(A));
end;
if length(matnames) < 1, return; end;
for f = 1 : size(matnames,1)
    matname = deblank(matnames(f,:));
    if ~exist(matname, 'file'), error('Unable to find %s', matname); end;
    [kModalities, ~] = nii_modality_list();
    mat = load(matname);
    for m = 1 : size(kModalities,1)
        modality = deblank(kModalities(m,:));
        if isfield(mat, modality) && isfield(mat.(modality),'hdr')
            hdr = mat.(modality).hdr;
            img = mat.(modality).dat;
            [pth,nam] = fileparts(matname);
            %hdr.fname = [nam '_' modality '.nii']; %save to CWD
            hdr.fname = fullfile(pth, [nam '_' modality '.nii']);
            spm_write_vol(hdr,img);
        end;
    end
end
