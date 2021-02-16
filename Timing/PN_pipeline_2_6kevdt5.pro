
;RESTORE,'/mdata1/shared/ozantoyran/ekalemci/pn_reanalysis/noflrlc/noflr_rawlist.sav' ; files : an array containing filenames

files='/mdata1/shared/ozantoyran/ekalemci/pn_reanalysis/central_removed_spectrums/PN_oot_free_2_6kev_dt5_nocenpix_noflr.lc'

eband=[2,6]
index=n_elements(files)

hfdtlevlog=DBLARR(index,2)

FOR k=0,index-1 DO BEGIN

;; Filename arrangements
   
    IF files[k] EQ '' THEN PRINT, 'File not found, please check your directory'+strtrim(k,1) ELSE BEGIN


    ;dtpos=strpos(files[0],'_')
    ;apos=strpos(files[0],'arcs')
    ;difpos=apos-dtpos
    
    ;arc_leahy=strmid(files[k],dtpos+1L,difpos-1)


    
    outdir_leahy='leahy.all'
    outdir_miyamoto_back='miyamoto.all'

    
    print, 'PN pipeline: Fourier Analysis Initiated'
    print, '************Now Processing*************'
    print, files[k]
    print, 'Leahy directory : ~/'+outdir_leahy
    print, 'Miyamoto directory : ~/'+outdir_miyamoto_back

    FOR i=0L,1L  DO BEGIN

;;Leahy Run 

       IF (i EQ 0L) THEN BEGIN

          
  ;  readxmmlc, files[k], time, rate, error, info=info
   ; xmmtokatja, time, rate, error, info, eband, outdir_leahy
    
;add background file
   ; spawn,'cp PN_ootf_bkg_2_6kev_dt5_nocenpix.lc '+outdir_leahy+'/light/raw/.'

    ;syncseg_xmm, id=outdir_leahy
;do leahy normalization to obtain background leahy level IF necessary

    ;fourier_xmm_leahy, id=outdir_leahy
  ENDIF

    get_avg_psd,outdir_leahy,avg_psd

  
          print,'PN pipeline: Leahy Normalized Spectrum Done!'
  print, 'Leahy normalized average psd at high frequencies :'+ strtrim(avg_psd[0],1)

  hfdtlev=avg_psd[0]
  hfdtlevlog[k,*]=avg_psd
  
;;Miyamoto Run

  IF (i EQ 1L) THEN BEGIN
 
     
    readxmmlc, files[k], time, rate, error, info=info
    xmmtokatja, time, rate, error, info, eband, outdir_miyamoto_back
;add background file
    ;spawn,'cp PN_ootf_bkg_2_6kev_dt5_nocenpix.lc '+outdir_miyamoto_back+'/light/raw/.'

    syncseg_xmm, id=outdir_miyamoto_back
;do leahy normalization to obtain background leahy level IF necessary   

    fourier_xmm_miyamoto, id=outdir_miyamoto_back,dtlevhf=hfdtlev

    
    print,'PN pipeline: Miyamoto Normalized Spectrum Done!'
   ENDIF

  ENDFOR

  ENDELSE
 
  ENDFOR

print, 'Leahy normalized average psd at high frequencies:'

FOR j=0,index-1 DO BEGIN

   print, files[j]+'    -    '+strtrim(hfdtlevlog[j,0],1)+'    '+strtrim(hfdtlevlog[j,1],1)

ENDFOR


print,'PN pipeline: Fourier Analysis is Done!'
print,'PN pipeline: Completed!'
END
