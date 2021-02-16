function getareacorrection2,expomap,imgposs,imgxl,imgxr,imgyu,imgyd

;  out of chip boundary and exposure area 0 pixels should not
;  contribute to the area


  yy=where(expomap GT 0.)

  sz=size(expomap)

  expoflag=dblarr(sz[1],sz[1])
  cnt=dblarr(125)



  yexp=(yy/sz[1])               ;-poss[1]
  xexp=(yy-yexp*sz[1])          ;-poss[0]

                                ;flag with 1 every pixel of interest
  expoflag[xexp,yexp]=1.

                                ;determine OOT pixels to be excluded

  ind=where((xexp GE imgxl) AND (xexp LE imgxr))

  yind=ind/sz[1]
  xind=ind-yind*sz[1]

  expoflag[xind,yind]=0.



  counts=0

FOR m=0, 124. DO BEGIN
   FOR j=0, 647. DO BEGIN


      IF (sqrt((xexp[j]-imgposs[0])^2+(yexp[j]-imgposs[1])^2) EQ m AND $
      expoflag[xexp[j]] GT 0.) THEN counts=counts+1



;   flagplus= where(expoflag[imgposs[0]+j,imgposs[1]+j] GT 0.,z1)


;  flagminus= where(expoflag[imgposs[0]-j,imgposs[1]-j] GT 0.,z2)



  counts=counts+z1+z2
  
ENDFOR

  cnt[m]=counts


ENDFOR
;stop

  yexp=yexp-imgposs[1]
  xexp=xexp-imgposs[0]
  rexp=sqrt(xexp^2+yexp^2)
                                ;stop
  expoarfrac=dblarr(125)

                                ;assume first 40 arcsec is always ok for 1E1742.
  expoarfrac[0:19]=1.

  maxradius=250.                ;in arcseconds


  FOR i=20., (maxradius/2.)-1. DO BEGIN
     rlim=where(rexp LT i)
     expoarfrac[i]=double(n_elements(rlim))/(!PI*double(i)^2.)
  ENDFOR


  return,expoarfrac

END
  
