function out = str2matrix(key, constant) 
        switch key 
            case 'w'
                out = [0 -constant];
            case 'a'
                out = [-constant 0];
            case 's'
                out = [0 constant];
            case 'd'
                out = [constant 0];
        end
    end