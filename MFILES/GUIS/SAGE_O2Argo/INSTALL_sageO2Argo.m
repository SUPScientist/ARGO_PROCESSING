function INSTALL_sageO2Argo
% ************************************************************************
% INSTALL_sageO2Argo.m
% ************************************************************************
%
% Saves all relevant paths to your MATLAB directory, and stores your
% working directory path for sageO2 to reference.
%
%
% USE AS:  INSTALL_sageO2Argo
%          INSTALL_sageO2Argo
%
% INPUTS:  
%
% OUTPUTS:
%
%
% AUTHOR: Tanya Maurer
%         Monterey Bay Aquarium Research Institute
%         tmaurer@mbari.org
%
% DATE: 10/25/17
% UPDATES: 04/15/18: Added file grab for WOA and NCEP files (bring to
% local)
%          09/17/18: removed input to function.  DataDir defaults to
%          /ARGO_PROCESSING/DATA/ARGO_REPO/.  User can navigate to files if
%          held elsewhere.  This makes install easier (one less
%          definition).
% NOTES:   
% ************************************************************************
%
% ************************************************************************

fp = filesep; % File separator for current platform
workingDIR = pwd;
XX = strfind(workingDIR,'ARGO_PROCESSING');
if isempty(XX)
    disp('ERROR: ARGO_PROCESSING DIRECTORY NOT FOUND.  DID YOU MAINTAIN THE ARGO_PROCESSING TOP LEVEL DIRECTORY STRUCTURE?')
	disp('INSTALL INCOMPLETE!')
	return
else
    topdir = workingDIR(1:XX-1);
    disp('INSTALLING "ARGO_PROCESSING\MFILE" PATHS...')
    addpath([topdir,fp,'ARGO_PROCESSING',fp,'MFILES',fp,'FLOATS',fp]);
    addpath([topdir,fp,'ARGO_PROCESSING',fp,'MFILES',fp,'GLODAP',fp]);
    addpath([topdir,fp,'ARGO_PROCESSING',fp,'MFILES',fp,'GUIS',fp,'SAGE_O2Argo',fp]);
    addpath([topdir,fp,'ARGO_PROCESSING',fp,'MFILES',fp,'MISC',fp]);
    addpath([topdir,fp,'ARGO_PROCESSING',fp,'MFILES',fp,'WOA',fp]);
    addpath([topdir,fp,'ARGO_PROCESSING',fp,'MFILES',fp,]);

    disp('INSTALLING "ARGO_PROCESSING\DATA" PATHS...')
    addpath([topdir,fp,'ARGO_PROCESSING',fp,'DATA',fp,'SHIPBOARD',fp]);
    addpath([topdir,fp,'ARGO_PROCESSING',fp,'DATA',fp,'ARGO_REPO',fp]);
%     addpath('C:\temp\');
    savepath
end
save([topdir,fp,'ARGO_PROCESSING',fp,'MFILES',fp,'GUIS',fp,'SAGE_O2Argo',fp,'sageO2Argo_workingDIR.mat'],'topdir');

% CHECK FOR WOA DATA.  IF DOESN'T EXIST, DOWNLOAD IT.
disp('CHECKING FOR LOCAL WOA2018 FILES...')
WOAdir = [topdir,fp,'ARGO_PROCESSING',fp,'DATA',fp,'WOA2018',fp,'o2sat',fp];
wdir = dir([WOAdir,'woa18_all_O*_01.nc']);
woafiles = char(wdir.name);
if size(woafiles,1)<17 %not all files exist on repo
    disp('POPULATING LOCAL WOA2018 REPOSITORY...')
    disp('May take a few minutes.')
    disp(['You can monitor download progress at ',WOAdir])
    try
        f = ftp('ftp.nodc.noaa.gov');
        cd(f);
        sf = struct(f);
        sf.jobject.enterLocalPassiveMode();
        cd(f,'pub/woa/WOA18/DATA/o2sat/netcdf/all/1.00/')
        disp('FTP CONNECTION TO ftp.nodc.noaa.gov/pub/woa/WOA18/DATA/o2sat/netcdf/all/1.00/ WAS SUCCESSFUL.')
        dir_list = dir(f);
        mget(f,'woa18_all_O*.nc',WOAdir)
        disp(['WOA2018 files saved to ',WOAdir])
        char(dir_list.name)
        close(f)
    catch
        disp('FTP CONNECTION TO ftp.nodc.noaa.gov FAILED.  ENDING INSTALL.')
        return
    end
else
    disp('WOA files were found:')
    woafiles
end

    
 
% CHECK FOR NCEP DATA.  IF DOESN'T EXIST, DOWNLOAD IT.
disp('CHECKING FOR LOCAL NCEP FILES...')
NCEPdir = [topdir,fp,'ARGO_PROCESSING',fp,'DATA',fp,'NCEP_TEMPORARY',fp];
ncp = dir([NCEPdir,'pres.sfc.gauss*.nc']);
ncepfiles = char(ncp.name);
if size(ncepfiles,1)<1 %no files on repo
    disp('POPULATING LOCAL NCEP REPOSITORY...')
    disp('May take a few minutes.')
    disp(['You can monitor download progress at ',NCEPdir])
    try
        f = ftp('ftp.cdc.noaa.gov');
        cd(f);
        sf = struct(f);
        sf.jobject.enterLocalPassiveMode();
        cd(f,'Datasets/ncep.reanalysis/surface_gauss/');
        disp('FTP CONNECTION TO ftp.cdc.noaa.gov/Datasets/ncep.reanalysis/surface_gauss/ WAS SUCCESSFUL.')
        dir_list = dir(f);
        mget(f,'pres.sfc.gauss.201*.nc',NCEPdir)
        myNfiles = dir([NCEPdir,'pres.sfc.gauss.201*.nc']);
        disp(['NCEP files saved to ',NCEPdir])
        char(myNfiles.name)
        close(f)
    catch
        disp('FTP CONNECTION TO ftp.cdc.noaa.gov FAILED.  ENDING INSTALL.')
        return
    end
else
    disp('NCEP files were found:')
    ncepfiles
end

    
disp('INSTALL COMPLETE.')
