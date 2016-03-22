function GraphTitles(ti, xl, yl, zl, tiSize, lSize, mSize)
%GraphTitles
%Add the title, x label and y label to the graph and set font sizes
%If no sizes defined, uses a standard sizing of 24, 22, 20
%
%Usage:
%GraphTitles(title, xlabel, ylabel)
%    Will use standard sizing
%GraphTitles(title, xlabel, ylabel, zlabel)
%    Includes z axis label and uses standard sizing
%GraphTitles(title, xlabel, ylabel, titleSize, labelSize, markerSize)
%    No z axis label, but custom label sizes
%GraphTitles(title, xlabel, ylabel, zlabel, titleSize, labelSize, markerSize)
%    Includes z axis label and custom axis sizing

switch(nargin)
    case 3
        GraphTitles(ti, xl, yl, '', 24, 22, 20);
        return;
    case 4
        GraphTitles(ti, xl, yl, zl, 24, 22, 20);
        return;
    case 6
        [mSize, lSize, tiSize] = deal(lSize, tiSize, zl);
    case 7
        zlabel(zl, 'FontSize', lSize);
end

title(ti, 'FontSize', tiSize);
xlabel(xl, 'FontSize', lSize);
ylabel(yl, 'FontSize', lSize);
set(gca,'FontSize', mSize);
grid on;
%grid minor;
end