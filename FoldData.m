function FoldData( x, y, e, reflect, ti, xl, yl)
%DATAFOLDER
%fold the data with a scroll bar, allowing the graph to be shifted
%also allow reflection instead

close all;
shift = mean([min(x), max(x)]);
monitorSize = get(0, 'MonitorPositions');

switch nargin
    case 2
        FoldData(x, y, -1, 0);
        return;
    case 3
        FoldData(x, y, e, 0);
        return;
    case 4
        [ti, xl, yl] = deal('','','');
    case 6
        [reflect, ti, xl, yl] = deal(e, reflect, ti, xl);%reassign the variables if no error
        e = -1; %set to -1 so can check if exists
end

figNo = figure('units','normalized','outerposition',[.1 .1 .8 .8]);
plotter();

    function moveGraph(source, ~)
        shift = get(source,'Value');
        plotter();
    end

    function plotter
        clf('reset');
        figSize = get(gcf,'Position');
        
        uicontrol(figNo,'Style','slider',...
            'Min',min(x),'Max',max(x),'Value',shift,...
            'SliderStep',[0.001 0.01],...
            'Position',[0 0 monitorSize(3)*figSize(3) 30],...
            'callback', @moveGraph);
        
        subplot(2,1,1);
        hold on;
        
        plotGraphs();
        
        hold off;
        GraphTitles(ti, xl, yl);
        text(0, -0.25, sprintf('shift: %0.2f', shift), 'Units', 'normalized', 'FontSize', 22)
        
        subplot(2,1,2);
        hold on;
        
        plotGraphs();
        
%        if reflect == 0
%            xlim([x(1), x(end)-shift]);
%        else
%            xlim([0, x(end)-shift]);
%        end
        hold off;
        GraphTitles('Folded data', xl, yl);
    end

    function plotGraphs
        if reflect == 0
            if e ~= -1
                errorbar(x, y, e, 'b');
                errorbar(x-shift, y, e, 'r');
            else
                plot(x, y, 'b');
                plot(x-shift, y, 'r');
            end
        else
            if e ~= -1
                errorbar(abs(x-shift), y, e, 'r');
            else
                plot(abs(x+shift), y, 'r');
            end
        end
    end
end

