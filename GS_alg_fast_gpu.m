% No convergence plot, no tolerance specification, uses GPU for most
% calculations

function GS_alg_fast_gpu()
% Algorithm for calculating the phase and target approximation.
% Also called from the trap_obj callback to update the phase and target
% approximation plots.
    global glb;
    
    % all dependent calculations done on gpu 
    hologram_phase = gpuArray.rand(glb.x_src,glb.y_src); 
    
    for k = 1:glb.num   
        hologram = glb.src_intensity .* exp(1i * hologram_phase);
        target_approximation = fftshift(fft2 (hologram, glb.x_target, glb.y_target));
        target_approximation_intensity = abs(target_approximation);
        target_approximation_angle = angle(target_approximation);
        
        target_approximation = glb.TARGET .* exp(1i * target_approximation_angle);        
        hologram_approximation = ifftshift(ifft2 (fftshift(target_approximation), glb.x_src, glb.y_src));
        hologram_phase = angle(hologram_approximation);
    end
 
    hologram_phase = phase_shift(hologram_phase);

    % ---- Update Plots ---- 
    
    % hologram phase
    p = duplicate_image(hologram_phase, 792, 600); %792x600: hardware dependent parameter
    phase2 = gather(p/max(max(p)));
    set(glb.holo, 'cdata', phase2); 
    
    % target intensity   
    set(glb.ti, 'cdata', glb.TARGET);

    % target approximation intensity
    maxVal = max(max(target_approximation_intensity));
    target_approximation_intensity = target_approximation_intensity / maxVal;
    set(glb.tai, 'cdata', gather(target_approximation_intensity));

end