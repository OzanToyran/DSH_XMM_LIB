PRO fourier_xmm_leahy,id=id

path                = id
type                = 'high'
maxdim              = 128L*32L
dim                 = 128L*32L
normindiv           = 0
;miyamoto            = 0
hfdtlev             = 1.97      ;dead time level in high frequency for Leahy
;schlittgen          = 0
leahy              = 1
xmm_bkg             = 0
nof                 = 1
logf                = 0.13
;ninstr              = 0
xmm_dt              = 1
fcut                = 32D
fmin                = 2D
fmax                = 127D
xmin                = [0.01,0.01,0.01]       &  xmax        = [32.,32.,32.]
ymin                = [1E-1,-4.,1E-2]        &  ymax        = [2,10.,1.]
xtenlog             = [1,1,1]
sym                 = [4,-3]
ebounds             = [[2,6],[2,6]]
obsid               = '1E1740otoyran/'+id
username            = 'Emrah Kalemci'
date                = systime(0)
color               = [50,50,50]
postscript          = 1
chatty              = 1

xmm_fourier,path,type=type, $
  maxdim=maxdim,dim=dim,normindiv=normindiv, $
  miyamoto=miyamoto,schlittgen=schlittgen, leahy=leahy, $
  dtlevhf=hfdtlev,$
  xmm_bkg=xmm_bkg,xmm_dt=xmm_dt, $
  linf=linf,logf=logf,nof=nof, $
  fmin=fmin,fmax=fmax,fcut=fcut, $
  xmin=plotxmin,xmax=plotxmax, $
  ymin=plotymin,ymax=plotymax, $
  xtenlog=plotxtenlog,ytenlog=plotytenlog,sym=plotsym, $
  ebounds=ebounds,obsid=obsid,username=username,date=date, $
  color=plotcolor,postscript=postscript,chatty=chatty




END
