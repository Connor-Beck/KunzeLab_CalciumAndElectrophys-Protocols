function display_Electrodes(t,E,L,varargin)
switch nargin
    case 3
        for i=2:7
            subplot(8,8,i); plot(t,E{i-1});
        end
        for i=9:57
            subplot(8,8,i); plot(t,E{i-2});
        end
        for i=58:63
            subplot(8,8,i); plot(t,E{i-3});
        end
                
    case 4
        plot(t,E{L(varargin{1})})
    case 5
        subplot(2,1,1); plot(t,E{L(varargin{1})});
        subplot(2,1,2); plot(t,E{L(varargin{2})});
end


