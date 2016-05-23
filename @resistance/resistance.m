classdef resistance < matlab.mixin.SetGet
    properties       
    end
    
    properties (Dependent)
        type        
    end
    
    methods
        %% -- constructor -- %
        %  this is the base constructor method that builds the class
        %  note the error screening for supported rating specifications
        function rr = resistance()
            if nargin > 0
                if strcmp(spec,'LRFD') || strcmp(spec,'LFR')
                    rr.spec = spec;              
                else
                    error(['Not a valid rating specification. '...
                          'Use LRFD or LFR.'])
                end  
            end
        end         
        
    end
    
end