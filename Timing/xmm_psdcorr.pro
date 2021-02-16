PRO xmm_psdcorr,totrate,inplength,inpdseg, $
            freq,noipsd,dpath=dirname, dtlevhf=hfdtlev, $
            avgrate=avgrate,$
            schlittgen=schlittgen,leahy=leahy,miyamoto=miyamoto, $
            avgback=avgback,unnormalized=unnormalized,chatty=chatty

;+
; NAME:
;          psdcorr
;
;
; PURPOSE:
;          calculates the frequencies
;          & observational noise of
;          the FFT-psd,
;          the latter modified by
;          detector dead-time,
;          primarily based
;          on the paper by Zhang, W. et al. 1995, ApJ, 449, 930.
;          = instrument independent dead-time correction
;
;
; CATEGORY:
;          timing tools
;
;
; CALLING SEQUENCE:
;          psdcorr,totrate,inplength,inpdseg, $
;                  freq,noipsd, $
;                  avgrate=avgrate, $
;                  schlittgen=schlittgen,leahy=leahy,miyamoto=miyamoto, $
;                  avgback=avgback,unnormalized=unnormalized,chatty=chatty
;
;
; INPUTS:
;          totrate   : total count rate, summed over all detectors
;          inplength : time length of the lightcurve segments for
;                      which the Fourier frequencies are calculated,
;                      to be given in seconds
;          inpdseg   : dimension of the lightcurve segments for which
;                      the Fourier frequencies are calculated,
;                      to be given in time bins
;          path      : name of the directory that started with xmmtokatja.pro  
;
;
;  
;
;
; OPTIONAL INPUTS:
;          avgrate     : average count rate for psd normalization
;                        done by psdnorm.pro
;                        default: avgrate=totrate
;
;
; KEYWORD PARAMETERS:
;         
;          schlittgen     : if set, the corrected Fourier quantities
;                           are Schlittgen-normalized
;                           (default:
;                           miyamoto=1: Miyamoto normalization)
;          leahy          : if set, the corrected Fourier quantities
;                           are Leahy-normalized
;                           (default:
;                           miyamoto=1: Miyamoto normalization)
;          miyamoto       : if set, the corrected Fourier quantities
;                           are Miyamoto-normalized (=default)
;          unnormalized   : if set, the corrected Fourier quantities
;                           are not normalized
;                           (default:
;                           miyamoto=1: Miyamoto normalization)
;          chatty         : controls screen output
;                           (default: no screen output)
;
;
; OUTPUTS:
;          freq   : Fourier frequency array
;          noipsd : array of observational noise of the psd,
;                   modified  by detector deadtime
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
;          setting of keyword defaults
;

;
; RESTRICTIONS:
;          none
;
;
; PROCEDURES USED:
;
;          fourierfreq.pro
;          psdnorm.pro
;          get_avg_psd.pro
;  
;
; EXAMPLE:
;          see foucalc.pro, dtcorr.pro
;
;
; MODIFICATION HISTORY:
;          Version 1.0: 12/2000, Katja Pottschmidt IAAT,
;                                based on code written by
;                                Sara Benlloch IAAT
;          Version 1.1: 11/2001, Katja Pottschmidt IAAT,
;                                header comment added
;          Version 1.7: 12/2001, Katja Pottschmidt IAAT,
;                                minor changes in header,
;                                idl/cvs version numbers synchronized
;                                 Version 1.8: 12/2001, Katja
;                                 Pottschmidt IAAT,
;                                minor changes in header
;          Version1.7.1:08/2017, Ozan Toyran
;                                Modified Katja's code for XMM
;                                pipeline we are working on.
;                                Calculates avg high freq psd then
;                                returns Leahy normalized value to be substracted 
;
;  
;-

  ;; avgrate-keyword for psd norm, default:
   avgrate=totrate
  IF (n_elements(avgrate) EQ 0) THEN avgrate=totrate

;  detrate=navg     NOt useful atm?? -ozan

  ;; normalization-keywords (schlittgen, leahy, miyamoto,
  ;; unnormalized),
  ;; default: miyamoto=1: Miyamoto normalization
  sum = n_elements(schlittgen)+n_elements(leahy)+   $
        n_elements(miyamoto)+n_elements(unnormalized)
  IF (sum GT 1) THEN BEGIN
     message, 'psdcorr: Only one normalization-keyword can be set'
  ENDIF
  IF (sum EQ 0) THEN BEGIN
     miyamoto=1
  ENDIF
  IF (keyword_set(schlittgen)) AND (keyword_set(chatty)) THEN BEGIN
     print,'psdcorr: The corrected Fourier quantities '
     print,'are Schlittgen-normalized'
  ENDIF
  IF (keyword_set(leahy)) AND (keyword_set(chatty)) THEN BEGIN
     print,'psdcorr: The corrected Fourier quantities '
     print,'are Leahy-normalized'
  ENDIF
  IF (keyword_set(miyamoto)) AND (keyword_set(chatty)) THEN  BEGIN
     print,'psdcorr: The corrected Fourier quantities '
     print,'are Miyamoto-normalized'
  ENDIF
  IF (keyword_set(unnormalized)) AND (keyword_set(chatty)) THEN BEGIN
     print,'psdcorr: The corrected Fourier quantities '
     print,'are unnormalized'
  ENDIF
;; lightcurve parameters
;  deadtime = double(inpdeadtime)
  dseg     = long(inpdseg)
  n        = double(dseg)
  length   = double(inplength)
  bt       = double(length/dseg)
  time     = double(bt*findgen(dseg))
  zpsd     = dblarr(dseg/2)
  

  ;; Fourier frequency array
  fourierfreq,time,freq
  om=2.*!pi*bt*freq
  time=0.

  zpsd[*]=hfdtlev
  

  

  ;; normalization of the xmm psd (xmm_psd is Leahy normalized)
  noipsd=(zpsd*dseg*dseg*avgrate)/(2.*length)
  IF (NOT keyword_set(unnormalized)) THEN BEGIN
     psdnorm,avgrate,length,dseg,noipsd, $
             schlittgen=schlittgen,leahy=leahy,miyamoto=miyamoto, $
             avgback=avgback,chatty=chatty

  ENDIF

  
 
END

