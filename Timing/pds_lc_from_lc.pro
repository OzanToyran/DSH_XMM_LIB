PRO pds_lc_from_lc,file,time,rate,error,info,lcplot=lcplot

;     This program plots lightcurve adn power spectrum of an XMM
;     lightcurve data
;
;
; INPUTS
; 
; file  : Name of the xmm lightcurve file                      
;
; OUTPUTS
;  
; time  : time array of the lightcurve 
;
; rate  : array containing counts
;
; error : 
;
; info  :
;
; USES  
;
; readxmmlc.pro
; fourierfreq.pro
; psd.pro
;  
; LOGS
; Created by Ozan Toyran, 18.08.2017
;
;  
  
  readxmmlc,file,time,rate,error,info,lcplot=lcplot

  fourierfreq,time,freq

  psd,time,rate,freq,pds,leahy=1
  psd,time,error,freq,perr,leahy=1
  
  nt=n_elements(time)
  ttime=DOUBLE(time-time(0))

  avgpsd=avg(pds)

;;
;; Rebinning Options to be added  
;;


;;
;;Average Count display
;;

;;
;;Avg power info display
;;

  
  !P.Multi=[0,1,3]
plot,freq,pds,xtitle='Frequency (Hz)',ytitle='Power',title='Power Spectrum'
  plot,ttime,rate,xtitle='Seconds',ytitle='Rate (cnts / s*dt)',title='Light Curve'

  ploterror,freq,pds,perr,/xlog,/nohat
  oplot,10^(!x.crange),[avgpsd[0],avgpsd[0]],line=0,col=0
  
  
  !P.Multi=0
  
  END
