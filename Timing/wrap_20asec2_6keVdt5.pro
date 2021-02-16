
pn_lightcurve='PN_20arcs_dt5_2_6kev.lc'
eband=[2,6]
outdir_leahy='test_idl_leahy'
outdir_miyamoto_back='test_idl_miy_backc'

FOR i=0L,1L  DO BEGIN
IF (i EQ 0L) THEN BEGIN
   
;readxmmlc, pn_lightcurve, time, rate, error, info
;xmmtokatja, time, rate, error, info, eband, outdir_leahy
;add background file
;spawn,'cp PN_dt5_bkg.lc '+outdir_leahy+'/light/raw/.'

;syncseg_xmm, id=outdir_leahy
;do leahy normalization to obtain background leahy level IF necessary

fourier_xmm_leahy, id=outdir_leahy
ENDIF

get_avg_psd,outdir_leahy,avg_psd

print, 'Leahy normalized average psd at high frequencies :'+ strtrim(avg_psd[0],1)

hfdtlev=avg_psd[0]

IF (i EQ 1L) THEN BEGIN

;readxmmlc, pn_lightcurve, time, rate, error, info
;xmmtokatja, time, rate, error, info, eband, outdir_miyamoto_back
;add background file
;spawn,'cp PN_dt5_bkg.lc '+outdir_miyamoto_back+'/light/raw/.'

;syncseg_xmm, id=outdir_miyamoto_back
;do leahy normalization to obtain background leahy level IF necessary   

fourier_xmm_miyamoto, id=outdir_miyamoto_back,dtlevhf=hfdtlev

ENDIF

ENDFOR

END
