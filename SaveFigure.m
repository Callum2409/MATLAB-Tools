function SaveFigure(figNo, fileName, aspX, aspY)
%SaveFigure
%Saves the specified figure to the specified filename
%SaveFigure(figureNumber, fileName, fileType, aspectRatioX, aspectRatioY)
%works if no aspect ratio specified

curFig = figure(figNo);

switch(nargin)
    case 4
        screen = get(groot, 'Screensize');%get the screensize
        mult = min(screen(3) / aspX, screen(4) / aspY);%find the minimum multiplier
        set(curFig, 'Position', [1, 1, mult*aspX, mult*aspY]);%set the figure size
    case 2
        
    otherwise
        error('You have not entered enough parameters. Please think about your life choices very carefully.');
end

set(figNo,'PaperPositionMode','auto');
saveas(curFig, fileName);
end
