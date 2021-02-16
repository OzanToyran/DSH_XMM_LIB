PRO xmm_fourier,path,type=type, $
                 maxdim=inpmaxdim,dim=inpdim,normindiv=normindiv, $
                 schlittgen=schlittgen,leahy=leahy,miyamoto=miyamoto, $
                 xmm_bkg=xmm_bkg, xmm_dt=xmm_dt,$
                 linf=linf,logf=logf,nof=nof, $
                 dtlevhf=hfdtlev, $
                 fmin=fmin,fmax=fmax,fcut=fcut,$
		 xmin=plotxmin,xmax=plotxmax, $
		 ymin=plotymin,ymax=plotymax, $
                 xtenlog=plotxtenlog,ytenlog=plotytenlog,sym=plotsym, $
		 ebounds=ebounds,obsid=obsid,username=username,date=date, $
		 color=plotcolor,postscript=postscript,chatty=chatty       
;+
; NAME:
;          xmm_fourier
;
;
; PURPOSE:
;          calculate and save Fourier quantities, their uncertainties, and
;          noise corrections from segmented, evenly spaced, 
;          multidimensional xdr lightcurves for all given energy
;          channels  
;
;
; FEATURES:       
;          segmented, evenly spaced, multidimensional (i.e.,
;          containing more than one energy band) xdr lightcurves
;          (e.g., prepared by the rxte_syncseg.pro routine) are read;
;          several multidimensional Fourier quantities and their
;          uncertainties are calculated:   
;          --- e.g., the normalized 
;                        (see keywords tagged ``kw1'', in case of
;                        Miyamoto normalization an additional
;                        background correction is possible for xmm data), 
;                    noise and deadtime 
;                        it is possible to provide xmm bkg 
;                    corrected POWER SPECTRA; 
;                    the noise corrected COHERENCE FUNCTIONS; 
;                    and the TIME LAG SPECTRA
;          --- ;
;          the rms value for each psd is calculated (``kw4''); the
;          maximum segment length ``maxdim'' of the input lightcurves
;          has to be given in time bins; the Fourier quantities can be
;          calculated for several segment lengths ``dim[*]'' obtained
;          by dividing ``maxdim'' by integer factors; the Fourier
;          quantities obtained for different segment lengths are saved
;          individually but also merged by taking different frequency
;          ranges from different segment lengths (``kw5''); the Fourier
;          quantities are rebinned (``kw2''): logarithmic or linear
;          rebinning can be chosen; unrebinned Fourier quantities can
;          be saved additionally by setting ``nof=1'', the latter are
;          only saved individually, not merged; the input xdr
;          lightcurves and output xdr Fourier quantities and overview
;          ps plots (``kw6'') are stored in subdirectories of the input
;          directory ``path'' (see RESTRICTIONS and SIDE EFFECTS)
;                
;          most important subroutines:   
;          foucalc.pro : calculate Fourier quantities  
;          foumerge.pro: merge Fourier quantities    
;          fouplot.pro : plot Fourier quantities    
;
;   
; CATEGORY:
;          timing tools
;
;
; CALLING SEQUENCE:
;          xmm_fourier,path,type=type, $
;                   maxdim=inpmaxdim,dim=inpdim,normindiv=normindiv, $
;                   leahy=leahy,miyamoto=miyamoto,schlittge=schlittgen, $
;                   xmm_bkg=xmm_bkg,xmm_dt=xmm_dt,dtlevhf=hfdtlev, $
;                   linf=linf,logf=logf,nof=nof, $
;                   fmin=fmin,fmax=fmax,fcut=fcut, $
;                   xmin=plotxmin,xmax=plotxmax, $
;                   ymin=plotymin,ymax=plotymax, $
;                   xtenlog=plotxtenlog,ytenlog=plotytenlog,sym=plotsym, $
;                   ebounds=ebounds,obsid=obsid,username=username,date=date, $
;                   color=plotcolor,postscript=postscript,chatty=chatty
;
;
; INPUTS:
;          path               : string containing the path to the observation
;                               directory which must have a
;                               subdirectory called light/processed/ where
;                               the prepared lightcurves are stored in
;                               xdr format, named according to the
;                               output of rxte_syncseg.pro routine      
;          type               : string indicating whether one
;                               (type='high') or more segment lengths
;                               (type='low') are given, and whether the
;                               non-frequency rebinned Fourier
;                               quantities are saved as well
;                               (type='low') or not (type='high');  
;                               note that the keywords/inputs
;                               corresponding to the above behavior
;                               still have to be set/given!     
;          maxdim             : parameter giving the maximum segment
;                               length of the input lightcurves in
;                               time bins; maxdim is part of the file
;                               name of the multidimensional input
;                               lightcurve; maxdim=long(inpmaxdim) is
;                               used    
;          dim                : array giving the different segment
;                               lengths (in bins) for which the Fourier
;                               quantities are to be calculated; to
;                               ensure that exactly the same
;                               lightcurve data are used for all
;                               segment lengths, dim should only
;                               contain integer values obtained by
;                               dividing maxdim by an integer value;  
;                               dim=long(inpdim) is used
;
;
; OPTIONAL INPUTS:  
;          see KEYWORD PARAMETERS
;
;
; KEYWORD PARAMETERS:
;          and OPTIONAL INPUTS:
;     
;       -- for the PSD norm (kw1)
;              normindiv      : if set, average after normalizing
;                               individual psds;
;                               default: normindiv=0: average raw
;                               psds, then normalize using the count
;                               rate of the total lightcurve      
;              schlittgen     : if set, return power in Schlittgen
;                               normalization (Schlittgen, H.J.,
;                               Streitberg, B., 1995,
;                               Zeitreihenanalyse, R. Oldenbourg)
;              leahy          : if set, return power in Leahy normalization 
;                               (Leahy, D.A., et al. 1983, Ap.J.,
;                               266,160)
;              miyamoto       : if set, return power in Miyamoto normalization
;                               (Miyamoto, S., et al. 1991, Ap.J., 383, 784); 
;                               default:
;                               schlittgen undefined, leahy undefined,
;                               miyamoto=1:
;                               Miyamoto normalization 
;              xmm_bkg        : read xmm background light curve which is used   
;                               for correcting the psd
;                               normalization in case of
;                               Miyamoto normalization
;                               default: pca_bkg undefined, may
;                               require additional implementation
;                               A background lightcurve has to exist
;                               in the path /light/raw
;              xmm_dt         :
;
;
;              dtlevhf        :
;
;
;              ebounds        : energy ranges, 
;   
;       -- for the frequency rebinning (kw2)
;              linf           : parameter giving the number of
;                               frequency bins for linear frequency
;                               rebinning 
;              logf           : parameter giving df/f for logarithmic
;                               frequency rebinning;
;                               default: linf undefined, logf=0.15   
;              nof            : if set, the non-frequency-rebinned
;                               Fourier quantities are saved
;                               additionally to the rebinned ones;
;                               default: nof undefined: the
;                               non-frequency-rebinned quantities are
;                               not saved 
;   
;       -- for the deadtime correction of the psds (kw3)
;          an average leahy psd level at high backgrounds will be provided
;   
;       -- for the determination of the rms for each psd (kw4)    
;              fmin           : minimum frequency in Hz;
;                               default (set in rmscal.pro, called by
;                               foucalc.pro): fmin=min(freq)  
;              fmax           : maximum frequency in Hz;
;                               default (set in rmscal.pro, called by
;                               foucalc.pro): fmax=max(freq) 
;   
;       -- for the merging of Fourier quantities from different
;          lightcurve segment lengths (kw5) 
;              fcut           : for the merging of Fourier quantities
;                               from different segment lengths, the
;                               frequency range selected for each
;                               segment length dim[*] ranges from the
;                               minimum frequency given by
;                               1./(dim[*]*bt) to the maximum
;                               frequency given by an entry in fcut 
;                               corresponding to dim[*] (e.g., for
;                               three segment lengths,
;                               fcut=[0.013D0,0.059D0,128D0]); fcut
;                               has to be given in Hz;     
;                               default: fcut=128D0 
;   
;       -- for the plot routines, three overview plots 
;          (psd-coherence-time lags, in this order) are produced (kw6) 
;              xmin, xmax     : define the plotted frequency range in Hz;
;                               default:  xmin=[0.001,0.001,0.001] 
;                                         xmax=[128.,128.,128.] 
;              ymin, ymax     : define the plotted range for the
;                               Fourier quantities in psd norm (psd),
;                               relative coherence (coherence) and sec
;                               (lags);   
;                               default: ymin=[1E-6,-4.,1E-5]
;                                        ymax=[4.,4.,1.]  
;            xtenlog, ytenlog : plot x/y-axis logarithmically (1) or
;                               not (0);
;                               default: xtenlog=[1,1,1]
;                                        ytenlog=[1,0,1] 
;              sym            : plot symbol for the rebinned quantities
;                               and - if present - for the unrebinned
;                               quantities;   
;                               default: sym=[4,-3]  
;              ebounds        : array containing the energy ranges;   
;                               default: ebounds is undefined, i.e.: 
;                                        1. plotting: see string
;                                           ``channels''   
;                                        2. if xmm_bkg=1 then the 
;                                           background rate is read
;                                           for the whole energy range 
;                                           of the standard2f spectrum
;                                           per default   
;                               example: ebounds=[[36,81],[82,159]]   
;              obsid          : string giving the name of the observation;
;                               plotted on the overview plots;
;                               inserted in the history string array;
;                               default: 'Keyword obsid has not been set
;                                        (rxte_fourier)'  
;              username       : string giving the name of the user; 
;                               plotted on the overview plots; 
;                               inserted in the history string array;   
;                               default: 'Keyword username has not been set
;                                        (rxte_fourier)'  
;              date           : string giving the production date of
;                               the Fourier quantities; plotted on the
;                               overview plots; 
;                               inserted in the history string array;   
;                               default: 'Keyword date has not been set
;                                        (rxte_fourier)'
;              color          : decide which color (of color table 39) is
;                               used for each of the three plots;
;                               default: color=[50,50,50]: blue   
;              postscript     : decide whether ps or eps plots are
;                               produced; 
;                               default: postscript=1: ps plots are
;                                        produced   
;   
;       -- for the screen output
;              chatty         : controls screen output; 
;                               default: screen output;  
;                               to turn off screen output, set
;                               chatty=0       
;   
;   
; OUTPUTS:
;          none, but: see side effects   
;
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
;          the resulting Fourier quantities and the corresponding
;          history files are written to subdirectories of the
;          <path>/light/fourier/ directory
;          (``_corr'' is added to the filenames of normalized psd
;          quantities when the miyamoto/hexte_bkg or the
;          miyamoto/pca_bkg keyword combination has been set)
;   
;          in xdr format under the following file names 
;          (the .history and the .txt files are ASCII): 
;   
;          <path>/light/fourier/<type>/onelength/:
;          (for nof undefined (default) only the ``*_rebin_*'' files are saved)
;                  <dim[*]>_cof.xdrfu
;                  <dim[*]>_errcof.xdrfu
;                  <dim[*]>_errlag.xdrfu
;                  <dim[*]>_errnormpsd(_corr).xdrfu
;                  <dim[*]>_errpsd.xdrfu
;                  <dim[*]>_foinormpsd(_corr).xdrfu
;                  <dim[*]>_imagcpd.xdrfu
;                  <dim[*]>_lag.xdrfu
;                  <dim[*]>_noicpd.xdrfu
;                  <dim[*]>_noinormpsd(_corr).xdrfu
;                  <dim[*]>_noipsd.xdrfu
;                  <dim[*]>_normpsd(_corr).xdrfu
;                  <dim[*]>_psd.xdrfu
;                  <dim[*]>_rawcof.xdrfu
;                  <dim[*]>_realcpd.xdrfu
;                  <dim[*]>_rebin_cof.xdrfu
;                  <dim[*]>_rebin_errcof.xdrfu
;                  <dim[*]>_rebin_errlag.xdrfu
;                  <dim[*]>_rebin_errnormpsd(_corr).xdrfu
;                  <dim[*]>_rebin_errpsd.xdrfu
;                  <dim[*]>_rebin_foinormpsd(_corr).xdrfu
;                  <dim[*]>_rebin_imagcpd.xdrfu
;                  <dim[*]>_rebin_lag.xdrfu
;                  <dim[*]>_rebin_noicpd.xdrfu
;                  <dim[*]>_rebin_noinormpsd(_corr).xdrfu
;                  <dim[*]>_rebin_noipsd.xdrfu
;                  <dim[*]>_rebin_normpsd(_corr).xdrfu
;                  <dim[*]>_rebin_psd.xdrfu
;                  <dim[*]>_rebin_rawcof.xdrfu
;                  <dim[*]>_rebin_realcpd.xdrfu
;                  <dim[*]>_rebin_rms(_corr).txt
;                  <dim[*]>_rebin_signormpsd(_corr).xdrfu
;                  <dim[*]>_rebin_sigpsd.xdrfu                  
;                  <dim[*]>_rms(_corr).txt
;                  <dim[*]>_signormpsd(_corr).xdrfu
;                  <dim[*]>_sigpsd.xdrfu 
;          <path>/light/fourier/<type>/merged/:
;                   merge_rebin_cof.history
;                   merge_rebin_cof.xdrfu
;                   merge_rebin_errcof.history
;                   merge_rebin_errcof.xdrfu
;                   merge_rebin_errlag.history
;                   merge_rebin_errlag.xdrfu
;                   merge_rebin_errnormpsd(_corr).history
;                   merge_rebin_errnormpsd(_corr).xdrfu   
;                   merge_rebin_foinormpsd(_corr).history
;                   merge_rebin_foinormpsd(_corr).xdrfu
;                   merge_rebin_lag.history
;                   merge_rebin_lag.xdrfu
;                   merge_rebin_noinormpsd(_corr).history
;                   merge_rebin_noinormpsd(_corr).xdrfu
;                   merge_rebin_signormpsd(_corr).history
;                   merge_rebin_signormpsd(_corr).xdrfu     
;   
;          and as ps plots under the following file names:
;
;          <path>/light/fourier/<type>/plots/:    
;          (for nof undefined (default) the ``*_norebin_*'' files are not saved)   
;          <dim[*]>_cof_norebin.ps
;          <dim[*]>_lag_norebin.ps
;          <dim[*]>_signormpsd(_corr)_norebin.ps
;          cof.ps
;          lag.ps
;          signormpsd(_corr).ps
;   
;
;  for a description of the Fourier quantities labeled by these file
;  names, see subroutines of rxte_fourier.pro or the ASCII file
;  readme.txt     
;   
;   
; RESTRICTIONS: 
;          the input lightcurves must have been produced
;          according to rxte_syncseg.pro: they have to be segmented,
;          evenly spaced and multidimensional, it must be possible to
;          read them with xdrlc_r.pro and they must be stored in a
;          directory named <path>/light/processed/; the subdirectories
;          <path>/light/fourier/<type>/merged,
;          <path>/light/fourier/<type>/onelength, and
;          <path>/light/fourier/<type>/plots must exist for saving the
;          results; to ensure that exactly the same lightcurve data
;          are used for all segment lengths, dim should only contain
;          integer values obtained by dividing maxdim by an integer
;          value
;   
;   
; PROCEDURES USED:
;           
;          xdrlc_r.pro, foucalc.pro, foumerge.pro, fouplot.pro
;          xmmbackrate.pro
;
; EXAMPLE:
;          xmm_fourier,'01.all/light',type='low', $
;                        maxdim=131072L,dim=[131072L,32768L,8192L], $
;                        ebounds=[[36,81],[82,159]],/chatty
;
; for an example of the rest of the keywords see default values  
;   
; LOGS
;
;  based on rxte_fourier
;  June 2017, Emrah Kalemci
;  June 2017, Ozan Toyran  - Added xmmbackrate.pro 
   

;;   
;; set default values
;; default values for fmin and fmax, see foucalc.pro   
;;
;; psd normalization and background keywords   
;;   
IF (n_elements(normindiv) EQ 0) THEN normindiv=0   
;;
;;
nsch = n_elements(schlittgen)
nlea = n_elements(leahy)
nmiy = n_elements(miyamoto)
IF ((nsch+nlea+nmiy) GT 1) THEN BEGIN  
    message,'xmm_fourier: Only one normalization-keyword can be set' 
ENDIF
IF ((nsch+nlea+nmiy) EQ 0) THEN miyamoto=1   
;;
;; 

nbkgxmm = n_elements(xmm_bkg)

IF keyword_set(xmm_bkg) THEN BEGIN
    IF (NOT keyword_set(miyamoto)) THEN BEGIN 
        message,'xmm_fourier: Background correction can only be performed for Miyamoto normalization'
    ENDIF 
 ENDIF ELSE print,'xmm_fourier: No background correction of the power spectra is performed'

;;
;;
IF (NOT keyword_set(ebounds)) THEN BEGIN
  channels='Keyword ebounds has not been set (xmm_fourier)'   
ENDIF ELSE BEGIN     
    nbou=n_elements(ebounds[0,*]) 
    IF (nbou EQ 0) THEN BEGIN 
        message,'Keyword ebounds has not been set correctly (xmm_fourier)'
    ENDIF 
    channels=strtrim(string(ebounds[0,0]),2)+'-'+ $
      strtrim(string(ebounds[1,0]),2)
    FOR i=1,nbou-1 DO BEGIN 
        channels=channels + ', ' + strtrim(string(ebounds[0,i]),2)
        channels=channels + '-'  + strtrim(string(ebounds[1,i]),2)
    ENDFOR
ENDELSE 
;; 
;; frequency rebin keywords
;;
nlin = n_elements(linf)
nlog = n_elements(logf)
IF ((nlin+nlog) GT 1) THEN BEGIN
    message,'xmm_fourier: Only one way of rebinning is allowed'
ENDIF
IF ((nlin+nlog) EQ 0) THEN logf=0.15

;; 
;; deadtime correction keywords
;; OZAN - PROBABLY OBSOLETE, but LET's CHECK LATER

;; 
;; plotting keywords
;;
IF (n_elements(fcut) EQ 0) THEN fcut=128D0      
IF (n_elements(plotxmin) EQ 0) THEN plotxmin=[0.001,0.001,0.001]
IF (n_elements(plotxmax) EQ 0) THEN plotxmax=[128.,128.,128.]
IF (n_elements(plotymin) EQ 0) THEN plotymin=[1E-6,-4.,1E-5]    
IF (n_elements(plotymax) EQ 0) THEN plotymax=[4.,4.,1.]   
IF (n_elements(plotxtenlog) EQ 0) THEN plotxtenlog=[1,1,1]  
IF (n_elements(plotytenlog) EQ 0) THEN plotytenlog=[1,0,1]    
IF (n_elements(plotsym) EQ 0) THEN plotsym=[4,-3]   
IF (n_elements(obsid) EQ 0) THEN BEGIN 
    obsid='Keyword obsid has not been set (xmm_fourier)'
ENDIF 
IF (n_elements(username) EQ 0) THEN BEGIN 
    username='Keyword username has not been set (xmm_fourier)' 
ENDIF     
IF (n_elements(date) EQ 0) THEN BEGIN
    date='Keyword date has not been set (xmm_fourier)'
ENDIF              
IF (n_elements(plotcolor) EQ 0) THEN plotcolor=[50,50,50]    
IF (n_elements(postscript) EQ 0) THEN postscript=1   
;; 
;;
IF (n_elements(chatty) EQ 0) THEN chatty=1



;;
;; helpful parameters, file names   
;;
maxdim      = long(inpmaxdim)   
dim         = long(inpdim)
ndim        = n_elements(dim)

segname     = path+'/light/processed/'+string(format='(I7.7)',maxdim)+'_seg.xdrlc'
fouroot     = path+'/light/fourier/'+type

fouquan     = ['signormpsd','errnormpsd','noinormpsd','foinormpsd', $
               'cof','errcof', $
               'lag','errlag']
nfou        = n_elements(fouquan)

plotquan          = ['signormpsd','cof','lag']
ploterror         = ['errnormpsd','errcof','errlag']
ploterror_norebin = ['none','none','none']
plotnoise         = ['foinormpsd','none','none']
nplot             = n_elements(plotquan)

corrbkg=0 ;is this really necessary

IF keyword_set(xmm_bkg) THEN corrbkg=1
IF (corrbkg EQ 1) AND (keyword_set(miyamoto)) THEN BEGIN
    fouquan     = ['signormpsd_corr','errnormpsd_corr', $
                   'noinormpsd_corr','foinormpsd_corr', $
                   'cof','errcof', $
                   'lag','errlag']
    nfou        = n_elements(fouquan)
    plotquan          = ['signormpsd_corr','cof','lag']
    ploterror         = ['errnormpsd_corr','errcof','errlag']
    ploterror_norebin = ['none','none','none']
    plotnoise         = ['foinormpsd_corr','none','none']
    nplot             = n_elements(plotquan)
ENDIF 


;;
;; read synchronized, segmented lightcurves for all channels
;;

xdrlc_r,segname,time,rate,history=lchistory,chatty=chatty
nch=n_elements(rate[0,*])


;;
;; read background and/or housekeeping data
;;


;;
;; read XMM background for psd normalization
;;
;; I save the background LC in the format "PN_dt*_bkg.lc" in below directory
;; * is dt=2^*


IF (keyword_set(xmm_bkg)) THEN BEGIN
   bkgfile=path+'/light/raw/PN_dt5_bkg.lc'
   xmmbackrate, bkgfile, avg_bkgx
   avg_bkg=[avg_bkgx,avg_bkgx]
ENDIF

;CORRECT LATER FOR DIFFERENT CHANNEL POSSIBILITIES



;IF (keyword_set(xmm_bkg)) THEN BEGIN
;    backfile=path+'/spectrum/fullback.pha' - WILL be backlc
;    avg_bkg=fltarr(nch)
;    FOR i=0,nch-1 DO BEGIN  
;        ebandrate,backfile,avgrate,cmin=ebounds[0,i],cmax=ebounds[1,i]        
;        avg_bkg[i]=avgrate
;    ENDFOR 
;ENDIF

;;
;; Fourier quantities
;;

;; calculate Fourier quantities for Fourier frequencies
;; save results
;; OZAN - copy foucalc to foucalc_xmm and remove all information
;;        regarding HEXTE, and leave xmm_dt such that you will only
;;        remove the average leahy normalized value at high frequencies

dirname=path

IF (nof EQ 1) THEN BEGIN 
    FOR i=0,ndim-1 DO BEGIN
        foupath=fouroot+'/onelength/'+string(format='(I7.7)',dim(i))
        foucalc_xmm,time,rate,foupath, $
          dseg=dim(i),normindiv=normindiv, $ 
          avg_bkg=avg_bkg, $ 
          schlittgen=schlittgen,leahy=leahy,miyamoto=miyamoto, $ 
          nof=nof, dtlevhf=hfdtlev,dpath=dirname,$
          xmm_dt=xmm_dt, $
          fmin=fmin,fmax=fmax, $  
          obsid=obsid,username=username,date=date, $
          history=lchistory,chatty=chatty  
    ENDFOR
ENDIF 

;;;;STOPPED HERE
;; calculate Fourier quantities, then perform frequency rebinning
;; save results
FOR i=0,ndim-1 DO BEGIN
    foupath=fouroot+'/onelength/'+string(format='(I7.7)',dim(i))+'_rebin'
    foucalc_xmm,time,rate,foupath, $
      dseg=dim(i),normindiv=normindiv, $
      schlittgen=schlittgen,leahy=leahy,miyamoto=miyamoto, $
      avg_bkg=avg_bkg, $ 
      linf=linf,logf=logf, $
      xmm_dt=xmm_dt, $
      dtlevhf=hfdtlev,dpath=dirname,$
      fmin=fmin,fmax=fmax, $  
      obsid=obsid,username=username,date=date, $
      history=lchistory,chatty=chatty    
ENDFOR

;; merge rebinned Fourier quantities from different segment lengths
;; (fmin=1/dim[*]*bt, fmax=fcut) for all channels
;; save results
mergelist=strarr(nfou)
histolist=strarr(nfou)
FOR j=0,nfou-1 DO BEGIN
    mergelist(j)=fouroot+'/merged/merge_rebin_'+fouquan(j)+'.xdrfu'
    histolist(j)=fouroot+'/merged/merge_rebin_'+fouquan(j)+'.history'
    foulist=strarr(ndim)
    FOR i=0,ndim-1 DO BEGIN 
        foulist(i)=fouroot+'/onelength/'+string(format='(I7.7)',dim(i))
        foulist(i)=foulist(i)+'_rebin_'+fouquan(j)+'.xdrfu'
    ENDFOR 
    foumerge,foulist,mergelist(j),histolist(j),fcut=fcut,chatty=chatty
ENDFOR 

;; save ps-plot of merged Fourier quantities for all channels
FOR i=0,nplot-1 DO BEGIN
    mergename=fouroot+'/merged/merge_rebin_'+plotquan(i)+'.xdrfu'
    plotname=fouroot+'/plots/'+plotquan(i)
    IF (ploterror(i) NE 'none') THEN BEGIN 
        errorname=fouroot+'/merged/merge_rebin_'+ploterror(i)+'.xdrfu'
    ENDIF ELSE BEGIN
        errorname='none'
    ENDELSE    
    IF (plotnoise(i) NE 'none') THEN BEGIN 
        noisename=fouroot+'/merged/merge_rebin_'+plotnoise(i)+'.xdrfu'
    ENDIF ELSE BEGIN
        noisename='none'
    ENDELSE     
    fouplot,mergename,plotname,errorname=errorname,noisename=noisename, $
      quantity=plotquan(i), $
      xmin=plotxmin(i),xmax=plotxmax(i), $
      ymin=plotymin(i),ymax=plotymax(i), $
      xtenlog=plotxtenlog(i),ytenlog=plotytenlog(i),sym=plotsym(0), $
      fcut=fcut,label=[type,obsid,username,date,channels], $
      color=plotcolor(i),postscript=postscript,chatty=chatty 
ENDFOR 

;; save ps-plot of none-rebinned Fourier quantities for all channels
IF (nof EQ 1) THEN BEGIN
    FOR i=0,nplot-1 DO BEGIN
        FOR j=0,ndim-1 DO BEGIN 
            onename=fouroot+'/onelength/'+string(format='(I7.7)',dim(j))+'_'
            onename=onename+plotquan(i)+'.xdrfu'
            plotname=fouroot+'/plots/'+string(format='(I7.7)',dim(j))+'_'
            plotname=plotname+plotquan(i)+'_norebin'
            IF (ploterror_norebin(i) NE 'none') THEN BEGIN 
                errorname=fouroot+'/onelength/'+string(format='(I7.7)',dim(j))+'_'
                errorname=errorname+ploterror_norebin(i)+'.xdrfu'
            ENDIF ELSE BEGIN
                errorname='none'
            ENDELSE    
            IF (plotnoise(i) NE 'none') THEN BEGIN 
                noisename=fouroot+'/onelength/'+string(format='(I7.7)',dim(j))+'_'
                noisename=noisename+plotnoise(i)+'.xdrfu'
            ENDIF ELSE BEGIN
                noisename='none'
            ENDELSE     
            fouplot,onename,plotname,errorname=errorname,noisename=noisename, $
              quantity=plotquan(i), $
              xmin=plotxmin(i),xmax=plotxmax(i), $
              ymin=plotymin(i),ymax=plotymax(i), $
              xtenlog=plotxtenlog(i),ytenlog=plotytenlog(i),sym=plotsym(1), $
              label=[type,obsid,username,date,channels], $
              color=plotcolor(i),postscript=postscript,chatty=chatty 
        ENDFOR 
    ENDFOR 
ENDIF 




END 





