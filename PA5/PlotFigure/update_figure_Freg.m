function update_figure_Freg(iteration, max_error)
    % plot the error of points pair
    plot(iteration, max_error, 'r*','MarkerSize',6);
    drawnow;
end