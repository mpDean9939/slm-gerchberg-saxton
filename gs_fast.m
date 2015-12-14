% No convergence plot, no tolerance specification, uses GPU for most calculations

function gs_fast()
% Algorithm for calculating the phase and target approximation.
% Called from the trap_obj callback to update the phase and target
% approximation plots.
    global glb;

    % ---- GS algorithm ---- %

    % Initialize phase estimate
    hologram_phase = gpuArray.rand(glb.x_src,glb.y_src);

    % Iterate between fourier and image domains
    for k = 1:glb.num
        hologram              = glb.src_intensity .* exp(1i * hologram_phase); % get the current approximation in phasor form
        targ_approx           = fftshift(fft2 (hologram, glb.x_targ, glb.y_targ)); % optical fourier transform
        targ_approx_intensity = abs(targ_approx);     % current intensity at the target
        targ_approx_angle     = angle(targ_approx);   % current angle at the target
        targ_approx           = glb.TARGET .* exp(1i * targ_approx_angle); % update the approx with the desired target intensity
        hologram_approx       = ifftshift(ifft2 (fftshift(targ_approx), glb.x_src, glb.y_src)); % get the corresponding input to the approximation
        hologram_phase        = angle(hologram_approx); % new phase at the input plane
    end
    hologram_phase = phase_shift(hologram_phase);

    % ---- Update Plots ---- %

    % hologram phase
    p = duplicate_image(hologram_phase, 792, 600); %792x600: size of the SLM
    phase2 = gather(p/max(max(p)));
    set(glb.holo, 'cdata', phase2);

    % target intensity
    set(glb.ti, 'cdata', glb.TARGET);

    % target approximation intensity
    maxVal = max(max(targ_approx_intensity));
    targ_approx_intensity = targ_approx_intensity / maxVal;
    set(glb.tai, 'cdata', gather(targ_approx_intensity));

end
