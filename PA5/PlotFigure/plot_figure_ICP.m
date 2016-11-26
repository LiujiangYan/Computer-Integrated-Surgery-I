function plot_figure_ICP(char)
    hold on;
    % draw the real time plot
    title(strcat('the real time plot of residual error of data set:',char));
    % x-axis label
    xlabel('ICP iteration counts');
    % y-axis label
    ylabel(' maximum points pair error'); 
end