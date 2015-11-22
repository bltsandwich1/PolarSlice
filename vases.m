%vases.m
%John Moosemiller
%11/21/15
%make Vases in Octave
%Make a Vase using EQN
%Inputs:
function [runningcode]= vases(r0,y1,y2,shells,height,layerheight,botlayer,maxfeedrate,startCode,nozzlewidth) 
runningcode = startCode;
totallayers = floor(height/layerheight);
%start extruding and move theta to all 360 degree positions, from 0 to 359 at that R extruding at rate determined by radius
for layernumber = 0:totallayers-1
  if layernumber == 0
    Rmax = r0+y1*(layernumber*layerheight)+y2*(layernumber*layerheight)^2; %find radius max
    runningcode = strcat(runningcode,"\n", "G0", " X", num2str(Rmax) , " Y0");%move R axis [X to max radius]
    runningcode = strcat(runningcode,"\n", "G0 Z0","\n","F",num2str(maxfeedrate));%place Z to correct height, set extrusion rate
  endif
  if layernumber < botlayer
    Rmax = r0+y1*(layernumber*layerheight)+y2*(layernumber*layerheight)^2; %find radius max
    shellcount = floor(Rmax/nozzlewidth);
    for shell = 0:shellcount-2
      R=r0+y1*(layernumber*layerheight)+y2*(layernumber*layerheight)^2 - shell*nozzlewidth;
      thetadist = 2*pi*R/360;
      if shell == 0
      runningcode = strcat(runningcode,"\n","G0 X", num2str(R));
      endif
      for theta = [0 1 2 358 359]
        runningcode = strcat(runningcode,"\n","G1 Y", num2str(theta), " E",num2str(thetadist)) ;
        if theta == 359
          R=r0+y1*(layernumber*layerheight)+y2*(layernumber*layerheight)^2 - (shell+1)*nozzlewidth;
          runningcode = strcat(runningcode,"\n","G0 X",num2str(R));
        endif
      endfor
      if shell == (shellcount-1)
        runningcode = strcat(runningcode,"\n","G0 Z",num2str((layernumber+1)*layerheight));
      endif
    endfor
  else
    Rmax = r0+y1*(layernumber*layerheight)+y2*(layernumber*layerheight)^2; %find radius max
    for shell = 0:shells-1
      R=r0+y1*(layernumber*layerheight)+y2*(layernumber*layerheight)^2 - shell*nozzlewidth;
      thetadist = 2*pi*R/360;
      if shell == 0
      runningcode = strcat(runningcode,"\n","G0 X", num2str(R));
      endif
      for theta = [0 1 2 357 358 359]
        runningcode = strcat(runningcode,"\n","G1 Y", num2str(theta), " E",num2str(thetadist)) ;
        if theta == 359
          R=r0+y1*(layernumber*layerheight)+y2*(layernumber*layerheight)^2 - (shell+1)*nozzlewidth;
          runningcode = strcat(runningcode,"\n","G0 X",num2str(R));
        endif
      endfor
      if shell == (shells-1)
        runningcode = strcat(runningcode,"\n","G0 Z",num2str((layernumber+1)*layerheight));
      endif
    endfor
  endif
endfor
runningcode = strcat(runningcode, "\n","GO Z",num2str(layerheight*totallayers+10))
endfunction