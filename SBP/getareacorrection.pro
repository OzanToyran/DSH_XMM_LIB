function getareacorrection,expomap,imgposs


  
   yy=where(expomap GT 0.)
   
   
   sz=size(expomap)
  
  yexp=(yy/sz[1])               ;-poss[1]
  xexp=(yy-yexp*sz[1])          ;-poss[0]

  yexp=yexp-imgposs[1]
  xexp=xexp-imgposs[0]
  rexp=sqrt(xexp^2+yexp^2)
  expoarfrac=dblarr(60)

;assume first 44 arcsec is always ok for 1E1742.  1 img pixel=4 arcsec
expoarfrac[0:10]=1.

 imgpix=4.           ;1 img pixel=4 arcsec
 maxradius=240.     ;in arcseconds
 imgrad=maxradius/imgpix   ;in image pix
FOR i=11., imgrad-1. DO BEGIN

   rlim=where(rexp LT i)
   expoarfrac[i]=double(n_elements(rlim))/(!PI*double(i)^2.)

  ENDFOR

  
  return,expoarfrac

END
