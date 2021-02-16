pro readxmmlc, file, time, rate, error, info, lcplot=lcplot


;This program reads the SAS output of xmm light curves and stores
;necessary information
;
; INPUTS
;
; file: Name of the light curve
;  
; OUTPUTS
;
; time: time 
; rate: rate 
; error: error in rate 
; info: structure carrying information on lightcurve
; 
; OPTIONAL OUTPUTS
;
; lcplot: if set plot the light curve
;
; USES
;
; loadcol
;
; USED BY
;
; xmmtokatja.pro
; 
;LOGS
;
; Created by E. Kalemci, historic
; cosmetic changes June 2017
;

IF NOT keyword_set(lcplot) THEN lcplot=0
  
time=loadcol(file,'TIME',ext=1)
rate=loadcol(file,'RATE',ext=1)
error=loadcol(file,'ERROR',ext=1)

bgti = loadcol(file,'START',ext=2)
egti = loadcol(file,'STOP',ext=2)

x = loadcol(file,'X',ext=3)
y = loadcol(file,'Y',ext=3)
r = loadcol(file,'R',ext=3)

info = create_struct('gti',dblarr(2,n_elements(bgti)),'tgti',0.,$
                     'posc',dblarr(3),'tres',0.,'dt',0)

info.gti(0,*) = bgti
info.gti(1,*) = egti
info.tgti = total(info.gti(1,*)-info.gti(0,*))

info.posc(0)=x
info.posc(1)=y
info.posc(2)=r

hd = headfits(file,ext=1)
info.tres = fxpar(hd,'TIMEDEL')

dtf = (alog(info.tres)/alog(2))*(-1)
if dtf-floor(dtf) gt 0.0001 then print, 'not suitable for fft'
dt=floor(dtf)

info.dt=dt

IF lcplot THEN ploterror,time-time(0),rate,error,/nohat,/xstyle,/ystyle,$
          xtitle='TIME (s)',ytitle='RATE (cnts/s)', charsize=1.3

END

