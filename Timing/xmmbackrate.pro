PRO xmmbackrate, file, avg_bkgx, $
                 dseg=dseg,chatty=chatty
  
;This program reads the SAS output of xmm event files and stores the
;average background counts
;
; INPUTS
;
; file: Name of the background light curve
;
; OUTPUTS
;
; avgbkg_psd  = Average Leahy normalized PSD of the background lightcurve
; 
; USES
;
; loadcol
; 
;
; USED BY
;
; xmm_fourier.pro
;
;LOGS
;
; Created by O.Toyran , June 2017
;


;
; Reading Background lightcurve and calculating Fourier frequencies
;
  
  readxmmlc,file,time,rate,error,info

;
; Keywords for Lightcurve  
;
  dseg=128L*32L
  nt=n_elements(time)                            ;Dimentions of LC
  nus=nt/dseg                                    ;Number of segments
  bt=time(1)-time(0)                             ;binsize of LC
  startbin=0L 
  endbin=dseg-1L
  length=time(endbin)-time(startbin)+bt          ;length of LC
;
; Calculating average background rate and Fourier powers
;  
  avg_bkgx=rate/length

;  fastftrans,avgbkg_rate,dft
;  ppsd=abs(dft)^2
;  rpsd=ppsd/nus                        ;Raw Power Spectrum
;
; Leahy Normalization of the background power spectrum  
;
 ; psdnorm,avgbkg_rate,length,dseg,ppsd,leahy=1,chatty=chatty,avgback=avgback

;  avgbkg_psd=ppsd                      ;Average Background Power


END
