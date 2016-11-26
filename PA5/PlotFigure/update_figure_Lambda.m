function update_figure_Lambda(iteration, Lambda)

    % plot the lambda
    plot(iteration, Lambda(1), 'yo','MarkerSize',6);
    plot(iteration, Lambda(2), 'm+','MarkerSize',6);
    plot(iteration, Lambda(3), 'c*','MarkerSize',6);
    plot(iteration, Lambda(4), 'r.','MarkerSize',6);
    plot(iteration, Lambda(5), 'gx','MarkerSize',6);
    plot(iteration, Lambda(6), 'bs','MarkerSize',6);
    
    % legend
    legend('\lambda_1','\lambda_2','\lambda_3','\lambda_4',...
        '\lambda_5','\lambda_6');
    
    drawnow;

end