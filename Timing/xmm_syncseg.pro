PRO xmm_syncseg,path,channels, $
                 orgbin=orgbin,newbin=newbin,dseg=dseg,dutylimit=dutylimit, $
                 obsid=obsid,username=username,date=date, $
                 chatty=chatty,gz=gz
;+
; NAME:
;          xmm_syncseg  
;
;
; PURPOSE: produce evenly spaced segments out of XMM lightcurves,
; process deadtime info    
;   
;   
; FEATURES:      
;          prepare XMM high time-resolution lightcurves extracted
;          in multiple energy bands (``channels'') and with given
;          bintimes (``orgbin'') for the analysis with
;          xmm_fourier.pro (calculate Fourier quantities). The
;          lightcurves can be rebinned by an integer
;          factor given by ``newbin''; strictly time-synchronous
;          lightcurves for all energy bands are created (and can be
;          checked for the occurence of neighboring zero count rates:
;          see ``dutylimit'') and cut into evenly spaced segments of
;          dimension ``dseg''; the input and output lightcurves are
;          stored in subdirectories of the input directory ``path'';
;          the output lightcurves contain a history string array
;          containing the keyword strings ``obsid'', ``username'',
;          ``date'', and others;  
;
; CATEGORY:
;          timing tools for XMM lightcurves 
;
;
; CALLING SEQUENCE:
;         xmm_syncseg,path,channels, $
;                      orgbin=orgbin,newbin=newbin,dseg=dseg, $
;                      dutylimit=dutylimit, $
;                      obsid=obsid,username=username,date=date, $
;                      chatty=chatty  
;
;   
; INPUTS:
;          path     : string containing the path to the observation
;                     directory which must have a subdirectory light/raw/ where
;                     the original lightcurves are stored in FITS format, named
;                     according to the output of the IAAT extraction scripts
;                     (e.g., PCA: FS37_978fa90-9790888__excl_8_160-214.lc or
;                     HEXTE: FS_04.00-a_src_6_15-30.lc), and a subdirectory
;                     light/processed/ for the resulting xdr
;                     lightcurves       
;          channels : string array containing the channel ranges (pha
;                     channels) of all energy bands that are to be
;                     considered  
;          orgbin   : double array containing the bintime exponent of
;                     each energy band with the bintime in sec being
;                     expressed as power of the basis 2 (the basis 2
;                     is generally used for the bintime by the PCA
;                     modi und the exponent is part of the FITS
;                     lightcurve file name)  
;
;   
; OPTIONAL INPUTS:
;          newbin   : integer array containing the rebin factor for
;                     each energy band;    
;                     default: 1 for all energy bands, i.e., no
;                     rebinning
;          dseg     : parameter containing the length in bins (after
;                     rebinning) of the evenly spaced, synchronous
;                     lightcurve segments that are produced;
;                     default: 1/10th of the time between the first
;                     and the last time bin of the synchronized time
;                     array given in the same units as the time array 
;          dutylimit: array giving the limit for the percentage of the
;                     elements of the rate array (after synchronizing,
;                     before segmenting) for each energy channel, that
;                     are NOT ZERO FOLLOWED BY ANOTHER ZERO; 
;                     gaps in the corresponding time array are NOT
;                     taken into account;
;                     if dutylimit is not given or the measured
;                     duty cycle is above the given limit, the duty cycle
;                     is printed to the screen and to the history string;
;                     if the measured duty cycle is below the given
;                     limit, the program is interrupted;
;                     default: dutylimit undefiend    
;          obsid    : string giving the name of the observation;
;                     this name is stored in the history keyword of
;                     the xdr lightcurve;
;                     default: 'Keyword obsid has not been set
;                     (xmm_syncseg)' 
;          username : string giving the name of the user ;
;                     this name is stored in the history keyword of
;                     the xdr lightcurve;
;                     default: 'Keyword username has not been set
;                     (xmm_syncseg)' 
;          date     : string giving the production date of the xdr
;                     lightcurve;
;                     this name is stored in the history keyword of
;                     the xdr lightcurve;
;                     default: 'Keyword date has not been set
;                     (xmm_syncseg)'    
;
;
; KEYWORD PARAMETERS:
;        
;          chatty   : controls screen output; 
;                     default: screen output;  
;                     to turn off screen output, set chatty=0         
;          gz       : if set, find gzipped files 
;   
; OUTPUTS:
;          none, but: see side effects and keyword defaults
;
;
; OPTIONAL OUTPUTS:
;          none
;
;
; COMMON BLOCKS:
;          none
;
;
; SIDE EFFECTS: 
;          the resulting two multidimensional lightcurves are
;          written to the <path>/light/processed/ directory in xdr
;          format; first lightcurve: sync.xdrlc, containes the
;          time-synchronized, rebinned lightcurves of all energy
;          bands; second lightcurve: <dseg>_seg.xdrlc, produced
;          by cutting sync.xdrlc into evenly spaced segments of
;          dimension dseg (during the procedure, temporary files are
;          also written to this directory and deleted again), 
;          for PCA lightcurves, if the deadtime information exists
;          in the <path>/light/raw/ directory, subroutines generate
;          pcadead-files in the <path>/light/processed/ directory
;          for the final lcs,   
;          some keyword defaults are set   
;
;   
; RESTRICTIONS: 
;          input lightcurves have to be FITS lightcurves in the
;          <path>/light/raw/ subdirectory and have to be named
;          according to the output of the IAAT extraction scripts
;          (e.g., PCA: FS37_978fa90-9790888__excl_8_160-214.lc or
;          HEXTE: FS_04.00-a_src_6_15-30.lc); the subdirectories
;          <path>/light/raw/ and <path>/light/processed/ must exist;
;          outside of the gaps the lightcurves have to be evenly
;          spaced with a bintime given in sec that can be expressed as
;          integer power for the basis 2; outside of the gaps the
;          lightcurves from different energy bands must have the same
;          time array after rebinning them by the integer factors
;          given in newbin;
;          several parameters/keywords must have the same number of
;          elements: channels,orgbin,newbin,dutylimit   
;   
;
; PROCEDURES USED: 
;          lcmerge.pro, lcsync.pro, lcseg.pro      
;
; EXAMPLE:
;          xmm_syncseg,'01.all',['0-10','11-13'], $
;                 orgbin=[-8D0,-8D0],newbin=[2L,2L],dseg=131072L, $
;                 dutylimit=[80D0,80D0], $   
;                 obsid='P40099/01.all', $
;                 username='Katja Pottschmidt', $
;                 date=systime(0),/chatty      
;
;
; LOGS:
;
; Modified from rxte_syncseg by EK, June 2017
;         
;-
   
   
;; helpful parameters
pa         = path+'/light'  
lcroot     = pa+'/raw'
nch        = n_elements(channels)
mergenames = strarr(nch)
mergeroot  = pa+'/processed/merge'
syncname   = pa+'/processed/sync.xdrlc'
segname    = pa+'/processed/'+string(format='(I7.7)',dseg)+'_seg.xdrlc'
   

;; set default values,
;; the default value for dseg is set in the lcseg.pro subroutine

IF (n_elements(obsid) EQ 0) THEN BEGIN 
    obsid='Keyword obsid has not been set (xmm_syncseg)'
ENDIF     
IF (n_elements(username) EQ 0) THEN BEGIN 
    username='Keyword username has not been set (xmm_syncseg)'
ENDIF     
IF (n_elements(date) EQ 0) THEN BEGIN 
    date='Keyword date has not been set (xmm_syncseg)'
ENDIF     
IF (n_elements(newbin) EQ 0) THEN BEGIN 
    newbin=lonarr(nch)
    newbin[*]=1L
ENDIF 
IF (n_elements(chatty) EQ 0) THEN chatty=1

if not keyword_set(gz) then gz=0

;; merge lightcurves for each individual energy range

FOR i=0,nch-1 DO BEGIN
    
    bin=string(format='(I1)',orgbin(0))
   
    IF gz then spawn,['/usr/bin/find',lcroot,'-name','*'+bin+'_'+channels(i)+'.lc.gz'], lclist,/noshell else spawn,['/usr/bin/find',lcroot,'-name','*'+bin+'_'+channels(i)+'.lc'], lclist,/noshell
        
    
    mergenames[i]=mergeroot+string(format='(I3.3)',i)+'.xdrlc'

    lcmerge,lclist,mergenames(i),channelrange=channels(i), $
      bintime=orgbin(i),factor=newbin(i),chatty=chatty

ENDFOR 

;; time-synchronize merged lightcurves from all energy ranges
lcsync,mergenames,syncname,dutylimit=dutylimit, $
  obsid=obsid,username=username,date=date, $
  chatty=chatty

;; remove merged lightcurves
FOR i=0,nch-1 DO BEGIN
     IF (NOT file_exist(mergenames[i])) THEN mergenames[i]=mergenames[i]+'.gz'
    spawn,['/bin/rm',mergenames(i)],/noshell
ENDFOR 
 
;; cut synchronized lightcurves into segments of dimension dseg  
lcseg,syncname,segname,dseg=dseg,chatty=chatty


END  








