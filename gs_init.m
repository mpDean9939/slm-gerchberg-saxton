function gs_init(m,n,d)
% First iteration of the complete GS algorithm, initializes trap objects
% and other parameters
    global glb;

    %**************************************************************************
    % target
    %**************************************************************************

    % initialize trap objects into grid, and target image
    N = 200;
    image = zeros(N);
    SQSZ = glb.sz; % trap size in pixels

    figure(3);
    trapIndex = 0;
    for i = 1:n
        for j = 1:m
            trapIndex = trapIndex + 1;
            glb.trap(trapIndex) = trap_obj(trapIndex, SQSZ, gca, N/2-(m+1)/2*d+i*d,N/2-(n+1)/2*d+j*d);

             ycords = round(N/2-(m+1)/2*d+i*d-SQSZ/2):round(N/2-(m+1)/2*d+i*d+SQSZ/2);
             xcords = round(N/2-(n+1)/2*d+j*d-SQSZ/2):round(N/2-(n+1)/2*d+j*d+SQSZ/2);
             image(xcords, ycords) = 1;
        end
    end
    glb.flag = true; % records that a set of trap objects has been initialized

    glb.TARGET = double(image); % target image
    [glb.x_targ,glb.y_targ] = size(glb.TARGET);
    glb.x_src=glb.x_targ;
    glb.y_src=glb.y_targ;

    %**************************************************************************
    % computation source
    %**************************************************************************
    I0 = 1;
    w0 = 100;     % minimum width, in grid
    w = 200;      % refer to position, in grid

    x_src = glb.x_targ; % x dimension
    y_src = glb.y_targ; % y dimension
    centroid = [round(x_src/2),round(y_src/2)];
    glb.src_intensity = zeros(x_src,y_src);
    for i = 1:x_src
        for j = 1:y_src
            r = ((i-centroid(1))^2+(j-centroid(2))^2)^0.5;
            glb.src_intensity(i, j) = I0*(w0/w)^2*exp(-2*r^2/w^2);
        end
    end

    % update source intensity
    imshow(glb.src_intensity, 'parent', glb.sub(2));
    title('source intensity');

    %**************************************************************************
    % Gerchberg and Saxton algorithm
    %**************************************************************************
    gs_fast(); % call the GS algorithm to update the approximation intensity

end
