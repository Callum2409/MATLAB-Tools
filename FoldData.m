function FoldData(x, y, e)
%FoldData
%Will produce a figure window with two plots
%The top contains the full data range
%The bottom is zoomed in on the range so a closest fit can be obtained
%A second window shows the number of folds and sliders to alter the value
%
%Usage:
%FoldData(x, y)
%    Folds the data with no error bars
%FoldData(x, y, e)
%    Folds the data and includes an error bar

nFolds = 1;
maxFolds = 25;
maxBeforeScroll = 6;
args = nargin;
%create the figure, make not visible so can populate
close all;
screen = get(groot, 'Screensize');%get the screensize

options = figure('Visible','on','Units', 'normalized', 'Position',[.2, .4, .2, .4], ...
    'Name', 'Fold data', 'NumberTitle', 'off', ...
    'MenuBar', 'none', 'ToolBar', 'none', 'Resize', 'off', ...
    'WindowScrollWheelFcn', @scroll_wheel);

graph = figure;

defaultColours = get(gca,'colororder');

pNF = uipanel('Parent', options, 'Title', 'Number of folds', 'TitlePosition', 'centertop', ...
    'FontSize', 14, 'Position',[.25 .99-.15 .5 .15]);

pNFArea = screen.*options.Position.*pNF.Position;%get the size in pixels of the panel
bWidth = pNFArea(4)-2*pNF.FontSize-2;%the button width
left = (1-((3*bWidth)/pNFArea(3)))/2;%work out the left insert for horizontal centering

minus = uicontrol('Parent', pNF, 'Style', 'pushbutton', ...
    'String', '-', 'FontSize', 12, ...
    'HorizontalAlignment', 'center', ...
    'Units', 'normalized', 'Position', [left, 2/bWidth, bWidth/pNFArea(3),(1-2/pNFArea(4))-.02], ...
    'Callback',@minus_Callback);

number = uicontrol('Parent', pNF, 'Style', 'text', ...
    'String', nFolds, 'FontSize', 14, ...
    'Units', 'normalized', 'Position', [left+minus.Position(3), 2/bWidth, bWidth/pNFArea(3),.8]);

plus = uicontrol('Parent', pNF, 'Style', 'pushbutton', ...
    'String', '+', 'FontSize', 12, ...
    'Units', 'normalized', 'Position', [number.Position(1)+number.Position(3), 2/bWidth, bWidth/pNFArea(3),(1-2/pNFArea(4))-.02], ...
    'Callback',@plus_Callback);

align([minus, number, plus], 'VerticalAlignment', 'Middle');

pTitles = uipanel('Parent', options, 'Title', 'Titles', 'FontSize', 14, 'Position', [.01, .52, .98, .3]);

uicontrol('Parent', pTitles, 'Style', 'text', ...
    'String', 'Title:', 'FontSize', 14, ...
    'Units', 'normalized', 'Position', [.01, .64, .25, .3]);

title = uicontrol('Parent', pTitles, 'Style', 'edit', ...
    'String', '', 'FontSize', 12, ...
    'Units', 'normalized', 'Position', [.27, .69, .72, .3], 'Callback', @drawGraphs);

uicontrol('Parent', pTitles, 'Style', 'text', ...
    'String', 'X Label:', 'FontSize', 14, ...
    'Units', 'normalized', 'Position', [.01, .3, .25, .3]);

xlabel = uicontrol('Parent', pTitles, 'Style', 'edit', ...
    'String', '', 'FontSize', 12, ...
    'Units', 'normalized', 'Position', [.27, .35, .72, .3], 'Callback', @drawGraphs);

uicontrol('Parent', pTitles, 'Style', 'text', ...
    'String', 'Y Label:', 'FontSize', 14, ...
    'Units', 'normalized', 'Position', [.01, -.04, .25, .3]);

ylabel = uicontrol('Parent', pTitles, 'Style', 'edit', ...
    'String', '', 'FontSize', 12, ...
    'Units', 'normalized', 'Position', [.27, .01, .72, .3], 'Callback', @drawGraphs);

pSliders = uipanel('Parent', options, 'Title', '', 'FontSize', 14, 'Position', [.01, .01, .98, .5]);

scrollSize = (nFolds-1)*0.2+0.2;
pScroll= uicontrol('Visible', 'off', 'Parent', pSliders, 'Style', 'slider', ...
    'Units', 'normalized', 'Position', [.94,.01,.05,.98], ...
    'Max', 0, 'Callback', @drawSliders);

for s = 1:maxFolds
    pos(s) = uicontrol('Visible', 'off', 'Parent', pSliders, 'Style', 'edit', 'String', s, ...
        'Units', 'normalized', 'FontSize', 12, 'Callback', @editedPos, 'Tag', sprintf('%i', s));
    
    range = max(x)-min(x);
    
    sliders(s) = uicontrol('Visible', 'off', 'Parent', pSliders, 'Style', 'slider', ...
        'Units', 'normalized', 'Min', -range, 'Max', range, 'Callback', @drawGraphs);
    addlistener(sliders(s),'Value','PreSet',@drawGraphs);
    
    cols(s) = uicontrol('Visible', 'off', 'Parent', pSliders, 'Style', 'pushbutton', ...
        'Units', 'normalized', 'BackgroundColor', defaultColours(mod(s, length(defaultColours))+1, :), 'Callback', @colour_Callback);
    
end

drawSliders();

    function minus_Callback(~,~)
        %only decrease if nFolds greater than 1
        if nFolds > 1
            nFolds = nFolds-1;
        end
        
        number.String = nFolds;%update the number string
        drawSliders();
    end

    function plus_Callback(~,~)
        if nFolds < maxFolds
            nFolds = nFolds+1;
            sliders(nFolds).Value = 0;
            cols(nFolds).BackgroundColor = defaultColours(mod(nFolds, length(defaultColours))+1, :);
        end
        
        number.String = nFolds;%update the number string
        drawSliders();
    end

    function drawSliders(~,~)
        scrollSize = max((nFolds-maxBeforeScroll-1)*.15+0.1, 0);
        pScroll.Min = -scrollSize;
        pScroll.SliderStep = [1/nFolds, 1/nFolds];
        
        %make sure the slider is within a valid range
        pScroll.Value = max(pScroll.Value, -scrollSize);
        pScroll.Value = min(pScroll.Value, 0);
        
        if nFolds > maxBeforeScroll % if bigger than the panel, then have a scroll bar
            pScroll.Visible = 'on';
        else
            pScroll.Visible = 'off';
        end
        
        for s = 1:maxFolds
            pos(s).Position = [.01, 1.03-s*.15-pScroll.Value, .2, .1];
            sliders(s).Position = [.22, 1.03-s*.15-pScroll.Value, .5, .1];
            cols(s).Position = [.73, 1.03-s*.15-pScroll.Value, .2, .1];
            
            if s<=nFolds
                pos(s).Visible = 'on';
                sliders(s).Visible = 'on';
                cols(s).Visible = 'on';
            else
                pos(s).Visible = 'off';
                sliders(s).Visible = 'off';
                cols(s).Visible = 'off';
            end
        end
        
        drawGraphs();
    end

    function scroll_wheel(~,data)
        pScroll.Value = pScroll.Value - data.VerticalScrollCount/nFolds;
        
        drawSliders();
    end

    function colour_Callback(src, ~)
        col = uisetcolor;
        src.BackgroundColor = col;
        drawGraphs();
    end

    function drawGraphs(~,~)
        figure(graph);
        clf('reset');
        
        subplot(2, 1, 1);
        GraphTitles(title.String, xlabel.String, ylabel.String);
        hold on;
        if args == 3
            errorbar(x, y, e);
        else
            plot(x, y);
        end
        
        subplot(2, 1, 2);
        GraphTitles(strcat(title.String,' zoom'), xlabel.String, ylabel.String);
        hold on;
        if args == 3
            errorbar(x, y, e);
        else
            plot(x, y);
        end

        for g = 1:nFolds
            for sub = 1:2
                subplot(2, 1, sub);
                pos(g).String = sprintf('%.3f', sliders(g).Value);
                
                if args == 3
                    errorbar(x+sliders(g).Value, y, e, 'Color', cols(g).BackgroundColor);
                else
                    plot(x+sliders(g).Value, y, 'Color', cols(g).BackgroundColor);
                end
            end
        end
        
        subplot(2, 1, 2);
        minLim = min(x)+max(minSlider, 0);
        maxLim = max(x)+min(maxSlider, 0);
        xlim([minLim, max(maxLim, minLim + range/100)]);
        
        figure(options);
    end

    function editedPos(src, ~)
        src.String = min(str2double(src.String), range);
        src.String = max(str2double(src.String), -range);
        
        sliders(str2double(src.Tag)).Value = str2double(src.String);
        drawGraphs();
    end

    function minVal =  minSlider
        minVal = sliders(1).Value;
        
        if nFolds == 1
            return;
        end
        
        for sli = 2:nFolds
            if sliders(sli).Value < minVal
                minVal = sliders(sli).Value;
            end
        end
    end

    function maxVal =  maxSlider
        maxVal = sliders(1).Value;
        
        if nFolds == 1
            return;
        end
        
        for sli = 2:nFolds
            if sliders(sli).Value > maxVal
                maxVal = sliders(sli).Value;
            end
        end
    end
end