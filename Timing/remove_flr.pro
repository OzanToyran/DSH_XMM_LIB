pro remove_flr,file,time,rate,error
  
  time=loadcol(file,'TIME',ext=1)
  rate=loadcol(file,'RATE',ext=1)
  error=loadcol(file,'ERROR',ext=1)


  index=where((time LE time(0)+11000.0) OR (time GE time(0)+14000.0))

  time=time(index)
  error=error(index)
  rate=rate(index)

  noflrlc='/mdata1/shared/ozantoyran/ekalemci/pn_reanalysis/central_removed_spectrums/'
  num=strlen(file)-3
  outlc=noflrlc+strmid(file,0,num)+'_noflr.lc'
  filename=string(outlc(0))
  writelc,time,rate,error,filename
  
 end
