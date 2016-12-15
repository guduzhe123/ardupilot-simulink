function blkStruct = slblocks 
  
%SLBLOCKS Defines a block library. 
  
% Library's name. The name appears in the Library Browser's 
% contents pane. 

blkStruct.Name = ['Flight_control' sprintf('\n') 'Ehang'];   % 模块库的显示名称  

% The function that will be called when the user double-clicks on 
% the library's name. ; 

blkStruct.OpenFcn = 'Lib_FlightControl';   %自定义的模块库名称 

% The argument to be set as the Mask Display for the subsystem. You 
% may comment this line out if no specific mask is desired. 
% Example: blkStruct.MaskDisplay = 
'plot([0:2*pi],sin([0:2*pi]));'; 
% No display for now. 

% blkStruct.MaskDisplay = ''; 

% End of blocks  
