PRO combine_profile


;Read the radial profiles

  basedir='/mdata1/shared/ozantoyran/ekalemci/pn_reanalysis/sbp/eradial'
  channel_number=5.

  tpsf=fltarr(126) ;size of rpsf depending on maxradius(N=250 -- N/2 +1 )
  tprof=fltarr(126)
  
  FOR i=1, channel_number DO BEGIN

     radfile='radprof_no_oot'+strtrim(i,1)+'.fits'
     
     ind=mrdfits(radfile,1)

     rpsf=ind.rpsf
     rprof=ind.rprof


;total psf     
     tpsf=tpsf+rpsf
     tprof=tprof+rprof

  ENDFOR

;average psf

  apsf=tpsf/channel_number
  aprof=tprof/channel_number
  
save,apsf,aprof,filename='average_oot_free_psf_2_6keV.sav'
  
END
