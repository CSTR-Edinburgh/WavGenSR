% Computes the new sample positions according to the warping needed.
% vStrectPos in ms
% length of baseF0 must be greater than targF0
% It works only for strict voiced data.
function vBaseNewPosMs = GetStrecthPositions3(baseF0, targF0, baseFs, targFs, interpType)

targTsMs = 1000 / targFs;
baseTsMs = 1000 / baseFs;

bSpline = false;
if strcmp(interpType, 'spline')
    bSpline = true;
end

targF0Len = length(targF0);

if bSpline % case spline    
    pp = spline(1:targF0Len,targF0);
else % case linear
    vCurrIntPos = [ 0, 0 ];% alloc
    vCurrF0     = [ 0, 0 ]; % alloc
end

vBaseNewPosMs = zeros(length(baseF0),1);
for nxBs = 1:length(baseF0)
    
    currBaseF0 = baseF0(nxBs);
    nxTarg     = ( vBaseNewPosMs(nxBs) / targTsMs ) + 1;   % + 1 because of MATLAB indexing
    if nxTarg > targF0Len        
        break;
    end  

    if ~bSpline % case linear   
        vCurrIntPos(1) = floor(nxTarg);
        vCurrIntPos(2) = vCurrIntPos(1) + 1; 
        %vCurrIntPos = floor(nxTarg) + [ 0 , 1 ];
        
        %{
        if sum(vCurrIntPos < 1) > 0 % Protections
            currTargF0 = targF0(1);
        elseif sum(vCurrIntPos > length(targF0)) > 0 
            currTargF0 = targF0(end);
        else            
            vCurrF0 = targF0(vCurrIntPos);
            a = ( vCurrF0(1) - vCurrF0(2) ) / ( vCurrIntPos(1) - vCurrIntPos(2) );
            b = vCurrF0(1) - a * vCurrIntPos(1);        
            currTargF0 = a * nxTarg + b;        
        end
        %}
                
        vCurrF0(1) = targF0(vCurrIntPos(1));
        vCurrF0(2) = targF0(vCurrIntPos(2));
        a = ( vCurrF0(1) - vCurrF0(2) ) / ( vCurrIntPos(1) - vCurrIntPos(2) );
        b = vCurrF0(1) - a * vCurrIntPos(1);        
        currTargF0 = a * nxTarg + b;           
        
    else % case spline
        currTargF0 = ppval(pp,nxTarg);
    end
        
    currF0StchRatio = currTargF0 / currBaseF0;
    currTsStchRatio = 1 / currF0StchRatio;
    
    %{
    % In case of unvoiced (f0 = 0), there is not picth shifting, so both signals have the same pitch:   
    if (currBaseF0 < 1) || (currTargF0 < 1)
        currTsStchRatio = 1;     
    end
    %}
    
    
    vBaseNewPosMs(nxBs+1) = vBaseNewPosMs(nxBs) + currTsStchRatio * baseTsMs;
    
end
vBaseNewPosMs = vBaseNewPosMs(1:nxBs);



%% VER 1
%{


targTsMs = 1000 / targFs;
baseTsMs = 1000 / baseFs;

vBaseNewPosMs = zeros(length(baseF0),1);
for nxBs = 1:length(baseF0)
    
    DispProgress(nxBs, 10000, 'Stretch pos frame: ', length(baseF0));
    
    currBaseF0 = baseF0(nxBs);
    nxTarg     = ( vBaseNewPosMs(nxBs) / targTsMs ) + 1;   % + 1 because of MATLAB indexing
    if nxTarg > length(targF0)        
        break;
    end  

    vCurrIntPos = floor(nxTarg) + [ -1 , 0 , 1, 2 ];
    if sum(vCurrIntPos < 1) > 0 % Protections
        currTargF0 = targF0(1);
    elseif sum(vCurrIntPos > length(targF0)) > 0 
        currTargF0 = targF0(end);
    else
        vCurrF0 = targF0(vCurrIntPos);
        currTargF0  = interp1(vCurrIntPos,vCurrF0, nxTarg, 'spline');
        %currTargF0  = interp1(vCurrIntPos,vCurrF0, nxTarg);
        %currTargF0  = interp1(vCurrIntPos,targF0(vCurrIntPos), nxTarg, 'spline');
        
        
    end
    
    currF0StchRatio = currTargF0 / currBaseF0;
    currTsStchRatio = 1 / currF0StchRatio;
    
    % In case of unvoiced (f0 = 0), there is not picth shifting, so both signals have the same pitch:   
    if (currBaseF0 < 1) || (currTargF0 < 1)
        currTsStchRatio = 1;     
    end
           
    vBaseNewPosMs(nxBs+1) = vBaseNewPosMs(nxBs) + currTsStchRatio * baseTsMs;
    
end
vBaseNewPosMs = vBaseNewPosMs(1:nxBs);
%}
end