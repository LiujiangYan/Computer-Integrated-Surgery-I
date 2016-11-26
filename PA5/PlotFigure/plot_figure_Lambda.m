function plot_figure_Lambda(char)
    hold on;
    % draw the real time plot
    title(strcat('the real time plot of Lambda:',char));
    % x-axis label
    xlabel('iteration counts');
    % y-axis label
    ylabel('value of lambda'); 
end