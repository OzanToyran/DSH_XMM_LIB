PRO equalchan,use_en

;This program finds energy channel bins with equal counts

  evlf      = '/mdata1/shared/ozantoyran/ekalemci/pn_reanalysis/sbp/P0303210201PNS003PIEVLI0000.FTZ'
  bincount  = 5.
    
  
;Read Energy Channels
  
  en=loadcol(evlf,'PI',ext=1)/1000. ;keV

;Energy Cut

  ind=where((en gt use_en[0]) AND (en le use_en[1]),count)

  chanbin=count/bincount

  en1=en[ind]
;Sort Energies

  sorten=en1(SORT(en1))

  
  eqchan=dblarr(2,5)

;Determine Energy Channels
  
  FOR i=1,5. DO BEGIN
     
     eqchan[0,i-1]=sorten[chanbin*(i-1)]
     eqchan[1,i-1]=sorten[chanbin*(i)-1]

  ENDFOR

  For j=0,4. DO BEGIN

     IF j EQ 0 THEN BEGIN
     Print, "Equal count energy channels between " + strtrim(use_en[0],1) +" & " + strtrim(use_en[1],1) + " keV :"
     ENDIF
     
     Print, strtrim(eqchan[0,j],1) + "   -   "+ strtrim(eqchan[1,j],1)

  ENDFOR

  save,eqchan,filename='equal_channels.sav'
  
end

