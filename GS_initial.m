function GS_initial(m,n,d)
% First iteration of the complete GS algorithm, initializes trap objects 
% and other parameters
    global glb; 
    
    % source parameters
    I0=1;
    w0=100;     % minimum width, in grid
    w=200;      % refer to position, in grid
    
      

    %**************************************************************************
    % target
    %**************************************************************************
    % initialize trap objects and target
    N=200;
    image=zeros(N);
    SQSZ = glb.sz;
    
    figure(3);
    v = 0;
    for i=1:m
        for j=1:n
            v = v + 1;
            glb.trap(v) = trap_obj(SQSZ, gca, N/2-(m+1)/2*d+i*d,N/2-(n+1)/2*d+j*d);
            xcords = round(N/2-(m+1)/2*d+i*d-SQSZ/2):round(N/2-(m+1)/2*d+i*d+SQSZ/2);
            ycords = round(N/2-(n+1)/2*d+j*d-SQSZ/2):round(N/2-(n+1)/2*d+j*d+SQSZ/2);
            image(xcords, ycords) = 1;
        end
    end
    glb.flag = true;

    glb.TARGET = double(image); 
    [glb.x_target,glb.y_target] = size(glb.TARGET);
    glb.src_grid=[792,600];
    glb.x_src=glb.x_target;
    glb.y_src=glb.y_target;

    %**************************************************************************
    % computation source
    %**************************************************************************
    x_src=glb.x_target;
    y_src=glb.y_target;
    centroid=[round(x_src/2),round(y_src/2)];
    glb.src_intensity=zeros(x_src,y_src);
    for i=1:x_src
        for j=1:y_src
            r=((i-centroid(1))^2+(j-centroid(2))^2)^0.5;
            glb.src_intensity(i,j)=I0*(w0/w)^2*exp(-2*r^2/w^2);
        end
    end
    
    % source intensity
    imshow(glb.src_intensity, 'parent', glb.sub(2));
    title('source intensity');


    %**************************************************************************
    % Gerchberg and Saxton algorithm
    %**************************************************************************
    GS_alg_fast_gpu();

end