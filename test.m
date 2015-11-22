function [runningcode]= test(r0,y1,y2,shells,height,layerheight,botlayer,maxfeedrate,startCode,nozzlewidth) 
f = 1
runningcode = startCode;
totallayers = floor(height/layerheight);
f = 2
%start extruding and move theta to all 360 degree positions, from 0 to 359 at that R extruding at rate determined by radius
for layernumber = 0
  if layernumber == 0
    Rmax = r0+y1*(layernumber*layerheight)+y2*(layernumber*layerheight)^2; %find radius max
    runningcode = strcat(runningcode,"\n", "G0", "\n", "X", num2str(Rmax) , "Y0");%move R axis [X to max radius]
    runningcode = strcat(runningcode,"\n", "G0 Z0","\n","F",num2str(maxfeedrate));%place Z to correct height, set extrusion rate
    shellcount = floor(Rmax/nozzlewidth)
    for shell = 0:shellcount-1
      R=r0+y1*(layernumber*layerheight)+y2*(layernumber*layerheight)^2 - shell*nozzlewidth;
      thetadist = 2*pi*R/360
      
      for theta = 0:5
        runningcode = strcat(runningcode,"\n","G1 Y", num2str(theta), " E",num2str(thetadist)) ;
      endfor
      if shell == (shellcount-1)
        runningcode = strcat(runningcode,"\n","G0 Z",num2str((layernumber+1)*layerheight));
      endif
    endfor
  endif
endfor
runningcode = strcat(runningcode, "\n","GO Z",num2str(layerheight*totallayers+10));
endfunction