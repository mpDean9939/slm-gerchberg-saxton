function slm_gui()
% Enter parameters into Figure 1, separated by commas or spaces, for instance:
%
%  1, 20, 4, 4, 10
%  or
%  1 20 4 4 10
%
% The parameters have the following interpretation:
%
%       'trap size' : the width and height of the trap, in pixels
%
%       'iterations' : the number of iterations used in the
%           approximation algorithm (Gerchberg-Saxton)
%
%       'rows' and 'columns' : the number of rows and columns in the initial
%           arrangement of traps
%
%       'distance' : the distance in pixels between traps in the initial
%           arrangement
%
% Key presses do the following:
%
%       'e' : Enables a cursor, that adds a new trap upon left-click. Press
%          'enter' to escape without adding a trap.
%
%       'w' 'a' 's' 'd' : Moves the most recently clicked trap by 1 pixel
%
%       'backspace' : Deletes the most recently clicked trap
%

    % initializes GUI figures, along with figure positions & properties
    global glb; % struct to store data across functions
    close all;

    glb.flag = false;

    % make figure handles
    glb.f(1) = figure('visible', 'off');
    glb.f(2) = figure('visible', 'off');
    glb.f(3) = figure('visible', 'off');
    glb.f(4) = figure('visible', 'off');

    % make subplot handles (for updating plots in other functns)
    figure(2);
        % glb.sub(1) = subplottight(2,2,1); <- unused subplot
    glb.sub(2) = subplottight(2,2,2); % source intensity
    glb.sub(3) = subplottight(2,2,3); % target intensity
        glb.ti = imshow(zeros(200,200));
    glb.sub(4) = subplottight(2,2,4); % target approx. intensity
        glb.tai = imshow(zeros(200,200)); %

    % get screen parameters
    scnsize = get(0,'ScreenSize');
    left = 0.65*scnsize(3);
    bottom = 0.3*scnsize(4);
    width = scnsize(3) - left - 10;
    height = width;

    % set figure 1 (parameter control)
    set(glb.f(1),'Position', [left-width/2, bottom+380,250,60]);

    hparams = uicontrol('Style','edit','Position',[15,15,200,20],...
        'Callback',{@params_Callback},...
        'parent', glb.f(1));
    htext1 = uicontrol('Style','text','String',...
        'trap size,iterations,rows,columns,distance',...
        'Position',[9,40,225,15],...
        'parent', glb.f(1));

    % set figure 2 (target, targ. approx, and source)
    set(glb.f(2),'position',...
            [left bottom width height],...
            'Renderer', 'zbuffer');

    % set figure 3 (control figure)
    figure(3);
    imshow(zeros(200,200), 'border', 'tight');
    set(glb.f(3), 'position', [left bottom+height/2 width/2 height/2],...
                  'KeyPressFcn', @keyPress_Callback);
            %      'WindowButtonDownFcn', @click_Callback);

    % set figure 4 (hologram phase)
    figure(4);
    lcSz = [600 792];
    glb.holo = imshow(zeros(lcSz), 'border', 'tight'); % stores hologram data
    set(glb.f(4), 'position', [scnsize(3)-lcSz(2) bottom-50 lcSz(2) lcSz(1)],...
                  'Renderer', 'zbuffer');

    % set rendering properties for image objects
    set(glb.holo, 'EraseMode', 'none');
    set(glb.ti, 'EraseMode', 'none');
    set(glb.tai, 'EraseMode', 'none');

    % show all figures;
    figure(4);
    figure(2);
    figure(3);
    figure(1);

    % callback function for parameter control (on fig 1)
    function params_Callback(source, eventdata)
        t = num2cell(str2num(get(source, 'String')));
        [glb.sz, glb.num, m, n, d] = deal(t{:}); % 'sz' : the trap size, in pixels
                                                 % 'num' : number of iterations for the GS algorithm
                                                 % 'm' : # of rows
                                                 % 'n' : # of columns
                                                 % 'd' : distance between traps, in pixels
        % clears old trap objects
        if glb.flag == true
            for i = 1:length(glb.trap)
                glb.trap(i).deletePoint;
            end
        end

        gs_init(m, n, d);
    end

    % callback function for key presses (on fig 3)
    function keyPress_Callback(source, eventdata)
        glb.stepSz = 1; % set constant for testing
        key = eventdata.Key;
        mostRecent = glb.recent;

        switch key
            % moves the most recently clicked trap by the stepSz, in pixels
            case {'w', 'a', 's', 'd'}
                if mostRecent >= 0
                    currentPos = glb.trap(mostRecent).getPosition;
                    step = str2matrix(key, glb.stepSz);
                    glb.trap(mostRecent).setPosition(currentPos+step);
                end
            % deletes the most recently clicked trap
            case 'backspace'
                if mostRecent >= 0
                    glb.trap(mostRecent).deletePoint;
                end
            % enables a cursor and adds a trap upon clicking. 'enter' to escape
            case 'e'
                [x,y] = ginput(1); % gets cursor position upon clicking
                trapIndex = length(glb.trap) + 1;
                glb.trap(trapIndex) = trap_obj(trapIndex, glb.sz, gca, x, y);
                glb.trap(trapIndex).drawPoint([x,y]);
        end
    end

end

