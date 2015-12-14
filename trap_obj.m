% Usage: trap_obj(trap index, trap size, axis, x_coord, y_coord,)

% impoint methods (for reference)
%{
        addNewPositionCallback     le
        addlistener                lt
        createMask                 ne
        delete                     notify
        eq                         removeNewPositionCallback
        findprop                   resume
        ge                         setColor
        getColor                   setConstrainedPosition
        getPosition                setPosition
        getPositionConstraintFcn   setPositionConstraintFcn
        gt                         setString
        impoint                    wait
        isvalid
%}

classdef trap_obj < impoint
% object for a single optical trap
    properties
        trap_sz % size of the trap in pixels
        prevPos % previous position of the trap
        index   % index in the array containing all trap objects
    end

    methods
        function obj = trap_obj(index, sz, varargin) % varargin = axis, x, y
            obj = obj@impoint(varargin{:}); % call impoint constructor

            obj.trap_sz = sz;
            obj.prevPos = obj.getPosition;
            obj.index = index;

            % Make new callback for drawing trap positions
            addNewPositionCallback(obj, @(pos) obj.drawPoint(pos));

            % Boundary constraint function (prevents from dragging the
            % trap object outside of the figure window)
            bdn = makeConstrainToRectFcn('impoint',...
                get(gca,'XLim')+obj.trap_sz*[2 -2],...
                get(gca,'YLim')+obj.trap_sz*[2 -2]);

            % Enforce boundary constraint
            setPositionConstraintFcn(obj,bdn);

        end

        % draws the trap object on dependent plots
                % Updates position data and most recently clicked
                % Calls GS algorithm to update the hologram
       function drawPoint(obj, pos)
            global glb;

            SqSz = glb.sz;

            prevX = round(obj.prevPos(2)-SqSz/2):round(obj.prevPos(2)+SqSz/2); % previous x coordinates
            prevY = round(obj.prevPos(1)-SqSz/2):round(obj.prevPos(1)+SqSz/2); % previous y coordinates
            glb.TARGET(prevX,prevY) = 0;

            currX = round(pos(2)-SqSz/2):round(pos(2)+SqSz/2); % current x coordinates
            currY = round(pos(1)-SqSz/2):round(pos(1)+SqSz/2); % current y coordinates
            glb.TARGET(currX, currY) = 1;
            obj.prevPos = pos; % update the previous position
            glb.recent = obj.index; % mark this trap object as the most recently clicked
            gs_fast();
        end

        % Deletes the trap object from the control figure, and updates
        % dependent fields and figures
        function deletePoint(obj)
            global glb;
            if obj.isvalid
                pos = obj.getPosition;
                SqSz = glb.sz;

                currX = round(pos(2)-SqSz/2):round(pos(2)+SqSz/2);
                currY = round(pos(1)-SqSz/2):round(pos(1)+SqSz/2);
                glb.TARGET(currX, currY) = 0;
                glb.recent = -1;
                obj.delete;
                gs_fast();
            end
        end

    end
end





