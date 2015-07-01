classdef (HandleCompatible) Parameterized
    
    %% -----------------------------------------------------------------------------------
    properties (SetAccess = protected)
        parameters;
    end
    
    %% -----------------------------------------------------------------------------------
    properties (Access = private)
        inParser;
        setCallbacks;
    end

    %% -----------------------------------------------------------------------------------
    methods (Access = protected)

        function obj = Parameterized( parameterDefinitions )
            if ~isa( obj.inParser, 'inputParser' ) 
                obj.inParser = inputParser();
            end
            obj.inParser.StructExpand = true;
            for ii = 1 : length( parameterDefinitions )
                pd = parameterDefinitions{ii};
                obj.addParameterDefinition( pd );
            end
        end
        %% -------------------------------------------------------------------------------
        
        function obj = addParameterDefinition( obj, pd )
            obj.inParser.addParameter( pd.name, pd.default, pd.valFun );
            if isfield( pd, 'setCallback' )
                obj.setCallbacks.(pd.name) = pd.setCallback;
            end
        end

    end
    
    %% -----------------------------------------------------------------------------------
    methods (Access = public)

        function obj = setParameters( obj, setDefaults, varargin )
            obj.inParser.parse( varargin{:} );
            parameterNames = fieldnames( obj.inParser.Results );
            for ii = 1 : length( parameterNames )
                paramName = parameterNames{ii};
                hasUserSetParam = ~any( strcmp( paramName, obj.inParser.UsingDefaults ) );
                if hasUserSetParam || setDefaults
                    if isfield( obj.setCallbacks, paramName )
                        setCb = obj.setCallbacks.(paramName);
                        oldValue = [];
                        if isfield( obj.parameters, paramName )
                            oldValue = obj.parameters.(paramName);
                        end
                        setCb( obj, obj.inParser.Results.(paramName), oldValue );
                    end
                    obj.parameters.(paramName) = obj.inParser.Results.(paramName);
                else
                    continue;
                end
            end
        end
        %% -------------------------------------------------------------------------------
        
    end
    
end
