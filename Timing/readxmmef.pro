pro readxmmef, file, dt, info=info, $
               outtime=lctime, outrate=rate, outerror=error, lcplot=lcplot


;This program reads the SAS output of xmm event files and stores
;necessary information
;
; INPUTS
;
; file: Name of the light curve
; dt: resolution in terms of 2^dt
;  
; OUTPUTS
;
; info: structure carrying information on lightcurve
; 
; OPTIONAL OUTPUTS
; outtime: time if external plotting is needed
; outrate: rate if external plotting is needed
; outerror: error in rate if external plotting is needed
; lcplot: if set plot the light curve
;
; USES
;
; loadcol
;
; USED BY
;
; ?
; obsolete?
;
;LOGS
;
; Created by E. Kalemci, historic
; cosmetic changes June 2017
;

IF NOT keyword_set(lcplot) THEN lcplot=0
time=loadcol(file,'TIME',ext=1)
time=time-time(0)
binsize=2.^(-dt)

nevbin=histogram(time,min=0,binsize=binsize)
rate=nevbin/binsize
error=sqrt(nevbin)/binsize

lctime=dindgen(n_elements(rate))*binsize
bgti = loadcol(file,'START',ext=6)
egti = loadcol(file,'STOP',ext=6)

x = loadcol(file,'X',ext=7)
y = loadcol(file,'Y',ext=7)
r = loadcol(file,'R',ext=7)


info = create_struct('gti',dblarr(2,n_elements(bgti)),'tgti',0.,$
                     'posc',dblarr(3),'tres',binsize,'dt',dt)

info.gti(0,*) = bgti
info.gti(1,*) = bgti
info.tgti = total(info.gti(1,*)-info.gti(0,*))

info.posc(0)=x
info.posc(1)=y
info.posc(2)=r

IF lcplot THEN ploterror,lctime,rate,error,/nohat,/xstyle,/ystyle,$
          xtitle='TIME (s)',ytitle='RATE (cnts/s)', charsize=1.3

END

