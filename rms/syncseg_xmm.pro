PRO syncseg_xmm,id=id

path                = id
channels            = ['2-6','2-6']
;hexte               = 1
;bkg                 = 1
;novle               = 1
orgbin              = [-5D0,-5D0]
newbin              = [1L,1L]
dseg                = 128L*32L
obsid               = '1E1740ozan'+id
username            = 'Emrah Kalemci'
date                = systime(0)
chatty              = 1

xmm_syncseg,path,channels,$
  orgbin=orgbin,newbin=newbin,dseg=dseg, $
  obsid=obsid,username=username,date=date, $
  chatty=chatty

END
