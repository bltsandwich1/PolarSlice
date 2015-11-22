%drawn.m
%John Moosemiller
%11/21/15
%make Vases in Octave
%Make a Vase using EQN
%Inputs:
function [runningcode]= drawn(shells,layerheight,botlayer,maxfeedrate,startCode,nozzlewidth,filename) 
image = imread(filename);
imageg = image(:,:,1);
[m,n] = size(imageg);
Rs = zeros(m,1);
for i = 1:m
  for j = 1:n
    if imageg(i,j) == 0
      Rs(i) = j;
    endif
  endfor
endfor

runningcode = startCode;

Rs = flipud(Rs);
runningcode = strcat(runningcode,"\n", "G0", " X", num2str(Rs(1)) , " Y0");
runningcode = strcat(runningcode,"\n", "G0 Z0","\n","F",num2str(maxfeedrate));
for layernumber = 1:n
  for shell = 0:shells-1
    R=Rs(layernumber)-shell*nozzlewidth;
    thetadist = 2*pi*R/360;
    if shell == 0
    runningcode = strcat(runningcode,"\n","G0 X", num2str(R));
    endif
    for theta = [0 1 2 358 359]
      runningcode = strcat(runningcode,"\n","G1 Y", num2str(theta), " E",num2str(thetadist)) ;
      if theta == 359
        R=Rs(layernumber) - (shell+1)*nozzlewidth;
        runningcode = strcat(runningcode,"\n","G0 X",num2str(R));
      endif
    endfor
    if shell == (shells-1)
      runningcode = strcat(runningcode,"\n","G0 Z",num2str((layernumber+1)*layerheight));
    endif
  endfor
endfor

runningcode = strcat(runningcode, "\n","GO Z",num2str(layerheight*m+10))
endfunction