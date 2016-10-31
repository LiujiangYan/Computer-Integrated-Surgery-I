function [pivot, g_1st_frame] = corrected_em_pivot_calibration...
                    (Ng, Nframes, G, C, qmax, qmin)                
    % undistorted
    G_expected = distortion_correct(G, C, qmax, qmin);
    % pivot calibration
    [pivot, g_1st_frame] = em_pivot_calibration(Ng, Nframes, G_expected);
end