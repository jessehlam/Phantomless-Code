% MULTILAYERTISSUEINPUT Defines the input data for multi-layer tissue
classdef MultiLayerTissueInput < handle % deriving from handle allows us to keep a singleton around (reference based) - see Doug's post here: http://www.mathworks.com/matlabcentral/newsreader/view_thread/171344
    properties
        LayerRegions = struct(...
            'ZRange', ...
            {...
                [-Inf, 0], ...
                [0, 100], ...
                [100, +Inf] ...
            }, ...
            'RegionOP', ...
            {...
                [0.0, 1e-10, 1.0, 1.0], ...
                [0.0, 1.0, 0.8, 1.4], ...
                [0.0, 1e-10, 1.0, 1.0] ...
                } ...
            ); 
    end
    
    methods (Static)
        function input = FromInputNET(inputNET)
            input = MultiLayerTissueInput;
            for i=1:inputNET.Regions.Length
                regions(i).ZRange = [...
                    inputNET.Regions(i).ZRange.Start, ...
                    inputNET.Regions(i).ZRange.Stop ...
                    ];
                regions(i).RegionOP = [ ...
                    inputNET.Regions(i).RegionOP.Mua, ...
                    inputNET.Regions(i).RegionOP.Musp, ...
                    inputNET.Regions(i).RegionOP.G, ...
                    inputNET.Regions(i).RegionOP.N ...
                    ];
            end
            input.LayerRegions = regions;
        end
        
        function inputNET = ToInputNET(input)            
            regionsNET = NET.createArray('Vts.MonteCarlo.ITissueRegion', length(input.LayerRegions)); 
            layerRegions = input.LayerRegions;
            for i=1:length(input.LayerRegions)
                zRange = layerRegions(i).ZRange;
                regionOP = layerRegions(i).RegionOP;
                regionsNET(i) = Vts.MonteCarlo.Tissues.LayerRegion(...
                    Vts.Common.DoubleRange( ...
                        zRange(1), ...
                        zRange(2) ...
                        ), ...
                    Vts.OpticalProperties( ...
                        regionOP(1), ...
                        regionOP(2), ...
                        regionOP(3), ...
                        regionOP(4) ...
                        ) ...
                    );
            end
            inputNET = Vts.MonteCarlo.MultiLayerTissueInput(regionsNET);
        end
    end
end