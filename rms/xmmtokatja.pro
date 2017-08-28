pro xmmtokatja,time,rate,error,info,eband,outdir

;The aim of this program is to create a special directory structure
;which holds the light curves such that Katja's Turbingen Timing Tools
;while the name is xmmtokatja in principle this program is valid for
;any mission which we could obtain a light curve.
;
; INPUTS
;
; time: time tags for "any source" light curve
; rate: counts/s light curve
; error: error of rate
; info: structure that has some information on the light curve properties
; eband: energy band for turbingen timing tools to correctly identify files
; outdir: name of the output directory
;
; OUTPUTS
;
; None
;
; OPTIONAL INPUTS
;
; None
;
; USES
;
; output of readxmmlc.pro
; xmm_temp.all template directory
;
; USED BY
;
; syncseg_xmm.pro
;
; LOGS
;
; Created by EK, historic
;

    
indir='xmm_temp.all' ;currently template directory is fixed
spawn,'pwd',pwd
spawn,'cp -fr '+indir+' '+outdir,/sh
e1=strcompress(string(eband(0)),/remove_all)
e2=strcompress(string(eband(1)),/remove_all)

;dtf = (alog(info.tres)/alog(2))*(-1)
;if dtf-floor(dtf) gt 0.0001 then print, 'not suitable for fft'
;dt=strcompress(string(floor(dtf)),/remove_all)
dt=strcompress(string(info.dt),/remove_all)

outlc=outdir+'/light/raw/FSxmm_'+dt+'_'+e1+'-'+e2+'.lc'

writelc,time,rate,error,outlc

cd,pwd

END
