function SaveFigure(figNo, fileName, aspX, aspY)
%SaveFigure
%Saves the specified figure to the specified filename
%
%Usage:
%SaveFigure(figureNumber, fileName)
%    Saves fullscreen figure
%SaveFigure(figureNumber, fileName, fileType, aspectRatioX, aspectRatioY)
%    Saves figure the largest possible size with given aspect ratio

curFig = figure(figNo);
screen = get(groot, 'Screensize');%get the screensize
switch(nargin)
    case 2
        set(curFig, 'Position', [1, 1, screen(3), screen(4)]);%set the figure size
    case 4
        mult = min(screen(3) / aspX, screen(4) / aspY);%find the minimum multiplier
        set(curFig, 'Position', [1, 1, mult*aspX, mult*aspY]);%set the figure size
    otherwise
        error('You have not entered enough parameters.');
end

set(figNo,'PaperPositionMode','auto');
saveas(curFig, fileName);
end
