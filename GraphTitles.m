function GraphTitles(ti, xl, yl, zl, tiSize, lSize, mSize)
%GraphTitles
%Add the title, x label and y label to the graph and set font sizes
%GraphTitles(title, xlabel, ylabel, zlabel, titleSize, labelSize, markerSize)
%works with no definied zlabel
%if no sizes defined, uses standard 24, 22, 20

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