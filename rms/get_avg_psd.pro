PRO get_avg_psd,dirname,avgpsd,freqr=rfreq,pcut=cutp,parr=rpar,ps=ps,fname=namef,pows=pds

;  This program calculates the average psd and errors of the input
;power spectra in the given frequency range. 
;

;INPUTS
;
; dirname: directory of the created power spectra
; 
; OUTPUTS
;
;  avgpsd: averaged Leahy normalized psd and its error,in the given frequency range
;
; OPTIONAL INPUTS
;
;  freqr:  frequency range to be used, If not set, default is above 10Hz.
;
;  
;  pcut:   Power cut for artificial peaks,default is 2.5
;
;  rpar:  Rebinning parameter
;
;  ps:    if set, plot postscript
;
;  fname: Postscript plot filename 
;
; USES
;  
; xdrfu_r1 
;
; USED BY
;
; psdcorr.pro
;
; LOGS
; Created by Ozan Toyran, 17.05.2017

  IF NOT keyword_set(cutp) THEN cutp=2.5
  IF Not keyword_set(rpar) THEN rpar=1.05
  IF NOT keyword_set(ps) THEN ps=0
  IF NOT keyword_set(namef) THEN namef='avgpsd_witherr.eps'

  if ps then begin
   set_plot, 'ps'   
;   device,/color
   device,/encapsulated
;IF bw THEN loadct,0 ELSE loadct,4
   device,decomposed=0
   device, filename = namef
   device, yoffset = 2
   device, ysize = 23
   device, xsize = 18
   !p.font=0
   device,/times
endif

  
; Find the appropriate file
  
  file=FILE_SEARCH(dirname,'*_normpsd.xdrfu.gz')
  errfile=FILE_SEARCH(dirname,'*_errnormpsd.xdrfu.gz')

  IF file[0] EQ '' THEN PRINT, 'File not found, please check your directory' ELSE BEGIN
     
; read the file

     xdrfu_r1,file[0],f,p
     xdrfu_r1,errfile[0],f,perr
  
; Find light curve segment length from file and calculate dt
  
     dtpos=strpos(file[0],'_norm')
     seg=long(strmid(file[0],dtpos-7.,7))
 
     dseg=1./(f[1]-f[0])

     dt=alog10(seg/dseg)/alog10(2)

;Find artificial peaks

     psel=where(p[*,0] LT cutp)

     multiplot,[1,2],mxtitle='Frequency(Hz)',mxtitsize=1.2,mytitle='Leahy Power',mytitsize=1.2

     ploterror,f,p[*,0],perr[*,0]

     oplot,!x.crange,[cutp,cutp],line=2,col=0

     fnew=f(psel)
     pnew=p(psel,0)
     pnerr=perr(psel,0)

;Determine frequency range to average

     IF NOT keyword_set(rfreq) THEN rfreq=[10.,max(f)]

     fcut=where((fnew GE rfreq[0]) AND (fnew LE rfreq[1]))

     
     avgpsd=FLTARR(2)

     avgpsd[0]=avg(pnew(fcut))
     avgpsd[1]=avg(pnerr(fcut))/sqrt(n_elements(fcut))

  endelse

  
;Plotting rebinned Power spectrum  
  ff=fnew
  pp=pnew
  pper=pnerr
  
  rebin_geo,rpar,ff,pp,pper

  multiplot
  ploterror,ff,pp,pper,/xlog,/nohat
  oplot,10^(!x.crange),[avgpsd[0],avgpsd[0]],line=2,col=0

  multiplot,/default

  IF ps THEN BEGIN
   device,/close
  IF !VERSION.OS eq 'Win32' THEN set_plot,'win' ELSE set_plot,'X'
  ENDIF

  pds=FLTARR(3,n_elements(f))
  pds[0,*]=f
  pds[1,*]=p[*,0]
  pds[2,*]=perr[*,0]

  hfdtlev=avgpsd[0]
  
  end

     
